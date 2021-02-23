#!/bin/bash

function install_tools() {
	START=$(pwd)
	for GO_PKG in "$@"; do
		if [ ! -d "$HOME/src/$GO_PKG" ]; then
			echo "Installing $GO_PKG"
			go get -u "$GO_PKG/..."
		else
			cd "$HOME/src/$GO_PKG"
			if [ -f Makefile ]; then
				make install
			else
				echo "Skipping $GO_PKG"
			fi
			cd "$START"
		fi
	done
}

PANDOC=$(which pandoc)
if [ "${PANDOC}" = "" ]; then 
    echo 'Missing pandoc, try "sudo apt install pandoc"'
    exit 1
else
    echo "Pandoc available: ${PANDOC}"
fi
MKPAGE=$(which mkpage)
if [ "${MKPAGE}" = "" ]; then
    echo 'Installing mkpage'
    install_tools github.com/caltechlibrary/mkpage
else
    echo "MkPage available: ${MKPAGE}"
fi
DATATOOLS=$(which range)
if [ "$DATATOOLS" = "" ]; then
    echo 'Installing datatools for range cli'
    install_tools github.com/caltechlibrary/datatools
else
    echo "range available: ${DATATOOLS}"
fi
