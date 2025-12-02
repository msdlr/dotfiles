#!/usr/bin/env sh

if [ -d "/opt/homebrew" ]; then
    homebrew_prefix="/opt/homebrew"  # MacOS 
elif [ -d "/home/linuxbrew/.linuxbrew" ]; then
    homebrew_prefix="/home/linuxbrew/.linuxbrew"  # Linux
else
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval $(${homebrew_prefix}/bin/brew shellenv)
unset homebrew_prefix