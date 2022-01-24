# Color prompt
autoload -U colors && colors

# <TAB> Completion
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit

function git_branch() {
    GIT_BRANCH="$(git branch 2>/dev/null | grep '^*' | colrm 1 2)"
    if [ -n "$GIT_BRANCH" ]; then
        echo "[$GIT_BRANCH] "
    fi
}

function precmd() { # Execute after every command
    # Prompt
    PS1="%F{red}%n@%m%f %F{green}%1~%f %F{13}$(git_branch)%f%F{11}%#%f "
}

# Setup $PATH
[ -f $HOME/.config/shell/path.sh ] && source $HOME/.config/shell/path.sh
# Setup aliases
[ -f $HOME/.config/shell/aliases.sh ] && source $HOME/.config/shell/aliases.sh
[ -f $HOME/.config/shell/aliases-w.sh ] && source $HOME/.config/shell/aliases-w.sh

# Ctrl + arrows
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
