#!/usr/bin/env sh

GOENV_ROOT=${GOENV_ROOT:="${HOME}/.goenv"}
[ -d "${GOENV_ROOT}" ] || git clone https://github.com/syndbg/goenv.git ${GOENV_ROOT}

[ $(expr "${PATH}" : "${GOENV_ROOT}/bin") = "0" ] && export PATH="${GOENV_ROOT}/bin:${PATH}"
eval "$(${GOENV_ROOT}/bin/goenv init -)"

[ $(expr "${PATH}" : ".*$GOROOT.*") = "0" ] && export PATH="${GOROOT}/bin:${PATH}"
[ $(expr "${PATH}" : ".*$GOPATH.*") = "0" ] && export PATH="${GOPATH}/bin:${PATH}"

unset GOENV_ROOT
