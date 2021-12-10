#!/bin/bash

set -e

case "$OSTYPE" in
  linux*)
    if command -v apt &>/dev/null; then
      apt-get update
      apt-get -y install software-properties-common
      add-apt-repository ppa:neovim-ppa/stable
      apt-get -y install stow pkg-config libssl-dev libxcb-composite0-dev libx11-dev curl cmake
      /bin/bash -c "$(curl -fsSL https://starship.rs/install.sh)"
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
    brew install stow openssl cmake starship
    ;;
  *)
    echo "unsupported: $OSTYPE"
    exit 1
    ;;
esac

if command -v rustup &> /dev/null; then
    rustup update
else
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

$HOME/.cargo/bin/cargo install nu --features=extra
pushd files
find . -maxdepth 1 -mindepth 1 -exec mv ~/{} ~/{}.orig \; 2> /dev/null
popd
stow files

BIN=$HOME/.cargo/bin/nu
if [ $(grep $BIN /etc/shells|wc -l) -eq 0 ]; then
  if [ "$EUID" -eq 0 ]; then
    echo $BIN >> /etc/shells
  else
    sudo echo $BIN >> /etc/shells
  fi
fi
chsh -s $BIN

echo "Setup Complete!"

$BIN install.nu
$BIN
