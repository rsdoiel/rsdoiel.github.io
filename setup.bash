#!/bin/bash

function installWebTools() {
    for GOPROG in "$@"; do
        if [ ! -f $HOME/bin/$GOPROG ]; then
            echo "Installing $GOPROG"
            go get -u github.com/caltechlibrary/$GOPROG/...
        fi
    done
}

if [ ! -f $HOME/bin/mergepath ]; then
    echo "Missing datatools, installing"
    go get -u github.com/caltechlibrary/datatools/...
fi
installWebTools mkpage
