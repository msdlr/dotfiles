# Source default conf
. /etc/skel/.bashrc
# Source bash_completion
[ -f /etc/bash_completion ] && . /etc/bash_completion

function git_branch() {
	GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    if [ -n "$GIT_BRANCH" ]; then
        echo "[$GIT_BRANCH] "
    fi
}

function cur_short_path() {
	[ "${PWD}" = "${HOME}" ] && echo "~" && return
	pwd | sed " s|${HOME}|~|g ; s|/|\n|g ; /^$/d" | cut -c1-1 |  tr '\n' '/' | sed "s|./$|$(basename $PWD)|g"
}

# Setup $PATH, other envvars, aliases, etc
for cfg in $(ls ${HOME}/.config/shell/*[\.sh,\.bash] 2>/dev/null)
do
    #echo "loaded ${cfg}"
    source ${cfg}
done

PS1='\[\e[0;31m\]\u\[\e[0;31m\]@\[\e[0;31m\]\h \[\e[0;32m\]$(cur_short_path) \[\e[0;1;35m\]$(git_branch)\[\e[0;93m\]\$ \[\e[0m\]'

bind 'set show-all-if-ambiguous on' 2>/dev/null
bind 'TAB:menu-complete' 2>/dev/null

setxkbmap es 2>/dev/null
xset led 2>/dev/null
