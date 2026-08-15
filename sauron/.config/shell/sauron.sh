#!/usr/bin/env sh
export SAURON_ROOT=${SAURON_ROOT:=$HOME/src/sauron}
if [ -d "${SAURON_ROOT}" ]
then
    SAURON_ROOT=$(realpath $SAURON_ROOT)
    setenv_file=$SAURON_ROOT/scripts/sauron-setenv.sh
    cd $(dirname $setenv_file)
    . $setenv_file
    cd - >/dev/null
fi
