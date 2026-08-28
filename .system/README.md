# System files — versioned here, installed by hand

Files that belong outside `$HOME` and so cannot be chezmoi-managed. They live
here to be versioned and reviewable; installing them is a deliberate, rare,
root-owned act, not something an apply should do behind your back.

`.system` is dot-prefixed, so chezmoi ignores it entirely. Git state only.

## `pacman-hooks/50-claude-code-mouse-recheck.hook`

Fires on install/upgrade of `claude-code` and prints a reminder to re-test the
mouse-paste workaround (`CLAUDE_CODE_DISABLE_MOUSE=1`). Exists because a
workaround with no exit criteria quietly becomes permanent — the variable costs
mouse support inside Claude Code, and nothing else would ever prompt you to
check whether it is still needed.

Install:

    sudo install -Dm644 \
      ~/.local/share/chezmoi/.system/pacman-hooks/50-claude-code-mouse-recheck.hook \
      /etc/pacman.d/hooks/50-claude-code-mouse-recheck.hook

Verify it fires without waiting for a real upgrade:

    yay -S claude-code          # reinstall; the hook runs PostTransaction

Remove, once the upstream bug is fixed and the workaround is gone:

    sudo rm /etc/pacman.d/hooks/50-claude-code-mouse-recheck.hook

`/etc/pacman.d/hooks/` is pacman's default `HookDir` (the setting is commented
out in `/etc/pacman.conf`, so the default applies) and does not exist until
something creates it — hence `install -D`.
