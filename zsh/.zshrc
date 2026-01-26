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
setopt hist_ignore_dups
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=${HOME}/.zsh_history

function git_branch() {
    # Current branch
    GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)" || return

    if [ -n "${GIT_BRANCH}" ]; then
        # Ahead/behind counts
        ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null)
        behind=$(git rev-list --count HEAD..@{u} 2>/dev/null)

        local gst=""

        [ -n "$ahead" ]  && [ "$ahead" -gt 0 ]  && gst="${gst}▲${ahead} "
        [ -n "$behind" ] && [ "$behind" -gt 0 ] && gst="${gst}▼${behind}"

        # Trim trailing space
        gst="${gst%" "}"

        # Wrap in brackets only if non-empty
        if [ -n "$gst" ]; then
            echo "git:${GIT_BRANCH} [${gst}]"
        else
            echo "git:${GIT_BRANCH}"
        fi
    fi
}

function cur_short_path() {
	[ "${PWD}" = "${HOME}" ] && echo "~" && return
	pwd | sed "s|^${HOME}|~|g; s|^/home/|~|; s|^/Users/|~|"
}

function precmd() { # Execute after every command

    if [[ -n $SSH_CLIENT ]]
    then
        # SSH shell
        PS1="%F{red}%n@%m%f %F{green}$(cur_short_path)%f %F{yellow}%#%f "
        RPROMPT="%B%F{magenta}$(git_branch)%f%b"
    else
        # Local shell
        PS1="%F{blue}$(cur_short_path)%f %F{yellow}%#%f "
        RPROMPT="%B%F{magenta}$(git_branch)%f%b"
    fi
    
}

# Movement
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^A" vi-beginning-of-line
bindkey "^E" vi-end-of-line
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# Search like bash
bindkey '^R' history-incremental-search-backward

# Del key writing '~'
bindkey "^[[3~" delete-char

# Remove whole words with CTRL
bindkey '^H' backward-kill-word
bindkey '5~' kill-word

# Silent cd -
setopt cdsilent

# Correct mistyped commands
setopt correct

# Setup $PATH, other envvars, aliases, etc
for cfg in $(ls ${HOME}/.config/shell/*[\.sh,\.zsh] 2>/dev/null)
do
    source ${cfg}
done

# Fish-like yntax highlighting
if [ "$(uname)" = "Linux" ] && [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ "$(uname)" = "Darwin" ] && [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

if command -v fzf &> /dev/null; then
    eval "$(fzf --zsh 2>/dev/null)"
fi

if command -v atuin &> /dev/null; then
    eval "$(atuin init zsh)"
fi

alias reload="source $HOME/.zshrc"
