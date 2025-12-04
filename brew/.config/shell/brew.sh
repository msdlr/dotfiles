#!/usr/bin/env sh

if [ -d "/opt/homebrew" ]; then
    HOMEBREW_PREFIX="/opt/homebrew"  # MacOS 
elif [ -d "/home/linuxbrew/.linuxbrew" ]; then
    HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"  # Linux
else
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval $(${HOMEBREW_PREFIX}/bin/brew shellenv)