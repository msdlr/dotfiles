#!/usr/bin/env sh

export XDG_CONFIG_HOME=${HOME}/.config
export XDG_CACHE_HOME=${HOME}/.cache
export XDG_DATA_HOME=${HOME}/.local/share

sh -c "which vim" >/dev/null && export EDITOR="vim" || export EDITOR="nano"
sh -c "which vim" >/dev/null && export VISUAL="vim" || export VISUAL="nano"

# XDG partially-supported configs
export SCREENRC="${XDG_CONFIG_HOME}"/screen/screenrc

# $DISPLAY for WSL

if [ $(expr "$(uname --kernel-release)" : ".*WSL.*") != "0"  ]
then
	DISPLAY=${DISPLAY:="$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):0.0"}
fi
