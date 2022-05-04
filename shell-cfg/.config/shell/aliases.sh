#!/usr/bin/env sh
# QOL
alias ls='ls --color=auto'
alias ll='ls -lh'
alias lla='ls -lah'
alias vim='vim -p'
alias du='du -h'
alias du1='du -h --max-depth=1'
alias df='df -h'
alias reload='source $HOME/.bashrc'
alias echopath='echo $PATH | sed s/:/\\n/g | uniq'
alias l='less'
alias make='make -j'

# Verbose commands
alias mkdir='mkdir -pv'
alias ln='ln -v'
alias rm='rm -v'
alias mv='mv -v'
alias cp='cp -v'
alias chmod='chmod -v'
alias chown='chown -v'

alias ups='sudo apt update && sudo apt dist-upgrade -y && sudo apt autoremove -y'
alias tzip='tar -czvf' # tar -czvf archive.tar.gz stuff
alias tunzip='tar -xzvf' # tar -xzvf archive.tar.gz

# Git
alias gst='git status'
alias ga='git add'
alias gcm='git commit -m'
alias gpush='git push'
alias gpull='git pull'
alias grh='git reset --hard'
alias grs='git reset --soft'
alias grm='git reset --mixed'
alias gcout='git checkout'
alias gclean='git clean -df'
alias gnuke='git clean -dfx' # Git clean of untracked files too
alias gua='git remote | xargs -L1 git push --all'
alias gdiff='git diff'

# Docker
alias dps='docker ps'
alias dimgs='docker images'
drmi () {
	docker rmi $1
}
alias drmi-all='docker rmi $(docker images -a -q)'
drem () {
	docker rm $1
}
alias drem-all='docker rm $(docker ps -a -q)'
alias drun='docker run'
alias dbuild='docker build'
alias dkill='docker kill'
alias dstop='docker stop'
alias dstop-all='docker stop $(docker ps -a -q)'
alias dsprune='docker system prune'

# Functions

ex () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# So that zsh does not print 'aliased to' is overriden
which () {
	sh -c "which $1"
}

# Go to (symlinked) file's original directory
cds () {
	dir=${1:=.} # Do nothing if a file is not specified
	cd $(dirname $(realpath ${dir}))	
}
