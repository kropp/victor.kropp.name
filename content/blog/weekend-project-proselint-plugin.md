---
date: 2017-07-24T16:13:21+02:00
description: Stylechecker in your favorite IDEA
title: "Weekend project: Proselint plugin for IntelliJ IDEA"
tags:
    - intellij
    - plugin
---

Last weekend I was listening to [CppCast](http://cppcast.com/2017/06/richel-bilderbeek/)—a podcast for C++ developers and heard about [Proselint](http://proselint.com/)—a linter for prose.

I usually use [Grammarly](https://grammarly.com/) for grammar and stylistic checks of my writings, but I also like to put finishing touches after I import the text into a blog codebase. IntelliJ IDEA already has a [spell checker built-in](https://www.jetbrains.com/help/idea/spellchecking.html), but it'd be good to have some style checker there too. Of course, I immediately decided to create a plugin for that. I've already had [some experience]({{< relref "makefile-plugin.md" >}}) writing plugins, and given that it's not the first linter to be supported by IntelliJ, I didn't take me much time to integrate Proselint into the editor.

So, please welcome [Proselint plugin](https://plugins.jetbrains.com/plugin/9854-proselint) for IntelliJ IDEA. The plugin depends on [Markdown support plugin](https://plugins.jetbrains.com/plugin/7793-markdown-support) and requires Python and [Proselint to be installed](https://github.com/amperser/proselint) on your computer. The only thing you need to do is to configure the path to proselint executable if it was not guessed correctly.

{{< figure src="/blog/img/2017/proselint.png" caption="Proselint plugin in action" width="453" height="73" >}}

If there is a replacement suggested by Proselint, a quick-fix appears to apply it via `Alt+Enter`.

Feel free to check out the [source code](https://github.com/kropp/intellij-proselint) and contribute by filing a feature request or bug report or submit a pull request.

P.S. This post was written in Intellij IDEA and checked by Proselint.
