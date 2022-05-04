#!/usr/bin/env sh

# Dependencies: openssl
# Optional: readline-common sqlite3 bzip2

export PYENV_ROOT=${PYENVROOT:="${HOME}/.pyenv"}

# Clone if not available
if [ ! -d "${PYENV_ROOT}" ]
then
	git clone --recursive https://github.com/pyenv/pyenv.git ${PYENV_ROOT}
fi

# Add bin directory to PATH
[ -d ${PYENV_ROOT}/bin ] && [[ ":${PATH}:" == *"${PYENV_ROOT}/bin"* ]] || export PATH=${PYENV_ROOT}/bin:${PATH}

# Enable pyenv as executable 
eval "$(pyenv init -)"
