#!/usr/bin/env bash

[ -n "$DEBUG" ] && set -x
set -euo pipefail

sudo=
[ "$EUID" -ne 0 ] && sudo=sudo

install_terminal() {
  echo "Installing Terminal..."

  mkdir -p ~/.local/bin
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n

  return 0
}

install_linux() {
  echo "Installing Packages..."

  LANG=${LANG:-C.UTF-8}

  $sudo add-apt-repository -y ppa:neovim-ppa/stable
  $sudo add-apt-repository -y ppa:kisak/kisak-mesa
  $sudo apt update -y
  # curl is not always installed on all systems
  # diodon is a GTK+ clipboard manager
  # gcc-multilib is used to cross-compile
  $sudo apt install -y \
    bash \
    bat \
    cc65 \
    cmake \
    coreutils \
    curl \
    diodon \
    direnv \
    docker \
    exa \
    fish \
    fzf \
    gcc-multilib \
    git \
    gnutls-bin \
    hexedit \
    hyperfine \
    librust-alsa-sys-dev \
    libssl-dev \
    libx11-dev \
    libxcb-composite0-dev \
    llvm \
    openssl \
    pkg-config \
    postgresql \
    pylint \
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
  $sudo apt autoremove -y

  mkdir -p ~/.local/bin

  [ ! -f ~/.local/bin/kitty ] \
    && mkdir -p ~/.local/bin \
    && ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/kitty \
    && mkdir -p ~/.local/kitty \
    && ln -s ~/.config/kitty/linux-keybinds.conf ~/.local/kitty/keybinds.conf

  [ ! -f ~/.local/bin/bat ] \
    && ln -s /usr/bin/batcat ~/.local/bin/bat

  mkdir -p ~/.fonts
  cp ./assets/*.ttf ~/.fonts/
  fc-cache -f -v

  curl -LO --compressed https://github.com/neovim/neovim/releases/latest/download/nvim.appimage \
    && chmod u+x nvim.appimage \
    && mv nvim.appimage ~/.local/bin/nvim

  curl -LO --compressed https://static.snyk.io/cli/latest/snyk-linux \
    && chmod u+x snyk-linux \
    && mv snyk-linux ~/.local/bin/snyk

  return 0
}

install_macos() {
  echo "Installing Packages..."

  xcode-select --install
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
    direnv \
    docker \
    exa \
    fish \
    fzf \
    git \
    gnutls \
    hexedit \
    hyperfine \
    llvm \
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
    && ln -s /Applications/kitty.app/Contents/MacOS/kitty ~/.local/bin/kitty \
    && mkdir -p ~/.local/kitty \
    && ln -s ~/.config/kitty/macos-keybinds.conf ~/.local/kitty/keybinds.conf
  [ ! -f ~/Library/LaunchAgents/environment.plist ] \
    && ln -s ~/.config/environment.plist ~/Library/LaunchAgents/environment.plist

  open ./assets/*.ttf

  curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz \
    && tar xzf nvim-macos.tar.gz \
    && mv nvim-macos/bin/nvim ~/.local/bin/nvim \
    && rm -rf nvim-macos*

  curl -LO https://static.snyk.io/cli/latest/snyk-macos \
    && chmod u+x snyk-macos \
    && mv snyk-macos ~/.local/bin/snyk

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

  curl -L --proto '=https' --tlsv1.2 -sSf \
    https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh \
    | bash

  cargo binstall \
    --no-confirm --no-symlinks \
    cargo-asm \
    cargo-audit \
    cargo-bloat \
    cargo-deny \
    cargo-expand \
    cargo-generate \
    cargo-info \
    cargo-leptos \
    cargo-outdated \
    cargo-release \
    cargo-tarpaulin \
    cargo-tree \
    cargo-udeps \
    cargo-watch \
    du-dust \
    fd-find \
    flamegraph \
    irust \
    just \
    mprocs \
    ncspot \
    porsmo \
    procs \
    ripgrep \
    rtx-cli \
    runcc \
    sd \
    speedtest-rs \
    starship \
    tealdeer \
    tokei \
    wasm-pack \
    wiki-tui \
    xh

  ~/.cargo/bin/rtx install node@lts

  return 0
}

install_npm() {
  echo "Installing Npm..."

  npm_dir=~/.npm-packages
  mkdir -p "$npm_dir"
  npm config set prefix "$npm_dir"

  npm install -g \
    @fsouza/prettierd \
    eslint \
    eslint_d \
    lighthouse \
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
