#!/usr/bin/env nu

let brew_packages = [
  azure-cli
  bash
  cc65
  cmake
  coreutils
  docker
  fzf
  git
  gnutls
  gradle
  helm
  hexedit
  kotlin
  ktlint
  kubernetes-cli
  llvm
  lolcat
  lua
  mongocli
  neovim
  node
  openjdk
  openjdk@11
  openssl
  postgresql
  prettier
  python
  python3
  sdl2
  sdl2_gfx
  sdl2_image
  sdl2_mixer
  sdl2_ttf
  sqlite
  starship
  stow
  tmux
  tree
  tree-sitter
  vim
  watchman
  wget
]
let npm_packages = [eslint_d]
let cargo_packages = [
  cargo-asm
  cargo-count
  cargo-expand
  cargo-flamegraph
  cargo-generate
  cargo-outdated
  cargo-readme
  cargo-tree
  cargo-watch
  flamegraph
  neovide
  ripgrep
  wasm-pack
]
let cargo_components = [clippy rust-analysis]

echo $brew_packages | each { brew install $it }

##-----##
## NPM ##
##-----##

echo $npm_packages | each { npm install -g $it }

##------##
## Rust ##
##------##

echo $cargo_packages | each { cargo install $it }
echo $cargo_components | each { rustup component add $it }

##-----##
## Vim ##
##-----##

vim +PlugUpgrade +PlugInstall +PlugClean +PlugUpdate +UpdateRemotePlugins +qall
python3 -m pip install --upgrade pip
python3 -m pip install --upgrade pi
pip3 install pynvim

##---------##
## Nushell ##
##---------##

^rm -f $nu.config-path
^rm -f $nu.keybinding-path
ln -s (build-string $nu.home-dir /.config/nu/config.toml) ($nu.config-path)
ln -s (build-string $nu.home-dir /.config/nu/keybindings.yml) ($nu.keybinding-path)
