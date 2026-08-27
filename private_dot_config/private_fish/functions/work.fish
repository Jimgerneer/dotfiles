function __work_live_sessions -d "live (non-EXITED) zellij sessions on the work Mac"
    # -n/--no-formatting keeps the (EXITED ...) marker, which is what we filter on.
    # --short would drop it and we could not tell live from resurrectable.
    ssh -o BatchMode=yes mac 'zellij list-sessions -n' 2>/dev/null \
        | grep -v EXITED | awk '{print $1}'
end

function work -d "Attach to a zellij session on the work Mac"
    # ⚠️ ATTACH ONLY. This never passes --create, on purpose.
    #
    # A zellij session created from an SSH login is born in macOS's "Background"
    # security session -- `launchctl managername` returns Background, not Aqua --
    # and Background sessions have NO login-keychain access. gh stores its token
    # in the keychain, so inside such a session it reports
    #
    #     X Failed to log in ... The token in default is invalid.
    #
    # which is a lie: the token is fine, it is simply unreadable. gh-dash, and
    # anything else touching the keychain, fails the same way.
    #
    # Sessions created from a terminal ON THE MAC run in the Aqua session, and
    # panes spawned by that server inherit its keychain access. So: create there,
    # attach from here.

    set -l live (__work_live_sessions)

    if test -z "$live"
        echo "No live zellij sessions on the Mac (or the Mac is unreachable)." >&2
        echo "Check with:  ssh mac 'zellij list-sessions'" >&2
        return 1
    end

    if test (count $argv) -gt 0
        set -l target $argv[1]
        if not contains -- $target $live
            echo "No LIVE session named '$target'." >&2
            echo >&2
            echo "Live sessions:" >&2
            printf '  %s\n' $live >&2
            echo >&2
            echo "To make a new one, run this ON THE MAC ITSELF, not here:" >&2
            echo "    zellij attach --create $target" >&2
            echo "(creating it over ssh costs keychain access -- see the note in this function)" >&2
            return 1
        end
        ssh -t mac "zellij attach '$target'"
        return $status
    end

    if not type -q fzf
        echo "Live sessions on the Mac:" >&2
        printf '  %s\n' $live >&2
        echo >&2
        echo "Usage: work <session>" >&2
        return 1
    end

    set -l chosen (printf '%s\n' $live | fzf --prompt="work session> " --height=40% --reverse)
    or return 1
    test -n "$chosen"; and ssh -t mac "zellij attach '$chosen'"
end
