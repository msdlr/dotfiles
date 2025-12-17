
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

