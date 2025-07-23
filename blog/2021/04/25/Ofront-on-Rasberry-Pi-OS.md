---
title: Ofront on Raspberry Pi OS
author: rsdoiel@gmail.com (R. S. Doiel)
date: '2021-04-25'
keywords:
  - Oberon
  - Raspberry Pi OS
  - Ofront
  - Mostly Oberon
  - V4
  - Linz
copyright: 'copyright (c) 2021, R. S. Doiel'
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
copyrightYear: 2021
copyrightHolder: R. S. Doiel
abstract: >

  This post is about getting Ofront[^1] up and running on Raspberry Pi OS[^2].

  Ofront provides a Oberon-2 to C transpiler as well as a Oberon V4[^3]

  development environment. There are additional clever tools like `ocat`

  that are helpful working with the differences in text file formats between

  Oberon System 3, V4 and POSIX. The V4 implementation sits nicely on top of

  POSIX with minimal compromises that distract from the Oberon experience.


  [^1]: Ofront was developed by Joseph Templ, see
  http://www.software-templ.com/ 


  [^2]: see https://www.raspberrypi.org/software/ (a 32 bit Debian based Linux
  for both i386 and ARM)


  [^3]: see https://ssw.jku.at/Research/Projects/Oberon.html


  ...
dateCreated: '2021-04-25'
dateModified: '2025-07-22'
datePublished: '2021-04-25'
series: |
  Mostly Oberon
seriesNo: 22
---

Ofront on Raspberry Pi OS
=========================

By R. S. Doiel, 2021-04-25

This post is about getting Ofront[^1] up and running on Raspberry Pi OS[^2].
Ofront provides a Oberon-2 to C transpiler as well as a Oberon V4[^3]
development environment. There are additional clever tools like `ocat`
that are helpful working with the differences in text file formats between
Oberon System 3, V4 and POSIX. The V4 implementation sits nicely on top of
POSIX with minimal compromises that distract from the Oberon experience.

[^1]: Ofront was developed by Joseph Templ, see http://www.software-templ.com/ 

[^2]: see https://www.raspberrypi.org/software/ (a 32 bit Debian based Linux for both i386 and ARM)

[^3]: see https://ssw.jku.at/Research/Projects/Oberon.html


An Initial Impression
---------------------

I first heard of running Ofront/V4 via the ETH Oberon Mail list[^4].
What caught my eye is the reference to running on Raspberry Pi. Prof. Templ 
provides two flavors of Ofront. One targets the Raspberry Pi OS on ARM
hardware the second Linux on i386. The Raspberry Pi OS for Intel is an
i386 variant. I downloaded the tar file, unpacked it and immediately ran
the "oberon.bash" script provided eager to see a V4 environment. It
renders but the fonts rendered terribly slowly. I should have read the
documentation first!  Prof. Templ provides man pages for the tools that
come with Ofront including the oberon application. Reading the
man page for oberon quickly addresses the point of slow font rendering.
It also discusses how to convert Oberon fonts to X Windows bitmap fonts.
If you use the X Window fonts the V4 environment is very snappy. It does
require that X Windows knows where to find the fonts used in V4. That is
done by appending the V4 converted fonts to the X Window font map. I had
installed the Ofront system in my home directory so the command was

```bash
xset +fp $HOME/ofront_1.4/fonts
```

Running "oberon.bash" after that immediately improved things. Since I didn't
need the Oberon fonts outside of V4 I added the `xset` command to the
"oberon.bash" script just before it invokes the `oberon` command.

[^4]: See Hans Klaver's message: http://lists.inf.ethz.ch/pipermail/oberon/2021/015514.html 


Goals in my setup
-----------------

I had three goals in wanting to play with Ofront and running the V4
Oberon.

1. I wanted to work in an Oberon System environment
2. I need a system meets my vision requirements (e.g. larger font size)
3. I wanted to understand the Linz/V4 variation in Oberon's evolution

