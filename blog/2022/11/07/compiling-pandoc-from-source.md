---
title: Compiling Pandoc from source
author: rsdoiel@sdf.org (R. S. Doiel)
byline: 'R. S. Doiel, 2022-11-07'
pubDate: 2022-11-07T00:00:00.000Z
keywords:
  - pandoc
  - pandoc-server
  - pandoc-citeproc
  - haskell-stack
  - cabal
  - ghc
copyrightYear: 2022
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: >
  I started playing around with Pandoc's __pandoc-server__ last Friday. I want
  to play with the latest version of Pandoc.  When I gave it a try this weekend
  I found that my Raspberry Pi 400's SD card was too small. This lead me to
  giving the build process a try on my Ubuntu desktop. These are my notes about
  how I going about building from scratch.  I am not a Haskell programmer and
  don't know the tool chain or language. Take everything that follows with a
  good dose of salt but this is what I did to get everything up and running. I
  am following the compile from source instructions in Pandoc's
  [INSTALL.md](https://github.com/jgm/pandoc/blob/master/INSTALL.md)


  I'm running this first on an Intel Ubuntu box because I have the disk space
  available there. If it works then I'll try it directly on my Raspberry Pi 400
  with an upgrade SD card and running the 64bit version of Raspberry Pi OS.


  I did not have Haskell or Cabal installed when I started this process.


  ...
dateCreated: '2022-11-07'
dateModified: '2025-07-22'
datePublished: '2022-11-07'
postPath: 'blog/2022/11/07/compiling-pandoc-from-source.md'
---

Compiling Pandoc from source
============================

By R. S. Doiel, 2022-11-07

I started playing around with Pandoc's __pandoc-server__ last Friday. I want to play with the latest version of Pandoc.  When I gave it a try this weekend I found that my Raspberry Pi 400's SD card was too small. This lead me to giving the build process a try on my Ubuntu desktop. These are my notes about how I going about building from scratch.  I am not a Haskell programmer and don't know the tool chain or language. Take everything that follows with a good dose of salt but this is what I did to get everything up and running. I am following the compile from source instructions in Pandoc's [INSTALL.md](https://github.com/jgm/pandoc/blob/master/INSTALL.md)

I'm running this first on an Intel Ubuntu box because I have the disk space available there. If it works then I'll try it directly on my Raspberry Pi 400 with an upgrade SD card and running the 64bit version of Raspberry Pi OS.

I did not have Haskell or Cabal installed when I started this process.

Steps
-----

1. Install __stack__ (it will install GHC)
2. Clone the GitHub repo for [Pandoc](https://github.com/jgm/pandoc)
3. Setup __stack__ for Pandoc
4. Build and test with __stack__
5. Install __stack__ install
6. Make a symbolic link from __pandoc__ to __pandoc-server__

```
sudo apt update
sudo apt search "haskell-stack"
sudo apt install "haskell-stack"
stack upgrade
git clone git@github.com:jgm/pandoc src/github.com/jgm/pandoc
cd src/github.com/jgm/pandoc
stack setup 
stack build
stack test
stack install
ln $HOME/.local/bin/pandoc $HOME/.local/bin/pandoc-server
```

This step takes a long time and on the Raspberry Pi it'll take allot longer.

The final installation of Pandoc was in my `$HOME/.local/bin` directory. Assuming this is early in your path this can allow you to experiment with a different version of Pandoc from the one installed on your system. 

I also wanted to try the latest of __pandoc-server__.  This was not automatically installed and is not mentioned in the INSTALL.md file explicitly. But looking at the discussion of running __pandoc-server__ in CGI mode got me thinking. I then checked the installation on my Ubuntu box for the packaged version of pandoc-server and saw that is was a symbolic link.  Adding a `ln` command to my build instruction solved the problem.

I decided to try compiling Pandoc on my M1 mac.  First I needed to get __stack__ installed. I use Mac Ports but it wasn't in the list of available packages.  Fortunately the Haskell Stack website provides a shell script for installation on Unixes. I wanted to install __stack__ in my home `bin` directory not `/usr/bin/slack`. So after reviewing the downloaded install script I found the `-d` option for changing where it installs to. It indicated I need to additional work with __xcode__.

```
curl -sSL https://get.haskellstack.org/ > stack-install.sh
more stack-install.sh
sh stack-install.sh -d $HOME/bin
```

The __stack__ installation resulted in a message in this form.

```
Stack has been installed to: $HOME/bin/stack

NOTE: You may need to run 'xcode-select --install' and/or
      'open /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg'
      to set up the Xcode command-line tools, which Stack uses.

WARNING: '$HOME/.local/bin' is not on your PATH.
    Stack will place the binaries it builds in '$HOME/.local/bin' so
    for best results, please add it to the beginning of PATH in your profile.
```

I already had xcode setup for compiling Go so those addition step was not needed.  I only needed to add `$HOME/.local/bin` to my search path.

I then followed the steps I used on my Ubuntu Intel box.

```
git clone git@github.com:jgm/pandoc src/github.com/jgm/pandoc
cd src/github.com/jgm/pandoc
stack setup
stack build
stack test
stack install
ln $HOME/.local/bin/pandoc $HOME/.local/bin/pandoc-server
```

Now when I have a chance to update my Raspberry Pi 400 to a suitable sized SD Card (or external drive) I'll be ready to compile a current version of Pandoc from source.

Additional notes
----------------

[stack](https://docs.haskellstack.org/en/stable/) is a Haskell build tool. It setups up an Haskell environment per project. If a project requires a specific version of the Haskell compiler it'll be installed and made accessible for the project. In this way it's a bit like having a specific environment for Python. The stack website indicates that it targets cross platform development in Haskell which is nice.  Other features of stack remind me of Go "go" command in that it can build things or Rust's "cargo" command. Like __cargo__ it can update itself which is nice. That is what I did after installing the Debian package version used by Ubuntu. Configuration of a "stack" project uses YAML files. Stack uses __cabal__, Haskell's older build tool but subsumes __cabal-install__ for setting up __cabal__ and __ghc__. It appears from my reading that __stack__ addresses some of the short falls __cabal__ originally had and specifically focusing on reproducible compiles. This is important in sharing code as well as if you want to integrate automated compilation and testing. It maintains a project with "cabal files" so there is the ability to work with older non-stack code if I read the documentation correctly. Both __cabal__ and __stack__ seem to be evolving in parallel taking different approaches but influencing one another. Both systems use "cabal files" for describing projects and dependencies as of 2022. The short version of [Why Stack](https://docs.haskellstack.org/en/stable/#why-stack) can be found the __stack__ website.

[Hackage](https://hackage.haskell.org/) is a central repository of Haskell packages. 

[Stackage](https://www.stackage.org/) is a curated subset of Hackage packages. It appears to be the preferred place for __stack__ to pull from.
