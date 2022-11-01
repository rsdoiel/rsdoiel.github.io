---
title: "Installing Cargo/Rust on Raspberry Pi 400"
author: "rsdoiel@gmail.com (R. S. Doiel)"
byline: "R. S. Doiel"
pubDate: 2022-10-31
keywords: [ "64bit", "Rapsberry Pi OS", "Cargo", "rustc" ]
---

Installing Cargo/Rest on Raspberry Pi 400
=========================================

On my Raspberry Pi 400 I'm running the 64bit Raspberry Pi OS.
The version of Cargo and Rustc are not recent enough to install
[ncgopher](https://github.com/jansc/ncgopher). What worked for
me was to first install cargo via the instructions in the [The Cargo Book](https://doc.rust-lang.org/cargo/getting-started/installation.html). 

~~~shell
curl https://sh.rustup.rs -sSf | sh
~~~

An important note is if you previously installed a version of Cargo/Rust
via the debian package system you should uninstall it before running the
instructions above from the Cargo Book.

With this version I was able to install __ncgopher__ using the simple
recipe of 

~~~shell
cargo install ncgopher
~~~


