---
date: 2016-11-11T17:49:05+01:00
description: null
image: null
draft: yes
tags:
  - programming
  - naming
title: No prefix, please!
---

For many years developers have been adding prefixes to instance fields: `my`, `m`, `_` and whatever else. Nowadays it looks like a rudiment of a previous century.

Firstly, Like bad known [Hungarian notation](https://en.wikipedia.org/wiki/Hungarian_notation) they are used to give programmer a hint on an origin of entity. With powerful IDEs it is not that necessary anymore. You can easily navigate code and have much more powerful hints.

Secondly, modern software development practices almost eliminate situations, where confusion between instance fields and methods parameters can arise. If your objects are immutable, then you don't have setters and only deal with parameters in constructor. For example, C++ has nice syntax for initializers.

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

Similarly properties are implemented in Objective-C. In C# many people prefer properties to field, because in most cases one can leave them auto-implemented while retaining ability to assign getter and setter different access rights.

If you are using some other languages that doesn't offer such syntactic sugar, you still may avoid getters as Yegor Bugayenko suggests in his blog post.

So the last case where confusion may arise is a method that has parameter with the same name as field, but it is neither setter not constructor. This has a code smell for me. Probably either of them must be renamed to better reflect their purpose.



Having a prefix on a method is a symptom of a bad design.

Let's consider some examples:

There is also another tightly related concept: color coding. I've been using it for quite some time already and am absolutely impressed. I used to use highlight usages on a variable to see data flow in a method. Now it is immediately visible at a glance.

