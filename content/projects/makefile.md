---
title: Makefile support plugin for IntelliJ IDEA
social: off
---

## Makefile support plugin for IntelliJ IDEA

Plugin is available for install via [official repository](https://plugins.jetbrains.com/idea/plugin/9333-makefile-support). Source code is available on <i class="fa fa-github" style="color: rgb(23,21,21)"></i> [GitHub](https://github.com/kropp/intellij-makefile)

Plugin provides full support for GNU [Makefile syntax](https://www.gnu.org/software/make/manual/make.html) including syntax highlighting, prerequisites completion and resolution. There is also a quick-fix to create new rule from unresolved prerequisite. Individual rules can be folded for better overview.

<div class="fotorama" data-width="900" data-transition="crossfade" data-loop="true">
  <img src="makefile-example.png" width="900" height="540" data-caption="" />
  <img src="makefile-example-dark.png" width="900" height="540" data-caption="" />
</div>

It also supports executing Makefiles:

 * via "run" gutter mark
 * from Make tool window
 * pressing Alt-Enter and selecting target
 * using Ctrl/Cmd-Shift-F10 on a target

{{< figure src="makefile-run.png" width="700" height="500" >}}

#### Run configuration

Alternatively, a run configuration can be created for any Makefile and target, with options to set up working directory, add arguments and environments variables.

{{< figure src="makefile-run-configuration.png" width="500" height="447" >}}

#### Tool window

Version 1.5 introduced a dedicated tool window, containing all project Makefiles and their targets. Press Enter to run a target, F4 to navigate to the source.

{{< figure src="makefile-toolwindow.png" width="477" height="318" >}}

Feedback and pull requests are always welcome!
