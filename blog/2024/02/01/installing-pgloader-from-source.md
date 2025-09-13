---
title: Installing pgloader from source
byline: 'R. S. Doiel, 2024-02-01'
keywords:
  - SQL
  - Postgres
  - PostgreSQL
  - MySQL
  - pgloader
  - lisp
  - macos
  - ecl
  - sbcl
series: SQL Reflections
number: 6
author: R. S. Doiel
copyrightYear: 2024
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: >
  I'm working on macOS at the moment but I don't use Home Brew so the
  instructions to install pgloader are problematic for me. Except I know
  pgloader is a Lisp program and once upon a time I had three different Lisps
  running on a previous Mac.  So what follows is my modified instructions for
  bringing pgloader up on my current Mac Mini running macOS Sonoma 14.3 with
  Xcode already installed.


  ## Getting your Lisps in order


  pgloader is written in common list but the instructions at
  https://pgloader.readthedocs.io/en/latest/install.html specifically mention
  compiling with [SBCL](https://sbcl.org) which is one of the Lisps I've used in
  the past. But SBCL isn't (yet) installed on my machine and SBCL is usually
  compiled using SBCL but can be compiled using other common lists.  Enter
  [ECL](https://ecl.common-lisp.dev/), aka Embedded Common-Lisp. ECL compiles
  via a C compiler including the funky setup that macOS has. This means the prep
  for my machine should look something like


  1. Compile then install ECL

  2. Use ECL to compile SBCL

  3. Install SBCL

  4. Now that we have a working SBCL, follow the instructions to compile
  pgloader and install


  NOTE: pgloader requires some specific configuration of SBCL when SBCL is
  compiled


  ...
dateCreated: '2024-02-01'
dateModified: '2025-07-23'
datePublished: '2024-02-01'
postPath: 'blog/2024/02/01/installing-pgloader-from-source.md'
seriesNo: 6
---

# Installing pgloader from source

By R. S. Doiel, 2024-02-01

I'm working on macOS at the moment but I don't use Home Brew so the instructions to install pgloader are problematic for me. Except I know pgloader is a Lisp program and once upon a time I had three different Lisps running on a previous Mac.  So what follows is my modified instructions for bringing pgloader up on my current Mac Mini running macOS Sonoma 14.3 with Xcode already installed.

## Getting your Lisps in order

pgloader is written in common list but the instructions at https://pgloader.readthedocs.io/en/latest/install.html specifically mention compiling with [SBCL](https://sbcl.org) which is one of the Lisps I've used in the past. But SBCL isn't (yet) installed on my machine and SBCL is usually compiled using SBCL but can be compiled using other common lists.  Enter [ECL](https://ecl.common-lisp.dev/), aka Embedded Common-Lisp. ECL compiles via a C compiler including the funky setup that macOS has. This means the prep for my machine should look something like

1. Compile then install ECL
2. Use ECL to compile SBCL
3. Install SBCL
4. Now that we have a working SBCL, follow the instructions to compile pgloader and install

NOTE: pgloader requires some specific configuration of SBCL when SBCL is compiled

## Getting ECL up and running

This recipe is straight forward. 

1. Review ECL's current website, find latest releases
2. Clone the Git repository from GitLab for ECL
3. Follow the install documentation and compile ECL then install it

Here's the steps I took in the shell (I'm installing ECL, SBCL in my home directory)

```
cd
git clone https://gitlab.com/embeddable-common-lisp/ecl.git \
          src/gitlab.com/embeddable-common-lisp/ecl
cd src/gitlab.com/embeddable-common-lisp/ecl
./configure --prefix=$HOME
make
make install
```

## Getting SBCL up and running

To get SBCL up and running I grab the sources using Git then compile it with the options recommended by pgloader as well as the options to compile SBCL with another common lisp, i.e. ECL. (note: the `--xc-host='ecl'`)

```
cd
git clone git://git.code.sf.net/p/sbcl/sbcl src/git.code.sf.net/p/sbcl/sbcl
cd git clone git://git.code.sf.net/p/sbcl/sbcl
sh make.sh --with-sb-core-compression --with-sb-thread --xc-host='ecl'
cd ./tests && sh ./run-tests.sh
cd ..
cd ./doc/manual && make
cd ..
env INSTALL_ROOT=$HOME sh install.sh
```

At this time SBCL should be available to compile pgloader.

## Install Quicklisp

Quicklisp is a package manager for Lisp. It is used by pgloader so also needs to be installed. We have two lisp on our system but since SBCL is the one I need to work for pgloader I install Quicklisp for SBCL.

1. Check the [Quicklisp website](https://www.quicklisp.org/beta/) and see how things are done (it has been a long time since I did some lisp work)
2. Follow the [instructions](https://www.quicklisp.org/beta/#installation) on the website to install Quicklisp for SBCL

This leaves me with the specific steps

1. Use curl to download quicklisp.lisp
2. Use curl to download the signature file
3. Verify the signature file
4. If OK, load into SBCL
5. From the SBCL repl execute the needed commands

```
curl -O https://beta.quicklisp.org/quicklisp.lisp
curl -O https://beta.quicklisp.org/quicklisp.lisp.asc
gpg --verify quicklisp.lisp.asc quicklisp.lisp
sbcl --load quicklisp.lisp
```

At this point you're in SBCL repl. You need to issue the follow command

```
(quicklisp-quickstart:install)
(quit)
```


## Compiling pgloader

Once you have SBCL and Quicklisp working you're now ready to look at the rest of the dependencies. Based on the what other Linux systems required I figure I need to have the following available

- SQLite 3, libsqlite shared library (already installed)
- unzip (already installed)
- make (already installed)
- curl (already installed)
- gawk (already installed)
- freetds-dev (not installed)
- libzip-dev (not installed)

Two libraries aren't installed on my system. I use Mac Ports so doing a quick search both appear to be available.

```
sudo port search freetds
sudo port search libzip
sudo port install freetds libzip
```


OK, now I think I am ready to build pgloader. Here's what I need to do.

1. Clone the git repo for pgloader
2. Invoke make with the right options
3. Test installation

```
cd
git git@github.com:dimitri/pgloader.git src/github.com/dimitri/pgloader
cd src/github.com/dimitri/pgloader
make save
./build/bin/pgloader -h
```

If all works well I should see the help/usage text for pgloader. The binary executable
is located in `./build/bin` so I can copy this into place in `$HOME/bin/` directory.

```
cp ./build/bin/pgloader $HOME/bin/
```

Happy Loading.
, "PostgreSQL"
