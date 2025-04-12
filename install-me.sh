#!/usr/bin/env bash

DOTFILES=$HOME/dotfiles

if [[ "$(uname)" == "Darwin" ]]; then
  echo "Configuring MacOS"
  $DOTFILES/osx/install_osx.sh
  cd $DOTFILES
elif [[ "$(uname)" == "Linux" ]]; then
  if [[ -f "/etc/arch-release" ]]; then
    echo "Configuring Arch Linux (Manjaro)"
    cd $DOTFILES
    $DOTFILES/arch/install_arch.sh
  else
    echo "Configuring Ubuntu"
    cd $DOTFILES
    $DOTFILES/ubuntu/install_ubuntu.sh
  fi
fi
