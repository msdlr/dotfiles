#!/usr/bin/env sh

# PATH + LD for .local/{bin,lib,etc...} for local, non-root user
[ -d ${HOME}/.local/bin ] && [[ ":${PATH}:" == *"${HOME}/.local/bin"* ]] || export PATH=${HOME}/.local/bin:${PATH}
[ -d ${HOME}/.local/lib ] && [[ ":${LD_LIBRARY_PATH}:" == *"${HOME}/.local/lib"* ]] || export LD_LIBRARY_PATH=${HOME}/.local/lib:${LD_LIBRARY_PATH}

stty -ixon # disable CTRL-S/Q

# Load XDG directories
[ -f ${HOME}/.config/user-dirs.dirs ] && . ${HOME}/.config/user-dirs.dirs

export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:=${HOME}/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:=${HOME}/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:=${HOME}/.local/share}

# Flatpak XDG stuff
if [ "$(command -v flatpak)" >/dev/null != "" ]
then
    [ -d '/var/lib/flatpak/exports/share' ] && [[ ":${XDG_DATA_DIRS}:" == *"/var/lib/flatpak/exports/share"* ]] || export XDG_DATA_DIRS="/var/lib/flatpak/exports/share":${XDG_DATA_DIRS}
    [ -d "${HOME}/.local/share/flatpak/exports/share" ] && [[ ":${XDG_DATA_DIRS}:" == *"${HOME}/.local/share/flatpak/exports/share"* ]] || export XDG_DATA_DIRS="${HOME}/.local/share/flatpak/exports/share":${XDG_DATA_DIRS}
fi

sh -c "command -v nvim" >/dev/null 2>/dev/null && VIM=nvim || VIM=vim
sh -c "command -v vim" >/dev/null && export EDITOR="${VIM}" || export EDITOR="nano"
sh -c "command -v vim" >/dev/null && export VISUAL="${VIM}" || export VISUAL="nano"

# XDG partially-supported configs
export SCREENRC="${XDG_CONFIG_HOME}"/screen/screenrc

# $DISPLAY for WSL

if [ $(expr "$(uname --kernel-release 2>/dev/null)" : ".*WSL.*") != "0"  ]
then
	DISPLAY=${DISPLAY:="$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):0.0"}
fi
