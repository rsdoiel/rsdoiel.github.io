{
    "markup": "mmark",
    "title": "Android, Termux and Dev Environment",
    "author": "R. S. Doiel",
    "date": "2016-09-20",
    "copyright": "copyright (c) 2016, R. S. Doiel",
    "license": "https://creativecommons.org/licenses/by-sa/4.0/"
}


# Android, Termux and Dev Environment

By R. S. Doiel 2016-09-20

Recently I got a new Android 6 tablet. I got a case with a tiny Bluetooth keyboard. I started wondering if I could use it as a developmment device when on the road. So this is my diary of that test.

## Challenges

1. Find a way to run Bash without rooting my device
2. See if I could use my normal web toolkit
	+ curl
	+ jq
	+ sed
	+ grep
3. See if I could compile or add my own custom Golang programs
4. Test setup by running a local static file server, mkpage and update my website

## Searching for Android packages and tools of my toolbox

After searching with Duck Duck Go and Google I came across the [termux](https://termux.com). Termux provides a minimal Bash shell environment with support for adding
packages with _apt_ and _dpkg_.  The repositories visible to *termux* include
most of the C tool chain (e.g. clang, make, autoconf, etc) as well as my old Unix favorites _curl_, _grep_, _sed_, _gawk_ and a new addition to my toolkit _jq_.  Additionally you'll find recent versionns (as of Sept. 2016) versions of _Golang_, _PHP_, _python_, and _Ruby_.

This quickly brought me through step 3.  Installing _go_, _git_, and _openssh_ completed what I needed to test static site development with some of the tools in our incubator at [Caltech Library](https://caltechlibrary.github.io).

## Setting up for static site development

After configuring _git_, adding my public key to Github and running _go get_ on my
custom static site tools I confirmed I could build and test static websites from my Android tablet using *Termux*.

Here's the list of packages I installed under *Termux* to provide a suitable shell environment for writing and website constructions.

```shell
    apt install autoconf automake bash-completion bc binutils-dev bison \
        bzip2 clang cmake coreutils ctags curl dialog diffutils dos2unix \
        expect ffmpeg findutils gawk git gnutls golang grep gzip \
	imagemagick jq less lynx m4 make-dev man-dev nano nodejs \
        openssh patch php-dev python readline-dev rlwrap rsync ruby-dev \
        sed sensible-utils sharutils sqlite tar texinfo tree unzip vim \
        w3m wget zip
```

This then allowed me to setup my *golang* envuronment variables and install
my typical custom written tools

```shell
    export PATH=$HOME/bin:$PATH
    export GOPATH=$HOME
    export GOBIN=$HOME/bin
    go get github.com/rsdoiel/shelltools/...
    go get github.com/caltechlibrary/mkpage/...
    go get github.com/caltechlibrary/md2slides/...
    go get github.com/caltechlibrary/ws/...
```

Finally pulled down some content to test.

```shell
    cd
    mkdir Sites
    git clone https://github.com/rsdoiel/rsdoiel.github.io.git Sites/rsdoiel.github.io
    cd  Sites/rsdoiel.github.io
    ws
```

This started the local static site webserver and I pointed by Firefox for Android at http://localhost:8000 and saw a local copy of my personal website. From there I wrote this article and updated it just as if I was working on a Raspberry Pi or standard Linux laptop.


