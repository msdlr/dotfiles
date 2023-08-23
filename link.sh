#!/usr/bin/env sh

# Method that links the files in the repo and creates the directory structure and then links regular files
stowlike () {
    TARGET=${HOME}
    PACKAGE=${1}
    
    cd ${PACKAGE}
    cp -rsv $(pwd)/ ${TARGET}
    
    cd $OLDPWD
}

case $# in
    "0")
        #echo "No params, installing all..."
        #find . -type d -maxdepth 1 2>/dev/null | sed '/^.*/d ; s|./||g'
        for p in $(find . -type d -maxdepth 1 -mindepth 1 -not -name '.*' 2>/dev/null)
        do
            echo "Installing ${p} config"
            stowlike ${p}
        done
        ;;
    "1")
        echo "Installing ${1} config"
        [ -d ${1} ] && stowlike ${1}
        ;;
    *)
        #echo "Installing $# pkgs"
        for p in $@
        do
            [ -d ${p} ] && stowlike ${p}
        done
        ;;
esac
