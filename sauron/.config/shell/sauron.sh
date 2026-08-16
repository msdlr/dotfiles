#!/usr/bin/env sh

# If we start the shell in the Sauron repo and the variable is not set
if [ -f scripts/sauron-setenv.sh ] && [ "$SAURON_ROOT" = "" ]
then
    SAURON_ROOT=$(realpath .)
fi

if [ -d "${SAURON_ROOT}" ]
then
    cd $SAURON_ROOT
    . scripts/sauron-setenv.sh
    cd - >/dev/null
fi
