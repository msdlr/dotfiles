#!/usr/bin/env sh

PYTHON_HOME_VENV="${HOME}/.local/opt/python"

if [ ! -d "${PYTHON_HOME_VENV}" ] || [ ! -f "${PYTHON_HOME_VENV}/bin/activate" ]
then
    echo "Creating Python venv..."
    mkdir -pv "${PYTHON_HOME_VENV}"
    python3 -m venv "${PYTHON_HOME_VENV}"
fi

# Look for a .venv in the current directory or any parent directory.
dir="$(pwd)"
found_venv=""

while [ "$dir" != "/" ]
do
    if [ -f "$dir/.venv/bin/activate" ]
    then
        found_venv="$dir/.venv"
        break
    fi

    dir="$(dirname "$dir")"
done

if [ -n "$found_venv" ]
then
    # echo "Activating venv: $found_venv"
    . "$found_venv/bin/activate"
else
    # echo "Activating default Python venv: $PYTHON_HOME_VENV"
    . "$PYTHON_HOME_VENV/bin/activate"
fi

unset PYTHON_HOME_VENV
unset dir
unset found_venv