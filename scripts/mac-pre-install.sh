#!/bin/bash

# Check if Homebrew is installed
if [ ! -f "`which brew`" ]; then
  echo 'Installing homebrew'
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo 'Updating homebrew'
  brew update
fi
brew tap homebrew/bundle  # Install Homebrew Bundle

# Check if Zim is installed for zshell
OMZDIR="$HOME/.zim"
if [ ! -d "$OMZDIR" ]; then
  echo 'Installing zim' 
  /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh)"
else
  echo 'Zim already installed'
fi

# Change default shell to bash and setup fish
if [ ! $0 = "-bash" ]; then
  echo 'Changing default shell to bash'
  echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
  chsh -s `which bash`
else
  echo 'Already using fish'
fi
