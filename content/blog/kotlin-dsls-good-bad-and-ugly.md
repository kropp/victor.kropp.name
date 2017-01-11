---
title: "DSLs in Kotlin: The Good, the Bad und the Ugly"
date: "2017-01-11T15:10:18+01:00"
description: 3 examples of DSLs in Kotlin
twitter_card: summary_large_image
image: /blog/img/2017/the-good-the-bad-and-the-ugly.jpg
tags:
    - kotlin
    - dsl
    - programming
---

[<abbr title="Domain-specific Language">DSLs</abbr>](https://en.wikipedia.org/wiki/Domain-specific_language) are a very hot topic among Kotlin developers. No surprise, language designers take it seriously and are adding [specific features directly into the language](https://github.com/Kotlin/KEEP/blob/master/proposals/scope-control-for-implicit-receivers.md) to improve DSL behavior. In this post, I'd like to share and discuss 3 examples of DSLs written in Kotlin.

{{< figure src="/blog/img/2017/the-good-the-bad-and-the-ugly.jpg" width="1000" caption="The Good, the Bad und the Ugly (1966)" >}}

### The Good

[Anko](https://github.com/Kotlin/anko) is a great DSL for building Android views. Here is an example from official documentation:

<pre><code class="kotlin">verticalLayout {
    val name = editText()
    button("Say Hello") {
        onClick { toast("Hello, ${name.text}!") }
    }
}
</code></pre>

Anko uses Kotlin's builder functions not only to create nested views but also to add listeners. Still, it is absolutely clear in both cases what is meant to be here. This language is extensible and covers all use cases.

[kotlinx.html](https://github.com/Kotlin/kotlinx.html) is very similar language to build HTML. It would be the perfect example as well if only it doesn't use `+` operator to append raw text. Why? I'll explain it in the next section.

### The Bad

Here is the whole DSL in just one line of code:
<pre><code class="kotlin">operator fun String.div(path: String) = this + "/" + path
val logFile = home / "logs" / "log.txt"</code></pre>

It allows using `/` operator on strings for file system path concatenation. I've seen it many times before (for example, in C# and C++ where operator overloading is possible too).

On the first sight, it looks like a smart and clever idea. However you soon discover its limits:

 * you cannot start path with `/` (there is no unary division). You should either start with an empty string or put root slash into first path component.
 * on Windows path components separated by backslashes (`\`) and there is a notion of "disks" which are denoted by a colon (`:`). You cannot extend this DSL to support this options and need to find other solutions.
 * you cannot extend this DSLs to manage file extensions, because `.` (dot) operator has very different meaning in Kotlin
 * it is confusing. This operator may become available in different contexts, where it is not applicable or should behave differently. For example, if there are numbers stored in strings, somebody can think that this operator implements mathematical division of such numbers.

Don't abuse operator overloading, it is usually unclear and can lead to unpredictable errors. Still not convinced? Read further.

### The Ugly

{{< gist naixx 9d94c1498c4d45ffda3a >}}

Just don't do this. Never.

It is a very quirky way to add missing ternary operator. Reasons, why it is not implemented in Kotlin, are explained in the [documentation](https://kotlinlang.org/docs/reference/control-flow.html). One of them is the lack of extensibility, nested ternary operators look ugly and it might be very difficult to find out what's going on there. Use `when` instead.

This DSL does not resolve the aforementioned problem but adds another one: without looking in the source code, it is absolutely unclear what does these `%` and `/` symbols mean in this context. I bet, even the author of this snippet will forget their meaning in a year.

If only it was not enough already, this particular code adds an object instantiation on every call, which may lead to performance problems if it is on a critical path.

So let me repeat it once again: **don't do this**.

### Conclusion

Kotlin is very flexible general purpose language. It offers great extensibility and power of type-safe builders and extension functions to library creators. Please, don't abuse it. With great power comes great responsibility.

Do you know other DSLs written in Kotlin? Share and discuss in comments!
