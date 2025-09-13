---
title: Notes on setting up a Mid-2010 Mac Mini
author: rsdoiel@gmail.com (R. S. Doiel)
date: '2021-12-18'
copyright: 'copyright (c) 2021, R. S. Doiel'
keywords:
  - macOS
  - High Sierra
  - Mac Mini
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
copyrightYear: 2021
copyrightHolder: R. S. Doiel
abstract: >
  I acquired a Mid 2010 Mac Mini. It was in good condition but lacked an OS on
  the hard drive.  I used a previously purchased copy of Mac OS X Snow Leopard
  to get an OS up and running on the bare hardware. Then it was a longer effort
  to get the machine into a state with the software I wanted to use on it. My
  goal was Mac OS X High Sierra, Xcode 10.1 and Mac Ports. The process was
  straight forward but very time consuming but I think worth it.  I wound up
  with a nice machine for experimenting with and writing blog posts.


  The setup process was as follows:


  1. Install macOS Snow Leopard on the bare disk of the Mac Mini

  2. Install macOS El Capitan on the Mac Mini after manually downloading it from
  Apple's support site

  3. Run updates indicated by El Capitan

  4. Install macOS High Sierra on the Mac Mini after manually downloading it
  from the Apple's support site

  5. Run updates indicated by High Sierra 

  6. Manually download and install Xcode 10.1 command line tools 

  7. Check and run some updates again

  8. Finally install Mac Ports


  The OS installs took about 45 minutes to 90 minutes each. Installing Xcode
  took about 45 minutes to an hour. Installing Mac Ports was fast as was
  installing software via Mac Ports.


  ...
dateCreated: '2021-12-18'
dateModified: '2025-07-22'
datePublished: '2021-12-18'
postPath: 'blog/2021/12/18/Notes-on-setting-up-a-2010-Mac-Mini.md'
---

Notes on setting up a Mid-2010 Mac Mini
=======================================

By R. S. Doiel, 2021-12-18

I acquired a Mid 2010 Mac Mini. It was in good condition but lacked an OS on the hard drive.  I used a previously purchased copy of Mac OS X Snow Leopard to get an OS up and running on the bare hardware. Then it was a longer effort to get the machine into a state with the software I wanted to use on it. My goal was Mac OS X High Sierra, Xcode 10.1 and Mac Ports. The process was straight forward but very time consuming but I think worth it.  I wound up with a nice machine for experimenting with and writing blog posts.

The setup process was as follows:

1. Install macOS Snow Leopard on the bare disk of the Mac Mini
2. Install macOS El Capitan on the Mac Mini after manually downloading it from Apple's support site
3. Run updates indicated by El Capitan
4. Install macOS High Sierra on the Mac Mini after manually downloading it from the Apple's support site
5. Run updates indicated by High Sierra 
6. Manually download and install Xcode 10.1 command line tools 
7. Check and run some updates again
8. Finally install Mac Ports

The OS installs took about 45 minutes to 90 minutes each. Installing Xcode took about 45 minutes to an hour. Installing Mac Ports was fast as was installing software via Mac Ports.

Reference material
------------------

- Apple support pages that I found helpful
    - [How to get old versions of macOS](https://support.apple.com/en-us/HT211683)
    - [How to create a bootable installer for macOS](https://support.apple.com/en-us/HT201372)
    - [macOS High Sierra - Technical Specifications](https://support.apple.com/kb/SP765?locale=en_US)
- Wikipedia page on [Xcode](https://en.wikipedia.org/wiki/Xcode) is how I sorta out what version of Xcode I needed to install
- Links to old macOS and Xcode
    - Download [Mac OS X El El Capitan](http://updates-http.cdn-apple.com/2019/cert/061-41424-20191024-218af9ec-cf50-4516-9011-228c78eda3d2/InstallMacOSX.dmg)
    - Download [Mac OX X High Sierra](https://apps.apple.com/us/app/macos-high-sierra/id1246284741?mt=12)
    - Download [Xcode 10.1](https://developer.apple.com/download/all/?q=xcode), Scroll down the list until you want it.
        - [Command Line Tools (macOS 10.13) for Xcode 10.1](https://download.developer.apple.com/Developer_Tools/Command_Line_Tools_macOS_10.13_for_Xcode_10.1/Command_Line_Tools_macOS_10.13_for_Xcode_10.1.dmg)
        - NOTE: There are two version available, you want the version for macOS 10.13 (High Sierra) NOT Mac OS 10.14.
