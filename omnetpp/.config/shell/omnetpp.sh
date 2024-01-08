#!/usr/bin/env sh

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:=${HOME}/.config}

if [ ! -f ${XDG_CONFIG_HOME}/omnetpp ]
then
    SETENV_FILE=$(find /opt ${HOME}/.local/opt -type f -name "setenv" | fzf)
    OMNET_ROOT=$(dirname ${SETENV_FILE})
    if [ -n "${OMNET_ROOT}" ]
    then
        echo "export OMNET_ROOT=$OMNET_ROOT" > ${XDG_CONFIG_HOME}/omnetpp
        echo "[[ ":\${LD_LIBRARY_PATH}:" == *"${OMNET_ROOT}/lib"* ]] || export LD_LIBRARY_PATH=\${LD_LIBRARY_PATH}:${OMNET_ROOT}/lib" >> ${XDG_CONFIG_HOME}/omnetpp
    fi
else
    . ${XDG_CONFIG_HOME}/omnetpp 2>/dev/null
fi

cd $OMNET_ROOT
. $OMNET_ROOT/setenv >/dev/null 2>/dev/null 
cd - >/dev/null