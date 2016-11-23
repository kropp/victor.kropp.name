---
date: 2016-11-21T17:49:05+01:00
description: Great conference for developers in Vilnius, Lithuania
image: /blog/img/2016/buildstuff.jpg
tags:
  - programming
  - conference
  - builfstuff
title: BuildStuff 2016 Report
---

Last week I attended [BuildStuff](http://buildstuff.lt/) conference in Vilnius. I was there to work (to chat with our users mostly) at the JetBrains booth, but I also had a chance to listen to many talks during all three conference days. Here is my report.

### Day 1

#### New Adventures in Responsive design *by* [Vitaly Friedman](https://twitter.com/smashingmag)

Vitaly is chief editor of well known [Smashing Magazine](https://smashingmagazine.com/). I couldn't miss a chance to see him live. He was talking about evolution in responsive design, building blocks and tools, showing parallels to teletext development few decades ago. In the second part of this talk he explained how one can be built statically generated, but dynamic web site with API services or generated JSON files and [Service Workers](https://developer.mozilla.org/en/docs/Web/API/Service_Worker_API). I chose similar approach for my personal web site.

#### Metrics Driven Development *by* [Sam Elamin](https://twitter.com/Samelamin)

To understand what your application is doing you need to measure it: on business level (number of requests served, purchases done, etc.) and application level (these are mainly performance timers). Choose core metric — the most important one and don't measure everything. Follow the money to choose what to measure.

There was also an interesting idea to DDOS your own application in order to prove it can handle future load. For example, put the application under constant load of 50% additional fake requests and when your real load increases, you can turn off these fake requests and serve real ones safely.

### Day 2

#### How shit works: the CPU *by* [Tomer Gabel](https://twitter.com/tomerg)

Tomer talked about basic things every developer should know, even if he/she work with higher level programing languages. 30 year old processor is already very complex, but CPUs didn't change fundamentally since then. He showed that RAM access is slow (like 30× time to access registers).
If you are working on performance critical parts of application, you should be aware of branch (mis)prediction and develop cache-friendly algorithms. There is one popular technique, **tiling**: split workload into blocks to limit number of hot cache lines.

#### Work on wrong things first *by* Amye Scavarda

This talk was a flop. Reading text on slides is not how one does a good talk.

#### Lean requirements *by* [Bill Cronin](https://twitter.com/AgileBandit)

Bill showed interesting numbers on failed projects and wasted budgets and provided some examples, like Myspace (which was once a most popular social network in the world) or Kodak, who invented digital photography, but didn't embrace new technology because of fear it destroy their current business.
There are 3 major reasons projects fail:
1. Lack of executive support
2. No end user involvement
3. Unclear requirements

In order to succeed team should achieve shared understanding of their goal.

#### Secret sauce of successful teams *by* [Sven Peters](https://twitter.com/svenpet)

Sven was talking about good practices in building successful teams and shared lots of examples how they achieve this in Atlassian. Here are they:

* Successful teams are built of successful persons. Rockstars are great, but it's a team who builds project.
* High performance teams speak to each other, listen to each other, respect each other. Make team a safe place.
* They share the same mindset, follow the same line and have the same vision.
* How do you measure success? Stretch goals, quarterly, transparent.
* Cross-functional teams.
* Conference video Fridays—watch and discuss together some relevant recent talk.
* Team is made of individuals, give kudos to each other
* Intranet should be open by default
* How healthy is the team?
* Be the change you seek

He also recommended a book to read on this topic: [Creativity Inc.](https://www.amazon.de/Creativity-Inc-Overcoming-Unseen-Inspiration/dp/0593070097/ref=tmm_hrd_swatch_0?_encoding=UTF8&qid=1479814692&sr=8-1)

### Day 3

#### Understanding and building your own Docker *by* [Motiejus Jakštys](https://twitter.com/mo_kelione)

Motiejus did an awesome talk on building your own Docker in 20 lines of Bash. However, the devil is in the details, so he warned not to use it in production, because there are tons of issues, you should be aware of.

So, basic building blocks are:

1. `fork`/`exec`
2. Copy-on-write filesystem, like `zfs`, `btrfs` or `lvm` (for effective container images)
3. `cgroups` for fairness
4. Namespaces for isolation
   * `unshare --map-root-user` → pretend to be root
   * `unshare --mount` → isolate mounts
   * `unshare --pid --mount-proc --fork` → isolate processes
   * `ip netns add t1` → adds network namespace t1

Here are [the materials for Motiejus' talk](https://github.com/Motiejus/buildstuff2016) if you're interested in more details.


#### Modern Linux Tracing Landscape *by* [Sasha Goldshtein](https://twitter.com/goldstn)

During his talk Sasha listed so many usefull commands, tools and extension points, that I need some more time to review them all. Firstly, there are tracepoints (`/sys/kernel/debug/tracing/available_events`) There are also tracepoints in VMs for higher level languages. This is employed by `ftrace` reads events from `debugfs` file, not really suitable for a huge number of events.
Secondly, there are `kprobes` and `uprobes` for kernel and user code. They are used by `BPF` — emering kernel tracing technology. BCC (BPF Compiler Collection) simplifies using it.

Very useful talk, here are the [slides](https://s.sashag.net/buildstuff1). You find lots of links there.

#### How Do You Know When Your Product is Ready to be Shipped? *by* [Yegor Bugayenko](https://twitter.com/yegor256)

Actually, the talk was renamed to "Test Exit Criteria", but I haven't heard exact criteria suggested. And there were also some points I strongly disagree, like "Developers and QA should be in (productive) conflict". However, Yegor has speaking talent and it was interesting to listen to him.

#### Functional C++ *by* [Kevlin Henney](https://twitter.com/KevlinHenney)

I did only few notes during this talk, because it was so interesting and packed, that I almost had no time. Kevlin is an excellent speaker and I definetely recommend to watch this talk when recording is available. Some key takeaways are:

* Functional approach provides benefits in any language

* Cast is ugly thing, so it should look ugly

* Mutex should have been called bottleneck (I put a bottleneck in this code)

And, surprisingly, I even learned a new russian word (остранение) during the talk!

### Conclusion

The conference overall was great organized, there were many entertaining things around: VR & Old Games rooms, I enjoyed both. I would love to come back next year!

P. S. One very important note about this conference:	

{{< tweet 798784908353097728 >}}