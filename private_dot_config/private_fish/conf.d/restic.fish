# restic backup environment.
#
# Everything in ~/.config/fish/conf.d/ is sourced automatically by fish, so this
# needs no reference from config.fish.
#
# NEITHER VALUE IS SECRET:
#   RESTIC_REPOSITORY       a path
#   RESTIC_PASSWORD_COMMAND a command that FETCHES the password from 1Password
# The password itself lives only in 1Password and never touches disk, history or
# argv. That also means it survives this machine dying -- which is the entire
# point, since a repo password stored only on the machine being backed up is
# unrecoverable in exactly the scenario the backup exists for.
#
# TINOS-ONLY: /mnt/nas is an SMB mount of the TrueNAS box on the LAN. Guarded to
# this host in .chezmoiignore, so the Mac never sees it.
#
# ⚠️ If the 1Password item is ever renamed, this reference must change with it.
# A restic repo whose password you cannot produce is permanently unreadable.

set -gx RESTIC_REPOSITORY       /mnt/nas/jdenton-data/backup/restic-tinos
set -gx RESTIC_PASSWORD_COMMAND 'op read op://Private/restic-tinos/password'
