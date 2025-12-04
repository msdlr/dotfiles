#!/usr/bin/env sh
# QOL
alias ls='ls --color=auto'
alias ll='ls -lh'
alias lla='ls -lah'
alias vim='vim -p'
alias du='du -hc'
alias du1='du -hc --max-depth=1'
alias du0='du -hc --max-depth=0'
alias df='df -h'
alias ip='ip -c=auto'
alias echopath='echo $PATH | sed s/:/\\n/g | uniq'
alias echoldpath='echo $LD_LIBRARY_PATH | sed s/:/\\n/g | uniq'
alias l='less -R'
alias make="make -j$(getconf _NPROCESSORS_ONLN)"
alias rsync='rsync -avhzP'
alias sudo='sudo '
alias py='python'
alias pip3up="pip3 list --outdated | tail -n +3 | cut -d' ' -f1 | xargs -n1 pip3 install --upgrade"
alias wi="echo "$USER@$HOST""

alias cdr='dir=$(fgr | fzf) && [ -n "$dir" ] && cd $dir'
alias icode='dir=$(fgr | fzf) && [ -n "$dir" ] && code $dir'
alias ivim='dir=$(fgr | fzf) && [ -n "$dir" ] && vim $dir'

# (GNU) tar + pigz
if [ -f "$(command -v pigz)" 2>/dev/null ]; then
  if [ "$(uname)" = "Darwin" ]; then
    if [ -x "$(command -v gtar)" ]; then
      alias tzip='gtar -I pigz -cvf' # Multithreaded
    else
      alias tzip='tar -czvf'
    fi
  else
    alias tzip='tar -I pigz -cvf' # Multithreaded
  fi
fi

# Conditional aliases
[ -f "$(command -v pigz)" 2>/dev/null ] && alias tzip='tar -I pigz -cvf' # Multithreaded
[ -f "$(command -v python)" 2>/dev/null ] || alias python='python3'
[ -f "$(command -v nvim)" 2>/dev/null ] && alias vim='nvim -p'
[ -n "$COLUMNS" ] && alias diff='diff --color=auto --side-by-side -W $COLUMNS' || diff='diff --color=auto --side-by-side'

# Verbose commands
alias mkdir='mkdir -pv'
alias ln='ln -v'
alias rm='rm -v'
alias mv='mv -v'
alias cp='cp -v'
alias chmod='chmod -v'
alias chown='chown -v'

# Git
if [ -x "$(command -v git)" ]
then
  alias gst='git status'
  alias ga='git add'
  alias gcm='git commit -m'
  alias gsu='git branch --set-upstream-to=origin/"$(git symbolic-ref --short HEAD)" "$(git symbolic-ref --short HEAD)"'
  alias gpush='git push'
  alias gpushu='git push --set-upstream $(git remote show) $(git rev-parse --abbrev-ref HEAD)'
  alias gpull='git submodule init; git pull --recurse-submodules'
  alias grh='git reset --hard'
  alias grs='git reset --soft'
  alias grm='git reset --mixed'
  alias gcout='git checkout'
  alias gclean='git clean -df'
  alias gnuke='git clean -dfx' # Git clean of untracked files too
  alias gua='git remote | xargs -L1 git push --all'
  alias gdiff='git diff'
  alias gs='git stash'
  alias gsp='git stash pop'
  alias gbs='git submodule update --remote' # git bump-submodules
  alias gd='git diff'
  alias gds='git diff --staged'
  alias gdt='git difftool --dir-diff'
  alias gdts='git difftool --staged --dir-diff'
  alias gsd='git diff > $(git rev-parse --abbrev-ref HEAD)-$(hostname).diff'
fi

# Docker
if [ -x "$(command -v docker)" ]
then
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
fi

  # Slurm
[ -x "$(command -v scancel)" ] && alias scancel-all="scancel --user=${USER}"
[ -x "$(command -v squeue)" ] && alias sq="squeue -u ${USER}"
[ -x "$(command -v squeue)" ] && alias sqr="squeue | grep '\sR\s.*'"

if [ -x "$(command -v squeue)" ]
then
  alias jm='sacct -o jobid,partition,jobname%32,user,state,elapsed,start,end,nodelist -X -S $(date -d "last month" +"%m/%d")'
  alias jw='sacct -o jobid,partition,jobname%32,user,state,elapsed,start,end,nodelist -X -S $(date -d "last week" +"%m/%d")'
  alias jinfo='sacct --units=G -o jobname%32,jobid,partition,alloccpus,reqmem,maxrss,timelimit,elapsed,state -j'
fi


# If on desktop diff with meld/kompare instead
if [ x$DISPLAY != "x" ] 
then
  if [ -x "$(command -v kompare)" ]; then
      alias diff='kompare'
  elif [ -x "$(command -v meld)" ]; then
      alias diff='meld'
  fi
fi
# Functions

# Go to (symlinked) file's original directory
cds () {
	dir=${1}
	dir=${dir:=.} # Do nothing if a file is not specified
	cd $(dirname $(realpath ${dir}))	
}

# Go to a dir's realpath
cdsd () {
	dir=${1}
	dir=${dir:=.} # Do nothing if a dir is not specified
	cd $(realpath ${dir})
}

fgr() {
  [ "$1" = "~" ] && cdr $HOME && return
  
  if [ "$(uname)" = "Darwin" ] || ! command -v locate &>/dev/null; then
    find . -maxdepth 4 -name '*.git' 2>/dev/null | sed 's/\/.git//' | grep "${1}"
  else
    locate "$(pwd)*/.git" | grep ".git$" | grep "^$(pwd)" | sed "s|.git||g; s|/$||g"
  fi
}

# notify-send-like in WSL
if [ $(expr "$(uname --kernel-release 2>/dev/null)" : ".*WSL.*") != "0"  ]
then
	#echo "Running in WSL"
	notifysend () {
		wsl-notify-send.exe --category ${1} ${2}	
	}
	alias notify-send='notifysend'
#else
#	echo "Non-WSL"
fi
