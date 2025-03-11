#!/usr/bin/env sh

# Dependencies: https://github.com/pyenv/pyenv/wiki#suggested-build-environment 

export PYENV_ROOT=${PYENVROOT:="${HOME}/.local/opt/pyenv"}

# Clone if not available
if [ ! -d "${PYENV_ROOT}" ]
then
	git clone --recursive https://github.com/pyenv/pyenv.git ${PYENV_ROOT}
fi

# Add bin directory to PATH
[ -d ${PYENV_ROOT}/bin ] && [[ ":${PATH}:" == *"${PYENV_ROOT}/bin"* ]] || export PATH=${PYENV_ROOT}/bin:${PATH}

# Enable pyenv as executable 
eval "$(pyenv init -)"
