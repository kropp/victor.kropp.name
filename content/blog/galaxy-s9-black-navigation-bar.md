---
title: Black navigation bar on Galaxy S9
description: "Two hidden settings for Galaxy S9 (and other Android phones)"
date: 2018-07-21T15:08:29+02:00
tags:
    - galaxys9
    - android
    - adb
---

I've been using Galaxy S9 since it's official release. I liked my previous Nexus 6, but unfortunately, it fell off my pocket shortly before. And also I got a good trade-in deal for one of my old phones. Samsung hardware is and has always been great, but their software… meh. It has improved recently, and it's possible to tune or disable most of the "features." One thing bothered me though: the navigation bar at the bottom was always bright white. Using apps with a dark theme in the twilight was very uncomfortable.

{{< figure src="/blog/img/2018/galaxy-s9-wnb.jpg" width="270" height="555" >}}

There is an easy solution. It only requires `adb` tool from [Android SDK](https://developer.android.com/studio/#command-tools).

❗ Do it on your own risk. I'm not responsible for any damage caused to your phone or computer by any of these actions.

[Enable USB debugging](https://developer.android.com/studio/debug/dev-options#enable). Connect the phone to a computer via a USB cable. Open Terminal and open a remote shell on your phone:

<pre class="shell nohighlight"><code><b>$</b> adb shell
</code></pre>

To check current settings run the following command:

```nohighlight
gsettings list global
```

If you've set up white navigation bar in System Settings, then among other preferences you'll see:

```nohighlight
navigationbar_color=-986896
navigationbar_current_color=-986896
```

You don't need to remember these since you can always revert to original color in Settings.

And now update the color by issuing two following commands:

```nohighlight
settings put global navigationbar_color=-16777216
settings put global navigationbar_current_color=-16777216
```

Congratulations, you now have a black navigation bar which doesn't hurt your eyes in the dark!


{{< figure src="/blog/img/2018/galaxy-s9-bnb.jpg" width="270" height="555" >}}


❗ You may want to try other colors; here's a [color picker](https://codepen.io/anon/pen/mwQjEZ). Be careful and do not try to guess colors, if you put an incorrect value, the phone may refuse to boot and need a factory reset. It happened to me, unfortunately. Don't repeat my mistakes.

#### Bonus

When I applied this change, I noticed another option available there: `airplane_mode_radios`. Its default value is `cell,bluetooth,wifi,nfc,wimax`. A quick check verified my guess: this is the list of the connections disabled when the phone is in airplane mode. I always use my Bluetooth noise-canceling headphones when I travel, and I do it quite often. I hate to re-enable Bluetooth after I switch the phone to airplane mode before takeoff.

{{< tweet 900310705630580737 >}}

So now I know how to fix this problem, all I need is to remove `bluetooth` from the list:

```nohighlight
settings put global airplane_mode_radios=cell,wifi,nfc,wimax
```

It takes just a few seconds to improve your experience from using the phone. It took me much longer to restore the phone after factory reset. And it took me even longer to finish this post.
