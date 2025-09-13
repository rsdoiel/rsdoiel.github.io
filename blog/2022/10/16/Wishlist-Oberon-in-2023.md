---
title: Wish list for Oberon in 2023
author: rsdoiel@gmail.com (R. S. Doiel)
byline: 'R. S. Doiel, 2022-10-16'
pubDate: 2022-10-16T00:00:00.000Z
keywords:
  - Oberon
  - Oberon-07
  - Oberon System
  - Artemis
copyrightYear: 2022
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: >
  Next year will be ten years since Prof. Wirth and Paul Reed released [Project
  Oberon 2013](https://www.projectoberon.com).  It took me most of that decade
  to stumble on the project and community.  I am left wondering if Prof. Wirth
  and Paul Reed sat down today what would they design? I think only minor
  changes are needed and those mostly around assumptions.



  ...
dateCreated: '2022-10-16'
dateModified: '2025-07-22'
datePublished: '2022-10-16'
postPath: 'blog/2022/10/16/Wishlist-Oberon-in-2023.md'
---

Wish list for Oberon in 2023
===========================

Next year will be ten years since Prof. Wirth and Paul Reed released [Project Oberon 2013](https://www.projectoberon.com).  It took me most of that decade to stumble on the project and community.  I am left wondering if Prof. Wirth and Paul Reed sat down today what would they design? I think only minor changes are needed and those mostly around assumptions.

Oberon-07 changing assumptions
------------------------------

The language of Oberon-07 doesn't need to change. I do think the assumptions of the compiler are worth revisiting.  A CHAR should not be assumed to be an eight bit byte.  A CHAR should represent a character or symbol in a language. Many if not most of the Oberon community speaks language other than American English and that which is trivially represented in seven or eight bit ASCII.  While changing the representation assumption in Oberon-07 does increase complexity I feel restrict the character presentation of a CHAR to eight bits puts us on the side of "too simple" in the equation of "Simpler but not to simple".

I am concerned about the assumption of an INTEGER as 32 bits. Increasingly I've seen single board computer implementations that are 64 bits.  Today feels allot like when I started in computing where personal computers were shifting from eight or sixteen bits to thirty two.  I suspect increasingly we will find that eight, sixteen and thirty two bit computers are relegated to the realm of specialized computers. While supporting these other widths will remain important I think shifting assumptions to sixty four bit machines makes sense now. Is a 32 bit machine "too simple" in our equation of "simpler but not too simple"?



Oberon as Operating System
--------------------------

The operating system I still find liberating in 2023 as when I first was able to use it.  The challenge in 2023 though is the three button mouse. I think the supporting the historic mouse remains important but that the viewers should also support navigation via the keyboard and easily support touch systems that lack a mouse.  Being backward compatibly while adopting an enhance UI would make things more complex bit if care is taken I think that it can be done while keep the equation balanced as "simpler, but not too simple".

Transforming my assumptions in 2023
-----------------------------------

I think the Artemis Project should presume that the representation of CHAR and INTEGER may change and probably should change. The portable modules should support compiling Oberon-07 programs on non-Oberon 2014 Systems without change.  I am skeptical that I can create a module system that provides a base line with the historic Oberon implementations. I think the Oakwood modules are just too limited. I think the assumption is I need implementations for Project Oberon 2013 modules as the base line perhaps enhanced with a few additional modules to supporting networking, UTF-8, JSON, and XML. The goal I think is that using Artemis on a non-Oberon System should facilitate bootstrapping an Oberon System 2023 should one come to exist.

Errata
------

7:00 - 7:30; Oberon Language; A minimum SYSTEM module; It occurred to me that while the SYSTEM module will need to address the specifics of the hardware and host environment it could support a minimum set of useful constants. What would be extremely helpful would be able to rely on knowing the max size of an INTEGER, the size of CHAR (e.g. 8, 16 or 32 bits), default character encoding used by the compiler (e.g. ASCII, UTF-8). Likewise it would be extremely helpful to know the the CPU type (e.g. arm64, amd64, x86-32), Operating System/version and name/version of the compiler.  I think this would allow the modules that depend on SYSTEM directly to become slightly more portable.
