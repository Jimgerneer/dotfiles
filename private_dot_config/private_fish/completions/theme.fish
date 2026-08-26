# Complete `theme` with the palettes actually defined in .chezmoidata, so the
# list never drifts from the repo.
complete -c theme -f -a "(chezmoi execute-template '{{ range \$k, \$v := .palettes }}{{ \$k }}\n{{ end }}' 2>/dev/null)"
