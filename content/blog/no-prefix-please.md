---
date: 2016-12-05T09:49:05+01:00
description: Some rant on 'my' prefix for fields
tags:
  - programming
  - naming
title: No prefix, please!
---

For many years developers have been adding prefixes to instance fields: `my`, `m`, `_` and whatever else. I’ve seen many coding style guides requiring one of these prefixes. But nowadays it looks like a rudiment of a previous century.

Like ill-famed [Hungarian notation](https://en.wikipedia.org/wiki/Hungarian_notation) they are used to give programmer a hint on some properties of entity. With powerful IDEs, it is not necessary anymore. You can have much more powerful hints and easily navigate code to discover much more.

Modern software development practices almost eliminate situations, where the confusion between instance fields and methods parameters can arise. If your objects are immutable, then you don’t have setters and only deal with parameters in the constructor. Here C++ has a nice syntax for fields initializers:

<pre><code class="cpp">class Point {
  private:
    const int x, y;
  public:
    Point(int x, int y) : x(x), y(y) {}
    int x() { return x; }
    int y() { return y; }
};
</code></pre>

Note also, that you can declare methods with the same as fields. And again there is no confusion!

[Kotlin](https://kotlinlang.org/) went further and completely eliminated getters and setters and merged them with fields and constructor parameters into a single entity.

<pre><code class="kotlin">class Point(public val x: Int, public val y: Int)</code></pre>

Similarly, properties are implemented in Objective-C. And in C# many people prefer properties to fields because in most cases one can leave them auto-implemented while retaining an ability to assign getter and setter different access rights.

So the last case where confusion may arise is a method that has a parameter with the same name as a field, but it is neither a setter nor the constructor or there is similarly named variable. This sounds suspicious. Probably some fields or variables must be renamed to better reflect their purpose.

And there is one more aid in this situation: [color coding](https://medium.com/@evnbr/coding-in-color-3a6db2743a1e#.37hfeyrw4). I've been using it for quite some time already in [IntelliJ IDEA 2016.3](https://www.youtube.com/watch?v=8WRH59PQ5Dk) and am absolutely impressed. I used to use highlight usages on a variable to see data flow in a method. Now it is immediately visible at a glance. And you'll never mix up different variables anymore.

Don’t add prefixes to fields names! They are unnecessary.
