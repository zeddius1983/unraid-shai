#!/bin/bash

# Ensure we are saving bash history
plugin_dir="/boot/config/plugins/shai"
hist_file="$plugin_dir/.bash_history"

# Only configure if interactive and we have a bash shell
if [ -n "$BASH_VERSION" ] && [ -n "$PS1" ]; then
    mkdir -p "$plugin_dir"
    
    export HISTFILE="$hist_file"
    export HISTSIZE=10000
    export HISTFILESIZE=10000
    
    # Append to the history file, don't overwrite it
    shopt -s histappend
    
    # Save history after each command and reload it to sync across sessions
    export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

    # AI Autocomplete Integration
    _shai_autocomplete() {
        if [ ! -f "/usr/local/bin/shai" ]; then
            return
        fi
        
        # Save the current line to temporary variables
        local current_line="$READLINE_LINE"
        local current_point="$READLINE_POINT"
        
        # Call shai for autocomplete
        # Note: We output a carriage return/newline manually if we want to show a status,
        # but to keep it clean we just block.
        local new_line
        new_line=$(/usr/local/bin/shai --autocomplete "$current_line" "$current_point" 2>/dev/null)
        
        if [ $? -eq 0 ] && [ -n "$new_line" ]; then
            READLINE_LINE="$new_line"
            READLINE_POINT=${#READLINE_LINE}
        fi
    }
    
    # Bind Ctrl+N to the autocomplete function
    bind -x '"\C-n": _shai_autocomplete'
fi
