#!/usr/bin/env bash

set -euxo pipefail

DEFAULT_SHELL=fish
OS="$(uname -s)"
sudo=
[ "$EUID" -ne 0 ] && sudo=sudo

symlink() {
  local src
  src="$1"
  local dst
  dst="$2"
  [ -f "$dst" ] || ln -s "$src" "$dst"
}

info() {
  local msg
  msg="$1"
  echo "$msg"
}

install_packages() {
  info "Installing packages..."

  LANG=${LANG:-C.UTF-8}

  $sudo apt update -y
  # TODO: document why packages are needed
  local packages
  packages=(
    bash            # Alternate shell
    cmake           # Required to build many -sys crates
    direnv          # Dynamically source .env files
    fish            # Primary shell
    fzf             # Fuzzy file finder
    libssl-dev      # Required by many Rust crates
    libasound2      # Required by TetaNES
    libudev-dev     # Required by TetaNES
    openssl         # Required by many Rust crates
    pkg-config      # Required to build/link many -sys crates
    python3         # Python, for scripts and Neovim
    python3-pip     # For Python packages
    python3.10-venv # Required by some Neovim plugins
    stow            # To symlink dotfiles
  )
  $sudo apt install -y "${packages[@]}"

  info "Installed packages successfully"
}

install_crates() {
  info "Installing crates..."

  if command -v rustup &> /dev/null; then
    rustup update
  else
    curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  fi

  curl -L -sSf \
    https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh \
    | bash

  # TODO: Handle github rate-limiting
  local crates
  crates=(
    bat             # `cat` replacement
    bottom          # `top` replacement
    cargo-asm       # Print Rust assembly
    cargo-audit     # Audit Rust crates
    cargo-bloat     # Print package size by crate
    cargo-deny      # Check Rust crate security/licences
    cargo-expand    # Expand Rust macros
    cargo-leptos    # Build Leptos projects
    cargo-outdated  # Check outdated crates
    cargo-tree      # List crate dependency hierachies
    cargo-udeps     # List unused dependencies
    du-dust         # `du` replacement
    dotacat         # `lolcat` replacement
    eza             # `ls` replacement
    fd-find         # `find` replacement
    flamegraph      # Performance profiling
    irust           # Rust repl
    just            # Command runner
    mprocs          # tmux-like multiple process runner
    ncspot          # Spotify TUI
    nu              # Nushell
    procs           # `ps` replacement
    ripgrep         # `grep` replacement
    rtx-cli         # `nvm` replacement for npm/node installation
    sd              # `sed` replacement
    starship        # Command prompt
    stylua          # `lua` style linter
    tealdeer        # TLDR help for commands
    tokei           # Language line counter
    wasm-pack       # Build wasm binaries
    xh              # `curl` replacement
  )
  cargo binstall --no-confirm --no-symlinks "${crates[@]}"

  command rtx activate nu >| ~/.local/rtx.nu

  info "Successfully installed crates"
}

install_npm() {
  info "Installing npm..."

  command rtx install node@lts
  PATH="$PATH:$HOME/.local/share/rtx/installs/node/lts/bin"

  local npm_dir
  npm_dir=~/.npm-packages
  mkdir -p "$npm_dir"
  npm config set prefix "$npm_dir"

  npm install -g \
    @fsouza/prettierd \
    eslint \
    eslint_d \
    jsonlint \
    neovim \
    markdownlint \
    markdownlint-cli \
    stylelint \
    stylelint-config-standard \
    yarn

  info "Successfully installed npm..."
}

install_terminal() {
  info "Installing terminal..."

  mkdir -p ~/.local/bin
  curl -L -sSf https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n

  local executable
  local keybinds
  executable=~/.local/kitty.app/bin/kitty
  keybinds=~/.config/kitty/linux-keybinds.conf

  mkdir -p ~/.local/bin
  symlink "$executable" ~/.local/bin/kitty

  mkdir -p ~/.local/kitty
  symlink "$keybinds" ~/.local/kitty/keybinds.conf

  mkdir -p ~/.local/share/applications
  symlink ~/.config/kitty/kitty.desktop ~/.local/share/applications/kitty.desktop

  info "Installed terminal successfully"
}

install_fonts() {
  info "Installing fonts..."

  mkdir -p ~/.fonts
  cp ./assets/*.ttf ~/.fonts/
  fc-cache -f -v

  info "Installed fonts successfully"
}

link_dotfiles() {
  info "Linking dotfiles..."

  set +o pipefail
  local conflicts=$(stow -nv dotfiles 2>&1 | rg "existing target" | sed 's/.*existing target .*: //')
  set -o pipefail

  for file in $conflicts; do
    mv ~/"$file"{,.orig}
    echo "Moved $file to ${file}.orig"
  done

  stow -Rv dotfiles

  info "Successfully linked dotfiles"
}

install_neovim() {
  info "Installing Neovim..."

  curl -LO -sSf --compressed https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.appimage
  chmod u+x nvim-linux-x86_64.appimage
  mkdir -p ~/.local/bin
  mv -f nvim-linux-x86_64.appimage ~/.local/bin/nvim

  nvim +VimspectorUpdate +qall

  info "Installed Neovim successfully"
}

change_shell() {
  info "Changing default shell..."

  local shell
  shell=$(command which $DEFAULT_SHELL)
  $sudo grep -qxF "$shell" /etc/shells | wc -l || echo "$shell" | $sudo tee -a /etc/shells
  [ "$SHELL" == "$shell" ] || chsh -s "$shell"

  info "Successfully set default shell"
}

apply_preferences() {
  xdg-settings set default-web-browser google-chrome.desktop
}

cleanup() {
  info "Cleaning up"

  $sudo apt autoremove -y

  info "Successfully cleaned up"
}

bootstrap() {
  info "Bootstrapping system..."

  PATH=~/.local/bin:~/bin:~/.cargo/bin:~/.npm-packages/bin:~/.fzf/bin:"$PATH"

  # TODO: Add installer script to config repo:
  # curl -sSf https://github.com/lukexor/config/bootstrap.sh | sh -s
  # - ssh-keygen -t ed25519
  # - Enter password
  # - Add ssh key to GitHub
  # - cd ~ && git clone git@github.com:lukexor/config
  link_dotfiles
  install_packages
  install_crates
  install_npm
  install_terminal
  install_fonts
  # TODO: dwm/slock/
  # install_window_manager
  install_neovim
  change_shell
  apply_preferences
  cleanup

# Sign into Chrome to sync extensions
# TODO: Remove default keyboard shortcuts:
# - Super+Return
# - Super+T
# - Super+N
# - Super+D
# - Super+H
# - Super+J
# - Super+K
# - Super+L
# - Ctrl+Super+H
# Reboot

  info "Bootstrap Complete!"

  exec fish
}

bootstrap
