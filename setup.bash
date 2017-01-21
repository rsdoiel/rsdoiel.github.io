#!/bin/bash

function installWebTools() {
    for GOPROGS in $@; do
        if [ ! -f $HOME/bin/$GOPROG ]; then
            go get github.com/rsdoiel/$GOPROG/...
        fi
    done
}

if [ ! -f $HOME/bin/mergepath ]; then
    go get github.com/rsdoiel/shelltools/...
fi
installWebTools mkpage mkslides
