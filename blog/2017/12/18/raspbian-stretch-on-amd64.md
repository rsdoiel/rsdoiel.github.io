---
title: Raspbian Stretch on DELL E4310 Laptop
author: rsdoiel@gmail.com (R. S. Doiel)
date: '2017-12-18'
keywords:
  - Raspbian
  - Raspberry Pi OS
  - amd64
  - i386
  - operating systems
copyright: 'copyright (c) 2017, R. S. Doiel'
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: >
  This post talks about a used Dell E4310 I purchased. It covers setting it up
  with [Raspbian Stretch](https://www.raspberrypi.org/blog/raspbian-stretch/)
  and configuring it so I can share it with my family.
dateCreated: '2017-12-18'
dateModified: '2025-07-22'
datePublished: '2017-12-18'
copyrightYear: 2017
copyrightHolder: R. S. Doiel
---

# Raspbian Stretch on DELL E4310 Laptop

by R. S. Doiel 2017-12-18

Today I bought a used Dell E4310 laptop. The E4310 is an "old model" now
but certainly not vintage yet.  It has a nice keyboard and reasonable 
screen size and resolution. I bought it as a writing machine. I mostly
write in Markdown or Fountain depending on what I am writing these days.

## Getting the laptop setup

The machine came with a minimal bootable Windows 7 CD and an blank 
internal drive. Windows 7 installed fine but was missing the network 
drivers for WiFi.  I had previously copied the new [Raspbian Stretch](https://www.raspberrypi.org/blog/raspbian-stretch/) ISO to a USB drive. While
the E4310 didn't support booting from the USB drive Windows 7 does make
it easy to write to a DVRW. After digging around and finding a blank disc
I could write to it was a couple of mouse clicks and a bit of waiting 
and I had new bootable Raspbian Stretch CD.

Booting from the Raspbian Stretch CD worked like a charm. I selected 
the graphical install which worked well though initially the trackpad 
wasn't visible so I just used keyboard navigation to setup the install.
After the installation was complete and I rebooted without the install
disc everything worked except the internal WiFi adapter.

I had several WiFi dongles that I use with my Raspberry Pis so I 
borrowed one and with that was able to run the usual `sudo apt update 
&& sudo apt upgrade`.

While waiting for the updates I did a little web searching and found 
what I needed to know on the Debian Wiki (see
https://wiki.debian.org/iwlwifi?action=show&redirect=iwlagn).  Following
the instructions for *Debian 9 "Stretch"* ---

```shell
    sudo vi /etc/apt/sources.list.d/non-free.list 
    # adding the deb source line from the web page
    sudo apt update && sudo apt install fireware-iwlwifi
    sudo modprobe -r iwlwifi; sudo modprobe iwlwifi
    sudo shutdown -r now
```

After that everything came up fine.

## First Impressions

First, I like Raspbian Pixel. It was fun on my Pi but on an Intel box
with 4Gig RAM it is wicked fast.  Pixel is currently my favorite flavor 
of Debian GNU/Linux. It is simple, minimal with a consistent UI for 
an X based system. Quite lovely. 

If you've got an old laptop you'd like to breath some life into 
Raspbian Stretch is the way to go.


### steps for my install process

+ Booted from a minimal Windows 7 CD to get a basic OS minus networking
+ Used Windows 7 and the internal DVD-RW to create a Raspbian Stretch CD
+ Booted from the Raspbian Stretch CD and installed Raspbian replacing Windows 7
+ Used a spare WiFi dongle initially to fetch the non-free iwlwifi modules
+ Updated my source list, re-run apt update and upgrade
+ Rebooted and everything came up and is running