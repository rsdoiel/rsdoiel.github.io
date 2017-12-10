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

install_tools \
	mvdan.cc/sh/cmd/shfmt \
	github.com/caltechlibrary/datatools \
	github.com/caltechlibrary/mkpage
