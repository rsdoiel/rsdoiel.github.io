---
title: Quick recipe, compiling Pandoc (M1)
pubDate: 2023-07-05
author: R. S. Doiel
keywords: [ 'Pandoc', 'GHCup', 'M1' ]
---

# Quick recipe, compile Pandoc (M1)

These are my quick notes for compiling Pandoc on a M1 Mac Mini. I use a similar recipe for building Pandoc on Linux (NOTE: the challenges with libiconv and Mac Ports' libiconv below if you get a build error).

1. Install [GHCup](https://www.haskell.org/ghcup/) to get a good Haskell setup (I accept all the default choices)
    a. Use the curl example command to install it
    b. Make sure the environment is active (e.g. source `$HOME/.ghcup/env`)
2. Make sure GHCup is pointing at the "recommended" versions of GHC, Cabal, etc. (others may work but I prefer the stable releases)
3. Clone <https://github.com/jgm/pandoc> to your local machine
4. Check out the version you want to build (e.g. 3.1.4)
5. Run the "usual" Haskell build sequence with cabal per Pandoc's installation documentation for building from source
    a. `cabal clean`
    b. `cabal update`
    c. `cabal install pandoc-cli`

Here's an example of the shell commands I run (I'm assuming you're installing GHCup for the first time).

~~~
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
source $HOME/.gchup/env
ghcup tui
mkdir -p src/github.com/jgm/pandoc
cd src/github.com/jgm/pandoc
git clone git@github.com:jgm/pandoc
cd pandoc
git checkout 3.1.4
cabal clean
cabal update
cabal install pandoc-cli
~~~

This will install Pandoc in your `$HOME/.cabal/bin` directory. Make sure
it is in your path (it should be if you've sourced the GHCup environment after you installed GHCup).

## libiconv compile issues

If you use Mac Ports it can confuse Cabal/Haskell which one to link to. You'll get an error talking about undefined symbols and iconv.  To get a clean compile I've typically worked around this issue by removing the Mac Ports installed libiconv temporarily (e.g. `sudo port uninstall libiconv`, an using the "all" option when prompted).  After I've got a clean install of Pandoc then I re-install libiconv for those Ports based applications that need it. Putting libiconv back is important, as Mac Ports version of Git expects it.

