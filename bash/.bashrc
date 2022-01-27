# Source default conf
. /etc/skel/.bashrc

function git_branch() {
    GIT_BRANCH="$(git branch 2>/dev/null | grep '^*' | colrm 1 2)"
    if [ -n "$GIT_BRANCH" ]; then
        echo "[$GIT_BRANCH] "
    fi
}

PS1='\[\e[0;31m\]\u\[\e[0;31m\]@\[\e[0;31m\]\h \[\e[0;32m\]\W \[\e[0;1;35m\]$(git_branch)\[\e[0;93m\]\$ \[\e[0m\]'

# Setup $PATH, other envvars, aliases, etc
for cfg in ${HOME}/.config/shell/*
do
    #echo "loaded ${cfg}"
    source ${cfg}
done

setxkbmap es 2>/dev/null
xset led 2>/dev/null
