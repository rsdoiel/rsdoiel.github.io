---
title: Setting up FreeDOS 1.3rc4 with Qemu
author: rsdoiel@gmail.com (R. S. Doiel)
date: '2021-11-27'
copyright: 'copyright (c) 2021, R. S. Doiel'
keywords:
  - FreeDOS
  - Qemu
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
copyrightYear: 2021
copyrightHolder: R. S. Doiel
abstract: |
  In this article I'm going explore setting up FreeDOS with Qemu
  on my venerable Dell 4319 running Raspberry Pi Desktop OS (Debian
  GNU/Linux).  First step is to download FreeDOS "Live CD" in the
  1.3 RC4 release. See http://freedos.org/download/ for that.

  ## Installing Qemu

  I needed to install Qemu in my laptop. It runs the Raspberry Pi
  Desktop OS (i.e. Debian with Raspberry Pi UI). I choose to install
  the "qemu-system" package since I will likely use qemu for other
  things besides FreeDOS. The qemu-system package contains all the
  various systems I might want to emulate in other projects as well
  as several qemu utilities that are handy.  Here's the full sequence
  of `apt` commands I ran (NOTE: these included making sure my laptop
  was up to date before I installed qemu-system).

  ...
dateCreated: '2021-11-27'
dateModified: '2025-07-22'
datePublished: '2021-11-27'
series: |
  Exploring FreeDOS
seriesNo: 1
---

Setting up FreeDOS 1.3rc4 with Qemu
-----------------------------------

By R. S. Doiel, 2021-11-27

In this article I'm going explore setting up FreeDOS with Qemu
on my venerable Dell 4319 running Raspberry Pi Desktop OS (Debian
GNU/Linux).  First step is to download FreeDOS "Live CD" in the
1.3 RC4 release. See http://freedos.org/download/ for that.

Installing Qemu
---------------

I needed to install Qemu in my laptop. It runs the Raspberry Pi
Desktop OS (i.e. Debian with Raspberry Pi UI). I choose to install
the "qemu-system" package since I will likely use qemu for other
things besides FreeDOS. The qemu-system package contains all the
various systems I might want to emulate in other projects as well
as several qemu utilities that are handy.  Here's the full sequence
of `apt` commands I ran (NOTE: these included making sure my laptop
was up to date before I installed qemu-system).

~~~
sudo apt update
sudo apt upgrade
sudo apt install qemu-system
~~~

Now that I had the software available it was time to figure out
how to actually knit things together and run FreeDOS.


Obtaining FreeDOS 1.3rc4
------------------------

Before I get started I create a folder in my home directory
for running everything. You can name it what you want
but I called mine `FreeDOS_13` and changed into that folder
for the work in this article.

~~~
mkdir FreeDOS_13
cd FreeDOS_13
~~~

I initially tried the CD images but ran into odd problems with
qemu (possibly due to my lack of experience with qemu).
After looking at that various options the USB Full release
seemed like a good choice. It comes both as an image you can
"burn" to your USB drive both also as a "vmdk" file used with
emulators.

~~~
curl -L -O https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/distributions/1.3/previews/1.3-rc4/FD13-FullUSB.zip
unzip FD13-FullUSB.zip
~~~

At this point you should see the FreeDOS "vmdk" file, and "img" file and readme files if you list the directory out. I'm going to use the "vmdk" file to install FreeDOS on my virtual harddrive freedos.img.

~~~
ls -l 
~~~

Prepping my virtual machine
---------------------------

A virtual machine is not just a CPU and some random
access memory. A machine can include storage devices. For
the retro "DOS" experience you might looking virtual devices
for a "harddrive", "floppy drive" and "CD-ROM drive". 
Qemu provides a tool called `qemu-img` for creating 
these types of virtual devices.

