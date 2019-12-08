#!/bin/bash

sudo npm update -g

PACKAGES=(
  elm-oracle
  @elm-tooling/elm-language-server
)

sudo npm install -g ${PACKAGES[@]}
