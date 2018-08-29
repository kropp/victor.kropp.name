---
title: Unexpected GIF animation issues
description: Not every GIF is created equal
date: 2018-08-29T15:50:33+02:00
tags:
    - gif
    - commandline
    - imagemagick
---

Last week I helped to create an animated GIF from a short screencast for a [blog post](https://blog.jetbrains.com/blog/2018/08/23/toolbox-app-1-11-whats-new/) announcing Toolbox App 1.11 release. The solution for this task on Ubuntu is pretty straightforward with `ffmpeg` and `ImageMagick`:

<pre class="shell nohighlight"><code><b>$</b> ffmpeg -i screencast.mov -r 25 'screencast/frame-%03d.png'
<b>$</b> convert -delay 4 -loop 0 -layers optimize-transparency screencast/*.png screencast.gif
</code></pre>

`ffmpeg` creates a sequence of frames in a given format (defined by the file extension in the pattern) with the given frame rate of 25 fps.

`convert` combines all the frames into an animated GIF. This command sets the delay between frames to 4 hundredths of a second (25 fps × 0.04 delay = 1 second), makes it loop infinitely (non-zero argument makes it repeat a given number of times and then stop), and optimizes file by saving only the difference between frames.

You may optionally also play with `-fuzz 1%` parameter, I don't recommend it for screencasts where you'd better have bigger but crispier image, but if you're working with video, than treating similar colors as the same may significantly reduce each layer and thus the size of the whole file.

*I intentionally don't make it a one-liner. Usually, GIF animations are short, so you can quickly check out all frames and edit them as necessary. For example, shorten intro and outro, remove unwanted intermediate mouse movements to produce precise and accurate motion.*

There were few issues though.

First, it didn't work. Well, it worked blazing fast when I didn't want any optimizations but produced 30 MB GIF file, which is… too large even for current download speeds. And when I applied optimizations, it either entered an infinite memory leaking loop or failed with some exceptions shortly after the start. It appeared that the problem was in [very low default resource limits](https://www.imagemagick.org/discourse-server/viewtopic.php?f=1&t=34044&p=156413#p156413) (`/etc/ImageMagick-6/policy.xml`). When I increased them everything worked as expected, it was just a little bit slower than in the first run.

{{< figure src="/blog/img/2018/toolbox111-bad.gif" width="584" height="740" caption="The image above appears broken in Safari" >}}

The second problem was that suddenly the resulting GIF didn't display in Safari and Preview on macOS. I spend nearly an hour trying to understand what's wrong with the image, and the answer surprised me. It turned out that cropping I applied to each frame before converting them into a GIF was breaking things. I applied the following command to each image:

<pre class="shell nohighlight"><code><b>$</b> convert -crop 800x600+100+200 image.png
</code></pre>

But this command only crops a visible layer but leaves the original image (Virtual Canvas) size intact. In many image formats, like JPEG, it is unsupported, but GIF supports files in which image size is different from any its layers sizes. And it worked in any browser and app I tried but confused Safari which I didn't try. Alas. Good for me the fix was trivial:

<pre class="shell nohighlight"><code><b>$</b> convert -crop 800x600+100+200 +repage image.png
</code></pre>

It is explained in the [documentation](http://www.imagemagick.org/Usage/crop/), but who reads it? ¯\\\_(ツ)\_/¯

{{< figure src="/blog/img/2018/toolbox111.gif" width="441" height="700" caption="Final animation" >}}
