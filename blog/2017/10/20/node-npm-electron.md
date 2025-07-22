---
title: 'NodeJS, NPM, Electron'
author: rsdoiel@gmail.com (R. S. Doiel)
date: '2017-10-20'
keywords:
  - Javascript
  - NodeJS
  - Electron
copyright: 'copyright (c) 2017, R. S. Doiel'
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: |
  This post discusses nodeJS and Electron.
dateCreated: '2017-10-20'
dateModified: '2025-07-22'
datePublished: '2017-10-20'
copyrightYear: 2017
copyrightHolder: R. S. Doiel
---

# NodeJS, NPM, Electron

By R. S. Doiel 2017-10-20

Electron is an app platform leveraging web technologies. Conceptually it is a
mashup of NodeJS and Chrome browser. [Electron](https://electron.atom.io/) site
has a nice starter app. It displays a window with Electron version info and
'hello world'.

Before you can get going with _Electron_ you need to have a
working _NodeJS_ and _NPM_. I usually compile from source and this
was my old recipe (adjusted for v8.7.0).

```shell
    cd
    git clone https://github.com/nodejs/node.git
    cd node
    git checkout v8.7.0
    ./configure --prefix=$HOME
    make && make install
```

To install an _Electron Quick Start_ I added the additional steps.

```shell
    cd
    git clone https://github.com/electron/electron-quick-start
    cd electron-quick-start
    npm install
    npm start
```

Notice _Electron_ depends on a working _node_ and _npm_.  When I
tried this recipe it failed on `npm install` with errors regarding
internal missing node modules.

After some fiddling I confirmed my node/npm install failed because
I had install the new version of over a partially installed previous
version. This causes the node_modules to be populated with various
conflicting versions of internal modules.

Sorting that out allowed me to test the current version of
*electron-quick-start* cloned on 2017-10-20 under _NodeJS_ v8.7.0.

## Avoiding Setup Issues in the future

The *Makefile* for _NodeJS_ includes an 'uninstall' option. Revising
my _NodeJS_ install recipe above I now do the following to setup a machine
to work with _NodeJS_ or _Electron_.

```shell
    git clone git@github.com:nodejs/node.git
    cd node
    ./configure --prefix=$HOME
    make uninstall
    make clean
    make -j 5
    make install
```

If I am on a device with a multi-core CPU (most of the time) you can speed
up the make process using a `-j CPU_CORE_COUNT_PLUS_ONE` option (e.g. `-j 5`
for my 4 core x86 laptop).

Once _node_ and _npm_ were working normally the instructions in the
*electron-quick-start* worked flawlessly on my x86.

I have tested the node install recipe change on my Pine64 Pinebook, on 
several Raspberry Pi 3s as well as my x86 Ubuntu Linux laptop.

I have not gotten Electron up on my Pine64 Pinebook or Raspberry Pi's yet. 
`npm install` outputs errors suggesting that it is expecting an x86 architecture.