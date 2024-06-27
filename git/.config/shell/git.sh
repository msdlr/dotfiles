#!/bin/env sh

# Possible git config locations:
# ~/.config/git/config
# ~/.gitconfig

GIT_DIR=${XDG_CONFIG_HOME}/git

# Set aliases
git config --global alias.c "clone --recursive"
git config --global alias.co "checkout"
git config --global alias.rh "reset --hard"
git config --global alias.rs "reset --soft"
git config --global alias.rm "reset --mixed"
git config --global alias.cfg "$EDITOR /.git/config"
git config --global alias.psh "push"
git config --global alias.pll "pull"
git config --global alias.pshf "push -f"
git config --global alias.pllf "pull -f"
git config --global alias.root "rev-parse --show-toplevel"
git config --global alias.bump-submodules "submodule update --remote"
git config --global alias.d "diff"
git config --global alias.ds "diff --staged"
git config --global alias.dt "difftool --dir-diff"
git config --global alias.dts "difftool  --staged --dir-diff"
git config --global alias.cfg "$EDITOR"
git config --global alias.savediff "!f() { git diff > \"\$(git rev-parse --abbrev-ref HEAD)-\$(hostname).diff\"; }; f"

# Set user information
git config --global user.email "miguelsrosa97@gmail.com"
git config --global user.name "msdlr"

# Set difftool prompt
git config --global difftool.prompt false

# Set fetch prune
git config --global fetch.prune true

if [ -x "$(command -v kompare)" ]; then
    alias diff='kompare'
    [ -x "$(command -v git)" ] && git config --global diff.tool kompare
elif [ -x "$(command -v meld)" ]; then
    alias diff='meld'
    [ -x "$(command -v git)" ] && git config --global diff.tool meld
fi

# Remove the script if it is a symlink, so that it doesn't write the cfg on every update
[ -L $0 ] && rm $0