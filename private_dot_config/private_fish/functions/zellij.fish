# ─────────────────────────────────────────────────────────────────────────────
# zellij -- refuse to nest a session inside another.
#
# Deployed on BOTH tinos and the work Mac from this one file -- same repo, same
# chezmoi path. Kept as a single canonical copy on purpose: the failure mode is
# identical on both, and a guard that exists on only one machine is one you stop
# trusting.
#
# Why this exists: on 2026-08-27 a `zellij attach web` was run inside the single
# pane of the Mac's "Code" session. That leaves a client living in a pane of
# another session -- two sets of keybindings fighting over the same keys, and a
# status bar that makes no sense. Easy to do by accident, and genuinely
# confusing afterwards: the obvious suspect is `work --start`, which is
# innocent. It attaches exactly once, correctly.
#
# zellij exports $ZELLIJ inside a session, so the test is exact and cheap.
#
# ⚠️ Only invocations that START or ATTACH a session are blocked. Everything you
# legitimately run INSIDE a session -- action, run, edit, pipe, plugin,
# list-sessions, kill-session, setup -- passes through untouched. Blocking those
# would be worse than the bug.
#
# NOT blocked on purpose: -l/--layout. Inside a session that adds a tab rather
# than starting anything, which is fine.
#
# Only argv[1] is inspected, so `zellij --debug attach foo` slips past. That is
# deliberate: scanning every argument would false-positive on things like
# `zellij run -- some-cmd -s`, and a guard that cries wolf gets disabled.
#
# Verified against zellij 0.45 (tinos) and 0.41.2 (Mac) -- the session-starting
# names are the same in both: attach/a, options, -s/--session,
# -n/--new-session-with-layout.
#
# Deliberate nesting:  ZELLIJ_ALLOW_NEST=1 zellij attach foo
# ─────────────────────────────────────────────────────────────────────────────
function zellij --description "zellij, refusing to nest a session inside another"
    # Not inside a session, or explicitly overridden -- nothing to guard.
    if not set -q ZELLIJ; or set -q ZELLIJ_ALLOW_NEST
        command zellij $argv
        return $status
    end

    set -l starts_session no

    if test (count $argv) -eq 0
        # Bare `zellij` creates a new session or attaches to an existing one.
        set starts_session yes
    else
        switch $argv[1]
            case attach a options
                set starts_session yes
            case -s --session -n --new-session-with-layout
                set starts_session yes
        end
    end

    if test $starts_session = no
        command zellij $argv
        return $status
    end

    echo "zellij: refusing to nest -- already inside session '$ZELLIJ_SESSION_NAME'." >&2
    echo >&2
    echo "  detach first, then attach:   ctrl-o  then  d" >&2
    echo "  see what is running:         zellij list-sessions" >&2
    echo "  nest anyway (rarely right):  ZELLIJ_ALLOW_NEST=1 zellij $argv" >&2
    return 1
end
