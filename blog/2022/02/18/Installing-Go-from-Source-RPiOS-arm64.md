---
title: Installing Golang from source on RPi-OS for arm64
series: Raspberry Pi
number: 1
author: rsdoiel@gmail.com (R. S. Doiel)
date: '2022-02-18'
copyright: 'copyright (c) 2022, R. S. Doiel'
keywords:
  - raspberry pi
  - Raspberry Pi OS
  - arm64
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
copyrightYear: 2022
copyrightHolder: R. S. Doiel
abstract: "By R. S. Doiel, 2022-02-18\n\nThis are my quick notes on installing Golang from source on the Raspberry Pi OS 64 bit.\n\n1. Get a working compiler\n\ta. go to https://go.dev/dl/ and download go1.17.7.linux-arm64.tar.gz\n\tb. untar the tarball in your home directory (it'll unpack to $HOME/go)\n\tc. `cd go/src` and `make.bash`\n2. Move go directory to go1.17\n3. Clone go from GitHub\n4. Compile with the downloaded compiler\n\ta. `cd go/src`\n\tb. `env GOROOT_BOOTSTRAP=$HOME/go1.17 ./make.bash`\n\tc. Make sure `$HOME/go/bin` is in the path\n\td. `go version`\n\n\n"
dateCreated: '2022-02-18'
dateModified: '2025-07-22'
datePublished: '2022-02-18'
postPath: 'blog/2022/02/18/Installing-Go-from-Source-RPiOS-arm64.md'
seriesNo: 1
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
