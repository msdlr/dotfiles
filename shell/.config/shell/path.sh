#!/usr/bin/env sh

# PATH + LD for .local/{bin,lib,etc...} for local, non-root user
[ -d ${HOME}/.local/bin ] && [[ ":${PATH}:" == *"${HOME}/.local/bin"* ]] || export PATH=${HOME}/.local/bin:${PATH}
[ -d ${HOME}/.local/lib ] && [[ ":${LD_LIBRARY_PATH}:" == *"${HOME}/.local/lib"* ]] || export LD_LIBRARY_PATH=${HOME}/.local/lib:${LD_LIBRARY_PATH}


stty -ixon # disable CTRL-S/Q

CARGOBIN=${HOME}/.cargo/bin
[[ ":${PATH}:" == *"${CARGOBIN}"* ]] || export PATH=${CARGOBIN}:${PATH}
