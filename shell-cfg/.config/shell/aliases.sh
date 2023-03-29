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
alias reload="source $HOME/.$(basename $(readlink /proc/$$/exe))rc"
alias echopath='echo $PATH | sed s/:/\\n/g | uniq'
alias echoldpath='echo $LD_LIBRARY_PATH | sed s/:/\\n/g | uniq'
alias l='less'
alias make="make -j$(getconf _NPROCESSORS_ONLN)"
alias rsync='rsync -avhzP'
alias tzip='tar -czvf' # tar -czvf archive.tar.gz stuff
alias sudo='sudo '

# Conditional aliases
[ -f "$(which pigz)" 2>/dev/null ] && alias tzip='tar -I pigz -cvf' # Multithreaded
[ -f "$(which python)" 2>/dev/null ] || alias python='python3'
[ -f "$(which nvim)" 2>/dev/null ] && alias vim='nvim -p'

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
  alias gpush='git push'
  alias gpushu='git push --set-upstream $(git remote show) $(git rev-parse --abbrev-ref HEAD)'
  alias gpull='git pull; git submodule update --recursive'
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
	sh -c "which $1" || echo "$(alias $1 | sed 's/^.*=//')"
}

tunzip () {
	for file in $@
	do
		echo "File: $file"
		if [ "$(which pigz 2>/dev/null)" = ""  ]
		then
			tar -xzvf "${file}"
		else
			tar -I pigz -xvf "${file}"
		fi
	done
}

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

unln () {
	cp -r --remove-destination $(realpath ${1}) ${1}
}


mass-tar () {
  for f in ${@}
  do
    file=$(realpath ${f})

    if [ -d ${file} ]; then
      cd $(dirname ${file})
      tzip "$(basename ${file}).tgz" "$(basename ${file})"
    fi

    if [ -f ${file} ]; then
      tzip "$(basename ${file}).tgz" -C "$(dirname ${file})" "$(basename ${file})"
    fi
  done
}

mass-untar () {
	for f in ${@}
	do
		if [ -f ${f} ]
		then
		cd $(dirname ${f})
			tunzip ${f}
		cd ${OLDPWD}
		fi
	done
}

eps2pdf () {
	for f in ${@}
	do
		[ -f ${f} ] && epstopdf ${f}
	done
}

rmdir_recursive () {
  where=${1}
  where=${where:=.}
  find ${where} -mindepth 1 -type d | tac | xargs -I {} rmdir --ignore-fail-on-non-empty {}
}

ups () {
  # Debian-based
  if [ "$(which apt)" >/dev/null != "" ]
  then
    [ "$(which deb-get)" >/dev/null != "" ] && deb-get upgrade
    sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
    return
  fi

  # Arch-based
  if [ "$(which pacman)" >/dev/null != "" ]
  then
    [ "$(which pacman)" >/dev/null != "" ] >/dev/null && yay -Syyu
    sudo pacman -Syyu
    return
  fi

  # RPM-based
  if [ "$(which dnf)" >/dev/null != "" ]
  then
    dnf upgrade -y
    return
  fi
}

cdr () {
    [ "$1" = "~" ] && cdr $HOME && return

	if [ -x "$(command -v locate)" ]
	then
		dst=$(locate $(pwd)*.git | sed 's/\/.git//' | grep "${1}" | fzf)
		[ "${dst}" != "" ] && cd ${dst}
	else
		dst=$(find . -name '*.git' 2>/dev/null | sed 's/\/.git//' | grep "${1}" | fzf)
		[ "${dst}" != "" ] && cd ${dst}
	fi
}

# notify-send-like in WSL
if [ $(expr "$(uname --kernel-release)" : ".*WSL.*") != "0"  ]
then
	#echo "Running in WSL"
	notifysend () {
		wsl-notify-send.exe --category ${1} ${2}	
	}
	alias notify-send='notifysend'
#else
#	echo "Non-WSL"
fi
