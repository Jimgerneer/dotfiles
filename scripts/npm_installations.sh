#!/bin/bash

npm update -g

PACKAGES=(
  elm-oracle
  elm-format
  @elm-tooling/elm-language-server
)

npm install -g ${PACKAGES[@]}
