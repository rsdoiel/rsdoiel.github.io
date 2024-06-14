---
title: "Installing Golang from source on RPi-OS for arm64"
series: "Raspberry Pi"
number: 1
author: "rsdoiel@gmail.com (R. S. Doiel)"
date: "2022-02-18"
copyright: "copyright (c) 2022, R. S. Doiel"
keywords: [ "raspberry pi", "Raspberry Pi OS", "arm64" ]
license: "https://creativecommons.org/licenses/by-sa/4.0/"
---


Installing Golang from Source on RPi-OS for arm64
==========================================

By R. S. Doiel, 2022-02-18

This are my quick notes on installing Golang from source on the Raspberry Pi OS 64 bit.

1. Get a working compiler
	a. go to https://go.dev/dl/ and download go1.17.7.linux-arm64.tar.gz
	b. untar the tarball in your home directory (it'll unpack to $HOME/go)
	c. `cd go/src` and `make.bash`
2. Move go directory to go1.17
3. Clone go from GitHub
4. Compile with the downloaded compiler
	a. `cd go/src`
	b. `env GOROOT_BOOTSTRAP=$HOME/go1.17 ./make.bash`
	c. Make sure `$HOME/go/bin` is in the path
	d. `go version`

