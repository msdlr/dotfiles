#!/usr/bin/env sh

set_omnet_root() {
    SETENV_FILE=$(find /opt ${HOME}/.local/opt -type f -name "setenv" | fzf)
    export OMNET_ROOT=$(dirname ${SETENV_FILE})


    # Once the variable is defined
    if [ -n "${OMNET_ROOT}" ]
    then
        echo "export OMNET_ROOT=$OMNET_ROOT" > ${XDG_CONFIG_HOME}/omnetpp
        echo "[[ ":\${LD_LIBRARY_PATH}:" == *"${OMNET_ROOT}/lib"* ]] || export LD_LIBRARY_PATH=\${LD_LIBRARY_PATH}:${OMNET_ROOT}/lib" >> ${XDG_CONFIG_HOME}/omnetpp
        echo "[[ ":\${C_INCLUDE_PATH}:" == *"${OMNET_ROOT}/include"* ]] || export C_INCLUDE_PATH=\${C_INCLUDE_PATH}:${OMNET_ROOT}/include" >> ${XDG_CONFIG_HOME}/omnetpp
        echo "[[ ":\${CPLUS_INCLUDE_PATH}:" == *"${OMNET_ROOT}/include"* ]] || export CPLUS_INCLUDE_PATH=\${CPLUS_INCLUDE_PATH}:${OMNET_ROOT}/include" >> ${XDG_CONFIG_HOME}/omnetpp
    fi
}

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:=${HOME}/.config}

if [ ! -f ${XDG_CONFIG_HOME}/omnetpp ]
then
    # If the variable is not definedm search for it
    if [ -z "${OMNET_ROOT}" ]
    then
        set_omnet_root
    fi
else
    . ${XDG_CONFIG_HOME}/omnetpp 2>/dev/null
fi

# Import the python package in the current venv
site_packages="$(python3 -c "import site; print(site.getsitepackages()[0])")"
if [ ! -L "$site_packages/omnetpp" ] || [ "$(realpath "$site_packages/omnetpp")" != "$OMNET_ROOT/python/omnetpp" ]; then
    ln -sfn "$OMNET_ROOT/python/omnetpp" "$site_packages/omnetpp" 2> /dev/null
fi
unset site_packages

alias omnetpp='(source ${OMNET_ROOT}/setenv && omnetpp)'
alias opp_shell='(source ${OMNET_ROOT}/setenv && $SHELL)'

function opp_scavetool () {
    (source ${OMNET_ROOT}/setenv && command opp_scavetool "$@")
}

# Remove omnet ide crash logs
ls ~/hs_err_pid*log >/dev/null 2>/dev/null && rm ~/hs_err_pid*log >/dev/null 2>/dev/null
