---
title: Makefile support plugin for IntelliJ IDEA
social: off
twitter_card: summary_large_image
image: /projects/makefile/makefile-3.png
---

## Makefile support plugin for IntelliJ IDEA

Plugin is available for install via [official repository](https://plugins.jetbrains.com/idea/plugin/9333-makefile-support). Source code is available on <i class="fa fa-github" style="color: rgb(23,21,21)"></i> [GitHub](https://github.com/kropp/intellij-makefile)

Plugin provides full support for GNU [Makefile syntax](https://www.gnu.org/software/make/manual/make.html) including syntax highlighting, prerequisites and variables completion and resolution. There is also a quick-fix to create new rule from unresolved prerequisite. Individual rules can be folded for better overview.

<img src="makefile-3.png" width="900" height="540" />

It also supports executing Makefiles:

 * via "run" gutter mark
 * from Make tool window
 * pressing <kbd>Alt+Enter</kbd> (<kbd>⌥⏎</kbd> on macOS) and selecting target
 * using <kbd>Ctrl+Shift+F10</kbd> (<kbd>⌃⇧R</kbd> on macOS) on a target

{{< figure src="makefile-run.png" width="700" height="500" >}}

#### Run configuration

Alternatively, a run configuration can be created for any Makefile and target, with options to set up working directory, add arguments and environments variables.

{{< figure src="makefile-3-run-configuration.png" width="688" height="575" >}}

#### Tool window

There is a tool window, which gives a quick overview of all Makefiles in the project and their targets. Press `Enter` (or double-click) to run a target, <kbd>F4</kbd> to navigate to the source.

{{< figure src="makefile-3-toolwindow.png" width="307" height="490" >}}

Feedback and pull requests are always welcome!
