# Color prompt
autoload -U colors && colors

# <TAB> Completion
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
unsetopt no_match

# History
setopt HIST_IGNORE_SPACE
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=${HOME}/.zsh_history

function git_branch() {
    GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    if [ -n "${GIT_BRANCH}" ]; then
        echo "git:${GIT_BRANCH}"
    fi
}

function cur_short_path() {
	[ "${PWD}" = "${HOME}" ] && echo "~" && return
	pwd | sed " s|${HOME}|~|g ; s|/|\n|g ; /^$/d" | cut -c1-1 |  tr '\n' '/' | sed "s|./$|$(basename $PWD)|g"
}

function precmd() { # Execute after every command
    # Prompt
    PS1="%F{red}%n@%m%f %F{green}$(cur_short_path)%f %F{yellow}%#%f "
    RPROMPT="%B%F{magenta}$(git_branch)%f%b"
}

# Setup $PATH, other envvars, aliases, etc
for cfg in ${HOME}/.config/shell/*[\.sh,\.zsh] 
do
    #echo "Loaded ${cfg}"
    source ${cfg}
done

# Movement
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^A" vi-beginning-of-line
bindkey "^E" vi-end-of-line

# Search like bash
bindkey '^R' history-incremental-search-backward

# Del key writing '~'
bindkey "^[[3~" delete-char
