#!/usr/bin/env sh

# Homebrew on Linux
homebrew_prefix=/home/linuxbrew/.linuxbrew

if [ ! -d ${homebrew_prefix} ]
then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval $(${homebrew_prefix}/bin/brew shellenv)
unset homebrew_prefix