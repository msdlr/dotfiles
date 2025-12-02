#!/usr/bin/env sh

# Method that links the files in the repo and creates the directory structure and then links regular files
stowlike () {
    TARGET=${HOME}
    PACKAGE=${1}

    if [ "$(uname)" = "Darwin" ]
    then
        PACKAGE_PATH=$(cd "${PACKAGE}" && pwd)  # Get the full absolute path of the PACKAGE
        find "$PACKAGE_PATH" -maxdepth 1 -mindepth 1 | while read -r item; do
            rm -f "${TARGET}/$(basename "$item")" 2>/dev/null
            cp -rsv "$item" "$TARGET"
        done

    else
        find $(realpath ${PACKAGE}) -maxdepth 1 -mindepth 1 | xargs -I {} cp -rsv --remove-destination {} ${TARGET}
    fi
}

case $# in
    "0")
        exit
        ;;
    "1")
        echo "> Installing ${1} configuration"
        [ -d ${1} ] && stowlike ${1}
        ;;
    *)
        #echo "Installing $# pkgs"
        for p in $@
        do
            echo "> Installing ${p} configuration"
            [ -d ${p} ] && stowlike ${p}
        done
        ;;
esac
