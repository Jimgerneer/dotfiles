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
function system-update -d "yay -Syu, with suspend blocked for the duration"
    echo "→ holding a block-mode sleep inhibitor for the duration"
    systemd-inhibit --what=sleep --mode=block --why="system-update: yay -Syu" \
        yay -Syu $argv
    set -l rc $status
    echo "→ inhibitor released (suspend re-enabled)"
    return $rc
end
