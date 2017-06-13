---
date: 2016-12-12T14:54:10+01:00
description: Creating encrypted & bootable USB stick
tags:
  - linux
  - encryption
  - privacy
title: Encrypted USB stick
---

I sometimes need access to different private documents. I want them to be always easily accessible. At the moment they are stored in the cloud. However, I can never be sure that when I need them I'll be able to go online. On the other hand, I can't store them on any memory stick because I don't want to expose sensitive information if I loose the medium.

I've recently got a small 8GB USB stick, which I decided to turn into multipurpose solution: it should be at the same time unencrypted drive accessible from every OS, bootable (I put live Ubuntu distribution on it) and has a secure encrypted partition. Here's how I achieved that.

Like any other storage, USB stick may be partitioned into several parts. Luckily, Windows detects only the first one, so it will be universally accessible FAT32 partition. So, if I lose the drive, chances are high nobody even notices there is anything else.

<figure><img src="/blog/img/2016/gnome-disks.png" width="873" /></figure>

USB stick can be partitioned in any utility of choice, like `parted` or [`fdisk`](http://unix.stackexchange.com/questions/30322/how-do-i-partition-a-usb-drive-so-that-its-bootable-and-has-a-windows-compatibl). I've used GUI-based Disks (`gnome-disks`). I've created 3 partitions:

 * 2 GB FAT32 partition, unencrypted and visible everywhere
 * 2 GB ext4 for Ubuntu Live installation
 * 4 GB LUKS+ext4 encrypted partition (if you prefer command line approach, here is the excellent [guide on creating encrypted partition](https://help.ubuntu.com/community/EncryptedFilesystemsOnRemovableStorage))

<figure><img src="/blog/img/2016/usb-creator-gtk.png" width="764" /></figure>

Creating data partitions is pretty straight-forward. But default Ubuntu Startup Disk Creator (`usb-creator-gtk`) utility can't put live install in a partition and erases the whole disk instead. The solution is to do it manually, it is really easy:

<pre class="shell"><code><b>$</b> sudo dd bs=4M if=~/Downloads/ubuntu-16.10-desktop-amd64.iso of=/dev/sdb2 && sync</code></pre>

So far so good, I tested newly prepared USB stick on several computers and OS and it works great. Apart from a small problem with file ownership on encrypted partition: all files will be created there with your UID (to find it out type `id` in terminal). But on a different computer, your UID may be different. This is, for example, the case with Ubuntu Live distribution where default user has UID 999, while on a real Ubuntu installation first user usually has UID 1000. To access files you then need first to change their ownership with `chown username * -R`

