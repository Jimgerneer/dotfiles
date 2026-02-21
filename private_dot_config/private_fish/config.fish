if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx EDITOR nvim

alias kill-firebase="kill-port 9000 8080 8085 4400 9199 9099"

starship init fish | source
