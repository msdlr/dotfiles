#!/usr/bin/sh

U=${U:=${USER}}
R=${R:=$(hostname)}

echo "Deploying at $U@$R"

# Method that links the files in the repo and creates the directory structure and then links regular files
scp_pkg () {
    TARGET=$(ssh ${U}@${R} 'echo $HOME')
    PACKAGE=$1
    
    cd ${PACKAGE}
    # Just copy everything to the remote destination

    FILELIST=$(find . -maxdepth 1 | sed '/^.$/d')
    scp -r ${FILELIST} ${U}@${R}:${TARGET}
    cd $OLDPWD
}

case $# in
    "0")
        #echo "No params, installing all..."
        #find . -type d -maxdepth 1 2>/dev/null | sed '/^.*/d ; s|./||g'
        for p in $(find . -type d -maxdepth 1 -mindepth 1 -not -name '.*' 2>/dev/null)
        do
            #echo "Installing ${p}"
            scp_pkg ${p}
            wait
        done
        ;;
    "1")
        #echo "Installing $1"
        scp_pkg $1
        ;;
    *)
        #echo "Installing $# pkgs"
        for p in $@
        do
            scp_pkg ${p}
            wait
        done
        ;;
esac
