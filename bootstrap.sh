#!/bin/bash

set -euxo pipefail

LANG=${LANG:-C.UTF-8}
[ "$EUID" -ne 0 ] && sudo=sudo

case "$OSTYPE" in
  linux*)
    if command -v apt &>/dev/null; then
      $sudo apt-get update -y
      $sudo apt-get -y install software-properties-common
      $sudo add-apt-repository ppa:neovim-ppa/stable
      $sudo apt-get -y install pkg-config libssl-dev libxcb-composite0-dev libx11-dev curl cmake
    elif command -v yum &>/dev/null; then
      $sudo yum update -y
      $sudo yum -y install curl cmake
    else
      echo "unsupported package manager"
      exit 1
    fi
    ;;
  darwin*)
    set +e
    xcode-select --install
    set -e
    if command -v brew &>/dev/null; then
        brew update
    else
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install openssl cmake
    ;;
  *)
    echo "unsupported: $OSTYPE"
    exit 1
    ;;
esac

if command -v rustup &> /dev/null; then
    rustup update
else
    curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

$HOME/.cargo/bin/cargo install nu --features=extra

BIN=$HOME/.cargo/bin/nu
grep -qxF $BIN /etc/shells | wc -l || $sudo echo $BIN >> /etc/shells
[ "$SHELL" == $BIN ] || chsh -s $BIN

echo "Bootstrap Complete!"

$BIN ./setup.nu
