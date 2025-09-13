---
title: 'Setting up my Raspberry Pi 500, a Portable Workstation'
author: R. S. Doiel
byline: 'R. S. Doiel, 2025-02-14'
dateCreated: '2025-02-14'
abstract: >
  Quick notes on configuring a Raspberry Pi 500 as a portable workstation along
  with a price list.
keywords:
  - Raspberry Pi
  - Workstation
  - Review
copyrightYear: 2025
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
dateModified: '2025-07-23'
datePublished: '2025-02-14'
postPath: 'blog/2025/02/14/Review_Pi-500_as_portable_workstation.md'
---

# Setting up my Raspberry Pi 500, a Portable Workstation

By R. S. Doiel, 2025-02-14

I'm  writing this on a newly setup Raspberry Pi 500. So far I'm impressed. I was sceptical about moving from my Pi 400 but when it died I was forced to upgrade. It has been worth it.

I've now had a chance to install the various pieces of software I regularly use. Even do some web browsing with it. Image some SD cards for a RISC OS project I'm working on. It feels much quicker than my Pi 400. I think the speed increase is in part the faster CPU but I suspect the program I am running is taking advantage of the 8 Gig RAM instead of the old 4. As I've testing this machine out I noticed I had stopped asking myself the question about launching more than one large program at a time (e.g. my browser is running and being used as I type this in VS Code). When I tried VS Code on my Pi 4B+ and 400 it just felt too sluggish. I'm typing this review in VS Code now on the Pi 500 is keeping up OK.

When I purchased the Pi-500 and I also decided to go with the new Raspberry Pi Monitor. Together I have a complete portable workstation. While my previous powered WaveShare monitor was higher resolution the Pi Monitor it  also used allot more power.  With the combination of Pi Monitor and Pi-500 I am now contemplating exploring power consumption so I can find a one battery to power the monitor and Pi-500.

Here's the spec and pricing for this new machine. Some parts I didn't purchase because I already owned them (e.g. the 27W Pi power supply) but I have included the list prices for those who might be interested.

Item                                List Price    Notes                   
----------------------------------  ------------  -----------------------
Raspberry Pi 500 unit               $90.00        included  32G SD card  
Raspberry Pi 27W Power supply       $13.65        used existing one      
Raspberry Pi Mouse                  $9.25         used existing one      
Micro HDMI to standard HDMI cable   $5.75         used existing one      
Raspberry Pi Monitor                $100.00                              
Raspberry Pi 15W Power supply       $8.00         for monitor            
Raspberry Pi 128G SD Card           $16.95        upgraded storage       


## Software Setup

I created an "image" on my 128G SD Card using the Raspberry Pi Imager on another computer.  The imager lets you setup initial user account, WiFi configuration and whether you want SSH services running the first boot. I like using the vanilla 64 bit Raspberry Pi OS distribution. I picked the one for the Raspberry Pi 5 series.

When I booted the Pi-500 connected to the Pi Monitor it seemed to cause the screen to cycle through and Pi splash page a few times. Once it completed its first boot it hasn't done that again. I am assuming that was some negotiation between the monitor and the Pi. After a quick click around test I rebooted the machine by doing a full shutdown and power off and the power back up.

### Development and Writing Software

I am planning to use the Pi-500 as a light weight development machine and as a machine for preparing updates for my blog. I installed the additional software below.

- Pandoc 3 via installed via deb package from Pandoc GitHub releases
- Rust installed via Rustup
- PageFind installed via Cargo
- Flatlake installed via Cargo
- htmlq installed via Cargo
- ncal installed via Cargo
- Deno installed via website using CURL
- Go installed via website's tar ball
- jq installed via apt
- SQLite3, libsqlite3-dev installed via apt
- Hunspell and US English dictionary installed via apt

The "build-essential" package was already installed. I noticed that Git and GNU Make were immediately available with my first boot.

I this setup as a portable  workstation. It feels quick and snappy but is small enough to toss in computer bag. I did test compile a few things. It is possible to peg the CPU but then again it's a little machine after all. I didn't get any warning lights or notifications like I used to on the Pi-400.

With a connection to my home WiFi network (not a fast connection) it took me about an hour or so to download and install all my extras. This was quicker than the last time I setup a Pi. Some of the time saved was the better hardware and net work performance but much of the time saved was due to the fact that I did not have to compile software from scratch. That was a change from the last time I setup a Pi up.  I guess  Pi and aarch64 processors are common enough that projects are now including it in their regular builds.

If  I pickup the right capacity battery I suspect I will have a lovely deconstructed Laptop to use as a portable workstation.
