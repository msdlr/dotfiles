#!/usr/bin/env sh

# Homebrew on Linux
homebrew_prefix=/home/linuxbrew/.linuxbrew

if [ ! -d ${homebrew_prefix} ]
then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

[ -d ${homebrew_prefix}/bin ] && [[ ":${PATH}:" == *"${homebrew_prefix}/bin"* ]] || export PATH=${homebrew_prefix}/bin:${PATH}
[ -d ${homebrew_prefix}/lib ] && [[ ":${LD_LIBRARY_PATH}:" == *"${homebrew_prefix}/lib"* ]] || export LD_LIBRARY_PATH=${homebrew_prefix}/lib:${LD_LIBRARY_PATH}

