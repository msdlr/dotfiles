#!/usr/bin/env sh

[ -d "${HOME}/.goenv" ] || git clone https://github.com/syndbg/goenv.git ${HOME}/.goenv

GOENV_ROOT=${GOENV_ROOT:="${HOME}/.goenv"}
[ $(expr "${PATH}" : "${GOENV_ROOT}/bin") = "0" ] && export PATH="${GOENV_ROOT}/bin:${PATH}"
eval "$(${GOENV_ROOT}/bin/goenv init -)"

[ $(expr "${PATH}" : ".*$GOROOT.*") = "0" ] && export PATH="${GOROOT}/bin:${PATH}"
[ $(expr "${PATH}" : ".*$GOPATH.*") = "0" ] && export PATH="${GOPATH}/bin:${PATH}"
