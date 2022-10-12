#!/bin/bash

set -euxo pipefail

setupLinux() {
  LANG=${LANG:-C.UTF-8}
  sudo=
  [ "$EUID" -ne 0 ] && sudo=sudo

  $sudo apt-get update -y
  $sudo apt-get -y install software-properties-common
  $sudo add-apt-repository -y ppa:neovim-ppa/stable
  $sudo apt-get -y install pkg-config libssl-dev libxcb-composite0-dev libx11-dev curl cmake gcc-multilib
}

setupMacOs() {
  set +e
  xcode-select --install
  set -e
  
  if command -v brew &>/dev/null; then
    brew update
  else
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  
  brew install openssl cmake
}

setupShell() {
  if command -v rustup &> /dev/null; then
    rustup update
  else
    curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  fi
  $HOME/.cargo/bin/cargo install nu --features=extra

  BIN=$HOME/.cargo/bin/nu
  sudo grep -qxF $BIN /etc/shells | wc -l || echo $BIN | sudo tee -a /etc/shells
  [ "$SHELL" == $BIN ] || chsh -s $BIN
}


bootstrap() {
  case "$(uname -s)" in
    Linux*)  setupLinux;;
    Darwin*) setupMacOs;;
    *)       echo "Platform $(uname -s) is not supported"
  esac
  
  setupShell
  
  echo "
  Bootstrap Complete!
  "

  $BIN ./setup.nu
}

bootstrap
