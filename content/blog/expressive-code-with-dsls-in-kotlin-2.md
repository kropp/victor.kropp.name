---
title: Expressive code with DSLs in Kotlin. Part 2
description: Advanced features for your DSLs
twitter_card: summary_large_image
date: 2017-12-24T17:40:51+01:00
image: /blog/img/2017/christmas2.jpg
tags:
    - kotlin
    - dsl
    - programming
---

{{< figure src="/blog/img/2017/christmas2.jpg" width="1000" height="550" >}}

In the [first part]({{< ref "expressive-code-with-dsls-in-kotlin.md" >}}) of this tutorial, I’ve shown how to create custom internal DSL, which helps to convert an unstructured imperative code to expressive structured and declarative. In this blog post, I'll improve it further.

### Dates manipulation

I know well that the Christmas is on December 25, but the question I always ask myself at the beginning of December when is the first Advent Sunday. There are four of them, and the last one is on Sunday before Christmas. So the first one can be anytime between November 27 and December 3. Let's find it out:

```kotlin
val `4th Advent` = Sunday before Christmas
```
*Variable names can neither start with a digit nor contain a space, in Kotlin you can escape them with backticks. Do not overuse this feature, though.*

Looks nice, isn't it? It doesn't work out of the box, though. To help compiler figure it out, let's declare the variable `Sunday` and infix function `before` (we've seen this trick before):

```kotlin
val Sunday = DayOfWeek.SUNDAY
infix fun DayOfWeek.before(date: LocalDate): LocalDate = date.with(TemporalAdjusters.previous(this))
```

To create events in our calendar for all Advent Sundays we need to find the first one (3 weeks earlier) and iterate over them. It can be done in the following way:

```kotlin
(`4th Advent` - 3 * week .. `4th Advent` every week).forEachIndexed { i, Advent ->
  event {
    title = "$i Advent"
    date = Advent
  }
}
```

The most interesting is the first line, which is packed with neat tricks, following lines just repeat the creation process of an event for Christmas. First, with the help of [overloaded multiplication operator](https://kotlinlang.org/docs/reference/operator-overloading.html), we create an object, representing three weeks:

```kotlin
val week: Period = Period.ofDays(7)
operator fun Int.times(p: Period): Period = p.multipliedBy(this)
```

`operator` keyword allows us to call extension function `times` with an asterisk, like any ordinary multiplication. `LocalDate` class is defined in Java and already has `minus` function, Kotlin allows to call it with a `-` sign without any additional modifications, so that
`4th Advent - 3 * week` compiles to `4th Advent.minus(3 * week)`

### Ranges

Two dots denote a [range](https://kotlinlang.org/docs/reference/ranges.html) in Kotlin. And since its a regular class we can define an extension function `every` on it:

```kotlin
infix fun ClosedRange<LocalDate>.every(period: Period) = buildSequence {
  var current = start
  do {
    yield(current)
    current += period
  } while (current <= endInclusive)
}
```

Without going into much detail here, it creates a sequence of dates with a given period in-between, which we can then iterate with `forEachIndexed`, or standard `for` loop, of course.

### `invoke` convention

This code will look much better if we can avoid this `.forEachIndexed` call altogether:

```kotlin
(`4th Advent` - 3 * week .. `4th Advent` every week) { i, Advent ->
  event {
    title = "$i Advent"
    date = Advent
  }
}
```

And we can! [`invoke`](https://kotlinlang.org/docs/reference/operator-overloading.html#invoke) operator allows us to call an object or an expression as a method. In our case it will just delegate to `forEachIndexed`:

```kotlin
operator fun <T> Sequence<T>.invoke(body: (Int, T) -> Unit) = forEachIndexed(body)
```

### Performance

DSLs in Kotlin are statically compiled code; they do not require any dynamic resolution whatsoever. They do not use reflection either. Everything we've seen here is just function calls. However, passing lambda functions here and there can be a performance problem because each of them requires creating a closure. To solve this problem, we can mark DSL functions with `inline` keyword. They will be inlined at the call site together with a lambda function they take as a parameter.

### Scopes

As I said before the whole DSL is based on simple functions, which can be called from everywhere, for example, such code is allowed by default:

```kotlin
calendar {
  event {
    event {}
  }
}
```

Nesting events don't make much sense. Since Kotlin 1.1 we can [control scope of the implicit receivers](https://kotlinlang.org/docs/reference/whatsnew11.html#scope-control-for-implicit-receivers-in-dsls).

```kotlin
@DslMarker
@Target(AnnotationTarget.TYPE)
annotation class CalendarDsl

fun calendar(builder: (@CalendarDsl ICalendar).() -> Unit) = ICalendar().apply(builder)
fun ICalendar.event(builder: (@CalendarDsl VEvent).() -> Unit) = addEvent(VEvent().apply(builder))
```

To disallow such calls, we define an annotation, mark it with `@DslMarker` annotation, and then apply it types which define logical scopes in our DSL. After that nested `event` may be called only with an implicit receiver.

And that's it! Our DSL is finished. You can find the full source code of this example <i class="fa fa-github" style="color: rgb(23,21,21)"></i> [GitHub](https://github.com/kropp/noslidesconf2017-kotlin-dsl). The recording of my talk about this DSL is available on <i class="fa fa-youtube-play" style="color: #ff0000"></i> [YouTube](https://www.youtube.com/watch?v=tZIRovCbYM8).

Thanks for reading! I wish you Merry Christmas and Happy New Year!
