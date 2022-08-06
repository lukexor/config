#!/usr/bin/env nu

echo "
Installing Packages...
"

let brew_packages = [
  azure-cli bash cc65 cmake coreutils docker fzf git gnutls gradle helm hexedit
  kotlin ktlint kubernetes-cli llvm mongocli neovim node openjdk
  openjdk@11 openssl postgresql prettier python python3 sdl2 sdl2_gfx sdl2_image
  sdl2_mixer sdl2_ttf shellcheck sqlite stow tidy-html5 tmux tree vim watchman
  wget yamllint
]
let apt_packages = [
  bash cc65 cmake coreutils docker fzf git hexedit llvm mongocli neovim
  nodejs npm openjdk-11-jdk openssl postgresql prettier pip python python3
  libsdl2-2.0-0 libsdl2-gfx-1.0-0 libsdl2-image-2.0-0 libsdl2-mixer-2.0-0
  libsdl2-ttf-2.0-0 sqlite stow tmux tree vim watchman wget
]
let npm_packages = [
  eslint_d @fsouza/prettierd markdownlint markdownlint-cli jsonlint stylelint
  stylelint-config-standard
]
let cargo_packages = [
  cargo-asm cargo-count cargo-expand cargo-generate cargo-outdated cargo-readme
  cargo-tree cargo-watch flamegraph ripgrep wasm-pack fnm procs tokei fd exa bat
  tealdeer
]
let cargo_components = [clippy rust-analysis]
let language_servers = [
  bashls cssls diagnosticls eslint html jsonls kotlin_language_server
  rust_analyzer sumneko_lua tsserver vimls yamlls
]

if ((sys).host.name =~ Darwin) {
  ^open ./roboto_mono_nerd_font.ttf
  echo $brew_packages | each { brew install $it }
} {
  if ((sys).host.name =~ Ubuntu) {
    xdg-open ./roboto_mono_nerd_font.ttf
    echo $apt_packages | each { apt-get -y install $it }
  } {}
}
echo $npm_packages | each { npm install -g $it }
echo $cargo_packages | each { cargo install $it }
echo $cargo_components | each { rustup component add $it }

vim +PlugUpgrade +PlugInstall +PlugClean +PlugUpdate +UpdateRemotePlugins +VimspectorUpdate +qall
vim -c (build-string "LspInstall --sync " ($language_servers | str collect " ")) +qall
python3 -m pip install --upgrade --user pip
pip3 install --upgrade --user pip
pip3 install --upgrade --user pynvim

# macOS has different paths
if ((sys).host.name =~ Darwin) {
  ^rm -f $nu.config-path
  ln -s ([$nu.home-path .config/nu/config.nu] | path join) ($nu.config-path)
  ^rm -f $nu.env-path
  ln -s ([$nu.home-path .config/nu/env.nu] | path join) ($nu.env-path)
}
exec nu

echo "
Installation Complete!

Make sure to update your terminal font to use Roboto Mono Nerd Font!
"
