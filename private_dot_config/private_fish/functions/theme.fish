function theme --description "Switch the desktop palette and re-apply chezmoi"
    # The active palette lives in ~/.config/chezmoi/chezmoi.toml, which is
    # machine-local and NOT in the dotfiles repo. That is deliberate: tinos and
    # the laptop can each sit on a different palette from the same commit.
    # The palettes themselves are shared, in .chezmoidata/palettes.toml.
    set -l cfg $HOME/.config/chezmoi/chezmoi.toml

    if not command -q chezmoi
        echo "theme: chezmoi is not installed" >&2
        return 1
    end

    set -l names (chezmoi execute-template '{{ range $k, $v := .palettes }}{{ $k }} {{ end }}' | string split -n ' ')
    set -l current (chezmoi execute-template '{{ .theme }}' 2>/dev/null)

    if test (count $argv) -eq 0
        echo "active:    $current"
        echo "available:"
        for n in $names
            if test "$n" = "$current"
                set_color --bold; echo "  * $n"; set_color normal
            else
                echo "    $n"
            end
        end
        echo
        echo "switch with:  theme <name>"
        return 0
    end

    set -l want $argv[1]

    if not contains -- $want $names
        echo "theme: unknown palette '$want'" >&2
        echo "       known: $names" >&2
        return 1
    end

    if test "$want" = "$current"
        echo "theme: already on $want (use 'chezmoi apply' to force a re-render)"
        return 0
    end

    if not test -w $cfg
        echo "theme: cannot write $cfg" >&2
        return 1
    end

    if grep -qE '^[[:space:]]*theme[[:space:]]*=' $cfg
        sed -i -E "s|^([[:space:]]*)theme[[:space:]]*=.*|\\1theme = \"$want\"|" $cfg
    else
        printf '    theme = "%s"\n' $want >>$cfg
    end

    echo "theme: $current -> $want"
    chezmoi apply
end
