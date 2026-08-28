# Package manifests

Config without the software it configures is half a backup. These lists exist so
a fresh machine can be rebuilt, and so tooling this repo *depends on* — notably
`gitleaks`, which `.githooks/pre-commit` hard-fails without — is declared rather
than assumed to be lying around.

Not deployed anywhere. `.packages` is dot-prefixed, so chezmoi ignores it; this
is git state only, read by humans.

## tinos (Arch)

| File | Contents | Regenerate with |
|---|---|---|
| `arch-native.txt` | explicitly-installed native packages | `pacman -Qqen > .packages/arch-native.txt` |
| `arch-aur.txt` | AUR / foreign packages | `pacman -Qqem > .packages/arch-aur.txt` |

Explicit only (`-e`): dependencies are omitted on purpose, because pacman pulls
those in itself and listing them makes the diff churn on every upgrade.

Restore:

    sudo pacman -S --needed - < .packages/arch-native.txt
    # AUR, needs an aur helper:
    yay -S --needed - < .packages/arch-aur.txt

## The work Mac

| File | Contents | Regenerate with |
|---|---|---|
| `Brewfile` | taps, formulae and casks | `brew bundle dump --force --file=.packages/Brewfile` |

Restore:

    brew bundle install --file=.packages/Brewfile

## ⚠️ These lists are a snapshot, not a lockfile

No versions are pinned, so a restore gets you whatever is current. That is the
right trade for a desktop — pinning a whole desktop is a losing battle — but it
does mean this cannot reproduce a machine bit-for-bit, only approximately.

Regenerate after installing or removing anything you want to keep.
