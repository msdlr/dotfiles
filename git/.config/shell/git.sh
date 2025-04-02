#!/bin/env sh

# Possible git config locations:
# ~/.config/git/config
# ~/.gitconfig

export GIT_CONFIG_GLOBAL=${XDG_CONFIG_HOME}/git/config
mkdir -p $(dirname ${GIT_CONFIG_GLOBAL})

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
git config --global alias.savediff "!f() { git diff > \"\$(git rev-parse --abbrev-ref HEAD)-\$(hostname).diff\"; }; f"

# Set user information
git config --global user.email "miguelsrosa97@gmail.com"
git config --global user.name "msdlr"

# Set difftool prompt
git config --global difftool.prompt false

# Set fetch prune
git config --global fetch.prune true

# Difftool with kompare/meld
if [ -x "$(command -v kompare)" ]; then
    [ -x "$(command -v git)" ] && git config --global diff.tool kompare
elif [ -x "$(command -v meld)" ]; then
    [ -x "$(command -v git)" ] && git config --global diff.tool meld
fi

# difftool with meld on MacOS
if [ "$(uname)" = "Darwin" ]
then
    # Meld for MacOS: https://gitlab.com/dehesselle/meld_macos
    alias meld='/Applications/Meld.app/Contents/MacOS/Meld'
    git config --global diff.tool meld
    git config --global difftool.prompt false
    git config --global difftool.meld.cmd "/Applications/Meld.app/Contents/MacOS/Meld \$LOCAL \$REMOTE"
fi

if [ -x "$(command -v delta)" ]
then
    git config --global core.pager delta
    git config --global interactive.diffFilter 'delta --color-only'
    git config --global delta.navigate true
    git config --global merge.conflictStyle zdiff3
fi

# Prune tags on fetch
git config --global fetch.pruneTags true
git config --global fetch.prune true
