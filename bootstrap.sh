#!/usr/bin/env bash

set -euxo pipefail

install_linux() {
  echo "
  Installing Packages...
  "

  LANG=${LANG:-C.UTF-8}
  sudo=
  [ "$EUID" -ne 0 ] && sudo=sudo

  $sudo add-apt-repository -y ppa:neovim-ppa/stable
  $sudo apt update -y
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
    software-properties-common
    sqlite \
    stow \
    tidy \
    tree \
    watchman \
    wget \
    yamllint
  $sudo apt autoremove

  ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/kitty

  mkdir -p ~/.local/share/fonts
  cp ./assets/*.ttf ~/.local/share/fonts/
  fc-cache -f -v
}

install_macos() {
  echo "
  Installing Packages...
  "

  set +e
  xcode-select --install
  set -e
  open ./assets/*.ttf

  if command -v brew &>/dev/null; then
    brew update
  else
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

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

  ln -s /Applications/kitty.app/Contents/MacOS/kitty ~/.local/bin/kitty
  ln -s ~/.config/environment.plist ~/Library/LaunchAgents/environment.plist
}

install_terminal() {
  echo "
  Installing Terminal...
  "

  mkdir -p ~/.local/bin
  PATH=~/bin:~/.local/bin:~/.cargo/bin"$PATH"
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
}

install_crates() {
  echo "
  Installing Crates...
  "

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
    fd-find
    flamegraph \
    fnm \
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
}

install_npm() {
  echo "
  Installing Npm...
  "

  npm_dir=~/.npm-packages
  mkdir -p "$npm_dir"
  npm config set prefix "$npm_dir"

  npm install -g \
    @fsouza/prettierd \
    eslint_d \
    jsonlint \
    markdownlint \
    markdownlint-cli \
    stylelint \
    stylelint-config-standard \
    yarn

  yarn set version stable
}

install_python() {
  echo "
  Installing Python...
  "

  python3 -m pip install --upgrade --user \
    pip
  pip3 install --upgrade --user \
    pip \
    pynvim \
    pytest \
    pylint
}

install_lolcat() {
  echo "
  Installing lolcat...
  "

  # https://github.com/jaseg/lolcat
  rm -rf lolcat
  git clone https://github.com/jaseg/lolcat
  pushd lolcat
  make lolcat
  cp lolcat ~/.local/bin/
  popd
  rm -rf lolcat
}

setup_config() {
  echo "
  Setting up configs...
  "

  conflicts=$(stow -nv files 2>&1 \
    | rg "existing target" \
    | sed 's/.*existing target .*: //')
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
}


bootstrap() {
  echo "
  Bootstrapping system...
  "

  case "$(uname -s)" in
    Linux*)  install_linux;;
    Darwin*) install_macos;;
    *)       echo "Platform $(uname -s) is not supported"
  esac

  install_terminal
  install_crates
  install_npm
  install_python
  install_lolcat

  setup_config

  exec fish

  echo "
  Bootstrap Complete!
  "
}

bootstrap
