# Load XDG directories
if test -f "$HOME/.config/user-dirs.dirs"
    cat "$HOME/.config/user-dirs.dirs" | while read -l line
        # Skip comments and empty lines
        echo "$line" | string match -q -r '^[^#].*='; or continue
        
        # Read file, replace $HOME with ~
        set -l var (echo "$line" | string split '=' | head -1)
        set -l value (echo "$line" | string split '=' | tail -1 | string trim -c '"')
        set value (string replace -r '\$HOME' "$HOME" "$value")
        
        # Set the variable
        set -gx "$var" "$value"
    end
end

# # Set XDG directories with defaults if not already set
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DATA_HOME "$HOME/.local/share"