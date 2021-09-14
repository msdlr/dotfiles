# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

function git_branch() {
    GIT_BRANCH="$(git branch 2>/dev/null | grep '^*' | colrm 1 2)"
    if [ -n "$GIT_BRANCH" ]; then
        echo "[$GIT_BRANCH] "
    fi
}

PS1='\[\e[0;31m\]\u\[\e[0;31m\]@\[\e[0;31m\]\h \[\e[0;32m\]\W \[\e[0;1;35m\]$(git_branch)\[\e[0;93m\]\$ \[\e[0m\]'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# PATH + LD for .local/{bin,lib,etc...} for local, non-root user
[ -d $HOME/.local/bin ] && [[ ":$PATH:" == *"$HOME/.local/bin"* ]] || export PATH=$HOME/.local/bin:$PATH
[ -d $HOME/.local/lib ] && [[ ":$LD_LIBRARY_PATH:" == *"$HOME/.local/lib"* ]] || export LD_LIBRARY_PATH=$HOME/.local/lib:$LD_LIBRARY_PATH
[ -d $HOME/.local/lib ] && ldconfig -n $HOME/.local/lib

# PATH for scripts directory
[ -d $HOME/.local/scripts ] && [[ ":$PATH:" == *"$HOME/.local/scripts"* ]] || export PATH=$HOME/.local/scripts:$PATH

stty -ixon # disable CTRL-S/Q

if [ "$(id -u)" -ne "0" ]
then
    # GOLANG
    if [ -d /opt/go/bin ]; then
        # Add go binary to PATH
        [[ ":$PATH:" == *"/opt/go/bin"* ]] || export PATH=/opt/go/bin:$PATH
    fi

    if  (command -v go >/dev/null); then
        # Create default go workspace
        [ -d $HOME/go ] || mkdir -p $HOME/go/{bin,src,pkg} 
        #export GOROOT=$(which go | sed 's|bin/go$||')
        export GOPATH=$HOME/go
        export GOBIN=$GOPATH/bin
        [[ ":$PATH:" == *"$HOME/go/bin"* ]] || export PATH=$PATH:$HOME/go/bin
        export PATH
    fi
fi

setxkbmap es 2>/dev/null
xset led 2>/dev/null

# Aliases

[ -f $HOME/.aliases ] && source $HOME/.aliases
[ -f $HOME/.aliases-w ] && source $HOME/.aliases-w
