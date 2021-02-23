---
title: "RetroFlag GPi Case Setup"
author: "R. S. Doiel"
date: "2020-12-24"
keywords: [ "raspberry pi", "retro games", "case" ]
copyright: "copyright (c) 2020, R. S. Doiel"
license: "https://creativecommons.org/licenses/by-sa/4.0/"
---


Setting up a RetroFlag GPi Case
===============================

By R. S. Doiel, 2020-12-24

These are my notes for setting up a RetroFlag GPi case using Recalbox
distribution for retro gaming.

+ RetroFlag GPi Case Kit (including a Raspberry Pi Zero W and blank SD Card)
+ A computer to setup the SD Card  and the Raspberry Pi Imager v1.5

We will be installing [Recalbox](https://www.recalbox.com/ "the all-in-one retro gaming console")
v7.7.x for Raspberry Pi Zero W and GPi case.  Recalbox which is a Retro
Gaming Linux distribution.

Steps
=====

Preparing the 32 GiB SD Card
---------------------------

1. Download the appropriate Raspberry Pi Imager 1.5 from 
   https://www.raspberrypi.org/software/ for your system
2. Install and launch the Raspberry Pi Imager
3. Click "Operating System"
  a. Select "Emulation and game OS"
  b. Select "Recalbox"
  c. Select "Recalbox 7.1.1-Reloaded (Pi 0/1/GPi Case)"
4. Click "SD Card" ", then select the bank 32 GiB SD Card
5. Click "Write"
6. You will be asked remove the SD Card when done, do so and and exit 
   Raspberry Pi Imager

NOTE: The current release of Recalbox (7.7.1) doesn't require patching
with "GPI_Case_patch.zip" or installing the shutdown scripts as suggested
on the RetroFlag website. Applying the patches will prevent the GPi
from booting. The website instructions appear to be for an earlier release
of Recalbox.


Installing the Raspberry Pi Zero W in the GPi Case
--------------------------------------------------

The RetroFlag comes with instructions to install the Raspberry Pi Zero W
in the case. I found the pictorial instructions confusing. Doing a search
for "RetroFlag GPi Case Setup" yielded a link to [Howchoo's YouTube
video](https://www.youtube.com/watch?v=NyJUlNifN1I&feature=youtu.be "RetroFlag GPi CASE Setup and Usage"),  This video also talks about setting up Retro Pi software,
GPi case patches. Skip these. The instructions are now for software that
is out of date (the video dates back to 2019). 

NOTE: Howchoo describes installing RetroPie not Recalbox. Don't install a
"wpa_supplicant.conf" file or "ssh" file on the SD Card as suggested.
It is not needed and will cause problems.

The GPi case looks very much like a Game Boy. It includes a "Game Pack"
type module which will hold our Raspberry Pi once installed. I found the
assembly instructions confusing but searching YouTube for "RetroFlag GPi
Case Setup" listed several videos which describe the process of putting
the case together as well as how to install RetroPie or
Recalbox Linux Distributions.

Booting the Pi Zero W with the SD Card
--------------------------------------

1. Make sure the GPi Zero Case **IS NOT CONNECTED TO POWER**
  a. the switch the case off
  b. Disconnect the barrel to USB cable from a power source
2. Remove the "game pack" element where you've installed the Raspberry Pi Zero W
3. Insert the SD Card into the SD Card slot under the soft cover on the side of
   the Game Pack case
4. Re-insert "Game Pack" into side of the GPi case
5. Plug the barrel USB cable into a USB Power supply , 
6. Turn the power switch to "ON" on the top of the GPi case
7. Wait patiently, it's going to take several minutes to boot the first time





