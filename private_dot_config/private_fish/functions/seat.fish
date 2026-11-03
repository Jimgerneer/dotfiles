# ─────────────────────────────────────────────────────────────────────────────
# seat -- get onto the Limen seat (seat-personal, DigitalOcean VPS on the tailnet).
#
#   seat            attach Herdr to the seat: the coordinator tab lives here
#   seat --shell    plain SSH shell as worker (logins, moshi-hook, one-offs)
#   seat --root     root over the tailnet (system changes only)
#   seat --keys     load the seat SSH keys into the agent for 8h
#
# Design notes that are easy to lose:
#  * Type remote commands at the seat prompt, not as `ssh host 'cmd'`: the
#    terminal's ssh wrapper appends its terminfo script to the remote command.
#  * Never start Limen jobs from a laptop clone. The seat's checkout is the
#    only one that runs jobs (/home/worker/Catch).
#  * Break-glass root over the public IP is `ssh seat-personal-public`. Use it
#    only when Tailscale is down.
# ─────────────────────────────────────────────────────────────────────────────

set -g __seat_host seat-personal.taildc6edb.ts.net

function __seat_keys
    # Keys are passphrased; only prompt for the ones not already loaded.
    set -l loaded (ssh-add -l 2>/dev/null)
    for key in limen_worker limen_admin
        set -l comment (string replace _ - $key)
        if not string match -q "*$comment*" -- $loaded
            ssh-add -t 8h $HOME/.ssh/$key; or return 1
        end
    end
end

function seat --description 'Attach to the Limen seat (Herdr), or --shell / --root / --keys'
    switch "$argv[1]"
        case '' --herdr
            __seat_keys; or return 1
            $HOME/.local/bin/herdr --remote worker@$__seat_host
        case --shell -s
            __seat_keys; or return 1
            ssh $__seat_host
        case --root
            __seat_keys; or return 1
            ssh seat-personal-root
        case --keys
            __seat_keys
        case -h --help
            sed -n '2,8p' (functions --details seat) | string replace -r '^# ?' ''
        case '*'
            echo "seat: unknown option '$argv[1]' (try seat --help)" >&2
            return 2
    end
end
