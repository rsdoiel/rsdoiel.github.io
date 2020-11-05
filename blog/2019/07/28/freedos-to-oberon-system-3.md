{
    "markup": "mmark",
    "title": "FreeDOS 1.2 to Oberon System 3",
    "author": "R. S. Doiel",
    "date": "2019-07-29",
    "keywords" : [ "dos", "retro", "computing", "operating systems" ],
    "copyright": "copyright (c) 2019, R. S. Doiel",
    "license": "https://creativecommons.org/licenses/by-sa/4.0/"
}


# FreeDOS to Oberon System 3

By R. S. Doiel, 2019-07-28
(updated: 2019-08-19)


What follows are notes on getting a FreeDOS 1.2 and 
then Native Oberon running under VirtualBox 6.0. You might 
wonder why these two are together. While it was
easy to run the Native Oberon installation process that process
assumes you have a properly partitioned hard disc and VirtualBox
seems to skip that process. I found taking advantage of FreeDOS
simplified things for me.

NOTE: FreeDOS is an Open Source implementation of PC/MS DOC

NOTE: Native Oberon is a 1990's version of Oberon System running on i386

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
DOS with FreeDOS 1.2. You'll find many of your old familiar commands
but also some nice improvements. You can even run it under VirtualBox
which is what I proceeded to do.

NOTE: Download FreeDOS from http://freedos.org/download

### VirtualBox 6.0 setup

