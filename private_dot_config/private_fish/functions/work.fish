# ─────────────────────────────────────────────────────────────────────────────
# work -- start / end a work session against the Mac.
#
#   work --start [session]   deskflow both ends, clipboard bridge, attach zellij
#   work --end               reverse, leaving the zellij session ALIVE
#   work --status            what is actually running, on both machines
#   work [session]           attach only (the original behaviour, unchanged)
#
# Design notes that are easy to lose:
#  * The zellij session is NEVER killed by --end. It holds work, and it can only
#    be created ON THE MAC (see the Aqua/keychain note in __work_attach below).
#  * The Deskflow SERVER on tinos is a systemd unit, not the Qt GUI. Two servers
#    fight over port 24800, so the GUI is for debugging only.
#  * clip-push-mac has no [Install]: it runs only inside a work session, because
#    it pushes this clipboard to the Mac continuously.
# ─────────────────────────────────────────────────────────────────────────────

set -g __work_default_session Code
set -g __work_state $HOME/.local/state/work-session
# ⚠️ Absolute path on purpose: ~/.local/bin is NOT in PATH on this machine
# (verified 2026-08-27). Same reason clip-push-mac.service uses %h/.local/bin
# and the Hyprland bind uses the interpolated home dir.
set -g __work_mac $HOME/.local/bin/mac-worksession

function __work_elapsed -d "human elapsed time since an epoch stamp"
    set -l secs (math (date +%s) - $argv[1])
    if test $secs -lt 3600
        echo (math -s0 $secs / 60)"m"
    else
        echo (math -s1 $secs / 3600)"h"
    end
end

function __work_live_sessions -d "live (non-EXITED) zellij sessions on the work Mac"
    # -n/--no-formatting keeps the (EXITED ...) marker, which is what we filter on.
    # --short would drop it and we could not tell live from resurrectable.
    ssh -o BatchMode=yes mac 'zellij list-sessions -n' 2>/dev/null \
        | grep -v EXITED | awk '{print $1}'
end

function __work_attach -d "Attach to a live zellij session on the work Mac"
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


function __work_start -d "Bring up a work session"
    set -l session $__work_default_session
    test (count $argv) -gt 0; and set session $argv[1]

    # ── guard: did the last session ever get ended? ──────────────────────────
    if test -f $__work_state
        set -l since (cat $__work_state)
        echo "⚠️  A work session was started "(__work_elapsed $since)" ago and never ended." >&2
        echo "   Continuing anyway -- every step below is idempotent." >&2
        echo "   (`work --end` to close it out, `work --status` to inspect.)" >&2
        echo >&2
    end

    # ── guard: the Qt GUI would fight the service over port 24800 ────────────
    if pgrep -x deskflow >/dev/null 2>&1
        echo "⚠️  The Deskflow GUI is running; it would fight the service for port 24800." >&2
        echo "   Stopping it." >&2
        pkill -x deskflow
        sleep 1
    end

    # ── agent: passphrase key, so this cannot be done by a background unit ───
    if not ssh-add -l >/dev/null 2>&1
        echo "→ ssh-add (agent is empty -- passphrase needed once per boot)"
        ssh-add $HOME/.ssh/keys/id_ed25519_mac; or return 1
    end

    echo "→ deskflow server (tinos)"
    systemctl --user start deskflow-server.service; or return 1

    echo "→ mac"
    $__work_mac start; or return 1

    echo "→ clipboard bridge"
    systemctl --user start clip-push-mac.service

    date +%s > $__work_state

    # ── attach: ATTACH ONLY, never --create. See __work_attach for why. ──────
    echo "→ zellij: $session"
    __work_attach $session
end

function __work_end -d "Tear a work session down"
    # Mac first, as requested -- and explicitly, so it is visible here rather
    # than only in the journal. deskflow-server's ExecStopPost repeats this on
    # stop; it is idempotent and its output goes to the journal, not here.
    echo "→ mac"
    $__work_mac stop

    echo "→ clipboard bridge"
    systemctl --user stop clip-push-mac.service

    echo "→ deskflow server (tinos)"
    systemctl --user stop deskflow-server.service

    rm -f $__work_state

    # The zellij session is deliberately left running. Detaching happened when
    # the ssh -t exited; the session and its panes survive on the Mac.
    echo
    echo "work done"
end

function __work_status -d "What is actually running"
    if test -f $__work_state
        echo "session: OPEN, started "(__work_elapsed (cat $__work_state))" ago"
    else
        echo "session: closed"
    end
    printf '  tinos: deskflow-server %s\n' (systemctl --user is-active deskflow-server.service)
    printf '  tinos: clip-push-mac   %s\n' (systemctl --user is-active clip-push-mac.service)
    if ssh-add -l >/dev/null 2>&1
        echo "  tinos: ssh agent       loaded"
    else
        echo "  tinos: ssh agent       EMPTY (bridge will fail -- run ssh-add)"
    end
    $__work_mac status
    set -l live (__work_live_sessions)
    if test -n "$live"
        printf '  mac: live zellij       %s\n' (string join ', ' $live)
    else
        echo "  mac: live zellij       none"
    end
end

function work -d "Work session against the Mac: --start / --end / --status, or attach"
    switch "$argv[1]"
        case --start -s
            __work_start $argv[2..-1]
        case --end -e
            __work_end
        case --status
            __work_status
        case -h --help
            echo "work --start [session]   bring up deskflow + clipboard, attach zellij (default: $__work_default_session)"
            echo "work --end               tear down, leaving the zellij session alive"
            echo "work --status            what is running on both machines"
            echo "work [session]           attach only"
        case '*'
            __work_attach $argv
    end
end
