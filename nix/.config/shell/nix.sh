#!/usr/bin/env sh

nix_setup_interactive() {
    CONFIG_FILE="$HOME/.config/nixpkgs/config.nix"
    categories="$(grep -oP '(?<=    )[a-zA-Z]+(?= = with pkgs;)' "$CONFIG_FILE")"

    for category in $categories; do
        echo "\e[32mDo you want to install packages in the '$category' category? (y/N)\e[97m"
        read -r answer
        if [ "$answer" = "y" ]; then
            nix-env -iA "nixpkgs.$category"
        fi
    done
}

nix_setup_all() {
    CONFIG_FILE="$HOME/.config/nixpkgs/config.nix"
    categories="$(grep -oP '(?<=    )[a-zA-Z]+(?= = with pkgs;)' "$CONFIG_FILE")"

    for category in $categories; do
		nix-env -iA "nixpkgs.$category"
    done
}

# Detect local user installation
if [ -f ${HOME}/.nix-profile/etc/profile.d/nix.sh ]
then
	source ${HOME}/.nix-profile/etc/profile.d/nix.sh
fi


