---
title: Makefile support plugin for IntelliJ IDEA
social: off
---

Plugin is available for install via [official repository](https://plugins.jetbrains.com/idea/plugin/9333-makefile-support). Source code is available on <i class="fa fa-github" style="color: rgb(23,21,21)"></i> [GitHub](https://github.com/kropp/intellij-makefile)

Plugin provides full support for GNU [Makefile syntax](https://www.gnu.org/software/make/manual/make.html) including syntax highlighting, prerequisites completion and resolution. There is also a quick-fix to create new rule from unresolved prerequisite. Individual rules can be folded for better overview.

<div class="fotorama" data-width="900" data-transition="crossfade" data-loop="true">
  <img src="makefile-example.png" width="900" height="540" data-caption="" />
  <img src="makefile-example-dark.png" width="900" height="540" data-caption="" />
</div>

It also supports executing Makefiles:

 * by clicking "run" gutter mark
 * pressing Alt-Enter and selecting target
 * using Ctrl/Cmd-Shift-F10 on a target

{{< figure src="makefile-run.png" width="700" height="500" >}}

Alternatively, a run configuration can be created for any Makefile and target, with options to set up working directory and environments variables.

{{< figure src="makefile-run-configuration.png" width="560" height="400" >}}

Feedback and pull requests are always welcome!
