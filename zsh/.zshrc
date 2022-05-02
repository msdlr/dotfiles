# Color prompt
autoload -U colors && colors

# <TAB> Completion
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit

# History
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=${HOME}/.zsh_history

function git_branch() {
    GIT_BRANCH="$(git branch 2>/dev/null | grep '^*' | colrm 1 2)"
    if [ -n "${GIT_BRANCH}" ]; then
        echo "git:${GIT_BRANCH}"
    fi
}

function precmd() { # Execute after every command
    # Prompt
    PS1="%F{red}%n@%m%f %F{green}%1~%f %F{yellow}%#%f "
    RPROMPT="%B%F{magenta}$(git_branch)%f%b"
}

# Setup $PATH, other envvars, aliases, etc
for cfg in ${HOME}/.config/shell/*[\.sh,\.zsh]
do
    #echo "Loaded ${cfg}"
    source ${cfg}
done

# Ctrl + arrows
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

# Del key writing '~'
bindkey "^[[3~" delete-char
