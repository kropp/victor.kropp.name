---
title: "Setting up IntelliJ IDEA on Ubuntu 18.10"
date: "2019-01-28T10:39:42+01:00"
description: Essential setup for Linux users
twitter_card: summary_large_image
image: /blog/img/2019/ubuntu-intellij.png
tags:
    - intellij
    - ubuntu
---

I’ve refreshed my computer recently and installed Ubuntu 18.10 from scratch. It doesn’t require much effort and from my experience is much quicker than installing any other OS. Setting up all the software takes much more time.

{{< figure src="/blog/img/2019/ubuntu-intellij.png" width="1000" height="562" caption="IntelliJ IDEA 2019.1 EAP running on Ubuntu 18.10" >}}

But first, you need to install your favorite IDE and the best way to do it is, of course, [JetBrains Toolbox App](https://jetbrains.com/toolbox/app/). And not because I’m one of the [developers of this application]({{< ref "jetbrains-toolbox.md" >}}), but because you download it once and then it updates itself and all your IDEs automatically. One less thing to care about.

#### inotify

Before you start the IDE, there is one important system setting to tune. [IntelliJ-based IDEs use inotify](https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit) to watch project files for changes. This subsystem has very low default watches limit but it's very easy to alter it: just put the following line in `/etc/sysctl.d/90-intellij-inotify.conf`

```conf
fs.inotify.max_user_watches = 524288
```

And run this command in a terminal to apply the change:

```bash
sudo sysctl -p --system
```

#### Keyboard shortcuts conflicts

Don’t close the terminal yet, you’ll need it to resolve keyboard shortcuts conflicts. There are many of them and unfortunately, some are not listed in System Settings → Devices → Keyboard dialog.

{{< figure src="/blog/img/2019/settings-keyboard.png" width="1020" height="750" caption="System keyboard shortucts in Ubuntu/GNOME control center" >}}

Most of the conflicts come from workspaces section. If you don’t use workspaces at all you may want to disable these shortcuts completely, like I do. Just run these commands from the terminal.

```bash
gsettings set org.gnome.desktop.wm.keybindings switch-group "['disabled']"
gsettings set org.gnome.desktop.wm.keybindings switch-group-backward "['disabled']"
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['disabled']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['<Super>Page_Down']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down "['<Super><Shift>Page_Down']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up "['<Super><Shift>Page_Up']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['<Super>Page_Up']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['disabled']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['disabled']"
gsettings set org.gnome.desktop.wm.keybindings begin-resize "['disabled']"
gsettings set org.gnome.desktop.interface menubar-accel ''
```

Alt+` shortcut which I use many times daily also conflicts with the system shortcut to switch application window. Since I prefer Alt+Tab to switch between all windows (and use [Alternate Tab](https://extensions.gnome.org/extension/15/alternatetab/) GNOME Shell extension to have a better overview), I disabled it too.
I never use Alt+F8 to resize windows, but do use this shortcut in debugger to evaluate expressions. And the last one is F10 absolutely unnecessary reserved for menubar access when fewer and fewer GNOME apps have one.

#### HiDPI font scaling

If you’re a happy owner of 4K (HiDPI) screen, then you also need to install `libgtk2.0-0` package, otherwise all text will be rendered in tiny font.

```bash
sudo apt install libgtk2.0-0
```

Here is [the related issue](https://youtrack.jetbrains.com/issue/JRE-1040) in the bug tracker, this step will be not be required as soon as it is fixed.

#### IDE Cloud Settings

Now we can finally start the IDE. If you’ve already used it you can skip all initial setup and have your code editor settings, plugins, etc. [synced from the cloud](https://www.jetbrains.com/help/idea/sharing-your-ide-settings.html). This is my preferred option now. And if you’re using Toolbox App as I already suggested, you can sign in into your JetBrains Account there and have all your settings from the cloud with no additional effort.

#### Plugins

There are several [thousand plugins in the repository](http://plugins.jetbrains.com/) including [some by yours truly](http://plugins.jetbrains.com/author/449d4b59-fc7f-4c81-877a-9d82eacdc737). I’d like to highlight one here. One of the features of Unity desktop I miss in GNOME Shell is global menu integration because it saved some precious vertical screen space. I know many shortcuts by heart and even if I don’t know the one I use Ctrl+Shift+A to find and invoke needed action. Given all this, I prefer to completely remove the main menu with [Main Menu toggler](http://plugins.jetbrains.com/plugin/7297-main-menu-toggler) plugin.

That’s it, happy coding!

