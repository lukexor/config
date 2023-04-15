#!/usr/bin/env bash

[ -n "$DEBUG" ] && set -x
set -euo pipefail

sudo=
[ "$EUID" -ne 0 ] && sudo=sudo

install_linux() {
  echo "Installing Packages..."

  LANG=${LANG:-C.UTF-8}

  $sudo add-apt-repository -y ppa:neovim-ppa/stable
  $sudo apt update -y
  set +e
  $sudo apt install -y \
    bat \
    bash \
    cc65 \
    cmake \
    cargo-outdated \
    cargo-udeps \
    cargo-watch \
    coreutils \
    curl \
    docker \
    exa \
    fd \
    fish \
    fzf \
    gcc-multilib \
    git \
    gnutls-bin \
    hexedit \
    hyperfine \
    libssl-dev \
    libx11-dev \
    libxcb-composite0-dev \
    llvm \
    ncspot \
    node-latest-version \
    npm \
    openssl \
    pkg-config \
    postgresql \
    procs \
    python2 \
    python3 \
    python3-pip
    shellcheck \
    software-properties-common \
    sqlite \
    starship \
    stow \
    tealdeer \
    tidy \
    tokei \
    tree \
    watchman \
    wasm-pack \
    wget \
    yamllint
  $sudo apt autoremove
  set -e

  [ ! -f ~/.local/bin/kitty ] \
    && ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/kitty

  mkdir -p ~/.local/share/fonts
  cp ./assets/*.ttf ~/.local/share/fonts/
  fc-cache -f -v

  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
  chmod u+x nvim.appimage
  mv nvim.appimage ~/.local/bin/nvim

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
    bat \
    cargo-outdated \
    cargo-udeps \
    cargo-watch \
    cc65 \
    cmake \
    coreutils \
    docker \
    exa \
    exercism \
    fd \
    fish \
    fzf \
    git \
    gnutls \
    hexedit \
    hyperfine \
    llvm \
    ncspot \
    node \
    openssl \
    postgresql \
    prettier \
    procs \
    pylint \
    python \
    python3 \
    shellcheck \
    sqlite \
    starship \
    stow \
    tealdeer \
    tidy-html5 \
    tokei \
    tree \
    watchman \
    wasm-pack \
    wget \
    yamllint
  set -e

  [ ! -f ~/.local/bin/kitty ] \
    && ln -s /Applications/kitty.app/Contents/MacOS/kitty ~/.local/bin/kitty
  [ ! -f ~/Library/LaunchAgents/environment.plist ] \
    && ln -s ~/.config/environment.plist ~/Library/LaunchAgents/environment.plist

  curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz
  tar xzf nvim-macos.tar.gz
  mv nvim-macos/bin/nvim ~/.local/bin/nvim
  rm -rf nvim-macos*

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
    cargo-asm \
    cargo-bloat \
    cargo-expand \
    cargo-generate \
    cargo-info \
    cargo-tree \
    du-dust \
    flamegraph \
    irust \
    mprocs \
    porsmo \
    ripgrep \
    sccache \
    speedtest-rs \
    wiki-tui \
    runcc \
    rtx-cli

  cargo install nu --features=extra
  nushell=$HOME/.cargo/bin/nu
  sudo grep -qxF "$nushell" /etc/shells | wc -l || echo "$nushell" | sudo tee -a /etc/shells
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

  nvim +VimspectorUpdate \
    +qall


  shell=$(which fish)
  $sudo grep -qxF "$shell" /etc/shells | wc -l || echo "$shell" | $sudo tee -a /etc/shells
  [ "$SHELL" == "$shell" ] || chsh -s "$shell"

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
