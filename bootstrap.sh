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
    python2 \
    python3 \
    python3-pip \
    python3.10-venv \
    software-properties-common \
    sqlite \
    stow \
    tree \
    watchman \
    wget
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

  curl -LO -sSf --compressed https://github.com/neovim/neovim/releases/download/stable/nvim.appimage \
    && chmod u+x nvim.appimage \
    && mv -f nvim.appimage ~/.local/bin/nvim

  curl -LO -sSf --compressed https://static.snyk.io/cli/latest/snyk-linux \
    && chmod u+x snyk-linux \
    && mv -f snyk-linux ~/.local/bin/snyk

  return 0
}

install_macos() {
  echo "Installing Packages..."

  set +e
  xcode-select --install
  set -e
  if command -v brew &>/dev/null; then
    brew update
  else
    mkdir ~/.local/homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C ~/.local/homebrew
    ln -s ~/.local/homebrew/bin/brew ~/.local/bin/brew
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
    neovim \
    openssl \
    pulseaudio \
    python \
    python3 \
    sqlite \
    stow \
    tree \
    watchman \
    wget

  [ ! -f ~/.local/bin/kitty ] \
    && mkdir -p ~/.local/bin \
    && ln -s /Applications/kitty.app/Contents/MacOS/kitty ~/.local/bin/kitty \
    && mkdir -p ~/.local/kitty \
    && ln -s ~/.config/kitty/macos-keybinds.conf ~/.local/kitty/keybinds.conf

  open ./assets/*.ttf

  curl -LO -sSf --compressed https://static.snyk.io/cli/latest/snyk-macos \
    && chmod u+x snyk-macos \
    && mv -f snyk-macos ~/.local/bin/snyk

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

  curl -L \
    https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh \
    | bash

  # TODO: Handle github rate-limiting
  cargo binstall \
    --no-confirm --no-symlinks \
    bottom \
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

  return 0
}

install_npm() {
  echo "Installing Npm..."

  rtx install node@lts
  npm_dir=~/.npm-packages
  mkdir -p "$npm_dir"
  npm config set prefix "$npm_dir"

  npm install -g \
    lighthouse \
    neovim \
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

  # TODO: Set up kity/fish/lolcat first, then install packages
  setup_config
  install_crates
  install_npm
  install_lolcat

  echo "Bootstrap Complete!"

  exec fish
}

bootstrap
