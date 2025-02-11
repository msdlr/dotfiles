#!/usr/bin/env sh

PYTHON_HOME_VENV="${HOME}/.local/opt/python"

if [ ! -d "${PYTHON_HOME_VENV}" ]
then
    echo "Creating Python venv..."
    python -m venv "${PYTHON_HOME_VENV}"
fi

source ${PYTHON_HOME_VENV}/bin/activate
unset PYTHON_HOME_VENV
