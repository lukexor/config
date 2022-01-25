#!/bin/bash

set -e
LANG=${LANG:-C.UTF-8}

case "$OSTYPE" in
  linux*)
    if command -v apt &>/dev/null; then
      apt-get update
      apt-get -y install software-properties-common
      add-apt-repository ppa:neovim-ppa/stable
      apt-get -y install stow pkg-config libssl-dev libxcb-composite0-dev libx11-dev curl cmake lolcat
      /bin/bash -c "$(curl -fsSL https://starship.rs/install.sh)"
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
    brew install stow openssl cmake starship lolcat
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

CONFLICTS=$(stow -nv files 2>&1 | awk '/\* existing target is/ {print $NF}')
for file in ${CONFLICTS[@]}; do
  if [ -f "$HOME/$file" ] || [ -L "$HOME/$file" ]; then
    echo "Moved $file to $file.orig"
    mv "$HOME/$file"{,.orig}
  fi
done
stow -Rv files

sudo=
[ "$EUID" -eq 0 ] && sudo=sudo
BIN=$HOME/.cargo/bin/nu
grep -qxF $BIN /etc/shells|wc -l || $sudo echo $BIN >> /etc/shells
[ "$SHELL" == $BIN ] || chsh -s $BIN

echo "Setup Complete!"

$BIN ./install.nu
$BIN