Ofront address all three once you get the X Window side setup correctly.

Setting up Ofront and V4
------------------------

First we need to boot up a Raspberry Pi OS device (or an i386 Linux with X11).
We need to retrieve the software from Joseph Templ's [software-templ.com](https://software-templ.com).
Two 1.4 versions are available precompiled. The first is for ARM running
Raspberry Pi OS and the second is for generic Linux i386 with X11. I initially
tested this on an old laptop where running the i386 version of Raspberry Pi OS. 

What we need
------------

The following software is usually already installed on your 
Raspberry Pi OS.

+ curl to download the files[^5]
+ gunzip to uncompressed the archive file
+ tar to unpack the archive file

[^5]: If not try `sudo apt install curl` from the command line

What we do
----------

1. Download the appropriate tar file
    a. ARM: http://www.software-templ.com/shareware/ofront-1.4_raspbian-Pi3.tar.gz
    b. Intel i386: http://www.software-templ.com/shareware/ofront-1.4_linux-386-3.2.tar.gz
2. Make sure we can read the compressed archive file
3. Gunzip and untar the file

Here's the commands I used for the Raspberry Pi hardware.

```bash
    curl -O http://www.software-templ.com/shareware/ofront-1.4_raspbian-Pi3.tar.gz
    tar ztvf ofront-1.4_raspbian-Pi3.tar.gz
    tar zxvf ofront-1.4_raspbian-Pi3.tar.gz
```

Here's the commands I used for Raspberry Pi OS on Intel

```bash
    curl -O http://www.software-templ.com/shareware/ofront-1.4_linux-386-3.2.tar.gz
    tar ztvf ofront-1.4_linux-386-3.2.tar.gz
    tar zxvf ofront-1.4_linux-386-3.2.tar.gz
```

At this point there should be an `ofront_1.4` directory
where you gunziped and untared the archive file. At this point
you can test to make sure everything runs by doing the following
(remember the font rendering with be very slow).

```
    cd ofront_1.4
    ./oberon.bash
```

You can exit the V4 environment by closing the window or typing
`System.Quit ~` in an Oberon viewer and middle clicking with your
mouse[^6].

[^6]: Oberon Systems expect a three button mouse, with a two button mouse you hold the alt key and press the left button. Note that command in Oberon are case sensitive.

The reason the system is so slow is that X is having to write bitmaps
a pixel at a time in the window holding our Oberon System. What we
want X to do is render an X Window font.  Joseph as provided us with
the Oberon fonts already converted for X! We just need to let the
X Window system know where to look.

What we need
------------

+ an editor for editing `oberon.bash`

What we'll do
-------------

1. Exit the running Oberon System using `System.Quit ~` or just close the window
2. Edit `oberon.bash` to speed up font rendering
3. Try `oberon.bash` again and see the speed bump

With your favorite editor add the `xset` line before the `oberon`
command is invoked. My "oberon.bash" looks like this.

```
#!/bin/bash

if [ -z "$OFRONT_HOME" ]; then
  export OFRONT_HOME=.
  echo "OFRONT_HOME set to ."
fi
export OBERON=.:$OFRONT_HOME/V4_ofront:$OFRONT_HOME/V4:$OFRONT_HOME/fonts
export LD_LIBRARY_PATH=.:$OFRONT_HOME/lib
export PATH=.:$OFRONT_HOME/bin:$PATH
xset +fp $HOME/ofront_1.4/fonts
$OFRONT_HOME/bin/oberon -f ./V4/Big.Map -u 8000 -c $* &
```

The `xset` command adds the provided X fonts to X Window. This
results in a huge speedup of rendering. I also add the options
for using the largest font sizes via a font map file, "V4/Big.Map"
and set the display units to 8000. Your vision or monitor may
not need this so you want to only add the line to include the
X fonts needed by Oberon.

Now re-launch Oberon using the updated "oberon.bash" and
see the improvement.

