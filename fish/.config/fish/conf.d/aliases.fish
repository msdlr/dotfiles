# QoL
abbr -a ls 'ls --color=auto'
abbr -a ll 'ls -lh'
abbr -a lla 'ls -lah'
abbr -a vim 'vim -p'
abbr -a du 'du -hc'
abbr -a du1 'du -hc --max-depth=1'
abbr -a du0 'du -hc --max-depth=0'
abbr -a df 'df -h'
abbr -a ip 'ip -c=auto'
abbr -a echopath 'echo $PATH | string replace ":" "\n" | uniq'
abbr -a echoldpath 'echo $LD_LIBRARY_PATH | string replace ":" "\n" | uniq'
abbr -a l 'less -R'
abbr -a make 'make -j(getconf _NPROCESSORS_ONLN)'
abbr -a rsync 'rsync -avhzP'
abbr -a sudo 'sudo '
abbr -a py 'python3'
abbr -a pip3up 'pip3 list --outdated | tail -n +3 | cut -d' ' -f1 | xargs -n1 pip3 install --upgrade'
abbr -a wi 'echo "$USER@$hostname"'
abbr -a sd 'date +%Y%m%d'
abbr -a sdt 'date +%Y%m%d_%H%M'

function cdr --description 'Change to directory found by fgr and fzf'
    set dir (fgr | fzf)
    if test -n "$dir"
        cd $dir
    end
end

abbr -a tzip 'tar -czvf'
abbr -a tunzip 'tar -xvf'

if command -v pigz > /dev/null 2>&1
    if test (uname) = "Darwin"
        if command -v gtar > /dev/null 2>&1
            abbr -a tzip 'gtar -I pigz -cvf' # Multithreaded
            abbr -a untzip 'gtar -I pigz -xvf'
        end
    else
        abbr -a tzip 'tar -I pigz -cvf' # Multithreaded
        abbr -a untzip 'tar -I pigz -xvf'
    end
end

# Verbose commands
abbr -a mkdir 'mkdir -pv'
abbr -a ln 'ln -v'
abbr -a rm 'rm -v'
abbr -a mv 'mv -v'
abbr -a cp 'cp -v'
abbr -a chmod 'chmod -v'
abbr -a chown 'chown -v'

# Git abbreviations
if command -q git
    abbr -a gst 'git status'
    abbr -a ga 'git add'
    abbr -a gcm 'git commit -m'
    abbr -a gsu 'git branch --set-upstream-to=origin/(git symbolic-ref --short HEAD) (git symbolic-ref --short HEAD)'
    abbr -a gpush 'git push'
    abbr -a gf 'git fetch'
    abbr -a gpushu 'git push --set-upstream (git remote show) (git rev-parse --abbrev-ref HEAD)'
    abbr -a gpull 'git submodule init; git pull --recurse-submodules'
    abbr -a grh 'git reset --hard'
    abbr -a grs 'git reset --soft'
    abbr -a grm 'git reset --mixed'
    abbr -a gcout 'git checkout'
    abbr -a gclean 'git clean -df'
    abbr -a gnuke 'git clean -dfx' # Git clean of untracked files too
    abbr -a gua 'git remote | xargs -L1 git push --all'
    abbr -a gdiff 'git diff'
    abbr -a gs 'git stash'
    abbr -a gsp 'git stash pop'
    abbr -a gbs 'git submodule update --remote' # git bump-submodules
    abbr -a gd 'git diff'
    abbr -a gds 'git diff --staged'
    abbr -a gdt 'git difftool --dir-diff'
    abbr -a gdts 'git difftool --staged --dir-diff'
    abbr -a gsd 'git diff > (git rev-parse --abbrev-ref HEAD)-(hostname).diff'
end

# Docker abbreviations
if command -q docker
    abbr -a dps 'docker ps'
    abbr -a dimgs 'docker images'
    abbr -a drun 'docker run'
    abbr -a dbuild 'docker build'
    abbr -a dkill 'docker kill'
    abbr -a dstop 'docker stop'
    abbr -a dsprune 'docker system prune'
    abbr -a drmi 'docker rmi'
    abbr -a drem 'docker rm'
    abbr -a drmi-all 'docker rmi (docker images -a -q)'
    abbr -a drem-all 'docker rm (docker ps -a -q)'
    abbr -a dstop-all 'docker stop (docker ps -a -q)'
end

# If on desktop diff with meld/kompare instead
if test -n "$DISPLAY"
    if command -q kompare
        abbr -a diff 'kompare'
    else if command -q meld
        abbr -a diff 'meld'
    end
end

# Go to (symlinked) file's original directory
function cds --description 'Go to symlinked file''s original directory'
    set dir $argv[1]
    if test -z "$dir"
        set dir "."
    end
    cd (dirname (realpath "$dir"))
end

# Go to a dir's realpath
function cdsd --description 'Go to a directory''s realpath'
    set dir $argv[1]
    if test -z "$dir"
        set dir "."
    end
    cd (realpath "$dir")
end

function fgr --description 'Find git repositories'
    if test "$argv[1]" = "~"
        cdr $HOME
        return
    end
    
    find . -maxdepth 4 -name '*.git' 2>/dev/null | sed 's/\/.git//' | grep "$argv[1]"
end