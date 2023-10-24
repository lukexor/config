#!/usr/bin/env bash

DEFAULT_SHELL=nu
[ -n "$DEBUG" ] && set -x
set -euo pipefail

sudo=
[ "$EUID" -ne 0 ] && sudo=sudo

# Returns true of OS is Linux
linux() {
  [[ "$(uname -s)" == Linux* ]]
}

# Returns true of OS is macOS
macos() {
  [[ "$(uname -s)" == Darwin* ]]
}

# Symlink a folder, if it doesn't exist
symlink() {
  [ ! -f "$2" ] && ln -s "$1" "$2"
}

# Install terminal emulator application
install_terminal() {
  echo "Installing terminal..."

  mkdir -p ~/.local/bin
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n

  local executable=~/.local/kitty.app/bin/kitty
  local keybinds=~/.config/kitty/linux-keybinds.conf

  if macos; then
    executable=/Applications/kitty.app/Contents/MacOS/kitty
    keybinds=~/.config/kitty/macos-keybinds.conf
  fi

  [ ! -f ~/.local/bin ] && mkdir -p ~/.local/bin
  [ ! -f ~/.local/kitty ] && mkdir -p ~/.local/kitty
  symlink "$executable" ~/.local/bin/kitty
  symlink "$keybinds" ~/.local/kitty/keybinds.conf

  echo "Successfully installed terminal"

  return 0
}

# Install minimal core packages
install_core_packages() {
  echo "Installing core packages..."

  if linux; then
    LANG=${LANG:-C.UTF-8}

    $sudo apt update -y
    $sudo apt install -y \
      bat \
      diodon \
      direnv \
      docker \
      exa \
      fish \
      fzf \
      git \
      stow

    symlink /usr/bin/batcat ~/.local/bin/bat

    mkdir -p ~/.fonts
    cp ./assets/*.ttf ~/.fonts/
    fc-cache -f -v

    curl -LO -sSf --compressed https://github.com/neovim/neovim/releases/download/stable/nvim.appimage \
      && chmod u+x nvim.appimage \
      && mv -f nvim.appimage ~/.local/bin/nvim

  elif macos; then
    set +e
    xcode-select --install
    set -e

    if command -v brew &>/dev/null; then
      brew update
    else
      mkdir -p ~/.local/homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C ~/.local/homebrew
      symlink ~/.local/homebrew/bin/brew ~/.local/bin/brew
    fi

    brew install \
      bat \
      direnv \
      docker \
      exa \
      fish \
      fzf \
      git \
      llvm \
      neovim \
      stow

    open ./assets/*.ttf
  fi

  # https://github.com/jaseg/lolcat
  rm -rf lolcat
  git clone https://github.com/jaseg/lolcat
  pushd lolcat
  make lolcat
  cp lolcat ~/.local/bin/
  popd
  rm -rf lolcat

  echo "Successfully installed core packages"

  return 0
}


# Link dot configs
link_configs() {
  echo "Setting up configs..."

  set +o pipefail
  local conflicts=$(stow -nv files 2>&1 | rg "existing target" | sed 's/.*existing target .*: //')
  set -o pipefail

  for file in $conflicts; do
    mv ~/"$file"{,.orig}
    echo "Moved $file to ${file}.orig"
  done

  stow -Rv files

  echo "Successfully setup configs"

  return 0
}

# Setup neovim
setup_neovim() {
  echo "Setting up neovim..."

  nvim +VimspectorUpdate +qall

  echo "Successfully set up neovim"

  return 0
}

# Set default shell
set_shell() {
  echo "Setting default shell..."

  local shell=$(command which $DEFAULT_SHELL)
  $sudo grep -qxF "$shell" /etc/shells | wc -l || echo "$shell" | $sudo tee -a /etc/shells
  [ "$SHELL" == "$shell" ] || chsh -s "$shell"

  echo "Successfully set default shell"

  return 0
}

# Install crates
install_crates() {
  echo "Installing crates..."

  if command -v rustup &> /dev/null; then
    rustup update
  else
    curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  fi

  rustup component add \
    clippy \
    llvm-tools-preview
  rustup target add wasm32-unknown-unknown

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

  command rtx activate nu >| ~/.local/rtx.nu

  echo "Successfully installed crates"

  return 0
}

# Install global npm modules
install_npm() {
  echo "Installing npm..."

  command rtx install node@lts
  npm_dir=~/.npm-packages
  mkdir -p "$npm_dir"
  npm config set prefix "$npm_dir"

  npm install -g \
    lighthouse \
    neovim \
    yarn

  echo "Successfully installed npm..."

  return 0
}


# Install extra packages
install_extra_packages() {
  echo "Installing extra packages..."

  if linux; then
    # curl is not always installed on all systems
    # diodon is a GTK+ clipboard manager
    # gcc-multilib is used to cross-compile
    $sudo apt install -y \
      bash \
      cmake \
      gcc-multilib \
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
      tree \
      wget

    curl -LO -sSf --compressed https://static.snyk.io/cli/latest/snyk-linux \
      && chmod u+x snyk-linux \
      && mv -f snyk-linux ~/.local/bin/snyk
  elif macos; then
    brew install \
      bash \
      cmake \
      hexedit \
      hyperfine \
      openssl \
      pulseaudio \
      python \
      python3 \
      sqlite \
      tree \
      wget

    curl -LO -sSf --compressed https://static.snyk.io/cli/latest/snyk-macos \
      && chmod u+x snyk-macos \
      && mv -f snyk-macos ~/.local/bin/snyk
  fi

  echo "Successfully installed extra packages..."

  return 0
}

cleanup() {
  echo "Cleaning up"

  if linux; then
    $sudo apt autoremove -y
  fi

  echo "Successfully cleaned up"

}

bootstrap() {
  echo "Bootstrapping system..."

  PATH=~/bin:~/.local/bin:~/.cargo/bin:~/.npm-packages/bin:~/.fzf/bin:"$PATH"

  # install_terminal
  # install_core_packages
  link_configs
  set_shell
  setup_neovim
  install_crates
  install_npm
  install_extra_packages
  cleanup

  echo "Bootstrap Complete!"

  exec fish
}

bootstrap