```
    vi oberon.bash
    ./oberon.bash
```

You now have a functioning V4 Oberon System to play with and
explore.

There are some additional POSIX environment setup you can
add to improve the integration with your Linux setup. These
are covered in the man pages for the tools that come with Ofront.
Additional information is also provided in the Oberon Texts
and Tools files in the V4 environment. All are worth reading.


What does this setup provide?
-----------------------------

At the point we have V4 available we have a rich development
and text environment. One which I feel is conducive to both
writing in general and programming specifically. You are running
under an adapted Oberon System so there are somethings to consider.

The Oberon V4 file system does support punctuation characters aside
from periods and slashes.  So when I tried to edit a file with hyphens
in the name Oberon assumed the filename stopped at the first hyphens.
The Oberon file systems are typically case sensitive so this can
be worked around with letter case. Of course I could modify the V4
system to allow for more letters too. That's the nice thing about
having the source code.

The second issue if file format.  In Oberon we can embed fonts
and coloring and that is treated as normal text. End of line
characters are represented as a carriage return. In POSIX environments
we have "plain text" without specific font directives and we use
a line feed to terminate lines. Fortunately Prof. Templ provided
a program called `ocat`[^7] that makes short work of converting an
Oberon text into a POSIX friendly format. On the Oberon side of things
it's also easy because Oberon will treat an ASCII file as a text we
only need to convert the line endings and in the Ofront implementation
of V4 it handles the differences in line endings behind the scenes.

If you create or store a file in the Oberon environment it'll become
Oberon text. If you need to have a plain text version use `ocat`.
If you only read POSIX files in the Oberon environment then they remain
plain text files but V4 takes care of translating the POSIX line ending
to ones that are displayed nicely in Oberon.


[^7]: In the `ofront_1.4` directory run `man man1/ocat.1` to find out more

What to explore next?
---------------------

Now that we have a fast running V4 system we have some choices
for development. Joseph Templ has adapted the display for X
and also the file system so the files are visible from the Unix
shell.  This is a powerful arrangement. This supports both Oberon
development and the use of Oberon language for the development of
POSIX friendly programs.  The Ofront collection provides the
`ofront` an Oberon-2 to C translator, `ocl` is a tool that will
combine `ofront` with your C compiler and linker to produce
programs and libraries for Linux. There is also `ocat` for
converting Oberon texts to POSIX plain text and `showdef` for
showing module definitions.  Finally Ofront provides the
`oberon` command so we have an Oberon System available as a
development environment.

One thing I recommend exploring is Jospeh Templ's GitHub repository.
The makefile provided with the GitHub version assuming an existing
installation of ofront. Since we have one we can compile our own copy
from scratch. If you're running i386 you'll want to look at
`V4_ofront/linix386` for Pi hardware take a look at `V4_ofront/raspbian`.

Here's how I generated a new version on my Pi hardware.

```
    git clone https://github.com/jtempl/ofront
    cd ofront/V4_ofront/raspbian
    make
    ./oberon.bash
```

There is a note in the README of that directory about finding
`libX11.so` but I did not need the symbolic link suggested. Since the
font path was previously adjusted for the original version I downloaded
from Templ's website I didn't need to add the fonts again. If I fork
Templ's version or GitHub I will probably update the "oberon.bash"
file included to check to see if the X fonts are available and if not
add them via `xset`. That's on a someday maybe list, for now I am
content exploring the system as is.


Someday, Maybe
--------------

Things that come to mind after initial exploration include--

- Figure out how to make Atkinson-Hyperlegible[^8] available to V4
- Replace the X11 integration with SDL 2 integration and run under macOS or Windows
- Exploring porting V4 to run natively Raspberry Pi via Clang cross compilers

Not sure I'll get the time or have the energy to do these things but
they are certainly seem feasible with Ofront as it stands now.

[^8]: See https://brailleinstitute.org/freefont