The [FreeDOS](https://freedos.org) website includes a CD ROM image
that you can use to install it. There are couple small hitches though
to get it working under VirtualBox. First go to the [download](https://freedos.org/download) page and download the [CDROM "standard" installer](http://www.freedos.org/download/download/FD12CD.iso).

While that is downloading you can setup your VirtualBox machine.
First to remember is DOS compared to today's operating systems is
frugal in its hardware requirements. As a result I picked very modest
settings for my virtual machine. 

1. Launch VirtualBox
2. From the menu, pick Machine then pick new
3. Name your machine (e.g. "FreeDOS 1.2"), select the type: "Other" and Operating system of "DOS"
4. Set memory size as you like, I just accepted the default 32MB
5. Hard disc, pick "Create a virtual hard disc now"
6. Hard disc file type, pick "VHD (Virtual Hard Disk)"
7. Storage on physical hard disc, I picked Dynamically allocated both either is fine
8. File location and size, I accepted the default location and size
9. Before starting my FreeDOS box I made a couple of changes using "settings" menu icon
    a. Display, I picked bumped memory up to 128M and picked VBoxSVGA with 33D acceleration (for games)
    b. Storage, I added a second floppy drive (empty)
    c. Network, I picked attached to NAT
10. When looking at my virtual machine's detail page I clicked on the Optical drive (empty), click "choose disc image" and pointed at the downloaded installed CD
11. Click Start.
12. At "Welcome to FreeDOS 1.2" blue screen, hit TAB key
13. Add type a space than add "raw" (without quotes) press enter
14. Follow the install instructions, when you get to "Drive C: does not appear to be partitioned" dialog, pick "Yes - Partition drive C:"
15. On the next screen pick "Yes - Please reboot now"
16. When at the "Welcome to FreeDOS 1.2" screen hit TAB again
17. Add a space to the command and then type "raw", press enter
18. Pick "Yes - continue with the installation"
19. Pick "Yes - Please erase and format drive C:"
20. At this point its a normal FreeDOS install
21. When the install is done and reboots choose the "boot from system disc",you now should have a working FreeDOS on VirtualBox

## Native Oberon System 3 on Virtual Box

Native Oberon can be found at http://www.ethoberon.ethz.ch/native/.
There is a related ftp site where you can download the necessary
files for the stand alone version. 

NOTE: Download Native Oberon Stand Alone from ftp://ftp.ethoberon.ethz.ch/ETHOberon/Native/StdAlone

Here's the steps I used in my Mac to download Native Oberon and
into a file on my desktop called "NativeOberon-Standalone". Open
the macOS Terminal application. I assume you've got a Unix
command called [wget](https://en.wikipedia.org/wiki/Wget)
already installed.

NOTE: wget is easily installed with [HomeBrew](https://brew.sh/) or [Mac Ports](https://www.macports.org/)

```bash
    cd
    mkdir -p Desktop/NativeOberon-Standalone
    cd Desktop/NativeOberon-Standalone
    wget ftp://ftp.ethoberon.ethz.ch/ETHOberon/Native/StdAlone/*.*
```

Clone your FreeDOS Box first. You'll want to do a "Full Clone". You'll
also want to "remove disk from virtual drive" for any optical discs 
or floppies. You do that from the virtual boxes' detail page and 
clicking on the drive and picking the "Remove disc from virtual 
drive" in the popup menu.

At this point we have a virtual machine that is very similar to an 
1999 era PC installed with MS DOS.  Normally you'd install 
[Native Oberon](http://www.ethoberon.ethz.ch/native/) 
via 1.44MB floppy discs.  In the folder of you downloaded there is 
disc image called "oberon0.dsk".  This is used to install a minimal
Oberon System.  What about the rest of the Oberon System?  How do 
we get the rest of the files onto a virtual floppies? This wasn't 
obvious to me at first.

## Making the floppy disc images on macOS

Use can use "Disk Utility" to create floppy disc images on a Mac. 
Unlike creating CD images you want to first use the blank image. 
From the menu click on File -> New Image -> Blank Image (or use 
the shortcut command key and "N").  You should then see a model
dialog box. This dialog lets you set the name of the image file. You
need to set the size to "1474560 B". Set format "MS-DOS (FAT)".
Set encryption of none. Set partition type of 
"Single partition - Master Boot Record" and image format set to 
"read/write". Once the disc image is created you can then mount 
the empty disc image by clicking on it in finder. Next drag the 
appropriate file(s) into the image. Unmount (eject) the image.
At the point you should have a floppy image suitable to mount
from the Virtual Box VM's "floppy drive". 

## Making the floppy disc images on Linux

On Linux I used the mkfs.mkdos with the "-o" option to set the 
image name and just created the images from the folders with each 
folder holding the appropriate file.

## Making the floppy disc images from FreeDOS

Another approach would is to use FreeDOS.  I create an 
ISO image of the Oberon installation directory and mounted that 
as a CD under FreeDOS. Next I used Virtual Box's 
"create a new floppy disc" to create an empty unformatted 1.44 MB
disc which I think formatted using the DOS command "format a:".
Once completed I copied the files to the "a:" drive also using the
DOS copy command.

In either case make sure the formatted floppy disc images are 
FAT12 or FAT16. FAT32 came about after this version of Oberon was
developed so it may not be readable for installation.

## Organizing the install discs

The Oberon install discs were organized as follows. The 
"oberon0.dsk" is initial disc to install a minimal Oberon System.
Once it's installation is complete (described in install.txt
in the Oberon System 3 Stdalone directory) you can then follow
the steps to install the rest of the system, source code
and documentation. E.g. gadgets1.arc contains the install for 
Gadgets desktop environment and is an interesting look at how
Oberon took a different path for (similar to RISC OS) for a GUI.


     PACKAGE    FILENAME       SIZE (MB)    DISC No.
------------    -----------    ---------    ---------
Oberon-0        oberon0.dsk    1.4          0
Gadgets         gadgets.arc    1.4  (2.9)   1
Documentation   docu.arc       1.3  (2.5)   2
Applications    apps.arc       1.3  (2.8)   3
Tutorials       tutorial.arc   0.3  (0.8)   4
Pr3Fonts        pr3fonts.arc   0.3  (0.6)   4
Pr6Fonts        pr6fonts.arc   0.5  (1.8)   4
Source1         source1.arc    0.9  (2.5)   5
Source2         source2.arc    1.2  (3.5)   6
Source3         source3.arc    0.6  (1.7)   7
------------    -----------    ---------    ---------

Table: sizes are in MB, compressed, then uncompressed





