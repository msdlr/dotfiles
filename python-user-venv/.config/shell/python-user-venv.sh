#!/usr/bin/env sh

PYTHON_HOME_VENV="${HOME}/.local/opt/python"

if [ ! -d "${PYTHON_HOME_VENV}" ] || [ ! -f "${PYTHON_HOME_VENV}/bin/activate" ]
then
    echo "Creating Python venv..."
    mkdir -pv ${PYTHON_HOME_VENV}
    python3 -m venv "${PYTHON_HOME_VENV}"
fi

source ${PYTHON_HOME_VENV}/bin/activate
unset PYTHON_HOME_VENV
