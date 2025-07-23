---
title: 'Quick recipe, compiling PostgREST (M1)'
pubDate: 2023-07-05T00:00:00.000Z
author: R. S. Doiel
keywords:
  - PostgREST
  - M1
copyrightYear: 2023
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: >
  These are my quick notes for compiling PostgREST on a M1 Mac Mini. I use a
  similar recipe for building PostgREST on Linux.


  1. Install [GHCup](https://www.haskell.org/ghcup/) to get a good Haskell setup
  (I accept all the default choices)
      a. Use the curl example command to install it
      b. Make sure the environment is active (e.g. source `$HOME/.ghcup/env`)
  2. Make sure GHCup is pointing at the "recommended" versions of GHC, Cabal,
  etc. (others may work but I prefer the stable releases)

  3. Clone <https://github.com/PostgREST/postgrest> to your local machine

  4. Check out the version you want to build (e.g. v11.1.0)

  5. Run the "usual" Haskell build sequence with cabal
      a. `cabal clean`
      b. `cabal update`
      c. `cabal build`
      d. `cabal install`

  Here's an example of the shell commands I run (I'm assuming you're installing
  GHCup for the first time).


  ...
dateCreated: '2023-07-05'
dateModified: '2025-07-22'
datePublished: '2023-07-05'
---

# Quick recipe, compile PostgREST (M1)

These are my quick notes for compiling PostgREST on a M1 Mac Mini. I use a similar recipe for building PostgREST on Linux.

1. Install [GHCup](https://www.haskell.org/ghcup/) to get a good Haskell setup (I accept all the default choices)
    a. Use the curl example command to install it
    b. Make sure the environment is active (e.g. source `$HOME/.ghcup/env`)
2. Make sure GHCup is pointing at the "recommended" versions of GHC, Cabal, etc. (others may work but I prefer the stable releases)
3. Clone <https://github.com/PostgREST/postgrest> to your local machine
4. Check out the version you want to build (e.g. v11.1.0)
5. Run the "usual" Haskell build sequence with cabal
    a. `cabal clean`
    b. `cabal update`
    c. `cabal build`
    d. `cabal install`

Here's an example of the shell commands I run (I'm assuming you're installing GHCup for the first time).

~~~
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
source $HOME/.gchup/env
ghcup tui
mkdir -p src/github.com/PostgREST
cd src/github.com/PostgREST
git clone git@github.com:PostgREST/postgrest
cd postgrest
cabal clean
cabal update
cabal build
cabal install
~~~

This will install PostgREST in your `$HOME/.cabal/bin` directory. Make sure
it is in your path (it should be if you've sourced the GHCup environment after you installed GHCup).