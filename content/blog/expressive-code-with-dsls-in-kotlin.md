---
title: Expressive code with DSLs in Kotlin
description: Step-by-step guide on creating DSL from scratch
twitter_card: summary_large_image
date: 2017-12-11T13:43:30+01:00
image: /blog/img/2017/christmas.jpg
tags:
    - kotlin
    - dsl
    - programming
---

{{< figure src="/blog/img/2017/christmas.jpg" width="1000" >}}

In this tutorial I'll show how to create your own DSL from scratch in Kotlin. It is mostly based on my talk I presented few weeks ago at [NoSlidesConf](http://noslidesconf.net/).

As an example I will create a calendar for upcoming holidays. I will use [Biweekly](https://github.com/mangstadt/biweekly) library for that:

```kotlin
val ical = ICalendar()
val event = VEvent()
event.setSummary("Christmas")

val date = GregorianCalendar(2017, 11, 25).time
event.setDateStart(date)
event.setDateEnd(date)

ical.addEvent(event)

println(Biweekly.write(ical).go())
```

The code looks exactly as you may expect it. We create a calendar object, then an object, representing an event, set its properties, add the event to the calendar, and finally serialize it to string and print. You've seen similar code billion times before, and there is nothing bad about it. Stop. Bullshit! There are a lot of flaws in this code.

Firstly, it's utterly unstructured. You can move statements back and forth, and in some cases, it will work as before while in some other cases it may suddenly fail even if the code will remain compilable. For example, if you modify `event` object after adding it to a calendar, the result depends on the implementation details of the library: it may save a copy of the event and then all subsequent changes are lost.

Secondly, it's very easy to mess everything up by copy-pasting. I know, one should never copy-paste any code, but still, people do this and then suffer from weird side-effects. If some references are not properly updated, a whole lot of different errors may arise, like missing or duplicate events, wrong event data, etc.

We can avoid most of this errors by changing code style from imperative to declarative. Let's see how.

### Declarative builders

Let's start with a one-line helper function to create a calendar:

```kotlin
fun calendar(builder: ICalendar.() -> Unit) = ICalendar().apply(builder)
```

Kotlin supports [top-level functions](https://kotlinlang.org/docs/reference/functions.html#function-scope), so we can put it anywhere in our file and then create and initialize calendar object with it. `builder` parameter, in this case, is [a lambda function with a receiver](https://kotlinlang.org/docs/reference/lambdas.html#function-literals-with-receiver) of type `ICalendar` which means that it behaves like if it was a member function of the given type, i. e. `this` is available in the lambda body (and can be omitted as in regular instance methods).

The same can be applied to an event:

```kotlin
fun ICalendar.event(builder: VEvent.() -> Unit) = addEvent(VEvent().apply(builder))
```

Here we not only create and initialize a `VEvent` object but also add it to an enclosing calendar. `event()` is an [extension function](https://kotlinlang.org/docs/reference/extensions.html) which behaves as a member function, like the lambda we've just discussed. Together with a previous one, they make a skeleton of our DSL:

```kotlin
val ical = calendar {
  event {
    setSummary("Christmas")

    val date = GregorianCalendar(2017, 11, 25).time
    setDateStart(date)
    setDateEnd(date)
  }
}

println(Biweekly.write(ical).go())
```

### More extension methods and properties

We now clearly see how the code is structured, but it is still a mix of imperative and declarative approach. With the help of extension functions and properties, we can improve it further.

First, if we need to print calendars often, it's worth to hide serialization code in a helper extension function.

```kotlin
fun ICalendar.print() = println(Biweekly.write(this).go())
```

Second, an idiomatic way of setting summary and date in Kotlin is by assign values to properties. Luckily, we can declare extension properties similar to extension functions:

```kotlin
var VEvent.title: String
  set(value) {
    setSummary(value)
  }
  get() = TODO()

var VEvent.date: LocalDate
  set(value) {
    val date = java.sql.Date.valueOf(value)
    setDateStart(date)
    setDateEnd(date)
  }
  get() = TODO()
```

*Setter-only properties are not (yet) allowed in Kotlin, so we must define dummy getters here.*

After this step the calendar creation code now looks like this:

```kotlin
calendar {
  event {
    title = "Christmas"
    date = LocalDate.of(2017, 11, 25)
  }
}.print()
```

It is now much shorter and cleaner!

### Mini-DSL for dates

The last thing that stands out in this example is a `LocalDate` object. What I especially dislike here are zero-numbered months, so that December is 11th month of the year. There is another factory method on `LocalDate` class accepting `Month` enum: `LocalDate.of(2017, Month.DECEMBER, 25)` However, in this particular case, my solution would be the following:

```kotlin
private infix fun Int.December(year: Int) = LocalDate.of(year, Month.DECEMBER, this)
// and similar methods for all months
```

`infix` modifier allows invoking function without dot and parenthesis. So the final example would then be:

```kotlin
calendar {
  event {
    title = "Christmas"
    date = 25 December 2017
  }
}.print()
```

Warning! Do not declare extension functions on standard types such as `Int` public. Especially in top-level package. They will spoil completion list and can lead to mysterious errors if they clash with other similar functions with slightly different implementations.

### Conclusion

In this tutorial, I've shown how to create custom internal DSL, using simple language features, such as extension functions and properties and lambdas with a receiver. With its help, an unstructured imperative code can be converted to expressive structured and declarative.

The source code of the complete example is available on <i class="fa fa-github" style="color: rgb(23,21,21)"></i> [GitHub](https://github.com/kropp/noslidesconf2017-kotlin-dsl).

In the second part, I'll show some advanced tricks to make DSL even more powerful. Stay tuned.
