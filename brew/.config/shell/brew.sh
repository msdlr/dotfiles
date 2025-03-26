#!/usr/bin/env sh

if [ -d "/opt/homebrew" ]; then
    homebrew_prefix="/opt/homebrew"  # MacOS 
elif [ -d "/home/linuxbrew/.linuxbrew" ]; then
    homebrew_prefix="/home/linuxbrew/.linuxbrew"  # Linux
else
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

[ -d "${homebrew_prefix}/bin" ] && echo "$PATH" | grep -q "${homebrew_prefix}/bin" || export PATH="${homebrew_prefix}/bin:${PATH}"
# [ -d ${homebrew_prefix}/lib ] && [[ ":${LD_LIBRARY_PATH}:" == *"${homebrew_prefix}/lib"* ]] || export LD_LIBRARY_PATH=${homebrew_prefix}/lib:${LD_LIBRARY_PATH}

