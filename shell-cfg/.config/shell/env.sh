#!/usr/bin/env sh

export XDG_CONFIG_HOME=${HOME}/.config
export XDG_CACHE_HOME=${HOME}/.cache
export XDG_DATA_HOME=${HOME}/.local/share

sh -c "which vim" >/dev/null && export EDITOR="vim" || export EDITOR="nano"
sh -c "which vim" >/dev/null && export VISUAL="vim" || export VISUAL="nano"
