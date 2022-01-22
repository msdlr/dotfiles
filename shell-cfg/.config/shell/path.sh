#!/usr/bin/env/sh

# PATH + LD for .local/{bin,lib,etc...} for local, non-root user
[ -d ${HOME}/.local/bin ] && [[ ":${PATH}:" == *"${HOME}/.local/bin"* ]] || export PATH=${HOME}/.local/bin:${PATH}
[ -d ${HOME}/.local/lib ] && [[ ":${LD_LIBRARY_PATH}:" == *"${HOME}/.local/lib"* ]] || export LD_LIBRARY_PATH=${HOME}/.local/lib:${LD_LIBRARY_PATH}
[ -d ${HOME}/.local/lib ] && ldconfig -n ${HOME}/.local/lib

# PATH for scripts directory
[ -d ${HOME}/.local/scripts ] && [[ ":${PATH}:" == *"${HOME}/.local/scripts"* ]] || export PATH=${HOME}/.local/scripts:${PATH}

stty -ixon # disable CTRL-S/Q

if [ "$(id -u)" -ne "0" ]
then
    # GOLANG
    if [ -d /opt/go/bin ]; then
        # Add go binary to PATH
        [[ ":${PATH}:" == *"/opt/go/bin"* ]] || export PATH=/opt/go/bin:${PATH}
    fi

    if  (command -v go >/dev/null); then
        # Create default go workspace
        export GOPATH=${HOME}/.go
	[ -d ${GOPATH} ] || mkdir -p ${GOPATH}/{bin,src,pkg} 
        export GOBIN=${GOPATH}/bin
        [[ ":${PATH}:" == *"${GOBIN}"* ]] || export PATH=${PATH}:${GOBIN}
        export PATH
    fi
fi

CARGOBIN=${HOME}/.cargo/bin
[[ ":${PATH}:" == *"${CARGOBIN}"* ]] || export PATH=${CARGOBIN}:${PATH}