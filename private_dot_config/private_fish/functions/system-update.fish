# system-update -- yay -Syu that cannot be suspended out from under itself.
#
# WHY THIS EXISTS
# hypridle suspends this machine at 90 minutes (~/.config/hypr/hypridle.conf).
# AUR rebuilds routinely run longer than that -- qt5-webengine took well past it
# on 2026-09-14, on 32 cores -- so an unattended `yay -Syu` can be suspended
# mid-compile. This holds a logind lock for the life of the update.
#
# ⚠️ --mode=block IS THE LOAD-BEARING PART, and it is systemd-inhibit's default
# only if you do not override it. 1Password, Discord and hypridle all hold
# *delay*-mode sleep inhibitors already; delay only postpones a suspend by
# seconds and gives you no protection at all. Verified 2026-09-14: with a block
# lock held, logind's BlockInhibited property reads "sleep" and the suspend
# simply cannot proceed.
#
# ⚠️ --what=sleep, NOT idle:sleep, on purpose. `sleep` alone still lets the
# session lock at 10 min and the panel blank at 60 -- the security behaviour is
# kept, only the suspend is blocked. `idle:sleep` would suppress the lock too,
# which is the wrong trade for something you walk away from.
#
# This does NOT depend on hypridle honouring idle inhibitors. Even if hypridle
# fires `systemctl suspend` at the 90 minute mark, logind refuses it.
#
# 🔜 Not covered here: `hey`, which installs to ~/.local/bin outside pacman and
# updates only via `hey upgrade`. yay covers everything else including
# claude-code, which is an AUR package (so `pacman -Syu` alone would skip it).
# ⚠️ --sudoloop IS PASSED EXPLICITLY even though ~/.config/yay/config.json now
# sets "sudoloop": true. Belt and braces on purpose: this function's whole job is
# surviving an unattended update, and a config file that can be reset, reinstalled
# or lost in a rebuild should not be the only thing keeping that true.
#
# WHAT IT FIXES (2026-09-14, a real failure):
# qt5-webengine built for ~12 minutes, then the install step died with
#     [sudo] password for decoy:
#     sudo: timed out reading password
# and the whole transaction was lost -- 9 built packages, ~1.6 GB, not installed.
# TWO sudo settings combined to do that:
#   timestamp_timeout (15 min default) -- the cached auth expired mid-build, so
#                                         sudo prompted again at install time
#   passwd_timeout    (5 min default)  -- nobody was there, so sudo gave up
# --sudoloop refreshes the timestamp in the background, so the prompt never
# reappears. It needs no sudoers edit and widens no privileges: it only keeps
# an already-authenticated session from expiring while you are actively updating.
#
# Also set in the yay config, and worth knowing here: "batchinstall": true, which
# installs all built AUR packages in ONE pacman transaction instead of one per
# package -- nine chances to hit this failure became one.
#
# NOT set, deliberately: answerdiff. The PKGBUILD diff menu stays on. The AUR is
# user-submitted and most of these packages (brave-bin, 1password, google-chrome,
# slack-desktop, spotify) are thin wrappers that fetch a vendor URL -- the diff is
# the only place a changed URL would be visible. The menus fire BEFORE any build,
# so answering them costs nothing against the walk-away problem this solves.
function system-update -d "yay -Syu, with suspend blocked for the duration"
    echo "→ holding a block-mode sleep inhibitor for the duration"
    systemd-inhibit --what=sleep --mode=block --why="system-update: yay -Syu" \
        yay -Syu --sudoloop $argv
    set -l rc $status
    echo "→ inhibitor released (suspend re-enabled)"
    return $rc
end
