---
title: Keeping passwords safe
date: "2017-03-09T21:58:13+01:00"
description: Powerful and easy-to-use command line password manager
image: /blog/img/2017/keepass.png
tags:
  - passwords
  - security
  - linux
  - encryption
  - privacy
---

In Summer 2012 popular professional network Linkedin was [hacked](https://en.wikipedia.org/wiki/2012_LinkedIn_hack), and around 6,5 Mio password were leaked. Though it was just one of [many data breaches](http://www.informationisbeautiful.net/visualizations/worlds-biggest-data-breaches-hacks/) in recent years, it urged to me rethink how I protect my private data in many web services I use.

At that time, I've been using just few strong, unique passwords for most important accounts, like Google or my home bank. While for all other websites I had one pretty simple and short password. Even though primary assets are more or less protected, this is an unacceptable level of digital protection. Just imagine how harmful for your reputation would it be if someone gets access to your accounts on social networks.

I solved a Linkedin issue by just deleting my account there. But for other services, including those that were not yet hacked, I was forced to create new secure and different passwords, because my old universal password was compromised. Given that I needed 30+ new passwords long and random enough I needed software to store and manage them. It doesn't make any sense to remember so many 10 to 20 characters long passwords.

#### Password Managers

My requirements for password management software were the following:

 * it should be **free and open source**. I want to be able to use it forever and can verify it is correct and doesn't have any backdoors;
 * it **should not depend on any web service**. I want to decide myself how to synchronize database securely;
 * it should be **available on all desktop and mobile operating systems**. (Or at least on Linux, Android, and Windows, which I've been using at that time.)

{{< figure src="/blog/img/2017/keepass.png" width="1000" caption="KeePass main window on Windows" >}}

I chose [KeePass](http://keepass.info/) and its implementations for other operating systems ([KeePassX](https://www.keepassx.org/) and [KeePassDroid](https://play.google.com/store/apps/details?id=com.android.keepass)). All applications worked well, but were almost unmaintained and I soon stumbled upon some [discussions](https://news.ycombinator.com/item?id=9727297) of [possible](http://keepass.info/help/kb/sec_issues.html) [vulnerabilities](http://lifehacker.com/keepass-vulnerability-could-let-attackers-steal-your-pa-1781486764). The first thing everybody learns about encryption: do not reinvent the wheel, use well-known and proved algorithms and apply them correctly. I doubt it is the case.

#### `pass`

So I started another research and finally found an application that fully satisfied me. It is `pass` — [the standard Unix password manager](https://www.passwordstore.org/). It follows Unix philosophy: do one thing and do it well. And then combine tools to achieve the goal. Despite the slogan `pass` is available for all modern operating systems.

`pass` uses [GnuPG](https://www.gnupg.org/) to encrypt data and [git](https://git-scm.com/) to store and version it. As you may expect it is a command line tool, which is good, because I type faster than can click a mouse. And with completion available for `bash` and `zsh` it is even more convenient and fast.

It is possible to encrypt passwords for several GPG keys, either for backup or to share them (or a subdirectory only!)

The only concern in using `pass` is that it doesn't encrypt password store structure: it is naked set of (encrypted) files. However it isn't a big issue, if you are encrypt your home directory (you should!)

Also it makes sense to sign all changes (call `pass git config commit.gpgsign true` once to turn it on) to ensure repository integrity and prevent [replay attacks](https://en.wikipedia.org/wiki/Replay_attack).

#### Usage

Basic `pass` commands are easy to remember. To show an entry invoke it without arguments.

<pre><code class="shell nohighlight"><b>$</b> pass my-secret-account
Tieg5Hox7jkas</code></pre>

`-c` key tells `pass` to copy password to clipboard instead of outputting it in terminal.

`pass insert` creates a new entry, that you can later edit with `pass edit`, but I prefer using `pass generate` to have it generate a password for me.

<pre><code class="shell nohighlight"><b>$</b> pass ls dev
dev
├── android
└── plugins.gradle.org</code></pre>

`pass ls`, `pass mv`, `pass cp`, `pass rm` subcommands do exactly what you'd expect them to do: list passwords, move/rename individual entries, copy, and delete them respectively. `pass find` helps to find an entry if you don't remember its exact name or directory where you put it. `pass git` lets you manipulate storage using familiar git commands. That's it. You can learn more on [man page](https://git.zx2c4.com/password-store/about/).

Pass is powerful but very easy to use tool. I enjoy using it and feel secure and protected.
