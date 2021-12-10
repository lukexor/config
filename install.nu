#!/usr/bin/env nu

echo "
Installing Packages...
"

let brew_packages = [
  azure-cli bash cc65 cmake coreutils docker fzf git gnutls gradle helm hexedit
  kotlin ktlint kubernetes-cli llvm mongocli neovim node openjdk
  openjdk@11 openssl postgresql prettier python python3 sdl2 sdl2_gfx sdl2_image
  sdl2_mixer sdl2_ttf sqlite stow tmux tree vim watchman
  wget
]
let apt_packages = [
  bash cc65 cmake coreutils docker fzf git hexedit llvm mongocli neovim
  nodejs npm openjdk-11-jdk openssl postgresql prettier pip python python3
  libsdl2-2.0-0 libsdl2-gfx-1.0-0 libsdl2-image-2.0-0 libsdl2-mixer-2.0-0
  libsdl2-ttf-2.0-0 sqlite stow tmux tree vim watchman wget
]
let npm_packages = [eslint_d]
let cargo_packages = [
  cargo-asm cargo-expand cargo-generate cargo-outdated cargo-readme cargo-tree
  cargo-watch flamegraph ripgrep wasm-pack
]
let cargo_components = [clippy rust-analysis]

if ((sys).host.name =~ Darwin) {
  echo $brew_packages | each { brew install $it }
} {
  if ((sys).host.name =~ Ubuntu) {
    echo $apt_packages | each { apt-get -y install $it }
  } {}
}
echo $npm_packages | each { npm install -g $it }
echo $cargo_packages | each { cargo install $it }
echo $cargo_components | each { rustup component add $it }

vim +PlugUpgrade +PlugInstall +PlugClean +PlugUpdate +UpdateRemotePlugins +qall
python3 -m pip install --upgrade --user pip
pip3 install --upgrade --user pip
pip3 install --upgrade --user pynvim

# macOS has a different config-path
let config = (build-string $nu.home-dir /.config/nu/config.toml)
if ($nu.config-path != $config) {
  ^rm -f $nu.config-path
  ^rm -f $nu.keybinding-path
  ln -s (build-string $nu.home-dir /.config/nu/config.toml) ($nu.config-path)
  ln -s (build-string $nu.home-dir /.config/nu/keybindings.yml) ($nu.keybinding-path)
} {}
nu

echo "
Installation Complete!
"
