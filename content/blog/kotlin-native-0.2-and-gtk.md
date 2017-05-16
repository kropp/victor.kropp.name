---
date: 2017-05-16T12:34:55+02:00
description: Exploring Kotlin/Native capabilities
image: /blog/img/2017/kotlin+gtk.png
tags:
- kotlin
- kotlin-native
- programming
title: Kotlin/Native 0.2 + GTK
---

{{< figure src="/blog/img/2017/kotlin+gtk.png" width="225" caption="" >}}

Last week Kotlin/Native saw its [second preview release](https://blog.jetbrains.com/kotlin/2017/05/kotlinnative-v0-2-is-out/). In case you missed it, Kotlin/Native is an another backend for [Kotlin](https://kotlinlang.org/) (in addition to JVM and JavaScript), which doesn't require any VM and runs natively on many [supported platforms](https://github.com/JetBrains/kotlin-native/blob/v0.1.0/RELEASE_NOTES.md#supported-platforms).

I played with it over the weekend, and it appeared to be already pretty good and solid for an early tech preview. To start with I took a [sample GTK+ application](https://github.com/JetBrains/kotlin-native/tree/v0.2.0/samples/gtk)  written in Kotlin and tried to improve it. Let's see what I did (spoiler alert: I rewrote it almost entirely).

### Demo application

The original sample code doesn't look very different from its pure C equivalent.

```kotlin
fun activate(app: CPointer<GtkApplication>?, user_data: gpointer?) {
    val windowWidget = gtk_application_window_new(app)!!
    val window = windowWidget.reinterpret<GtkWindow>()
    gtk_window_set_title(window, "Window");
    gtk_window_set_default_size(window, 200, 200)

    val button_box = gtk_button_box_new(
            GtkOrientation.GTK_ORIENTATION_HORIZONTAL)!!
    gtk_container_add(window.reinterpret(), button_box);

    val button = gtk_button_new_with_label("Konan говорит: click me!")!!
    g_signal_connect(button, "clicked",
            staticCFunction { widget: CPointer<GtkApplication>?, data: gpointer? ->
                println("Hi Kotlin")
            });
    g_signal_connect(button, "clicked",
            staticCFunction { widget: CPointer<GtkWidget>? ->
                gtk_widget_destroy(widget)
            },
            window, G_CONNECT_SWAPPED)
    gtk_container_add (button_box.reinterpret(), button);

    gtk_widget_show_all(windowWidget)
}

fun gtkMain(args: Array<String>): Int {
    val app = gtk_application_new("org.gtk.example", G_APPLICATION_FLAGS_NONE)!!
    g_signal_connect(app, "activate", staticCFunction(::activate))
    val status = memScoped {
        g_application_run(app.reinterpret(),
                args.size, args.map { it.cstr.getPointer(memScope) }.toCValues())
    }
    g_object_unref(app)
    return status
}
```

You see, it's just a number of C-style function calls. Let's try to convert it to a more pleasantly looking Kotlin code.

### Object Oriented version

First of all, Kotlin is an object oriented language. GTK+ framework too, in fact. Let's introduce object hierarchy for widget types used in the example.

```kotlin
abstract class Widget {
  abstract val widgetPtr: CPointer<GtkWidget>
}

abstract class Container: Widget() {
  fun add(widget: Widget) = gtk_container_add(widgetPtr.reinterpret(), widget.widgetPtr)
}

class Window(app: CValuesRef<GtkApplication>): Container() {
  override val widgetPtr = gtk_application_window_new(app)!!
  private val window get() = widgetPtr.reinterpret<GtkWindow>()

  var title: String
    get() = gtk_window_get_title(window)
    set(value) { gtk_window_set_title(window, value) }

  fun setDefaultSize(width: Int, height: Int) = gtk_window_set_default_size(window, width, height)
  
  fun showAll() = gtk_widget_show_all(widgetPtr)
}

class ButtonBox(orientation: GtkOrientation): Container() {
  override val widgetPtr = gtk_button_box_new(orientation)!!
}

class Button(label: String): Widget() {
  override val widgetPtr = gtk_button_new_with_label(label)!!
  private val button get() = widgetPtr.reinterpret<GtkButton>()

  fun onClicked(handler: GtkButton, callback: CPointer<CFunction<(CPointer<GtkButton>?, gpointer?) -> Unit>>) {
    g_signal_connect(widgetPtr, "clicked", callback)
  }

  fun <T : Widget> onClicked(handler: T, callback: CPointer<CFunction<(CPointer<GtkWindow>?, gpointer?) -> Unit>>) {
    g_signal_connect(widgetPtr, "clicked", callback, handler.widgetPtr, G_CONNECT_SWAPPED)
  }
}
```

Here we have basic hierarchy with `Widget` as the root, `Window` and `ButtonBox` both are `Container` subclasses and `Button` derived from `Widget`. `title` and `setDefaultSize` belong now to `Window` class. Note how naturally `gtk_window_get_title`/`gtk_window_set_title` method pair is converted to a `title` property. `Button` class also features `onClicked` method encapsulating signal subscription logic. It hasn't changed much and still doesn't look good, we'll return to it later.

Similarly I've converted code related to a GtkApplication into an `Application` class.

```kotlin
class Application(id: String) {
  val app = gtk_application_new(id, G_APPLICATION_FLAGS_NONE)!!

  fun onActivate(callback: CPointer<CFunction<(CPointer<GtkApplication>?, gpointer?) -> Unit>>) {
    g_signal_connect(app, "activate", callback)
  }

  fun run(args: Array<String>): Int {
    val status = memScoped {
        g_application_run(app.reinterpret(),
                args.size, args.map { it.cstr.getPointer(memScope) }.toCValues())
    }
    g_object_unref(app)
    return status
  }
}
```

This is how the main method now looks like:

```kotlin
fun gtkMain(args: Array<String>): Int {
  val app = Application("org.gtk.example")
  app.onActivate(staticCFunction { app, _ ->
    val window = Window(app!!.reinterpret())
    window.title = "Kotlin"
    window.setDefaultSize(200, 200)

    val buttonBox = ButtonBox(GtkOrientation.GTK_ORIENTATION_HORIZONTAL)

    val button = Button("Hello world!")
    button.onClicked(staticCFunction { widget: CPointer<GtkButton>?, data: gpointer? ->
      println("Hello Kotlin!")
    })

    button.onClicked(window, staticCFunction { window: CPointer<GtkWindow>?, data: gpointer? ->
      gtk_widget_destroy(window!!.reinterpret())
    })

    buttonBox.add(button)

    window.add(buttonBox)

    window.showAll()
  })
  return app.run(args)
}
```

Looks much more readable and object-oriented, isn't it? There are still few things left, however. You have definetely noticed that ugly `staticCFunction` calls. These are the helpers to pass Kotlin/Native callbacks into C function calls, see [interoperability guide](https://github.com/JetBrains/kotlin-native/blob/v0.2.0/INTEROP.md). Unfortunately, we cannot pass any bound lambda through the boundary, so if we'd like our signal subscriptions look better we need to workaround it.

### Better callbacks

The idea behind the workaround is the following: we will store all handlers in Kotlin and subscribe a static function to an original signal. This callback will then call each handler when invoked. Here is the `Signal` class which stores handlers. It is a simplified version of `Event` class from [libcurl](https://github.com/JetBrains/kotlin-native/blob/v0.2.0/samples/libcurl/src/org/konan/libcurl/Event.kt) example.

```kotlin
typealias SignalHandler = () -> Unit
class Signal {
  private var handlers = emptyList<SignalHandler>()

  operator fun plusAssign(handler: SignalHandler) { handlers += handler }
  operator fun minusAssign(handler: SignalHandler) { handlers -= handler }

  operator fun invoke() {
    for (handler in handlers) {
      try {
        handler()
      } catch (e: Throwable) {
      }
    }
  }
}
```

Then we rewrite `Button` class as follows:

```kotlin
fun signalHandler(sender: CPointer<*>?, data: COpaquePointer?) {
  val button = StableObjPtr.fromValue(data!!).get() as Button
  button.clicked()
}

class Button(label: String): Widget() {
  override val widgetPtr = gtk_button_new_with_label(label)!!

  init {
    g_signal_connect(widgetPtr, "clicked", staticCFunction(::signalHandler), StableObjPtr.create(this).value)
  }

  val clicked = Signal()
}
```

Here we've created a static signal handler for `"clicked"` signal and used it together with `Signal` object to handle this signal. Button creation code can now be simplified as well:

```kotlin
button.clicked += {
  println("Hello Kotlin!")
  gtk_widget_destroy(window.widgetPtr)
}
```

Lambda provided as a signal handler can now capture local variables, so we don't need to connect `"clicked"` signal again to handle it in `window` context. Cool!

### UI builder DSL

But this is not the end yet! I'm a big [Kotlin DSL lover](/tag/dsl/), so I couldn't resist adding some [Anko](https://github.com/Kotlin/anko) style UI builders. They are very simple:

```kotlin
fun CPointer<GtkApplication>.window(builder: Window.() -> Unit) {
  Window(reinterpret()).apply(builder).showAll()
}
fun Container.buttonBox(builder: ButtonBox.() -> Unit) = add(ButtonBox(GtkOrientation.GTK_ORIENTATION_HORIZONTAL).apply(builder))
fun ButtonBox.button(label: String, builder: Button.() -> Unit) = add(Button(label).apply(builder))
```

But see how nice and concise is the window creation code now!

```kotlin
app!!.window {
  title = "Kotlin"
  setDefaultSize(200, 200)

  buttonBox {
    button("Hello World!") {
      clicked += {
        println("Hello Kotlin!")
        this@window.destroy()
      }
    }
  }
}
```

Awesome!

### Result

I've uploaded the full working code to [a Gist](https://gist.github.com/kropp/9b8b9578b9421e932f932bb6aed9598a).

The proposed solution has several advantages:

 * it is much more readable
 * it is statically typed, including signals
 * it doesn't expose underlying C function calls (thus it is more portable)

### What's next?

I'm going to create similar [bindings](https://github.com/kropp/kotlin-native-gtk) for all GTK+ entities and develop some sample application using it to prove that Kotlin can be a great alternative to [Vala](https://wiki.gnome.org/Projects/Vala) for GNOME developers.

Stay tuned!
