# PATH additions.
#
# Everything in ~/.config/fish/conf.d/ is sourced automatically by fish, so this
# needs no reference from config.fish.
#
# ⚠️ DELIBERATELY NOT `fish_add_path ~/.local/bin` TYPED AT A PROMPT.
# That form writes a UNIVERSAL variable into ~/.config/fish/fish_variables --
# which is NOT tracked by chezmoi. It works on the machine you typed it on and
# silently disappears on the next rebuild, which is exactly how this kept
# getting lost. Keeping it here makes it reproducible and reviewable.
#
# `-g` is global (per-session), not universal: no state accumulates in
# fish_variables, it is simply re-applied on every shell start. fish_add_path is
# idempotent, so re-sourcing cannot produce duplicate entries.
# `-p` prepends, so ~/.local/bin wins over a system binary of the same name.
#
# ⚠️ THIS AFFECTS INTERACTIVE FISH ONLY, and that distinction is load-bearing.
# systemd user units and Hyprland's exec_cmd do NOT inherit fish's environment,
# so they still cannot resolve a bare `mac-worksession` or `clip-pull-mac`.
# The absolute-path convention in those places is still correct -- see
# phase-6-remote-mac.md. This changes what YOU can type, not what they can run.
fish_add_path -g -p $HOME/.local/bin
