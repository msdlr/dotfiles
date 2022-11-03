#!/usr/bin/env sh

export R=${R:=$(hostname)}
export U=${U:=$(ssh ${R} whoami)}

[ "${R}" = "$(hostname)" ] || ssh-copy-id ${U}@${R} 2>/dev/null

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
