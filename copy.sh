#!/usr/bin/env sh

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
    echo "> Installing ${pkg} configuration"
    if [ "${R}" = "$(hostname)" ] 
    then
        [ -d ${pkg} ] && cp --remove-destination -rv $(find ${pkg} -mindepth 1 -maxdepth 1 -not -name ${pkg}) ~
    else    
        [ -d ${pkg} ] && scp -q -r $(find ${pkg} -maxdepth 1 -mindepth 1 -not -name ${pkg}) ${U}@${R}:
    fi
done
