
# Cross compiling go1.8.3 for Pinebook (Pine64)

By R. S. Doiel 2017-06-16

Pin64's Pinebook runs on ARM 7 under an 64bit Ubuntu Mate.
Go is available as a Debian/Ubuntu package but the version is 1.6 and
is not setup to work well for compiling other versions of Go. Fortunetly
cross compiling Go is very straight forward. I started with a couple of
Gists I found on Github and felt my way through the process easily.

+ [conoro's gist](https://gist.github.com/conoro/4fca191fad018b6e47922a21fab499ca)
+ [truedat101's gist](https://gist.github.com/truedat101/5898604b1f7a1ec42d65a75fa6a0b802)

To cross compile I used a spare Raspberry Pi 3 that already had Go 1.8.3. 
available.  Inspired by the gists I wound up with this workflow to bring
a recent Go to my Pinebook.

On my host Raspberry Pi 3 (called raspberrypi.local for this example)

```shell
    cd
    mkdir -p gobuild
    cd gobuild
    git clone https://github.com/golang/go.git go1.8.3
    cd go1.8.3
    git checkout go1.8.3
    export GOHOSTARCH=arm
    export GOARCH=arm64
    export GOOS=linux
    cd src
    ./bootstrap.bash
```

Then I switching over to my Pinebook and recompiled Go
using the Cross compiled version of go1.8.3.

```shell
    cd
    scp -r raspberrypi.local:gobuild/*.tbz ./
    tar jxvf go-linux-arm64-bootstrap.tbz
    export GOROOT=go-linux-arm64-bootstrap
    go-linux-arm64-bootstrap/bin/go version
    unset GOROOT
    git clone https://github.com/golang/go
    cd go
    git checkout go1.8.3
    export GOROOT_BOOTSTRAP=$HOME/go-linux-arm64-bootstrap
    ./all.bash
```

At that point I had a working go1.8.3 on my Pinebook ready for
compiling code.
