#!/bin/bash

sudo chown -R $(whoami) ~/.npm-packages
sudo chown -R $(whoami) /usr/local/lib/node_modules

npm update -g

PACKAGES=(
  elm-oracle
  elm-format
  @elm-tooling/elm-language-server
)

npm install -g ${PACKAGES[@]}
