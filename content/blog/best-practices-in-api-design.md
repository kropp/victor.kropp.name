---
title: "Best practices in API design"
date: "2017-01-24T17:12:10+01:00"
description: Designing programming interfaces for people
twitter_card: summary_large_image
image: /blog/img/2017/qurlquery.png
tags:
    - c++
    - programming
    - qt
---

Recently I faced some issues with [`QUrlQuery`](http://doc.qt.io/qt-5/qurlquery.html) class from [Qt Framework](http://qt.io/) which I would like to discuss.

The sole purpose of this class is to provide abstraction over query string part of URL. It converts an array of key-value pairs to a percent-encoded string as required by the standard.

The typical usage example is:

```cpp
QUrlQuery query;
query.addQueryItem("firstname", "Victor");
query.addQueryItem("lastname", "Kropp");
…
query.toString(QUrl::FullyEncoded);
```

And the resulting string would be:

```http
firstname=Victor&lastname=Kropp
```

What can possibly go wrong here?

### Design API for the real world, not for specifications

I like specifications. They help a lot if you want to know every detail of a particular system, library or protocol. However, actual implementations often differ from specifications. Sometimes these differences become standards *de facto*.

For example, spaces in query strings are encoded with `+` signs. And `+` itself is encoded with `%2B` (which is its hexadecimal ASCII value obviously). Every browser and every web server do this. But it was not required by [**RFC 1738** Uniform Resource Locators (URL)](https://tools.ietf.org/html/rfc1738)! This RFC is dated back to December 1994—the very early days of the World Wide Web.

A lot has changed since then, and the newer [**RFC 3986** Uniform Resource Identifier (URI): Generic Syntax](https://tools.ietf.org/html/rfc3986) was released in January 2005. Apparently, This RFC reflected how all implementations interpreted the specification. `+` sign was added to the list of reserved characters that must be percent-encoded (section 2.2).

`QUrlQuery` still doesn't encode `+` even in the latest version. To say I was surprised is to say nothing. And it isn't a bug; it's a feature. This peculiarity even has its own section in [documentation](http://doc.qt.io/qt-5/qurlquery.html#handling-of-spaces-and-plus). Should I have read it? Probably. But do you read *all* documentation, especially in such obvious cases?

A good solution would be to add an option to enforce the old or the new standard.

Here comes the first rule in designing APIs for people: API should reflect the real world, not a specification.

### Explicit is better than implicit.

Let's continue our journey with `QUrlQuery`. The case of `+` is solved, now it is time to find out what happens if query parameter contains `%` sign. As with many programming questions, the correct answer is: "It depends."

Not the answer you want to hear? Sorry. Let's investigate what happens here. In the following snippent, I provide two strings (`%ab` and `%xy`) to `QUrlQuery` and check the result.

```cpp
query.addQueryItem("encoded", "%abc&");
query.addQueryItem("plain", "%xyz&");
```

```http
encoded=%ABc%26&plain=%25xyz%26
```
 
Surprised? Me too. And again, public API is not the best place for surprises. Well, what has happened here?

* String `%ab` was treated as encoded and was outputted unaltered.
* `%` in string `%xy` was encoded, because it didn't represent a hexadecimal number.

It is great that `addQueryItem` can handle both types of arguments. What is disappointing here, is the lack of control. I'd prefer to have two methods or a method with a parameter. This way I, as a user of the library, can decide how it should to interpret each particular string.

The second rule of designing APIs is: explicit is better than implicit.

### Legacy API

Somebody may argue that these rules are inapplicable to old libraries, that must remain backward compatible. A good solution would be to add interfaces, implementations, new methods or overloaded methods. New entities could then provide updated behavior while original ones remain for compatibility. To keep the public API surface clean and tidy old variants may be marked as deprecated and eventually removed.

I appreciate the work of Qt Framework developers and maintainers. Keeping such a big and famous library up and running is a demanding task. They are doing a great job! But there is always room to improve.
