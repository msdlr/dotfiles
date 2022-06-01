#!/usr/bin/env sh

[ -d "${HOME}/.goenv" ] || git clone https://github.com/syndbg/goenv.git ${HOME}/.goenv

export GOENV_ROOT=${GOENV_ROOT:="$HOME/.goenv"}
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"

export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"
