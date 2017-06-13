---
title: Java Preferences API
date: "2016-09-28T22:05:00+02:00"
description: Some enexpected findings in Java Preferences API
tags:
    - java
    - cross-platform
    - windows
    - linux
    - mac
---

[`java.util.prefs.Preferences`](https://docs.oracle.com/javase/8/docs/api/java/util/prefs/Preferences.html) API is available in Java since 1.4. Here is an example:

```java
import java.util.prefs.Preferences;

public class Example {
  public static void main(String[] args) {
    Preferences root = Preferences.userRoot().node("name").node("kropp");
    root.putInt("birth_year", 1986);
    root.put("camelCase", "String/Value");
    root.node("sub_node").putBoolean("enabled", true);

    System.out.println(root.getInt("birth_year", 0));
  }
}
```

Java somehow stores given key-value pairs organized in a tree structure on a user's computer. On every operating system, it uses native APIs to do this. So values are stored in [Registry](https://en.wikipedia.org/wiki/Windows_Registry) on Windows, in [`.plist`](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man5/plist.5.html) on Mac and in XML files on others systems (primarily, Linux). Although, you shouldn't really care about it, because it just works.

But only until you need to access these settings from outside Java Virtual Machine. In my case, I needed to read/write these values from C++. So I started to investigate how it is implemented in JRE and reimplement the same in C++. Here is what I've found.

#### Mac OS

Let's start with the simplest case. On Mac OS X preferences are stored in dictionaries in `.plist` you can list them quite easily:

<pre class="shell"><code><b>$</b> defaults read ~/Library/Preferences/com.apple.java.util.prefs.plist /</code></pre>
<pre class="highlight"><code>{
    "name/" =     {
        "kropp/" =         {
            "birth_year" = 1986;
            camelCase = "String/Value";
            "sub_node/" =             {
            };
        };
    };
}
</code></pre>

Have you noticed slashes at the end of each key? For some reason Mac implementation doesn't remove node separator even though nodes are already nested. However the biggest problem is that [Preferences daemon](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man8/cfprefsd.8.html) caches these values and you're in trouble if you read/write them not using standard APIs. [The best advice](http://manytricks.com/blog/?p=3049) on how to overcome this issue was: `killall cfprefsd`

Ouch.


#### Windows

Registry keys are nested too, but Windows JRE developers have removed unnecessary slashes. Right before they would apply some fancy encoding to both keys and values.

<figure><img src="/blog/img/2016/java-preferences-registry.png" width="695" height="160" alt="" /></figure>

[Comment in Javadoc](http://hg.openjdk.java.net/jdk8/jdk8/jdk/file/687fd7c7986d/src/windows/classes/java/util/prefs/WindowsPreferences.java#l1030) explains why do they did this.

```java
/**
 * Converts value string to it Windows representation.
 * as a byte-encoded string.
 * Encoding algorithm adds "/" character to capital letters, i.e.
 * "A" is encoded as "/A". Character '\' is encoded as '//',
 * '/' is encoded as  '\'.
 * Then encoding scheme similar to jdk's native2ascii converter is used
 * to convert java string to a byte array of ASCII characters.
 */
private static byte[] toWindowsValueString(String javaName) {
  // …
}
```

Do you understand? Me neither.

#### Linux

But my favorite implementation is on Linux. At first sight it is the cleanest and the most obvious one:

<pre class="shell"><code><b>$</b> cat ~/.java/.userPrefs/name/kropp/site/prefs.xml</code></pre>
<pre class="highlight"><code>&lt;?xml version="1.0" encoding="UTF-8" standalone="no"?&gt;
&lt;!DOCTYPE map SYSTEM "http://java.sun.com/dtd/preferences.dtd"&gt;
&lt;map MAP_XML_VERSION="1.0"&gt;
  &lt;entry key="birth_year" value="1986"/&gt;
  &lt;entry key="camelCase" value="String/Value"/&gt;
&lt;/map&gt;
</code></pre>

Up until you store a key in a node with underscore in its name. Then something really awkward happens:

<pre class="shell"><code><b>$</b> ls ~/.java/.userPrefs/name/kropp/       
<b>_!(:!d@"i!&8!bg"v!'@!~@==</b>  prefs.xml
</code></pre>

This cryptic **_!(:!d@"i!&8!bg"v!'@!~@==** is actually "birth_year". What happened to it? Let's again take a look into [Java sources](http://hg.openjdk.java.net/jdk8/jdk8/jdk/file/687fd7c7986d/src/solaris/classes/java/util/prefs/FileSystemPreferences.java#l847):

```java
/**
 * Returns true if the specified character is appropriate for use in
 * Unix directory names.  A character is appropriate if it's a printable
 * ASCII character (> 0x1f && < 0x7f) and unequal to slash ('/', 0x2f),
 * dot ('.', 0x2e), or underscore ('_', 0x5f).
 */
private static boolean isDirChar(char ch) {
    return ch > 0x1f && ch < 0x7f && ch != '/' && ch != '.' && ch != '_';
}

/**
 * Returns the directory name corresponding to the specified node name.
 * Generally, this is just the node name.  If the node name includes
 * inappropriate characters (as per isDirChar) it is translated to Base64.
 * with the underscore  character ('_', 0x5f) prepended.
 */
private static String dirName(String nodeName) {
    for (int i=0, n=nodeName.length(); i < n; i++)
        if (!isDirChar(nodeName.charAt(i)))
            return "_" + Base64.byteArrayToAltBase64(byteArray(nodeName));
    return nodeName;
}
```

The encoding used appears to be Base64, but some *alternative* one. This is because in original Base64 there are both lower and upper case characters, which are indistinguishable on some file systems.

When you look at it again, this is really crazy: if there is an underscore in a node name, it is encoded and as a final step underscore is prepended. What?!


#### Conclusion

Cross platform programming is hard.
