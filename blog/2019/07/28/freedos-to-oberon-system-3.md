---
title: "FreeDOS 1.2 to Oberon System 3"
author: "R. S. Doiel"
date: "2019-07-28"
updated: "2021-03-16"
keywords: [ "FreeDOS", "Oberon System" ]
copyright: "copyright (c) 2018, R. S. Doiel"
license: "https://creativecommons.org/licenses/by-sa/4.0/"
---


FreeDOS to Oberon System 3
==========================

By R. S. Doiel, 2019-07-28

>    UPDATE: (2021-02-26, RSD) Under VirtualBox 6.1 these
>    instructions still fail. My hope is to revise these 
>    instructions when I get it all sorted out.
>
>    Many links such as the ftp site at ETH Oberon are 
>    no more. I've updated this page to point at Wayback machine
>    or included content in here where I cannot find it else where.
>
>    UPDATE: (2021-02-19, RSD) Under VirtualBox 6.1 these instructions 
>    fail. For VirtualBox I’ve used FreeDOS 1.3rc3 Live CD installing 
>    the “Plain DOS” without problems.
>
>    UPDATE: (2021-03-16, RSD) After reviewing my post, correcting
>    some mistakes I finally was able to get FreeDOS up and running
>    on VirtualBox 6.1. This allows NativeOberon 2.3.6 to be brought
>    up by booting the "oberon0.dsk" virtual floppy and following
>    the instructions included. You need to know how to use
>    the Oberon mouse and the way commands work in Oberon.

What follows are notes on getting a FreeDOS 1.2[^1] and 
then Native Oberon[^2] running under VirtualBox 6.0. You might 
wonder why these two are together. While it was
easy to run the Native Oberon installation process that process
assumes you have a properly partitioned hard disk and VirtualBox
seems to skip that process. I found taking advantage of FreeDOS
simplified things for me.

My goal was running Oberon System 3, but setting up a Virtual Box
with FreeDOS 1.2 gave me a virtual machine that functions like a 
1999 era PC. From there all the steps in the Oberon instructions
just worked.

## Creating FreeDOS 1.2 Virtual Box

I've been doing a bit if computer history reading and decided to
bring up some older systems as a means to understand where
things were.  The first computers I had access to were 8080, 8086
machines running MS DOS based. My first computer programming language
was Turbo Pascal. Feeling a bit nostalgic I thought it would be
interesting to use it again and see what I remembered from the days
of old. While PC and MS DOS no longer exist as commercial productions
an wonderful group of Open Source hackers have brought new life into
DOS with FreeDOS 1.2[^3]. You'll find many of your old familiar commands
but also some nice improvements. You can even run it under VirtualBox
which is what I proceeded to do.

### VirtualBox 6.0 setup

