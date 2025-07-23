---
title: Compiling OBNC on macOS
series: Mostly Oberon
number: 6
author: rsdoiel@gmail.com (R. S. Doiel)
date: '2020-05-06'
keywords:
  - Oberon
  - programming
copyright: 'copyright (c) 2020, R. S. Doiel'
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
copyrightYear: 2020
copyrightHolder: R. S. Doiel
abstract: >
  This is the sixth post in the [Mostly Oberon](../../04/11/Mostly-Oberon.html)
  series. Mostly Oberon documents my exploration of the Oberon Language, Oberon
  System and the various rabbit holes I will inevitably fall into.


  Compiling OBNC v0.16.1 on macOS (10.13.6) using MacPorts (2.6.2) 

  is straight forward if you have the required dependencies and 

  environment setup up. Below are my notes to get everything working.


  ...
dateCreated: '2020-05-06'
dateModified: '2025-07-22'
datePublished: '2020-05-06'
seriesNo: 6
---

Compiling OBNC on macOS 
=======================

By R. S. Doiel, 2020-05-06

This is the sixth post in the [Mostly Oberon](../../04/11/Mostly-Oberon.html) series. Mostly Oberon documents my exploration of the Oberon Language, Oberon System and the various rabbit holes I will inevitably fall into.

Compiling OBNC v0.16.1 on macOS (10.13.6) using MacPorts (2.6.2) 
is straight forward if you have the required dependencies and 
environment setup up. Below are my notes to get everything working.

## Prerequisites

+ OBNC v0.16.1
+ SDL v1.2
+ Boehm-Demers-Weiser GC
+ A C compiler and linker (OBNC uses this to generate machine specific code)

### SDL 1.2

MacPorts has libsdl 1.2 available as a package called "libsdl"
(not surprisingly). There are other versions of the SDL available
in ports but this is the one we're using.


~~~

   sudo port install libsdl

~~~


### The Boehm-Demers-Weiser GC

You need to install the Boehm-Demers-Weiser GC installed. Using
MacPorts it is almost as easy as installing under Debian. The
package is less obviously named than under Debian. The package
you want is "beohmgc".


~~~

    sudo port install boehmgc

~~~


More info on the GC.

+ [The Boehm-Demers-Weiser GC](https://www.hboehm.info/gc/)
+ [MacPorts page](https://ports.macports.org/port/boehmgc/summary)

### C compiler and linker

XCode is provides a C compiler and linker. That is what is installed on my
machine. It can be a bit of a pain at times with obscure errors, particularly with regards to the linker. Your milleage may very. I know you can
install other C compilers (e.g. Clang) but I haven't tried them yet.

## Setting up my environment

You need to update your CC variables to find the header and
shared library files for compilation of obnc with `build`. (I added
these to my `.bash_profile`). New Macs ships with zsh and
your settings might be in a different location. MacPorts puts 
its libraries under the `/opt/local` directory.


~~~

    export C_INCLUDE_PATH="/usr/include:/usr/local/include:/opt/local/include"
    export LIBRARY_PATH="/usr/lib:/usr/local/lib:/opt/local/lib"
    export LD_LIBRARY_PATH="/usr/lib:/usr/local/lib:/opt/local/lib"

~~~


## OBNC environment variables

This follows' Karl's docs.  Additionally if you install OBNC extlib so
you can do POSIX shell programs you'll need to set your
`OBNC_IMPORT_PATH` environment.  An example of including a default
install location and local home directory location.


~~~

    export OBNC_IMPORT_PATH="/usr/local/lib/obnc:$HOME/lib/obnc"

~~~


### Next and Previous

+ Next [Oberon-07 and the file system](../09/Oberon-07-and-the-filesystem.html)
+ Previous [Combining Oberon-07 and C](../01/Combining-Oberon-and-C.html)