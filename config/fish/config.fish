set -Ux FZF_DEFAULT_COMMAND "fd --hidden --type f"
set -Ux TERM "xterm-256color"
set -Ux EDITOR nvim
set -Ux VISUAL nvim

alias eltest='fswatch lib/ test/ | mix test --listen-on-stdin'
if type -q exa
  alias la='exa -la'
  alias ls='exa -la'
else
  alias la='ls -la'
end

if type -q vim
  alias fsh='vim ~/.config/fish/'
  alias vrc='vim ~/.vim/settings/'
  alias tmc='vim ~/.tmux.conf'
end

if type -q git
  alias gco='git checkout'
  alias gs='git status'
  alias ga='git add'
end

if type -q nvim
  alias vim=nvim
  alias vimdiff="nvim -d"
end

if type -q fzf
  alias fm='fzf | xargs rm -rfi'
end

if type -q dmux
  alias malibu='dmux ~/Code/malibu/ -P "javascript"'
end

if type -q npm
  set fish_user_paths (npm bin)
end

function fco -d "Fuzzy-find and checkout a branch"
  git branch --all | grep -v HEAD | string trim | fzf | read -l result; and git checkout "$result"
end

function dev
  set ol_dir (pwd)
  cd
  if count $argv > /Code/null
    cd Code
    git clone $argv
    cd (echo $argv | awk -F "/" '{print $NF}' | sed 's/\.git//')
    bash ~/.dotfiles/scripts/dev_tmux.sh
  else if set destination (fd -t d | fzf --preview 'tree -aCt {}' --reverse --margin=7%)
    cd $destination
    bash ~/.dotfiles/scripts/dev_tmux.sh
  end
  cd $ol_dir
end

status --is-interactive; and source (anyenv init -|psub)

eval (starship init fish)
