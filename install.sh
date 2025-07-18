#!/usr/bin/env bash

set -euo pipefail
# Debugging
# set -x

DEFAULT_SHELL=fish
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

setup_git() {
  info "Setting up Github SSH key..."

  if [ ! -d "$HOME/config" ]; then
    ssh-keygen -t ed25519
    gpg --gen-key

    info "Copy the following into Github (https://github.com/settings/keys):"

    cat "$HOME/.ssh/id_ed25519.pub"

    gum input --prompt "Press enter when done > "

    eval "$(ssh-agent)"
    ssh-add

    cd "$HOME"

    git clone git@github.com:lukexor/config

    cd -
  fi
}

install_packages() {
  info "Installing packages..."

  LANG=${LANG:-C.UTF-8}

  # Clean up cruft
  yay -Rns --noconfirm 1password-beta 1password-cli xournalpp typora spotify rust hyprshot fastfetch mariadb-libs tldr || true

  if command -v rustup &>/dev/null; then
    rustup update
  else
    curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  fi
  yay -Syu --noconfirm --answerdiff None --answerclean None paru

  local packages
  packages=(
    cmake         # Required to build many -sys crates
    direnv        # Dynamically source .env files
    firefox       # Alternative browser
    fish          # Primary shell
    flameshot-git # Screenshot utility
    gimp          # Paint program
    grim          # Required for flameshot
    hyprcwd       # Get cwd of active window
    jq            # JSON parser
    lazysql       # SQL TUI
    pass          # For storing passwords
    quickemu-get  # for VMs - choose qemu-desktop or qemu-full
    rsync         # File syncing
    stow          # To symlink dotfiles
    tidy          # HTML formatter
    udiskie       # To automount drives using udisks2
    yazi          # File manager TUI
  )
  paru --noconfirm "${packages[@]}"

  local mode
  mode=$(gum choose home work --header="Install packages for:")

  local packages
  case "$mode" in
  home)
    packages=(
      discord
      libretro
      libretro-fbneo
      lutris
      minecraft-launcher
      retroarch
      retroarch-assets
      steam
    )
    ;;
  work)
    packages=(
      docker-buildx
      teams-for-linux
    )
    ;;
  esac

  info "Installing packages for $($mode)"

  paru --noconfirm "${packages[@]}"

  info "Installed packages successfully"
}

install_crates() {
  info "Installing crates..."

  curl -L -sSf \
    https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh |
    bash

  # TODO: Handle github rate-limiting
  local crates
  crates=(
    bat            # `cat` replacement
    bottom         # `top` replacement
    cargo-asm      # Print Rust assembly
    cargo-audit    # Audit Rust crates
    cargo-bloat    # Print package size by crate
    cargo-deny     # Check Rust crate security/licences
    cargo-expand   # Expand Rust macros
    cargo-leptos   # Build Leptos projects
    cargo-outdated # Check outdated crates
    cargo-tree     # List crate dependency hierachies
    cargo-udeps    # List unused dependencies
    dotacat        # `lolcat` replacement
    du-dust        # `du` replacement
    eza            # `ls` replacement
    fd-find        # `find` replacement
    flamegraph     # Performance profiling
    irust          # Rust repl
    just           # Command runner
    leptosfmt      # Leptos formater
    mprocs         # tmux-like multiple process runner
    nu             # Nushell
    procs          # `ps` replacement
    ripgrep        # `grep` replacement
    sd             # `sed` replacement
    starship       # Command prompt
    stylua         # `lua` style linter
    tealdeer       # TLDR help for commands
    tokei          # Language line counter
    typos-cli      # Typo checker
    wasm-pack      # Build wasm binaries
    xh             # `curl` replacement
  )
  cargo binstall --no-confirm --no-symlinks "${crates[@]}"

  tldr --update

  info "Successfully installed crates"
}

install_npm() {
  info "Installing npm..."

  mise use --global node@lts
  eval "$(mise activate bash)"

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
  local conflicts
  conflicts=$(stow -nv dotfiles 2>&1 | rg "existing target" | sed -E 's/.*existing target ([^ ]+) .*/\1/')
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

install_webapps() {
  # Add webapps
  web2app "Gmail" https://gmail.com/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/gmail.png
  web2app "Google Calendar" https://calendar.google.com/ https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/google-calendar.png
  web2app "Claude" https://claude.ai https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/claude-ai.png
  web2app "GitHub" https://github.com/lukexor https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/github.png

  web2app-remove X
  web2app-remove Basecamp
  web2app-remove WhatsApp
}

# Install with
# curl -sSf https://raw.githubusercontent.com/lukexor/config/refs/heads/main/install.sh | sh -s
install() {
  info "Installing configs..."

  PATH=~/.local/bin:~/bin:~/.cargo/bin:~/.npm-packages/bin:~/.fzf/bin:"$PATH"

  # Boostrapping
  # - Download archlinux ISO
  # - Flash to USB

  #   ```sh
  #   sudo dd if=<PATH_TO_ISO> of=/dev/sdX bs=4M status=progress oflag=sync
  #   ```

  # - Boot ISO
  # - Type `archinstall`
  #   Mirror Region: United States
  #   Disk Config: Default partition (ensure gpt/systemd boot)
  #   Disk -> File system: btrfs default structure, use compression
  #   Disk -> Encryption: LUKS
  #   Hostname
  #   Root Password
  #   User Account: Superuser
  #   Audio: pipewire
  #   Network Config: Copy ISO
  #   Addtl Packages: wget
  #   Timezone: PST
  # - Add extra hard drives:

  #   ```sh
  #   lsblk
  #   sudo parted /dev/sdX
  #     mklabel gpt
  #     mkpart primary ext4 0% 100%
  #     quit
  #   sudo mkfs.ext4 /dev/sdX1
  #   sudo blkid /dev/sdX1
  #   sudo nvim /etc/fstab
  #     UUID=XXX        /mnt/<FOLDER>        ext4        defaults,noatime 0 2
  #   sudo systemctl daemon-reload
  #   sudo mount -a
  #   ```

  info "Installing omarchy"
  wget -qO- https://omarchy.org/install | bash

  setup_git
  install_packages
  link_dotfiles
  install_crates
  install_npm
  install_terminal
  install_fonts
  install_neovim
  change_shell
  install_webapps

  # TODO
  # Apply config changes, e.g. mimetypes, custom themes

  # Manual
  # Set up ~/.gitconfig.local to set email/custom settings
  # Sign into Chrome to sync extensions (LastPass, Dark Reader, AdBlock)
  # Sign into LastPass/Google/Outlook/Claude/ChatGPT

  info "Bootstrap Complete!"

  exec "$shell"
}

install
