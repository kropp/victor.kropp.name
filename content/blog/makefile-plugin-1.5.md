---
title: "Makefile support plugin 1.5"
date: "2018-09-27T09:18:55+02:00"
description: Makefile tool window and performance improvements
twitter_card: summary_large_image
image: /projects/makefile/makefile-toolwindow.png
tags:
    - intellij
    - plugin
    - makefile
---

I’m very happy to announce the release 1.5 of [Makefile support plugin](/projects/makefile/) for IntelliJ based IDEs, which adds a Make tool window to quickly browse and execute Makefile targets.

{{< figure src="/projects/makefile/makefile-toolwindow.png" width="477" height="318" caption="Makefile tool window" >}}

Since I first wrote about the plugin even before its release, I’ve been getting lots of feedback, including many samples when it failed to parse some special directives. Did you know how complex [Makefile syntax](https://www.gnu.org/software/make/manual/) is? I know now. And what upsets me the most is that plugin still fails in some rare cases. If you encounter faulty behavior please don’t hesitate to submit an issue on <i class="fa fa-github" style="color: rgb(23,21,21)"></i> [GitHub](https://github.com/kropp/intellij-makefile).

Recently the plugin was [featured in CLion blog](https://blog.jetbrains.com/clion/2018/08/working-with-makefiles-in-clion-using-compilation-db/). I’ve got a lot of positive reviews after that. Thanks to everyone for your feedback and 5-star ratings in the plugin repository. If you haven’t yet put your 5 stars, do it now! This and downloads stats motivate me to continue working on this project.

{{< figure src="/blog/img/2018/makefile-plugin-stats.png" width="590" height="170" >}}

I’ve been preparing this update for quite some time. To efficiently show all Makefiles and target in a tool window, the plugin must first index all of them. So there is now an index, which contributes to an Indexing phase of IntelliJ startup. I tried to keep at as minimal and as simple as possible. As a “side effect,” it also brings performance improvements in different analyses like “Unresolved target” for example.

If you use Makefiles in your project, [install the plugin](https://plugins.jetbrains.com/idea/plugin/9333-makefile-support) now!
