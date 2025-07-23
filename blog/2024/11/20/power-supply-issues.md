---
title: Raspberry Pi 4 & 400 Power Supply Issues
abstract: >
  Quick notes on some low voltage issues I ran into with my Raspberry Pi 4 and
  400 using the stock power supply with thumb drives.
pubDate: 2024-11-20T00:00:00.000Z
createDate: 2024-11-20T00:00:00.000Z
byline: 'R. S. Doiel, 2024-11-20'
author: R. S. Doiel
keywords:
  - Raspberry Pi
  - Power Supply
  - Voltage errors
dateCreated: '2024-11-20'
dateModified: '2025-07-23'
copyrightYear: 2024
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
datePublished: '2024-11-20'
---

# Raspberry Pi 4 & 400 Power Supply Issues

By R. S. Doiel, 2024-11-20

I have a Raspberry Pi 4 and Raspberry Pi 400. The former builds my personal website and my [Antenna](https://rsdoiel.github.io/antenna). I use the latter as a casual portable development box.

Over the last year or two I noticed I would get voltage warnings popping up. Typical this was prevalent when I was compiling Go, Pandoc or Deno. The power supply I was using was the Official Raspberry Pi 4 power supply that came with the Raspberry Pi Desktop Kit and Raspberry Pi 400 Computer Kit.  At first I thought the power supplies were going bad or had become damaged.  I tried replacing the power supply with one of the extras I had picked up (power supplies can and do fail). Still had problems with low voltage.

I did some digging but found nothing useful than the old recommendations of making sure the power supplies were appropriately and to spec. I did read somewhere in my searching that the official power supplies didn't have allot of headroom. This got me thinking.  The Raspberry Pi OS has been updated many times since I got these devices. Maybe there are more power demands happening than I realized.  I've also moved away from using the internal micro SD cards to using an external thumb drive to boot, that would place an additional power requirement on the system.

I looked at [PiShop.us](https://www.pishop.us) which is linked from the Raspberry Pi website as an official retailer.  They had the official supplies that came with my kits but also had one that had a higher wattage rating. I ordered [Raspberry Pi 27W USB-C Power Supply White US](https://www.pishop.us/product/raspberry-pi-27w-usb-c-power-supply-white-us/). Connected it up to my Raspberry Pi 400 via the powered monitor. Booted from the thumb drive and then tried rebuilding Go from Go 1.19 that ships with Raspberry Pi OS compiling Go 1.21.9 and 1.23.3 from source. No voltage errors.  Looks like I just out grew the stock power supply.  If this remains working without problems I will order another one and use it with my old Pi Drive enclosure and my Pi 4. Keeping my fingers crossed.