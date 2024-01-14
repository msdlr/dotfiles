#!/usr/bin/env sh

export R=${R:=$(hostname)}
if [ "${R}" != "$(hostname)" ]
then
    # Copy ssh key if dest is remote
    [ "${R}" != "$(hostname)" ] || ssh-copy-id ${R} 2>/dev/null
    export U=${U:=$USER}
fi

[ $# -eq 0 ] && $(realpath ${0}) $(find $(dirname $0) -maxdepth 1 -type d -not -name '.' -not -name '.git')

for pkg in $@
do
    if [ "${R}" = "$(hostname)" ] 
    then
        [ -d ${pkg} ] && cp --remove-destination -rv $(find ${pkg} -mindepth 1 -maxdepth 1 -not -name ${pkg}) ~
    else    
        [ -d ${pkg} ] && scp -r $(find ${pkg} -maxdepth 1 -mindepth 1 -not -name ${pkg}) ${U}@${R}:
    fi
done
