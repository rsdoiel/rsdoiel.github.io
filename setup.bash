#!/bin/bash

function installWebTools() {
    for GOPROG in "$@"; do
        if [ ! -f $HOME/bin/$GOPROG ]; then
            echo "Installing $GOPROG"
            go get github.com/rsdoiel/$GOPROG/...
        fi
    done
}

if [ ! -f $HOME/bin/mergepath ]; then
    echo "Missing shell tools, installing"
    go get github.com/rsdoiel/shelltools/...
fi
installWebTools mkpage mkslides
