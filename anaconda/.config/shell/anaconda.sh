#!/usr/bin/env sh

conda_paths="
$HOME/miniconda3
$HOME/anaconda3
/opt/conda
/usr/local/miniconda3
/usr/local/anaconda3
/opt/miniforge3
/opt/homebrew/anaconda3
"

for path in $conda_paths; do
    conda_sh="$path/etc/profile.d/conda.sh"
    if [ -f "$conda_sh" ]; then
        . "$conda_sh"
        break
    fi
done

unset conda_paths
