---
title: Updated recipe, compiling PostgREST 12.0.2 (M1)
pubDate: 2024-01-04
author: R. S. Doiel
keywords: [ 'PostgREST', 'M1' ]
---

# Updated recipe, compile PostgREST 12.0.2 (M1)

by R. S. Doiel, 2024-01-04

These are my updated "quick notes" for compiling PostgREST v12.0.2 on a M1 Mac Mini using the current recommended
versions of ghc, cabal and stack supplied [GHCup](https://www.haskell.org/ghcup).  When I recently tried to use
my previous [quick recipe](/blog/2023/07/05/quick-recipe-compiling-PostgREST-M1.md) I was disappointed it failed with errors like 

~~~
Resolving dependencies...
Error: cabal: Could not resolve dependencies:
[__0] trying: postgrest-9.0.1 (user goal)
[__1] next goal: optparse-applicative (dependency of postgrest)
[__1] rejecting: optparse-applicative-0.18.1.0 (conflict: postgrest =>
optparse-applicative>=0.13 && <0.17)
[__1] skipping: optparse-applicative-0.17.1.0, optparse-applicative-0.17.0.0
(has the same characteristics that caused the previous version to fail:
excluded by constraint '>=0.13 && <0.17' from 'postgrest')
[__1] trying: optparse-applicative-0.16.1.0
[__2] next goal: directory (dependency of postgrest)
[__2] rejecting: directory-1.3.7.1/installed-1.3.7.1 (conflict: postgrest =>
base>=4.9 && <4.16, directory => base==4.17.2.1/installed-4.17.2.1)
[__2] trying: directory-1.3.8.2
[__3] next goal: base (dependency of postgrest)
[__3] rejecting: base-4.17.2.1/installed-4.17.2.1 (conflict: postgrest =>
base>=4.9 && <4.16)

...

~~~

So this type of output means GHC and Cabal are not finding the versions of things they need
to compile PostgREST. I then tried picking ghc 9.2.8 since the default.nix file indicated
a minimum of ghc 9.2.4.  The `ghcup tui` makes it easy to grab a listed version then set it
as the active one.

I made sure I was working in the v12.0.2 tagged release version of the Git repo for PostgREST.
Then ran the usual suspects for compiling the project. I really wish PostgREST came with 
install from source documentation. It took me a while to think about looking in the default.nix
file for a minimum GHC version. That's why I am writing this update.

A similar recipe can be used for building PostgREST on Linux.

1. Upgrade [GHCup](https://www.haskell.org/ghcup/) to get a good Haskell setup (I accept all the default choices)
    a. Use the curl example command to install it or `gchup upgrade`
    b. Make sure the environment is active (e.g. source `$HOME/.ghcup/env`)
2. Make sure GHCup is pointing at the version PostgREST v12.0.2 needs, i.e. ghc v9.2.8. I chose to keep "recommended" versions of Cabal and Stack
3. Clone <https://github.com/PostgREST/postgrest> to my local machine
4. Check out the version you want to build, i.e. v12.0.2
5. Run the "usual" Haskell build sequence with cabal
    a. `cabal clean`
    b. `cabal update`
    c. `cabal build`
    d. `cabal install` (I use the `--overwrite-policy=always` option to overwrite my old v11 postgrest install)

Here's an example of the shell commands I run (I'm assuming you're installing GHCup for the first time).

~~~
ghcup upgrade
ghcup tui
mkdir -p src/github.com/PostgREST
cd src/github.com/PostgREST
git clone git@github.com:PostgREST/postgrest
cd postgrest
git checkout v12.0.2
cabal clean
cabal update
cabal build
cabal install --overwrite-policy=always
~~~

This will install PostgREST in your `$HOME/.cabal/bin` directory. Make sure
it is in your path (it should be if you've sourced the GHCup environment after you installed GHCup).


