
function git_branch
    # Current branch
    set -l GIT_BRANCH (git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if test $status -ne 0
        return
    end

    if set -q GIT_BRANCH[1]
        # Ahead/behind counts
        set -l ahead (git rev-list --count @{u}..HEAD 2>/dev/null)
        set -l behind (git rev-list --count HEAD..@{u} 2>/dev/null)
        
        set -l gst ""

        if set -q ahead[1]; and test $ahead -gt 0
            set gst "$gst▲$ahead "
        end
        
        if set -q behind[1]; and test $behind -gt 0
            set gst "$gst▼$behind"
        end

        # Trim trailing space
        set gst (string trim --right --chars=" " "$gst")

        # Wrap in brackets only if non-empty
        if test -n "$gst"
            echo "($GIT_BRANCH $gst) "
        else
            echo "($GIT_BRANCH) "
        end
    end
end

function cur_short_path
    if test "$PWD" = "$HOME"
        echo "~"
        return
    end
    
    # Using string replace instead of sed
    string replace "$HOME" '~' -- $PWD | \
    string replace '/home/' '~' -- | \
    string replace '/Users/' '~' -- 
end

# Prompt
if set -q SSH_CLIENT
    # SSH shell
    function fish_prompt
        set -l ssh_color red
        set -l path_color green
        set -l git_color magenta -o
        set -l prompt_color yellow
        
        set_color $ssh_color
        echo -n (whoami)
        echo -n "@"
        echo -n (hostname -s)
        echo -n " "
        
        set_color $path_color
        echo -n (cur_short_path)
        echo -n " "
        
        set_color $git_color
        echo -n (git_branch)
        
        set_color $prompt_color
        echo -n '$ '
        
        set_color normal
    end
else
    # Local shell
    function fish_prompt
        set -l path_color blue
        set -l git_color magenta -o
        set -l prompt_color yellow
        
        set_color $path_color
        echo -n (cur_short_path)
        echo -n " "
        
        set_color $git_color
        echo -n (git_branch)
        
        set_color $prompt_color
        echo -n '$ '
        
        set_color normal
    end
end

# --- Movement ---
# Ctrl+← and Ctrl+→ move by word
bind \e\[1\;5D backward-word
bind \e\[1\;5C forward-word

# Ctrl+A / Ctrl+E move to beginning/end of line
bind \ca beginning-of-line
bind \ce end-of-line

# Home / End keys
bind \e\[H beginning-of-line
bind \e\[F end-of-line

# Remove welcome message
set -U fish_greeting ""

# fzf for completion
if type -q fzf
    fzf --fish | source

    function __fzf_complete_files
        if type -q fd
            fd . --hidden --follow --exclude .git
        else
            find . -type f 2>/dev/null
        end | fzf --height=40% --reverse --multi
    end

    complete -c '*' -f -a "(__fzf_complete_files)"
end

# Aliases
abbr -a reload 'exec fish'

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
abbr -a tzip 'tar -czvf'  # tar -czvf archive.tar.gz stuff
abbr -a sudo 'sudo '
abbr -a py 'python3'
abbr -a wi 'echo "$USER@$HOST"'

abbr -a sd 'date +%Y%m%d'
abbr -a sdt 'date +%Y%m%d_%H%M'

function cdr --description 'Change to directory found by fgr and fzf'
    set dir (fgr | fzf)
    if test -n "$dir"
        cd $dir
    end
end

if command -v pigz > /dev/null 2>&1
    if test (uname) = "Darwin"
        if command -v gtar > /dev/null 2>&1
            abbr -a tzip 'gtar -I (command -v pigz) -cvf' # Multithreaded
        else
            abbr -a tzip 'tar -czvf'
        end
    else
        abbr -a tzip 'tar -I (command -v pigz) -cvf' # Multithreaded
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