The [FreeDOS](https://freedos.org) website includes a CD ROM image
that you can use to install it. There are couple small hitches though
to get it working under VirtualBox. First go to the [download](https://freedos.org/download) page and download the [CDROM "standard" installer"](http://www.freedos.org/download/download/FD12CD.iso).

While that is downloading you can setup your VirtualBox machine.
First to remember is DOS compared to today's operating systems is
frugal in its hardware requirements. As a result I picked very modest
settings for my virtual machine. 

1. Launch VirtualBox
2. From the menu, pick Machine then pick new
3. Name your machine (e.g. "FreeDOS 1.2"), select the type: "Other" and Operating system of "DOS"
4. Set memory size as you like, I just accepted the default 32MB
5. Hard disk, pick "Create a virtual hard disc now"
6. Hard disk file type, pick "VHD (Virtual Hard Disk)"
7. Storage on physical hard disk, I picked Dynamically allocated both either is fine
8. File location and size, I accepted the default location and size
9. Before starting my FreeDOS box I made a couple of changes using "settings" menu icon
    a. Display, I picked bumped memory up to 128M and picked VBoxSVGA with 33D acceleration (for games)
    b. Storage, I added a second floppy drive (empty)
    c. Network, I picked attached to NAT
10. When looking at my virtual machine's detail page I clicked on the Optical drive (empty), click "choose disc image" and pointed at the downloaded installed CD
11. Click Start.
12. At "Welcome to FreeDOS 1.2" blue screen, hit TAB key
13. You will see a line that begins with a boot instruction. Add a space than add the word "raw" (without quotes) press enter
14. Follow the install instructions, when you get to "Drive C: does not appear to be partitioned" dialog, pick "Yes - Partition drive C:"
15. On the next screen pick "Yes - Please reboot now"
16. When at the "Welcome to FreeDOS 1.2" screen hit TAB again
17. Once again add a space and type "raw" to the command then press enter
18. Pick "Yes - continue with the installation"
19. Pick "Yes - Please erase and format drive C:"
20. At this point its a normal FreeDOS install
21. When the install is done and reboots "eject" the virtual CD form the "Optical Drive" in the VirtualBox panel, then choose "boot from system disk",you now should have a working FreeDOS on VirtualBox

## Native Oberon System 3 on Virtual Box

Native Oberon can be found at http://www.ethoberon.ethz.ch/native/.
There is a related ftp site[^4] where you can download the necessary
files for the stand alone version. 

Here's the steps I used in my Mac to download Native Oberon and
into a file on my desktop called "NativeOberon-Standalone". Open
the macOS Terminal application. I assume you've got a Unix
command called [wget](https://en.wikipedia.org/wiki/Wget)
already installed[^5].

> NOTE: The ETH ftp server is no more. I've included Web Archive
> links and links to my own copies of the files needed to
> install Native Oberon 2.3.6 in the paragraphs that follow.
> RSD, 2021-03-16

```bash

    cd
    mkdir -p Desktop/NativeOberon-Standalone
    cd Desktop/NativeOberon-Standalone
    wget ftp://ftp.ethoberon.ethz.ch/ETHOberon/Native/StdAlone/

```

Clone your FreeDOS Box first. You'll want to do a "Full Clone". You'll
also want to "remove" any optical disks or floppies. You do that from
the virtual boxes' detail page and clicking on the drive and picking the
"Remove disk from virtual drive" in the popup menu.

At this point we have a a virtual machine that is very similar to an 
1999 era PC installed with MS DOS.  [Native Oberon](http://web.archive.org/web/20190929033749/http://www.ethoberon.ethz.ch/native/) Normally you'd
install [Native Oberon via 1.44MB floppy disks](/blog/2019/07/28/NativeOberon-StnAlone-2.3.6.zip "Zip file of individual floppies"). 
We can simulate that with our Virtual machine.
In the folder of you downloaded there is disc called "oberon0.dsk". That
can go in our first floppy drive. But how to we get the rest of the 
files onto a virtual floppies? This wasn't obvious to me at first.

The Oberon install disks were organized as follows

| PACKAGE    | FILENAME     | SIZE  | DSK   |
| ---------- | ------------ | ----- | ----- |
| Oberon-0      | [oberon0.dsk](oberon0.dsk "boot disk")  |          | 0 | 
| Gadgets       | [gadgets.arc](gadgets1.arc "a modified gadgets.arc to fit 1.4 floppy")  | 1.4  2.9 | 1 | 
| Documentation | [docu.arc](docu.arc "documentation")     | 1.3  2.5 | 2 | 
| Applications  | [apps.arc](apps.arc "applications")     | 1.3  2.8 | 3 | 
| Tutorials     | [tutorial.arc](tutorial.arc "tutorial") | 0.3  0.8 | 4 | 
| Pr3Fonts      | [pr3fonts.arc](pr3fonts.arc "fonts") | 0.3  0.6 | 4 | 
| Pr6Fonts      | [pr6fonts.arc](pr6fonts.arc "fonts") | 0.5  1.8 | 4 | 
| Source1       | [source1.arc](source1.arc "Source Code")  | 0.9  2.5 | 5 | 
| Source2       | [source2.arc](source2.arc "Source Code")  | 1.2  3.5 | 6 | 
| Source3       | [source3.arc](source3.arc "Source Code")  | 0.6  1.7 | 7 | 


It turns out you can create 1.44MB Fat16 disc images from the
Virtual Box 6.0 floppy drive link.  When you click on the floppy
drive in the details page you have a choice that includes "create a new floppy disc". Select this, find the disc a filename like "disk1". Click
on the virtual floppy disk in the Virtual Box and "remove"
the disc then create disk2, disk3, etc. In each the empty disc image
files places the files from the table above. These image files can then
be opened on your host operating system and files copied to them. 
It's a tedious process but this gives you something the Oberon System 
can read and install from. Originally I just put all the files into an 
ISO CD ROM image but I could not figure out how to mount that from this
version of Oberon. Now when you start up your Oberon V3 virtual machine
you can install the rest of the software like Gadgets.


[^1]: FreeDOS is an Open Source implementation of PC/MS DOC

[^2]: Native Oberon is a 1990's version of Oberon System running on i386

[^3]: Download FreeDOS from http://freedos.org/download

[^4]: Download Native Oberon Stand Alone from [ftp://ftp.ethoberon.ethz.ch/ETHOberon/Native/StdAlone](NativeOberon-StdAlone-2.3.6.zip "Zip of what used to be available in that directory at ftp.ethoberon.ethz.ch")

[^5]: wget is easily installed with [HomeBrew](https://brew.sh/) or [Mac Ports](https://www.macports.org/)
