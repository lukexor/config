#!/usr/bin/env bash

[ -n "$DEBUG" ] && set -x
set -euo pipefail

sudo=
[ "$EUID" -ne 0 ] && sudo=sudo

install_linux() {
  echo "Installing Packages..."

  LANG=${LANG:-C.UTF-8}

  $sudo curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
  $sudo add-apt-repository -y ppa:neovim-ppa/stable
  $sudo apt update -y
  $sudo apt remove nodejs libnode-dev libnode72
  $sudo apt install -y \
    bat \
    bash \
    cc65 \
    cmake \
    coreutils \
    curl \
    diodon \
    docker \
    exa \
    fish \
    fzf \
    gcc-multilib \
    git \
    gnutls-bin \
    hexedit \
    hyperfine \
    libfuse2 \
    librust-alsa-sys-dev \
    libssl-dev \
    libx11-dev \
    libxcb-composite0-dev \
    llvm \
    node-latest-version \
    nodejs \
    npm \
    openssl \
    pkg-config \
    postgresql \
    python2 \
    python3 \
    python3-pip \
    python3.10-venv \
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

  mkdir -p ~/.local/bin

  [ ! -f ~/.local/bin/kitty ] \
    && ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/kitty

  [ ! -f ~/.local/bin/bat ] \
    && ln -s /usr/bin/batcat ~/.local/bin/bat

  mkdir -p ~/.fonts
  cp ./assets/*.ttf ~/.fonts/
  fc-cache -f -v

  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
  chmod u+x nvim.appimage
  mv nvim.appimage ~/.local/bin/nvim

  return 0
}

install_macos() {
  echo "Installing Packages..."

  xcode-select --install
  open ./assets/*.ttf

  if command -v brew &>/dev/null; then
    brew update
  else
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  brew install \
    bash \
    bat \
    cc65 \
    cmake \
    coreutils \
    docker \
    exa \
    exercism \
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

  [ ! -f ~/.local/bin/kitty ] \
    && mkdir -p ~/.local/bin \
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
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n

  return 0
}

install_crates() {
  echo "Installing Crates..."

  if command -v rustup &> /dev/null; then
    rustup update
  else
    curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  fi

  rustup component add \
    clippy \
    llvm-tools-preview

  cargo install \
    cargo-asm \
    cargo-bloat \
    cargo-expand \
    cargo-generate \
    cargo-info \
    cargo-outdated \
    cargo-release \
    cargo-tree \
    cargo-udeps \
    cargo-watch \
    du-dust \
    fd-find \
    flamegraph \
    irust \
    mprocs \
    ncspot \
    porsmo \
    procs \
    ripgrep \
    rtx-cli \
    runcc \
    rtx-cli \
    sd \
    speedtest-rs \
    starship \
    tealdeer \
    tokei \
    wasm-pack \
    wiki-tui \
    xh

  return 0
}

install_npm() {
  echo "Installing Npm..."

  npm_dir=~/.npm-packages
  mkdir -p "$npm_dir"
  npm config set prefix "$npm_dir"

  npm install -g \
    @fsouza/prettierd \
    eslint_d \
    jsonlint \
    neovim \
    markdownlint \
    markdownlint-cli \
    stylelint \
    stylelint-config-standard \
    yarn

  return 0
}

install_lolcat() {
  echo "Installing lolcat..."

  # https://github.com/jaseg/lolcat
  rm -rf lolcat
  git clone https://github.com/jaseg/lolcat
  pushd lolcat
  make lolcat
  mkdir -p ~/.local/bin 
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
    mv ~/"$file"{,.orig}
    echo "Moved $file to ${file}.orig"
  done

  stow -Rv files

  nvim +VimspectorUpdate \
    +qall

  echo "Setting fish as default shell"
  shell=$(which fish)
  $sudo grep -qxF "$shell" /etc/shells | wc -l || echo "$shell" | $sudo tee -a /etc/shells
  [ "$SHELL" == "$shell" ] || chsh -s "$shell"

  return 0
}


bootstrap() {
  echo "Bootstrapping system..."

  PATH=~/bin:~/.local/bin:~/.cargo/bin:~/.npm-packages/bin:~/.fzf/bin:"$PATH"

  install_terminal

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

  install_crates
  install_npm
  install_lolcat

  setup_config

  echo "Bootstrap Complete!"

  exec fish
}

bootstrap
