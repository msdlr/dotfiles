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

# Prompt
PS1="%F{red}%n@%m%f %F{green}%1~%f %F{13}$(git_branch)%f%F{11}%#%f "
