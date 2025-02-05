#!/usr/bin/env sh

# Detect local user installation
if [ -e ${HOME}/.nix-profile/etc/profile.d/nix.sh ]
then
	source ${HOME}/.nix-profile/etc/profile.d/nix.sh
fi