The basic command is `qemu-img` using the "create" option with
some parameters.  The parameter are filename and size (see
`man qemu-img` for gory details). I am calling my virtual
harddrive "freedos.img".  With `qemu-img` the size can be
specified with a suffix like "K" for kilobytes,  "M" for
megabytes and "G" for gigabytes. DOS is a minimal requirements
a small (by today's standards) 750 megabyte harddrive seems
appropriate.

~~~
qemu-img create freedos.img 750M
~~~

For my purposes I need a harddrive so I stopped there. You
can always create other drives and then restart your virtual
machine with the appropriate options.

Bring up my FreeDOS box
-----------------------

Now I was ready to boot from installation media and install
FreeDOS 1.3rc4 on my virtual harddrive.  For that I
use a "qemu" command for the system I want to emulate.
I picked `qemu-system-i386` (see can see
the gory details of that command using `man qemu-system-i386`).
To install FreeDOS I'm going to boot from the vmdk file 
provided for the purpose of installation. I then use the FreeDOS
installer to make my freedos.img file bootable with all the
DOS software I want to play with.

~~~
qemu-system-i386 \
   -m 8 \
   -boot menu=on,strict=on \
   -hda freedos.img \
   -hdb FD13FULL.vmdk
~~~

At this point you should see the machine start to boot, press Esc
when prompted and select the second hard drive to boot from (that's
our vmdk drive).  The drive is then treated like the CD-ROM, follow
the programs instructions for installation. You will need to reboot
several times during the process. Until your full installation is
complete you'll need to select the second harddrive as the boot drive
and continue the installation.

The first time I successfully installed FreeDOS 1.3rc4 I just installed
the plain dos. When I re-did the process I install everything. It
fills up my 750M virtual harddrive but rc4 includes development tools
like a C compiler.  That I think made it worth it.

Here's a Bash script you can use to build your FreeDOS machine.

~~~
#!/bin/bash

if [ ! -f freedos.img ]; then
  echo "Creating fresh Harddisk as drive C:"
  qemu-img create freedos.img 750M
fi
echo "Booting machine using FD13FULL.vmdk for installation"
qemu-system-i386 \
    -m 8 \
    -boot menu=on,strict=on \
    -hda freedos.img \
    -hdb FD13FULL.vmdk
~~~

And here is one for running it.

~~~
#!/bin/bash

echo "Booting machine using freedos.img as drive C:"
qemu-system-i386 \
    -m 8 \
    -boot menu=on,strict=on \
    -hda freedos.img
~~~

Next step, explore FreeDOS and see what I can build.

Putting everything together
---------------------------

Below is a [script](run-freedos-1.3rc4.bash) I developed automating either building or running your FreeDOS setup.

~~~
#!/bin/bash

if [ ! -f FD13FULL.vmdk ]; then
    if [ ! -f FD13-FullUSB.zip ]; then
      echo "Missing FD13FULL.vmdk, downloading FD13-FullUSB.zip"
      curl -L -O https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/distributions/1.3/previews/1.3-rc4/FD13-FullUSB.zip
    fi
    echo "Unzipping FD13-FullUSB.zip"
    unzip FD13-FullUSB.zip
fi

if [ ! -f freedos.img ]; then
  echo "Creating fresh Harddisk as drive C:"
  qemu-img create freedos.img 750M
  echo "Booting machine using FD13FULL.vmdk as drive C:"
  echo "Installing FreeDOS on drive D:"
  qemu-system-i386 \
      -name FreeDOS \
      -machine pc \
      -m 32 \
      -boot order=c \
      -hda FD13FULL.vmdk \
      -hdb freedos.img \
      -parallel none \
      -vga cirrus \
      -display gtk
else
  echo "Booting machine using freedos.img on drive C:"
  qemu-system-i386 \
      -name FreeDOS \
      -machine pc \
      -m 32 \
      -boot menu=on,strict=on \
      -hda freedos.img \
      -parallel none \
      -vga cirrus \
      -display gtk
fi
~~~


Reference material
------------------

My inspiration for this was the description of manual install in
the FreeDOS book section of the website, [Manual Install](https://www.freedos.org/books/get-started/june14-manual-install.html).