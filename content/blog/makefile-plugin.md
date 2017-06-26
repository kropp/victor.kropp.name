---
title: "Makefile support plugin for IntelliJ IDEA"
date: "2017-02-06T11:40:50+01:00"
description: Announcing my first plugin for my favorite IDE
twitter_card: summary_large_image
image: /projects/makefile/makefile-example.png
tags:
    - intellij
    - plugin
---

I'm excited to announce my first ever plugin for IntelliJ IDEA and other IntelliJ platform based IDEs: [Makefile support](/projects/makefile/).

I've been developing it since few months, and now it has reached Beta status and is ready for preview. It can be installed from [official plugin repository](https://plugins.jetbrains.com/idea/plugin/9333-makefile-support); the source code is on <i class="fa fa-github" style="color: rgb(23,21,21)"></i> [GitHub](https://github.com/kropp/intellij-makefile) (where else?)

*Disclaimer: I've been working at JetBrains since many years, but have never contributed to IntelliJ before. This is my pet project, I have developed it following official documentation, investigating source code, searching forums, but I haven't received any direct support from IntelliJ team.*

My overall impression of the platform and APIs is great. Sometimes it is verbose or unclear, but given the huge experience of IntelliJ developers in supporting hundreds of very different programming languages, I trust them that some verbosity is inevitable.

#### The plugin

There are several reasons, why have I developed this plugin. Firstly, I use Makefiles for automation and want to see syntax highlighting in the IDE and be able to run tasks right from there. Secondly, I've never written a plugin for my favorite IDE before and the last time I wrote a parser was somewhat ten years ago at the University. So, I took a chance to make something useful and usable, refresh some skills and to have fun at the same time.

{{< figure src="/projects/makefile/makefile-example.png" width="900" height="540" caption="Syntax highlighting and run actions provided by plugin. Makefile from Hugo static site generator." >}}

So well, what does the plugin do? It supports:

 * syntax highlighting for [GNU Makefile](https://www.gnu.org/software/make/manual/make.html)
 * rule and multiline variables folding
 * prerequisites completion (filenames and other targets)
 * quick fix to create new rule from unresolved prerequisite
 * run configurations to execute any target in any Makefile
 * context action and gutter mark icon to run target

Pretty much everything you need to start editing and using Makefiles in your project. Plugin is stable and fast. 

Even before the announcement, I received a lot of feedback from users. Thanks to everyone who submitted bugs on GitHub for making the plugin better.

If you have any feedback or suggestions, feel free to comment here, file a bug on GitHub or submit a pull request.
