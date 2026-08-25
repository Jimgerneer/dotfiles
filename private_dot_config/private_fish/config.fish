if status is-interactive
    # Commands to run in interactive sessions can go here
end

# NOTE: these were `set -Ux` (UNIVERSAL) in the old tinos config. Universal
# variables persist in fish_variables and do not belong in config.fish -- they
# get re-set on every shell start for no reason. `set -gx` is correct here.
# TERM was also set universally; that is actively wrong, the terminal sets it.
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx FZF_DEFAULT_COMMAND "fd --hidden --type f"

# Every alias below is guarded with `type -q` so this file is safe on any
# machine regardless of what happens to be installed.

# eza is the maintained successor to exa; prefer it, fall back gracefully.
if type -q eza
    alias la='eza -la'
    alias ls='eza -la'
else if type -q exa
    alias la='exa -la'
    alias ls='exa -la'
else
    alias la='ls -la'
end

if type -q nvim
    alias vim=nvim
    alias vimdiff="nvim -d"
end

if type -q git
    alias gco='git checkout'
    alias gs='git status'
    alias ga='git add'
end

if type -q fzf
    alias fm='fzf | xargs rm -rfi'

    function fco -d "Fuzzy-find and checkout a branch"
        git branch --all | grep -v HEAD | string trim | fzf | read -l result; and git checkout "$result"
    end
end

if type -q kill-port
    alias kill-firebase="kill-port 9000 8080 8085 4400 9199 9099"
end

alias fsh='$EDITOR ~/.config/fish/'

function dev
    set ol_dir (pwd)
    cd
    if count $argv > /dev/null
        cd Code
        git clone $argv
        cd (echo $argv | awk -F "/" '{print $NF}' | sed 's/\.git//')
        bash ~/.dotfiles/scripts/dev_tmux.sh
    else if set destination (fd -t d | fzf --preview 'tree -aCt {}' --reverse --margin=7%)
        cd $destination
        bash ~/.dotfiles/scripts/dev_tmux.sh
    end
    cd $ol_dir
end

starship init fish | source
