---
title: "A2 Oberon on VirtualBox 6.1"
author: "R. S. Doiel"
date: "2021-04-02"
keywords: [ "FreeDOS 1.2", "VirtualBox 6.1", "A2 Oberon"  ]
copyright: "copyright (c) 2021, R. S. Doiel"
license: "https://creativecommons.org/licenses/by-sa/4.0/"
---


A2 Oberon on VirtualBox 6.1
===========================

By R. S. Doiel, 2021-04-02

This is a short article documenting how I install A2 Oberon
in VirtualBox using the [FreeDOS 1.2](https://freedos.org),
the A2 [ISO](https://sourceforge.net/projects/a2oberon/files/) cd image and [VirtualBox 6.1](https://virtualbox.org).

Basic Approach
--------------

1. Download the ISO images for FreeDOS and A2
2. Create a new Virtual Machine
3. Install FreeDOS 1.2 (Base install) in the virtual machine
4. Install A2 from the ISO image over the FreeDOS installation

From working with Native Oberon 2.3.7 I've found it very helpful
to have a FreeDOS 1.2. installed in the Virtual machine first. 
I suspect the reason I have had better luck taking this approach
is based on assumptions about the virtual hard disk being setup
with an existing known formatted, boot-able partition. In essence
making our Virtualbox look like a fresh out of the box vintage PC.

Download the ISO Images for FreeDOS and A2
------------------------------------------

You'll find FreeDOS 1.2 installation ISO image at 
[FreeDos.org](http://freedos.org/download/). Download it
where you can easily find it from the VirtualBox manager.

You'll find the A2 Oberon ISO image at [SourceForge](https://sourceforge.net/projects/a2oberon/files/) in the A2 Files section. There is a green download
button you can click and it'll take you to a downloads page and download
the ISO.  Once again move it to where you can find it from 
the VirtualBox manager easily.


Create a new Virtual Machine
----------------------------

Fire up VirtualBox.  Click the "New" icon. Given your machine
a descriptive name and set the Type to "Other" and version to "DOS".
Click Next.

On the Memory Size panel select the memory size you want. I picked
2048 MB. A2 like other Oberon are frugal in resource consumption.
Click Next.

On the Hard Disk panel I accepted the default "Create a virtual hard disk now"
and clicked "Create" button at the bottom of the panel.

I accepted the default "VDI (VirtualBox Disk Image)" and clicked
Next.

I accepted "Dynamically allocated" and clicked Next.

I accepted the default name and 500 MB disk size and clicked
Create.

This returned me to the main VirtualBox manager panel. I click on 
the "Settings" icon. This opens the Settings panel. I Clicked on the
"Display" label in the left side of the panel. On the "Screen" tab
I increased the Video Memory from 6 MB to 128 MB.  I also checked
the "Enable 3D Acceleration" box.

Next I clicked  "Network" label in the left side of the panel.
I changed the Attached to from "NAT" to "Bridged Adapter"
before clicking "OK". This should return you to the manager panel.

Scroll down the description of your virtual machine so that the
"Storage" section is visible. You should see "IDE Secondary Device 0: 
[Optical Drive] Empty". Click the the words "Optical Drive".
You be given a context menu, click on "Choose a Disk file". Navigate
to where you saved the FressDOS ISO (e.g. FD12CD.iso).
Click Open. This should return you to the manager panel and you
should see the "FD12CD.iso" file listed.

Install FreeDOS 1.2
-------------------

Click the "Start" button.  This should boot the machine. By
default the search order for booting is floppy drive,
CD-ROM drive then hard disk.  Since we have the FD12CD.iso
mounted in the cd ROM drive it'll boot using it.

When you see the "Welcome" screen press the tab key.
You should see a line describing the image it'll boot.  Click
into the Virtual machine's window and press the space bar
then type "raw" (without the quotes). Press the enter key.

This should return you to the install process, select your
language (e.g. English for me). The select "Yes - Continue with the
installations". On the next screen select "Yes - Partition drive C:".
Then select "Yes - Please reboot now". This will reboot the
machine and bring you back to the Welcome page. Once again
press the tab key, press the space bar and type in "raw"
(without the quotes).

As before select your language and select "Yes - Continue with
the installation". This time you should see the option 
"Yes - Please erase and format drive C:", select it. 
After formatting it ask you to select your keyboard type.
It will then give you the option of installing base or full
installations (with our without source).  I suggest only
selecting "Base packages only".  

On the next screen select "Yes - Please install FreeDOS 1.2".
After it finishes you can select "Yes - Please reboot now".
When the machine reboots you'll see the welcome screen again
but rather than press tab, select "Boot system from hard disk".
Press enter to select the extended memory manager and you
should now be at the DOS "C:>" prompt.

Switch back to the VirtualBox manager panel and click on
"Optical Drive" and click "Remove disk from virtual drive".

Installing A2 Oberon
--------------------

We now should have a Virtual Machine ready to receive A2.
Click the "Optical Drive" again and select the A2 ISO
image you downloaded from SourceForge previously.
Your optical drive should show the full filename of
the ISO image, e.g. "A2_Rev-6498_serial-trace.iso"
We can now click the "Start" icon in the manager panel.

A2 comes up running like a "live CD".  It's the full A2
so you can play around with it if you want but we're going
to install it on our virtual hard drive. At the bottom of the
A2 desktop you should see a panel of buttons. Click the button
labeled "System". This will change the panel buttons below it.
In the lower panel you should see "Installer", click it. This
will bring up a "Welcome to Oberon" installer window. You will
see two presentations of drives. The upper one will be the hard
drive where we want to install A2 and the lower one is the 
virtual CD ROM we're running. Click on the bar for the hard disk.
Before click the drive bar was red. After clicking it was yellow.
The text label above the var says, "IDE0 (VBOX HARD DISK), Size 
500 MB, Open count 0".

In the lower part of the panel click "Quickinstall", then
answer Yes to the model dialog that pops up. After a few moments 
A2 should finish installing itself on the virtual hard disk.  The lower
panel's buttons will include one labeled "Done", press it. This
will close the installer window.

At the bottom of the desktop you should still see the System
panel buttons. There is a red one labeled "Shutdown". Press it.

The virtual machine's screen should go black. On my machine
I press the right control key (the host key) to release my
mouse and keyboard from the virtual machine. Close the window
and when it select "Power of the machine" in when VirtualBox
prompts how to shut it down.

Like with the FD12CD.iso we want to unmount our A2 installation
CD ROM. Click on the "Optical Drive" in the manager panel
and choose "Remove disk from virtual Drive". 

You can now start the machine again and start exploring A2.
I recommend looking at the [Oberon Wikibook](https://en.wikibooks.org/wiki/Oberon#A2_and_UnixAOS)
 for details about how to use A2 and ideas of what to explore.

One nice feature of A2 is it includes a full "NativeOberon"
or ETH Oberon as an A2 Application.

