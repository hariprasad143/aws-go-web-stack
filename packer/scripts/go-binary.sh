#!/bin/bash

export GOROOT="/usr/local/go"
export GOPATH="/opt/go"
export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"

apt-get install -y make

go get $PACKAGE

cd $GOPATH/src/$PACKAGE && make
