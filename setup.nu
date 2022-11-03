#!/usr/bin/env nu

echo "
Installing Packages...
"

let apt_packages = [
  bash cc65 cmake coreutils docker fzf git gnutls-bin hexedit llvm neovim
  node-latest-version npm openssl postgresql python2 python3 python3-pip
  shellcheck sqlite stow tidy tree watchman wget yamllint
]
let brew_packages = [
  bash cc65 cmake coreutils docker exercism fzf git gnutls hexedit llvm neovim
  node openssl postgresql prettier python python3 shellcheck sqlite stow
  tidy-html5 tree watchman wget yamllint
]
let npm_packages = [
  eslint_d @fsouza/prettierd markdownlint markdownlint-cli jsonlint stylelint
  stylelint-config-standard yarn
]
let cargo_packages = [
  bat cargo-asm cargo-bloat cargo-expand cargo-generate cargo-outdated
  cargo-tree cargo-watch exa flamegraph fnm hyperfine procs pueue starship
  ripgrep tealdeer tokei wasm-pack fd-find
]
let cargo_components = [clippy]

let os = (uname -s)
let is_linux = ($os | str starts-with Linux)
let is_macos = ($os | str starts-with Darwin)

if $is_linux {
  mkdir ~/.local/share/fonts
  cp ./assets/*.ttf ~/.local/share/fonts/
  fc-cache -f -v

  echo $apt_packages | each { |it| sudo apt install $it }
  sudo apt autoremove
} else if $is_macos {
  ^open ./assets/*.ttf

  echo $brew_packages | each { |it| brew install $it }
} else {
  echo $"Platform ($os) is not supported"
}

let npm_dir = ([$nu.home-path .npm-packages] | path join)
mkdir $npm_dir
npm config set prefix $npm_dir

echo $npm_packages | each { |it| npm install -g $it }
echo $cargo_packages | each { |it| ~/.cargo/bin/cargo install $it }
echo $cargo_components | each { |it| ~/.cargo/bin/rustup component add $it }

# Move conflict files out of the way
do { bash -c "stow -nv files 2>&1" } | complete | get stdout | lines | wrap line
  | where line =~ "existing target" | each { |in| echo $in.line
  | str replace ". existing target .*:" "" | str trim } | each { |file|
    let file = ([$env.HOME $file] | path join)
    echo $"Moved ($file) to ($file).orig"
    mv $file $"($file).orig"
  }

stow -Rv files

if $is_linux {
  systemctl --user daemon-reload
  systemctl --user enable pueued.service
  systemctl --user start pueued.service
} else if $is_macos {
  ln -s assets/pueued.plist ~/Library/LaunchDaemons/pueued.plist
  launchctl load ~/Library/LaunchDaemons/pueued.plist
} else {
  echo $"Platform ($os) is not supported"
}

nvim +PlugUpgrade +PlugInstall +PlugClean +PlugUpdate +UpdateRemotePlugins +VimspectorUpdate +qall
python3 -m pip install --upgrade --user pip
pip3 install --upgrade --user pip pynvim pytest pylint
yarn set version stable

^rm -f $nu.config-path
ln -s ([$nu.home-path .config/nu/config.nu] | path join) ($nu.config-path)
^rm -f $nu.env-path
ln -s ([$nu.home-path .config/nu/env.nu] | path join) ($nu.env-path)

if ($nu.os-info.name == "macos") {
  ln -s ([$nu.home-path .config/environment.plist]|path join) ~/Library/LaunchAgents/environment.plist
}

# https://github.com/jaseg/lolcat
rm -rf lolcat
git clone https://github.com/jaseg/lolcat
enter lolcat
make lolcat
cp lolcat ~/.local/bin/
rm -rf lolcat
exit

exec nu

echo "
Installation Complete!

Make sure to update your terminal font to use Roboto Mono Nerd Font!
"
