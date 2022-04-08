#!/usr/bin/sh

# Method that links the files in the repo and creates the directory structure and then links regular files
stowlike () {
    TARGET=${HOME}
    PACKAGE=${1}
    
    cd ${PACKAGE}
    
    # Create directory structure
    for dir in $(find . -type d -mindepth 1 2>/dev/null)
    do
        TARGETDIR=$(echo $dir | sed "s|^.|${TARGET}|g")
        #echo "CREATE DIR ${TARGETDIR}" #| sed -e "s/$PACKAGE//d"
        mkdir -pv ${TARGETDIR} 2>/dev/null
    done
    
    # Link regular files
    for file in $(find . -type f -mindepth 1 2>/dev/null)
    do
        SOURCEFILE=$(realpath ${file})
        TARGETFILE=$(echo ${file} | sed "s|^.|${TARGET}|g")
        
        # echo "Link ${SOURCEFILE} @ ${TARGETFILE}"
        rm ${TARGETFILE} 2>/dev/null # Remove target file to override it
        ln -sv ${SOURCEFILE} ${TARGETFILE} 2>/dev/null
    done
    
    cd $OLDPWD
}

case $# in
    "0")
        #echo "No params, installing all..."
        #find . -type d -maxdepth 1 2>/dev/null | sed '/^.*/d ; s|./||g'
        for p in $(find . -type d -maxdepth 1 -mindepth 1 -not -name '.*' 2>/dev/null)
        do
            #echo "Installing ${p}"
            stowlike ${p}
        done
        ;;
    "1")
        #echo "Installing ${1}"
        stowlike ${1}
        ;;
    *)
        #echo "Installing $# pkgs"
        for p in $@
        do
            stowlike ${p}
        done
        ;;
esac
