#!/usr/bin/env bash

[ -n "$DEBUG" ] && set -x
set -euo pipefail

install_linux() {
  echo "Installing Packages..."

  LANG=${LANG:-C.UTF-8}
  sudo=
  [ "$EUID" -ne 0 ] && sudo=sudo

  $sudo add-apt-repository -y ppa:neovim-ppa/stable
  $sudo apt update -y
  set +e
  $sudo apt install -y \
    bash \
    cc65 \
    cmake \
    coreutils \
    curl \
    docker \
    fzf \
    gcc-multilib \
    git \
    gnutls-bin \
    hexedit \
    libssl-dev \
    libx11-dev \
    libxcb-composite0-dev \
    llvm \
    neovim
    node-latest-version \
    npm \
    openssl \
    pkg-config \
    postgresql \
    python2 \
    python3 \
    python3-pip
    shellcheck \
    software-properties-common \
    sqlite \
    stow \
    tidy \
    tree \
    watchman \
    wget \
    yamllint
  $sudo apt autoremove
  set -e

  [ ! -f ~/.local/bin/kitty ] \
    && ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/kitty

  mkdir -p ~/.local/share/fonts
  cp ./assets/*.ttf ~/.local/share/fonts/
  fc-cache -f -v

  return 0
}

install_macos() {
  echo "Installing Packages..."

  set +e
  xcode-select --install
  set -e
  open ./assets/*.ttf

  if command -v brew &>/dev/null; then
    brew update
  else
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  set +e
  brew install \
    bash \
    cc65 \
    cmake \
    coreutils \
    docker \
    exercism \
    fish \
    fzf \
    git \
    gnutls \
    hexedit \
    llvm \
    neovim \
    node \
    openssl \
    postgresql \
    prettier \
    pylint \
    python \
    python3 \
    shellcheck \
    sqlite \
    stow \
    tidy-html5 \
    tree \
    watchman \
    wget \
    yamllint
  set -e

  [ ! -f ~/.local/bin/kitty ] \
    && ln -s /Applications/kitty.app/Contents/MacOS/kitty ~/.local/bin/kitty
  [ ! -f ~/Library/LaunchAgents/environment.plist ] \
    && ln -s ~/.config/environment.plist ~/Library/LaunchAgents/environment.plist

  return 0
}

install_terminal() {
  echo "Installing Terminal..."

  mkdir -p ~/.local/bin
  set +e
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
  set -e

  return 0
}

install_crates() {
  echo "Installing Crates..."

  set +e
  if command -v rustup &> /dev/null; then
    rustup update
  else
    curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  fi

  rustup component add \
    clippy \
    llvm-tools-preview \
    rust-analyzer

  cargo install \
    bat \
    cargo-asm \
    cargo-bloat \
    cargo-expand \
    cargo-generate \
    cargo-outdated \
    cargo-tree \
    cargo-watch \
    exa \
    fd-find \
    flamegraph \
    hyperfine \
    procs \
    ripgrep \
    starship \
    tealdeer \
    tokei \
    wasm-pack

  cargo install nu --features=extra
  NU_BIN=$HOME/.cargo/bin/nu
  sudo grep -qxF "$NU_BIN" /etc/shells | wc -l || echo "$NU_BIN" | sudo tee -a /etc/shells
  set -e

  return 0
}

install_npm() {
  echo "Installing Npm..."

  npm_dir=~/.npm-packages
  mkdir -p "$npm_dir"
  npm config set prefix "$npm_dir"

  set +e
  npm install -g \
    @fsouza/prettierd \
    eslint_d \
    jsonlint \
    markdownlint \
    markdownlint-cli \
    stylelint \
    stylelint-config-standard \
    yarn
  set -e

  yarn set version stable

  return 0
}

install_lolcat() {
  echo "Installing lolcat..."

  # https://github.com/jaseg/lolcat
  rm -rf lolcat
  git clone https://github.com/jaseg/lolcat
  pushd lolcat
  set +e
  make lolcat
  set -e
  cp lolcat ~/.local/bin/
  popd
  rm -rf lolcat

  return 0
}

setup_config() {
  echo "Setting up configs..."

  set +o pipefail
  conflicts=$(stow -nv files 2>&1 | rg "existing target" | sed 's/.*existing target .*: //')
  set -o pipefail

  for file in $conflicts; do
    echo "Moved $file to ${file}.orig"
    mv "$file"{,.orig}
  done

  stow -Rv files

  nvim +PlugUpgrade \
    +PlugInstall \
    +PlugClean \
    +PlugUpdate \
    +UpdateRemotePlugins \
    +VimspectorUpdate \
    +qall

  return 0
}


bootstrap() {
  echo "Bootstrapping system..."

  PATH=~/bin:~/.local/bin:~/.cargo/bin:~/.npm-packages/bin:~/.fzf/bin:"$PATH"

  case "$(uname -s)" in
    Linux*)
      install_linux
      ;;
    Darwin*)
      install_macos
      ;;
    *)
      echo "Platform $(uname -s) is not supported"
      ;;
  esac

  install_terminal
  install_crates
  install_npm
  install_lolcat

  setup_config

  echo "Bootstrap Complete!"

  exec fish
}

bootstrap
