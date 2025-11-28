---
title: Upgrade my Raspberry Pi 500+ to Trixie
dateCreated: "2025-11-27"
dateModified: "2025-11-28"
datePublished: "2025-11-28"
author: R. S. Doiel
description: |
  A brief step by step to upgrading from Raspberry Pi OS 5 to Raspberry Pi OS 6
  for my Raspberry Pi 500+.
keywords:
  - Raspberry Pi
  - Upgrade
postPath: "blog/2025/11/28/Upgrade-Pi-500-plus.md"
---

# Upgrading my Raspberry Pi 500+ to Trixie

By R. S. Doiel, 2025-11-28

I has a Raspberry Pi 500+ running Raspberry Pi OS 5 (bookworm). It has been a really fun computer for my hobby projects. Raspberry Pi OS 6 is now out (Trixie). The official recommendation to update the OS is to back everything, then re-image the drive. For the Raspberry Pi 500+ the image is on the NVME drive. I don't have access to boot from Ethernet for the 500+ so how to proceed? One approach is install Pi OS on an SD Card, boot from it to re-image the NVME drive.

Here's the multi-step process.

1. Using a SD Card and Raspberry Pi Imager, create a boot-able SD card
2. Reboot selecting the SD Card as the boot drive
3. Test Trixie via the SD Card
4. If the tests work out then install Trixie on the NVME drive and reboot

This is pretty straight forward and reminds me a bit of the old days with DOS and CP/M.  The question is step 2. 

I've have seen the new boot menu flash by when I boot up the 500+ plus but haven't payed close attention to it. It came with the original OS install on the Pi 500+.  The boot menu provides an option to select a boot drive. This makes it much easier than the old days when you had to edit files to change the boot drive. 

My missing bit of information was how to interrupt the regular boot sequence to make the selection. The 500+ boots pretty quickly so it was hard to read the text that flashes by. The answer is **to pause the boot process and enter the boot menu start from a cold boot. Power up and press the space bar**. This will present you with some choices. Select the number for the drive and proceed.

## Actual steps

1. Backup home directory on Raspberry Pi 500+ (home was one NVME drive)
2. Confirm firmware is up to date, following the instruction on Raspberry Pi website
2. Confirm I have the latest Raspberry Pi Imager
2. Using Raspberry Pi Imager image an SD Card with latest Raspberry Pi OS 6
3. Power down Raspberry Pi 500+
4. Power up Raspberry Pi 500+ pressing space bar during boot process
5. Select boot from SD Card with fresh OS
6. Setup Raspberry Pi on SD Card, updating to the latest Raspberry Pi Imager
7. Using the Pi Imager on the SD Card, install a fresh image on the NVME drive (NOTE: This erases the whole drive!!!)
8. Then finished, power down the 500+
9. Remove the SD Card from the 500+
10. Boot 500+ from the NVME, complete the usual setup process
11. Restore my home directory backup, install latest Go, Deno, OBNC, etc.

