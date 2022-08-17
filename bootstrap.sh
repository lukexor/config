#!/bin/bash

set -euxo pipefail

set +e
xcode-select --install
set -e

if command -v brew &>/dev/null; then
  brew update
else
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew install openssl cmake

if command -v rustup &> /dev/null; then
  rustup update
else
  curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

$HOME/.cargo/bin/cargo install nu --features=extra

BIN=$HOME/.cargo/bin/nu
grep -qxF $BIN /etc/shells | wc -l || sudo echo $BIN >> /etc/shells
[ "$SHELL" == $BIN ] || chsh -s $BIN

echo "
Bootstrap Complete!
"

$BIN ./setup.nu
