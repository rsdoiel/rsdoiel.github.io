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
