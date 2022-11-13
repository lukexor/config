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

  ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/kitty
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

  ln -s /Applications/kitty.app/Contents/MacOS/kitty ~/.local/bin/kitty
}

setupTerminal() {
  mkdir -p ~/.local/bin
  PATH=~/bin:~/.local/bin:~/.cargo/bin"$PATH"
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
}

setupShell() {
  if command -v rustup &> /dev/null; then
    rustup update
  else
    curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  fi
  "$HOME"/.cargo/bin/cargo install nu --features=extra

  NU_BIN=$HOME/.cargo/bin/nu
  sudo grep -qxF "$NU_BIN" /etc/shells | wc -l || echo "$NU_BIN" | sudo tee -a /etc/shells
  [ "$SHELL" == "$NU_BIN" ] || chsh -s "$NU_BIN"
}


bootstrap() {
  setupTerminal

  case "$(uname -s)" in
    Linux*)  setupLinux;;
    Darwin*) setupMacOs;;
    *)       echo "Platform $(uname -s) is not supported"
  esac

  setupShell

  echo "
  Bootstrap Complete!
  "

  $NU_BIN ./setup.nu
}

bootstrap
