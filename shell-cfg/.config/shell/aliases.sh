#!/usr/bin/env sh
alias ls='ls --color=auto'
alias ll='ls -lh'
alias lla='ls -lah'
alias ups='sudo apt update && sudo apt dist-upgrade -y && sudo apt autoremove -y'
alias mkdir='mkdir -p'
alias rm='rm -r'
alias vim='vim -p'
alias du='du -h'
alias du1='du -h --max-depth=1'
alias df='df -h'
alias reload='source $HOME/.bashrc'
alias echopath='echo $PATH | sed s/:/\\n/g | uniq'
alias l='less'

alias tzip='tar -czvf' # tar -czvf archive.tar.gz stuff
alias tunzip='tar -xzvf' # tar -xzvf archive.tar.gz
alias python='python3'

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
alias gnuke='git clean -dfx' # Git clean of untracker files too
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