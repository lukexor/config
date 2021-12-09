#!/bin/bash

#--------------------------#
# Install/Update packages #
#-------------------------#

case "$OSTYPE" in
  linux*)
    if command -v apt &>/dev/null; then
      apt update
      apt install stow pkg-config libssl-dev libxcb-composite0-dev libx11-dev
    else if  command -v yum &>/dev/null; then
      yum update
      yum install stow libxcb openssl-devel libX11-devel
    else
      echo "unsupported package manager"
      exit 1
    fi
    ;;
  darwin*)
    xcode-select --install
    if command -v brew &>/dev/null; then
        brew update
    else
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install stow openssl cmake
    ;;
  *)
    echo "unsupported: $OSTYPE"
    exit 1
    ;;
esac

#--------------#
# Install Rust #
#--------------#

if command -v rustup &> /dev/null; then
    rustup update
else
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

#-----------------#
# Install nushell #
#-----------------#

cargo install nu --features=extra

#-----------------#
# Symlink Configs #
#-----------------#

stow files

#----------------------#
# Change default shell #
#----------------------#

BIN=$HOME/.cargo/bin/nu
if [[ $(grep $BIN /etc/shells|wc -l) -eq 0 ]]; then
    sudo echo $BIN >> /etc/shells
fi
chsh -s $BIN
nu install.nu
nu
