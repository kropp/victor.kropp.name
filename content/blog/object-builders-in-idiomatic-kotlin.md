---
date: 2017-04-13T16:19:03+02:00
description: How to write nice and easy to use object builders
image: /blog/img/2017/construction.jpg
tags:
- kotlin
- programming
title: Object Builders in idiomatic Kotlin
---

{{< figure src="/blog/img/2017/construction.jpg" width="1000" attr="CC-BY-SA · flickr.com/photos/loozrboy/7218773508/" attrlink="https://www.flickr.com/photos/loozrboy/7218773508/" >}}

Kotlin supports functions and constructors with named and optional (default) [arguments](https://kotlinlang.org/docs/reference/functions.html). These features help make object construction clear but don't help to avoid huge towers of nested constructors. It is also almost impossible to have any conditionally set properties.

```kotlin
data class Article(
  val name: String,
  val text: String,
  val author: Author,
  val comment: Comment
)

val article = Article(
  "Kotlin 1.1 released!",
  "Lorem ipsum dolor sit amet",
  Organization("JetBrains"),
  Comment("Hooray!", Person("John Doe"))
)
```

Looks nice, however mixing named and positional arguments is not allowed, which doesn't make construction of complex objects any easier.

Some time ago I created a Java library with a collection of builders for entities defined in [Schema.org](http://schema.org/).
This is how typical object builder looks like:
```java
final Article article = SchemaOrg.article()
        .name("Kotlin 1.1 released!")
        .text("Lorem ipsum dolor sit amet")
        .author(organization().name("JetBrains").build())
        .comment(
                comment().text("Hooray!").author(person().name("John Doe").build()).build()
        ).build();
```
It is such a common pattern, that there is a [@FreeBuilder](https://github.com/google/FreeBuilder) Java library that generates such builders from interfaces. And Groovy has [a similar feature](http://docs.groovy-lang.org/2.4.7/html/gapi/groovy/transform/builder/Builder.html) built in.

Everybody is used to this pattern, but it still has some downsides:

 * Fluent interface eliminates an intermediate builder variable, but cannot help when you need to set some properties conditionally.
 * It is repetitive. When creating nested objects you often need to `.build()` each of them.
 * It is verbose. Consider setting comment's author in the code above, you need explicitly create `Person` object and provide it as an `author`, but it is clear that an author is a person. You can either have a nice fluent interface or reduce verbosity by making `author()` return builder for `Person`.

I propose the following syntax in Kotlin to build the same object:
```kotlin
val article = article {
    name = "Kotlin 1.1 released!"
    text = "Lorem ipsum dolor sit amet"
    author = organization { name = "JetBrains" }
    comment {
        text = "Hooray!"
        author { name = "John Doe" }
    }
}
```

What advantages does this code have over its Java counterpart?

 * It is possible to have any arbitrary logical constructs inside the builder without any intermediate variables to store it.
 * Less repetitive. No ubiquitous `build()` method, fewer braces.
 * In unambiguous cases it reduces verbosity significantly by providing builders for nested objects in-place.
 * And it is like `data class` constructor with benefits!

Looks great? Hell yes! What is even better is that it takes only a few lines of code to implement it!

```kotlin
class ArticleBuilder {
  var name: String
  var text: String
  var author: Author
  var comment: Comment
  fun build() = Article(name, text, author, comment)
}

// and a convenience function to create builder:

fun article(builder: ArticleBuilder.() -> Unit) = ArticleBuilder().apply(builder).build()
```

The only problem with the code above is that it doesn't compile unfortunately, because properties must be initialized. There are several possible workarounds:

 * Add `lateinit` modifier. Accessing uninitialized property in `build()` will result in `UninitializedPropertyAccessException` in runtime.
 * Make properties nullable and initialize them all with `null`. (We need to deal with unset properties somehow anyway.)
 * Add private dictionary and [delegate](https://kotlinlang.org/docs/reference/delegated-properties.html) it handle all properties

```kotlin
class ArticleBuilder {
  private val values = mutableMapOf<String,Any>()
  var name: String by values
  …
  var comment: Comment by values
}
```

In this case all type casts are done behind the scenes. This is my preferred approach actually. And if you need this object only to serialize it later to JSON, which basically **is** just a dictionary, it is very efficient.

> *When Kotlin adds support for [write-only properties](https://youtrack.jetbrains.com/issue/KT-6519), it would be possible to remove getters from `var` properties making builders another few bytes smaller.*

Nested builders are very simple too.

```kotlin
var comment: Comment by values
fun comment(builder: CommentBuilder.() -> Unit) {
  comment = CommentBuilder().apply(builder).build()
}
```

Voilà!

You can try out builders implemented this way in my [jsonld-metadata](https://github.com/kropp/jsonld-metadata) library, which implements full [Schema.org](http://schema.org/) vocabulary. It is available on BinTray as [`org.schema:jsonld-metadata`](https://bintray.com/kropp/org.schema/jsonld-metadata) and [`org.schema:jsonld-metadata-kotlin`](https://bintray.com/kropp/org.schema/jsonld-metadata-kotlin).

To be continued.
