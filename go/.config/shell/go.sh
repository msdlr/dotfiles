#!/usr/bin/snv sh

if [ -x $(command -v go) ] && [ $USER != "root" ]
then
    export GOPATH=${GOPATH:=$HOME/go}
    export GOBIN=${GOBIN:=$GOPATH/bin}
    mkdir -pv $GOBIN
    [[ ":${PATH}:" == *"${GOBIN}"* ]] || export PATH="${GOBIN}":${PATH}
fi