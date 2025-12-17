
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

