#!/usr/bin/env sh

PYTHON_HOME_VENV="${HOME}/.local/opt/python"
mkdir -pv ${PYTHON_HOME_VENV}

if [ ! -f "${PYTHON_HOME_VENV}/bin/activate" ]
then
    echo "Creating Python venv..."
    python -m venv "${PYTHON_HOME_VENV}"
fi

source ${PYTHON_HOME_VENV}/bin/activate
unset PYTHON_HOME_VENV
