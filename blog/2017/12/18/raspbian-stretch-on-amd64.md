
# Raspbian Stretch on AMD64

by R. S. Doiel 2017-12-18

To day I bought a used Dell E4310. It is an old model, not quiet vintage
yet.  It has a nice keyboard and responable screen size and resolution. I
bought it as a writing machine.

The machine case with a minimal bootable Windows 7. With that I was able
to download and create a CD to Boot [Raspbian Strech](https://www.raspberrypi.org/blog/raspbian-stretch/) for PC. Last year I had played with the
Pixel Raspbian live boot for Intel and enjoyed it but didn't have a machine
to run it on regularly. I also have a number of Raspberry Pis so it wasn't
compelling. But installing the new Stretch on this used Dell has been a
real joy.

First, I like Raspbian Pixel. It is currently my favorite flavor of Debian 
GNU/Linux to use. It simple, minimal with a consistant UI for an X based 
system. Quite lovely. It makes my Raspberry Pi pleasurable to use.  But 
what has impressed me today is have wicked fast it runs on this old 
Intel based laptop. 

The install process for me went as followed.

+ Booted from a minimal Windows 7 CD to get a basic OS with network working
+ Downloaded the ISO and created a Raspbian Stretch for PC CD using the built in DVD+RW drive
+ Rebooted from Raspbian Strech and replaced the Windows install

The only small hickup was I needed to use one of my Raspberry Pi's 
WiFi dongles to add the non-free apt source lists to pick up the driver 
module needed by the Dell. Ran the usual `sudo apt update && sudo apt upgrade && sudo apt autoremove` followed by a reboot and everything seems to 
work fine. Even sound seems to work though the built in speaker are pretty
modest.

If you've got an old laptop you'd like to breath some life into this is
the way to go!

