#!/usr/bin/env sh

if [ -x "$(command -v cargo)" ] && [ $USER != "root" ]
then
    export CARGO_HOME=${CARGO_HOME:="$HOME/.cargo"}
    mkdir -pv $CARGO_HOME
    [[ ":${PATH}:" == *"${CARGO_HOME}"* ]] || export PATH="${CARGO_HOME}":${PATH}
fi