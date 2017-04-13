---
title: On code formatting
date: "2017-03-20T19:05:46+01:00"
description: Avoid terribly formatted code
draft: false
image: /blog/img/2017/code-is-art.jpg
tags:
  - programming
---

{{< figure src="/blog/img/2017/code-is-art.jpg" width="1000" height="550" attr="“Code is Art” mosaic drawn by JetBrainers" attrlink="https://blog.jetbrains.com/blog/2017/02/20/happy-birthday-jetbrains-how-old-are-you/" >}}

Code is text. Like every natural language, programming languages have strict grammar and syntax rules. And like in typography, there are formatting rules. We can read and understand poorly formatted books, but it might be difficult. The same applies to source code as well.

Well-formatted code helps us understand program structure. Of course, different languages have different formatting styles. Wrong or unusual formatting makes code look awkward and dumb.

{{< figure src="https://i.imgur.com/wG51k7v.png" width="597" height="255" attr="A Python programmer attempting Java (via Reddit)" attrlink="https://www.reddit.com/r/ProgrammerHumor/comments/2wrxyt/a_python_programmer_attempting_java/" >}}

#### Tabs vs. Spaces

Programmers often argue about code formatting. One of the most popular topics is Tabs vs. Spaces. The problem is that you cannot visualy distinguish them and tabs may be displayed differently on different computers and in different code editors: either as 8 or 4 spaces (or any other number of spaces, actually). Besides visual, in some cases they have semantic difference too, like in [Makefile](https://www.gnu.org/software/make/manual/make.html) or in [Python](https://www.python.org/) code.

A recent [extensive research](https://medium.com/@hoffa/400-000-github-repositories-1-billion-files-14-terabytes-of-code-spaces-or-tabs-7cfe0b5dd7fd#.h2z315mgw) should put a stop to it: spaces are far more prevalent in modern programming languages.

{{< figure src="https://cdn-images-1.medium.com/max/1680/1*Aaqc9L1Hc62hBg_dpNgBKg.png" width="592" height="389" attr="Tab vs. Spaces (top 400 000 GitHub repos)" attrlink="https://medium.com/@hoffa/400-000-github-repositories-1-billion-files-14-terabytes-of-code-spaces-or-tabs-7cfe0b5dd7fd#.h2z315mgw" >}}

And take a closer look at Python, in which indentation is crucial for program structure: spaces are used 20 times more frequently. The only language programming language where tabs prevail over spaces is C. Here I would love to see the per year breakdown of newly created files with different indentation styles. Because it might well be the case that recent contributions are using spaces and they may soon take the lead in C language too.

#### Braces

Just take a look at this Wikipedia [article](https://en.wikipedia.org/wiki/Indent_style) discussing all known brace and indentation styles. Great that all modern programming languages provide style guides and nowdays I see less arguments on where to put a brace. Because what can you object to those, who name their preferred style **1TBS**: One True Brace Style?!

#### Double and single quoted string

Ok, done with tabs vs. spaces. What's next? Single or double quotes for strings, of course. There are languages like PHP or JavaScript, which allow both. And some even [seriously consider performance difference](http://stackoverflow.com/questions/13620/speed-difference-in-using-inline-strings-vs-concatenation-in-php5) between them! This might sound like bullshit, but many programmers were micro-optimizing their horribly slow and insecure websites by changing how they concatenate strings.

Hopefully, it's not a problem anymore in PHP world, but it is still a real thing in JavaScript. [ESLint](http://eslint.org), a widely used JavaScript linter, has [a rule](http://eslint.org/docs/rules/quotes) to force quoting style throughout the codebase. And it is extremely irritating. On the bright side such issues can be fixed automatically by `eslint`.

> By the way ESLint is a great example of how good idea can be abused by some [Grammar-Nazi](http://www.urbandictionary.com/define.php?term=Grammar%20Nazi) style rules, like string quotes one or one forcing proper [indentation](http://eslint.org/docs/rules/indent). And given that it is usually set up to fail CI build in case of *any* found problem, I feel I sometimes spend more time satisfying `eslint` than writing any meaningful code.

The same applies to [Go programming language](https://golang.org/). Its creators even brought it to the next level and made formatter a part of official language tooling. Many open-source projects reject improperly formatted pull requests, so contributors must not forget to execute `go fmt` before committing.

#### Automation and version control systems

When it is all about personal preferences, version control systems might have come to the rescue. [Git](https://git-scm.com/) already converts line endings according to the user's OS standard. It has [extensible hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) on push, checkout and commit. If only there was a tool, that can convert formatting back-and-forth between user's preferred style and the style used in the repository; then it could be applied automatically and save billion of hours spent on arguments and reformatting.

A related issue, which is not fully resolved yet, is a semantic diff. Current diff/merge tools are rather dumb and apply changes based on lines of code. This way it is easy to loose a small change in the middle of a method if it was shifted few spaces due to formatting update.

#### Parameters list formatting

Another type of change merge tools usually struggle with is a change in parameters list of a method. Consider following example:

```java
void method(int first, String second, float third) {}

// New parameter is added in the middle of the line

void method(int first, String newParam, String second, float third) {}
```

Merge tool will highlight the whole line as changed and it might be hard to spot the difference if there are many parameters. So, the usual solution to this problem (probably invented by those paid per line of code) is to place each parameter on a separate line like this:

```java
void method(
       int first,
/*     String newParam, ← new parameter inserted here */
       String second,
       float third
) {}
```

Each parameter change will result in line change/insert/deletion, which is easily handled by any diff/merge tool. There is a problem though with the last line, where you put a comma if you'd like to add another parameter at the end of the list. A creative solution would be to put a comma always in front of a parameter, but this makes code look so awkward…

```java
void method(
       int first
     , String second
     , float third
) {}
```

WTF?! Please, please never do this.

> There is a tool [SemanticMerge](https://www.semanticmerge.com/) which aims to solve this and other merge issues, but I haven't tried it yet.

### Conclusion

I admit that consistent coding style is important for the sustainability of the codebase. Formatting style is an important part of code style, but don't overrate it.

It doesn't worth it to argue a lot on code formatting. If it looks nice—great, but it's far more important that it is correct, maintanable and fast.

Stick to some style across the whole team and just forget it. It is absolutely important to set up automatic code formatting in your IDE of choice. When team IDE preferences vary, [EditorConfig](http://editorconfig.org/) may help, it is suppported by all popular code editors.

And let's create better tools that would not force us to apply bad-smelling tricks to our code.
