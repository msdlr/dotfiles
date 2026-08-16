#!/usr/bin/env sh

# Method that links the files in the repo and creates the directory structure and then links regular files
stowlike () {
    TARGET=${HOME}
    PACKAGE=$(realpath "$1") || return
    cd "${PACKAGE}" || return

    find . -mindepth 1 -type d -print |
    while IFS= read -r d; do
        mkdir -p "${TARGET}/${d}"
    done

    find . -mindepth 1 -type f -print |
    while IFS= read -r f; do
        f=${f#./}
        mkdir -p "${TARGET}/$(dirname "${f}")"
        rm -f "${TARGET}/$f"
        ln -sv "${PACKAGE}/$f" "${TARGET}/${f}"
    done
    cd - >/dev/null
}

cd $(dirname $0)

case $# in
    "0")
        if [ -x "$(command -v fzf)" ]
        then
            pkgs="$(find . -mindepth 1 -maxdepth 1 -type d | sed 's|./||g' | fzf -m --reverse --prompt='Select configs> ')"
            for p in $pkgs
            do
                stowlike $p
            done
        fi
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
