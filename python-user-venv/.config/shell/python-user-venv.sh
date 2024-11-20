#!/usr/bin/env sh

PYTHON_HOME_VENV="${XDG_CONFIG_HOME}/python-user-venv"

if [ ! -d "${XDG_CONFIG_HOME}/python-user-venv" ]
then
    echo "Creating Python venv..."
    python -m venv "${XDG_CONFIG_HOME}/python-user-venv"
fi

source ${PYTHON_HOME_VENV}/bin/activate
unset PYTHON_HOME_VENV
