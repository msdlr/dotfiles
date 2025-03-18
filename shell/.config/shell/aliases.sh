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
alias tzip='tar -czvf' # tar -czvf archive.tar.gz stuff
alias sudo='sudo '
alias py='python'
alias pip3up="pip3 list --outdated | tail -n +3 | cut -d' ' -f1 | xargs -n1 pip3 install --upgrade"
alias wi="echo "$USER@$HOST""

alias cdr='dir=$(fgr | fzf) && [ -n "$dir" ] && cd $dir'
alias icode='dir=$(fgr | fzf) && [ -n "$dir" ] && code $dir'
alias ivim='dir=$(fgr | fzf) && [ -n "$dir" ] && vim $dir'

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

tunzip () {
	for file in $@
	do
		echo "File: $file"
		if [ "$(command -v pigz 2>/dev/null)" = ""  ]
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
	if [ "$(realpath -s ${1})" != "$(realpath ${1})" ]
	then
		cp -r --remove-destination $(realpath ${1}) $(realpath -s ${1})
	fi
}


mass-tar () {
  date_suffix=""
  
  # Check for the -d flag
  if [ "$1" == "-d" ]; then
    date_suffix="-$(date +%Y%m%d_%H%M)"
    shift  # Remove the -d argument from the list
  fi

  for f in "$@"; do
    file=$(realpath "$f")

    if [ -d "$file" ]; then
      (
      cd "$(dirname "$file")"
      tzip "$(basename "$file")${date_suffix}.tgz" "$(basename "$file")"
      )
    fi

    if [ -f "$file" ]; then
      (
      tzip "$(basename "$file")${date_suffix}.tgz" -C "$(dirname "$file")" "$(basename "$file")"
      )
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
		cd - > /dev/null 
		fi
	done
}

mass-zip () {
  date_suffix=""

  # Check for the -d flag
  if [ "$1" == "-d" ]; then
    date_suffix="-$(date +%Y%m%d_%H%M)"
    shift  # Remove the -d argument from the list
  fi

  for f in "$@"; do
    file=$(realpath "${f}")

    if [ -d "${file}" ]; then
      (
      cd "$(dirname "${file}")"
      zip -r "$(basename "${file}")${date_suffix}.zip" "$(basename "${file}")"
      )
    fi

    if [ -f "${file}" ]; then
      (
      zip "$(basename "${file}")${date_suffix}.zip" -j "${file}"
      )
    fi
  done
}

mass-unzip () {
  for f in "$@"
  do
    if [ -f "${f}" ]; then
      cd "$(dirname "${f}")"
      unzip "${f}"
      cd - >/dev/null
    fi
  done
}


eps2pdf () {
	for f in ${@}
	do
      while [ "$(jobs | wc -l)" -ge "$(getconf _NPROCESSORS_ONLN)" ]; do
        sleep 0.01
      done
      ([ -f ${f} ] && epstopdf ${f}) &
	done
	wait
}

eps2svg () {
	for f in ${@}
	do
      while [ "$(jobs | wc -l)" -ge "$(getconf _NPROCESSORS_ONLN)" ]; do
        sleep 0.01
      done
		(
		[ -f ${f} ] && epstopdf ${f}
		pdf2svg $(echo "${f}" | sed 's/.eps/.pdf/g') $(echo "${f}" | sed 's/.eps/.svg/g') 
		) &
	done
	wait
}

pdf2eps () {
	for f in ${@}
	do
      while [ "$(jobs | wc -l)" -ge "$(getconf _NPROCESSORS_ONLN)" ]; do
        sleep 0.01
      done
      ([ -f "${f}" ] && inkscape -o $(echo "${f}" | sed 's/.pdf/.eps/g') ${f}) &
	done
	wait
}

svg2pdf () {
	for f in "${@}"
	do
	
	while [ "$(jobs | wc -l)" -ge "$(getconf _NPROCESSORS_ONLN)" ]; do
      sleep 0.01
    done
	
	rsvg-convert -f pdf -o "$(echo "${f}" | sed 's/.svg/.pdf/g')" ${f} &
	done
	wait
}


rmdir_recursive () {
  where=${1}
  where=${where:=.}
  find ${where} -mindepth 1 -type d | tac | xargs -I {} rmdir --ignore-fail-on-non-empty {}
}

ups () {
  # Distro-agnostic package managers
  if [ "$(command -v flatpak)" >/dev/null != "" ]
  then
    echo "\e[32m> Upgrading flatpak packages...\e[97m"
    flatpak update -y 
    flatpak uninstall --unused -y
  fi

  if [ "$(command -v snap)" >/dev/null != "" ]
  then
    echo "\e[32m> Upgrading snap packages...\e[97m"
    sudo snap refresh
  fi

  if [ "$(command -v brew)" >/dev/null != "" ]
  then

  echo "\e[32m> Upgrading brew packages...\e[97m"
    brew update && brew upgrade && brew cleanup
  fi

  # Debian-based
  if [ "$(command -v apt)" >/dev/null != "" ]
  then
    echo "\e[32m> Upgrading apt packages...\e[97m"
    sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
    if [ "$(command -v deb-get)" >/dev/null != "" ]
    then
      echo "\e[32m> Upgrading deb-get packages...\e[97m"
      deb-get update && deb-get upgrade
    fi
    if [ -x "$(command -v pacstall)" ]
    then
      echo "\e[32m> Upgrading pacstall packages...\e[97m" && yes | sudo pacstall -P -Up
    fi
    return
  fi

  # Arch-based
  if [ "$(command -v pacman)" >/dev/null != "" ]
  then
    echo "\e[32m> Upgrading pacman packages...\e[97m"
    sudo pacman -Syyu --noconfirm
    if [ "$(command -v yay)" >/dev/null != "" ]
    then
      yay -Syyu --noconfirm
    fi
    return
  fi

  # RPM-based
  if [ "$(command -v dnf)" >/dev/null != "" ]
  then
    echo "\e[32m> Upgrading dnf packages...\e[97m"
    sudo dnf upgrade -y && sudo dnf autoremove -y
    return
  fi
 

}

fgr () {
  [ "$1" = "~" ] && cdr $HOME && return
	if [ "$(uname)" != "Darwin" && -x "$(command -v locate)" ]
	then
	  locate "$(pwd)*/.git" | grep ".git$" | grep "^$(pwd)" | sed "s|.git||g; s|/$||g"
	else
	  find . -maxdepth 4 -name '*.git' 2>/dev/null | sed 's/\/.git//' | grep "${1}"
	fi
}

lastgrep() {
  if [ "$#" -eq 0 ] || [ "$#" -gt 2 ]; then
    echo "Usage: lastgrep [directory] <pattern>"
    return 1
  fi

  if [ "$#" -eq 2 ]; then
    directory="$1"
    pattern="$2"
  else
    directory="."
    pattern="$1"
  fi

    grep -rHn "$pattern" "$directory" | awk -F: '{file=$1; line=$2; text=$0} {lines[file]=line; texts[file]=text} END {for (f in lines) print texts[f]}'
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
