#!/usr/bin/env bash


if [ -x $(command -v kubectl) ]
then 
    eval $(kubectl completion bash)
fi

if [ -x $(command -v virtctl) ]
then 
    eval $(virtctl completion bash)
fi