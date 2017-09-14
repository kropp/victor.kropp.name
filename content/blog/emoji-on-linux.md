---
date: 2017-08-28T18:11:16+02:00
description: How to enable colored emoji on Linux
image: /blog/img/2017/emoji.png
tags:
- emoji
- linux
title: 🎉 Emoji on 🐧 Linux
twitter_card: summary_large_image
---

{{< figure src="/blog/img/2017/emoji.png" width="749" caption="" >}}

I should have prepared this blog post on World Emoji Day when Google [said farewell](https://www.blog.google/products/android/world-emoji-day-since-u-been-blob/) to its iconic 'blob' emoji typeface. Better late than never.

I'm not the biggest emoji fun, but even if I only use them rarely, I still want to see web pages as they were intended to be seen. By default on Linux one only sees a small number of black-and-white smileys. However, it is easy to setup your system to display all emojis in color.

During my short research, I stumbled upon [few](https://github.com/notwaldorf/ama/issues/53) [posts](http://probablement.net/txt/emojilinux) on how to set up emoji on Linux, but all of them were lengthy and suggested some incorrect setups. So I decided to sum up my experience in this super quick tutorial.

### Choose font

First of all, you need to choose a font. I prefer [Noto Color Emoji](https://www.google.com/get/noto/#emoji-zsye-color), which is a font used to display emojis on Android. The font was [recently updated](https://github.com/googlei18n/noto-emoji/commit/91dc393ca4f4a924f4f6b06bf8e4407b30c7bdd9) with [normal faces](https://medium.com/google-design/redesigning-android-emoji-cb22e3b51cc6) instead of old controversial blobs. But if you've been using Android since ages and like those, you always can install an older version of the same font. An alternative option would be an [Emoji One font](https://www.emojione.com/), which is also good, especially its third version.

Independently of which font you've chosen, put it in `~/.fonts`.

### Tell system you prefer this font to render emoji

Next, you need to create a file `~/.config/fontconfig/fonts.conf` with following content:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <alias>
    <family>serif</family>
    <prefer>
      <family>Noto Color Emoji</family>
    </prefer>
  </alias>
  <alias>
    <family>sans-serif</family>
    <prefer>
      <family>Noto Color Emoji</family>
    </prefer>
  </alias>
  <alias>
    <family>monospace</family>
    <prefer>
      <family>Noto Color Emoji</family>
    </prefer>
  </alias>
</fontconfig>
```

To apply new configuration, run `fc-cache -f -v` in Terminal.

After you restart a browser (or any other app), you'll see new emojis everywhere. If everything looks good, congratulations, you're done! If you see new emojis, but still in black-and-white, read further.

### *(Optionally)* Install modified font rendering library

On Ubuntu, most applications are built with [GTK](https://www.gtk.org/) framework, which uses [`cairo`](https://cairographics.org/) library to render text. It supports multi-color fonts, but this support is for some reason disabled by default. I uncommented the related line of code and [published a package in a PPA](https://launchpad.net/~kropp/+archive/ubuntu/cairo-coloremoji). To install it run the following commands:

<pre class="shell"><code><b>$</b> sudo add-apt-repository ppa:kropp/cairo-coloremoji
<b>$</b> sudo apt update && sudo apt upgrade</code></pre>

Restart your computer to apply changes.

Voilá! 🎉
