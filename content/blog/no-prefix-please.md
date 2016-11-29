---
date: 2016-12-02T17:49:05+01:00
description: Some rant on 'my' prefix for fields
draft: yes
tags:
  - programming
  - naming
title: No prefix, please!
---

For many years developers have been adding prefixes to instance fields: `my`, `m`, `_` and whatever else. Nowadays it looks like a rudiment of a previous century.

Like ill famed [Hungarian notation](https://en.wikipedia.org/wiki/Hungarian_notation) they are used to give programmer a hint on an origin of entity. With powerful IDEs it is not that necessary anymore. You can easily navigate code and have much more powerful hints.

Modern software development practices almost eliminate situations, where confusion between instance fields and methods parameters can arise. If your objects are immutable, then you don't have setters and only deal with parameters in constructor. For example, C++ has nice syntax for fields initializers.

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

[Kotlin](https://kotlinlang.org/) went further and completely eliminated getters and setters and merged them, fields and constructor parameters into a single entity.

<pre><code class="kotlin">class Point(public val x: Int, public val y: Int)</code></pre>

Similarly properties are implemented in Objective-C. In C# many people prefer properties to fields, because in most cases one can leave them auto-implemented while retaining ability to assign getter and setter different access rights.

So the last case where confusion may arise is a method that has parameter with the same name as field, but it is neither setter not constructor or there is similarly named variable. These are code smells. Probably some fields or variables must be renamed to better reflect their purpose.

There is also another tightly related concept: [color coding](https://medium.com/@evnbr/coding-in-color-3a6db2743a1e#.37hfeyrw4). I've been using it for quite some time already in [IntelliJ IDEA 2016.3](https://blog.jetbrains.com/idea/2016/10/intellij-idea-2016-3-public-preview/) and am absolutely impressed. I used to use highlight usages on a variable to see data flow in a method. Now it is immediately visible at a glance. And you'll never mix up different variables anymore.

Don't add prefixes to fields names! They are unnecessary.
