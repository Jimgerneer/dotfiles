# ── DELIBERATELY A NO-OP ─────────────────────────────────────────────────────
# This file came from the fisher plugin danhper/fish-ssh-agent, which starts an
# ssh-agent PER SHELL on a RANDOM socket path and records it in
# ~/.ssh/environment:
#
#     ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
#
# Only fish shells could then find the agent. systemd user services and
# Hyprland's exec_cmd could not, because they never source that file.
#
# That silently broke the clipboard bridge to the work Mac: ssh could not
# authenticate, and the failure was invisible because a live ControlMaster
# connection masked it -- copies worked until ControlPersist expired, then
# stopped, with the service still reporting "active".
#
# The agent is now a systemd user service on a FIXED socket
# (ssh-agent.service), exported session-wide via
# ~/.config/environment.d/10-ssh-agent.conf. Starting another one here would
# override SSH_AUTH_SOCK in shells and reintroduce exactly the split.
#
# The plugin is still listed in ~/.config/fish/fishfile; running `fisher update`
# will restore the original contents of this file. If that happens, empty it
# again or drop the plugin from fishfile.
