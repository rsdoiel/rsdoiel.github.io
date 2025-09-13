---
title: Getting Started with Miranda
byline: 'R. S. Doiel, 2024-04-25'
keywords:
  - functional
  - miranda
pubDate: 2024-04-25T00:00:00.000Z
author: R. S. Doiel
copyrightYear: 2024
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: >
  I've been interested in exploring the Miranda programming language. Miranda
  influenced Haskell. Haskell was used for programs I use almost daily such as
  [Pandoc](https://pandoc.org) and [shellcheck](https://www.shellcheck.net/).
  I've given a quick review of [miranda.org.uk](https://miranda.org.uk) to get a
  sense of the language but to follow along with the [Miranda: The Craft of
  Functional
  Programming](https://www.cs.kent.ac.uk/people/staff/sjt/Miranda_craft/) it is
  really helpful to have Miranda available on my machine. Today that machine is
  a Mac Mini, M1 processor, running macOS Sonoma (14.4.x) and the related Xcode
  C tool chain.  I ran into to minor hiccups in compilation and installation.
  Both easy to overcome but ones I will surely forget in the future. Thus I
  write myself another blog post.


  ...
dateCreated: '2024-04-25'
dateModified: '2025-07-23'
datePublished: '2024-04-25'
postPath: 'blog/2024/04/25/getting-started.md'
---

# Getting Started with Miranda

I've been interested in exploring the Miranda programming language. Miranda influenced Haskell. Haskell was used for programs I use almost daily such as [Pandoc](https://pandoc.org) and [shellcheck](https://www.shellcheck.net/). I've given a quick review of [miranda.org.uk](https://miranda.org.uk) to get a sense of the language but to follow along with the [Miranda: The Craft of Functional Programming](https://www.cs.kent.ac.uk/people/staff/sjt/Miranda_craft/) it is really helpful to have Miranda available on my machine. Today that machine is a Mac Mini, M1 processor, running macOS Sonoma (14.4.x) and the related Xcode C tool chain.  I ran into to minor hiccups in compilation and installation. Both easy to overcome but ones I will surely forget in the future. Thus I write myself another blog post.

## Compilation

First down load Miranda source code at <http://miranda.org.uk/downloads>. The version 2.066 is the most recent release I saw linked (2024-04-25), <http://www.cs.kent.ac.uk/people/staff/dat/ccount/click.php?id=11>. The [COPYING](https://www.cs.kent.ac.uk/people/staff/dat/miranda/downloads/COPYING) link shows the terms under which this source release is made available.

Next you need to untar/gzip the tarball you downloaded. Try running `make` to see if it compiles. On my Mac Mini I got a compile error that looks like

~~~shell
make
gcc -w    -c -o data.o data.c
data.c:666:43: error: incompatible integer to pointer conversion passing 'word' (aka 'long') to parameter of type 'char *' [-Wint-conversion]
                     else fprintf(f,"%c%s",HERE_X,mkrel(hd[x]));
                                                        ^~~~~
1 error generated.
make: *** [data.o] Error 1
~~~

While I'm rusty on C I read this as the C compiler being more strict today then it was back in the 1990s. That's a good thing generally.  Next I checked the compiler version. 

~~~shell
gcc --version
Apple clang version 15.0.0 (clang-1500.3.9.4)
Target: arm64-apple-darwin23.4.0
Thread model: posix
InstalledDir: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin
~~~

I'm using clang and the website mentioned it should compile with clang for other platforms.  I reviewed the data.c file and notice other similar lines that invoked `mkrel(hd[x])` had a `(char *)` cast in front of `hd[x]`. This tells me that being explicit with the compiler might solve my problem. I edited line 666 of data.c to look like

~~~C
    else fprintf(f,"%c%s",HERE_X,mkrel((char *)hd[x]));
~~~

Save the file and then ran Make again. It compile cleanly. I gave at quick test run of the `mira` command creating an simple function called `addone`

~~~miranda
mira
/edit
addone a = a + 1
:wq
addone (addone (addone 3))
6
/q
~~~

Miranda seems to work. The Makefile comes with a an install rule but the install defaults doesn't really work with macOS (it wants to install into `/usr`).
I'd rather it install into my home directory so I copied the Makefile to `miranda.mak` and change the lines setting `BIN`, `LIB` and `MAN` to the following
lines.

~~~Makefile
BIN=$(HOME)/bin
LIB=$(HOME)/lib#beware no spaces after LIB
MAN=$(HOME)/man/man1
~~~

In my `.profile` I set the `MIRALIB` variable to point at `$HOME/lib/miralib`. I opened a new terminal session and ran `mira` and the interpreter was up and running.
