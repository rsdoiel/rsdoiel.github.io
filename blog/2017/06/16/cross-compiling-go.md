{
    "markup": "mmark",
    "title": "Cross compiling Go 1.8.3 for Pine64 Pinebook",
    "author": "R. S. Doiel",
    "date": "2016-06-16",
    "keywords": [ "Golang", "Pine64", "ARM" ],
    "copyright": "copyright (c) 2016, R. S. Doiel",
    "license": "https://creativecommons.org/licenses/by-sa/4.0/"
}


# Cross compiling Go 1.8.3 for Pine64 Pinebook

By R. S. Doiel 2017-06-16

Pine64's Pinebook has a 64-bit Quad-Core ARM Cortex A53 which is 
not the same ARM processor found on a Raspberry Pi 3. As a 
result it needs its own compiled version of Go. Fortunately cross 
compiling Go is very straight forward. I found two helpful Gists
on GitHub discussing compiling Go for a 64-Bit ARM processor. 

+ [conoro's gist](https://gist.github.com/conoro/4fca191fad018b6e47922a21fab499ca)
+ [truedat101's gist](https://gist.github.com/truedat101/5898604b1f7a1ec42d65a75fa6a0b802)

I am using a Raspberry Pi 3, raspberrypi.local, as my cross compile 
host. Go 1.8.3 is already compiled and available.  Inspired by the 
gists I worked up with this recipe to bring a Go 1.8.3 to my Pinebook.

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

After the bootstrap compile is finished I switch to my Pinebook,
copy the bootstrap compiler to my Pinebook and use it to compile
a new go1.8.3 for Pine64.

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
    cd src
    ./all.bash
```

_all.bash_ will successfully compile _go_ and _gofmt_ but fail on 
the tests. It's not perfect but appears to work as I explore
building Go applications on my Pinebook. Upcoming Go releases should
provide better support for 64 bit ARM.
