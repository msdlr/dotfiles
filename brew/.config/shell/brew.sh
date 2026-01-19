#!/usr/bin/env sh

if [ "$(uname)" = "Darwin" ]; then
    HOMEBREW_PREFIX="/opt/homebrew"  # MacOS 
elif [ "$(uname)" = "Linux" ]; then
    HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"  # Linux
else
    echo "Unsupported OS"
    return 1
fi

if [ ! -f "${HOMEBREW_PREFIX}/bin/brew" ]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval $(${HOMEBREW_PREFIX}/bin/brew shellenv)