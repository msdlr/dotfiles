#!/usr/bin/env sh

TARGET=${TARGET:=$HOME}

if [ "$#" = "0" ] && [ -x "$(command -v fzf)" ]
then
    pkgs="$(find . -mindepth 1 -maxdepth 1 -type d | sed 's|./||g' | fzf -m --reverse --prompt='Select configs> ')"
    for p in $pkgs
    do
        $0 $p
    done
    exit
fi

export R=${R:=$(hostname)}
if [ "${R}" != "$(hostname)" ]
then
    # Copy ssh key if dest is remote
    [ "${R}" != "$(hostname)" ] || ssh-copy-id ${R} 2>/dev/null
    export U=${U:=$USER}
fi

for pkg in $@
do
    if [ -d ${pkg} ]
    then
        echo "> Installing ${pkg} configuration"
    
        if [ "${R}" = "$(hostname)" ] 
        then
            rsync -avhzP ${pkg}/ ${TARGET}
        else
            rsync -avhzP ${pkg}/ ${U}@${R}:
        fi
    fi
done


if [ "${R}" != "$(hostname)" ]
then
    ssh ${U}@${R} rm /tmp/$(basename $0)
fi