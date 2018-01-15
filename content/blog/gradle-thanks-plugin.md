---
title: Thanks plugin for Gradle
description: Say thanks to the libraries you depend on
date: 2018-01-15T15:24:26+01:00
tags:
    - programming
    - happiness
---

Please welcome [Thanks plugin](https://plugins.gradle.org/plugin/com.github.kropp.thanks) for [Gradle](https://gradle.org/): the simplest way to thank opensource projects you depend upon. When invoked it enumerates all projects dependencies, finds out their Github projects (if source control URL is set in .pom file) and stars all those projects.

The usage is pretty simple, just add the plugin to `plugins` section:

```gradle
plugins {
    id "com.github.kropp.thanks" version "0.3"
}
```

Plugin is only compatible with Gradle 4.2 or newer. By default it does nothing, so it is safe to commit this change to your repository. To invoke the plugin, just call Gradle with `thanks` parameter.

<pre class="shell nohighlight"><code><b>$</b> ./gradlew -q thanks
</code></pre>

*`-q` disables auxiliary output*

To access [GitHub API](https://developer.github.com/v3/) the plugin needs a valid token. You can get one [here](https://github.com/settings/tokens/new). Only `public_repo` scope is required.

{{< figure src="/blog/img/2018/github-new-token.png" width="1000" height="540" >}}

Then either set it to an environment variable `GITHUB_TOKEN` or pass to Gradle with `-PGithubToken=…` command line parameter.

Here is how it works on a sample project:

<script src="https://asciinema.org/a/UJpnS2sfTioUQ60h37WsagWcu.js" id="asciicast-UJpnS2sfTioUQ60h37WsagWcu" async></script>

Thanks plugin also stars Gradle and known plugins. To add a plugin to a known plugins list, submit [issue](https://github.com/kropp/gradle-plugin-thanks/issues) or pull request on <i class="fa fa-github" style="color: rgb(23,21,21)"></i> [GitHub](https://github.com/kropp/gradle-plugin-thanks).

Don't forget to say thanks regularly, because new dependencies are added over time and ask your team colleagues to do the same.

PS. This plugin was inspired by PHP [Composer Thanks plugin](https://symfony.com/blog/say-thanks-to-the-libraries-you-depend-on), which in turn was inspired by Rust's [cargo Thanks plugin](https://github.com/softprops/cargo-thanks). Thanks [@artspb](https://twitter.com/artspb) for a link.
