#!/usr/bin/env zsh


if [ -x $(command -v kubectl) ]
then 
    eval $(kubectl completion zsh)
fi

if [ -x $(command -v virtctl) ]
then 
    eval $(virtctl completion zsh)
fi