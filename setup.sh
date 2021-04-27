#!/bin/sh

DOTFILES=(
  'bash_profile'
  'bashrc'
  'ctags'
  'editrc'
  'gitconfig'
  'gitignore'
  'ignore'
  'inputrc'
  'prettierrc'
  'tmux.conf'
  'vim'
  'vimrc'
)

LINKS=(bin)

BREW=(
  'azure-cli'
  'bash'
  'cmake'
  'coreutils'
  'cc65'
  'cmake'
  'ctags'
  'dos2unix'
  'git'
  'gnutls'
  'grip' # Github README preview
  'helm'
  'hexedit'
  'kotlin'
  'mysql'
  'neovim'
  'node'
  'nvm'
  'openjdk'
  'openssl'
  'prettier'
  'postgresql'
  'python'
  'python3'
  'readline'
  'ripgrep'
  'sdl2'
  'sdl2_gfx'
  'sdl2_image'
  'sdl2_mixer'
  'sdl2_ttf'
  'sqlite'
  'tmux'
  'tree'
  'vim'
  'watchman'
  'webpack'
  'wget'
  'yarn'
)

CARGO=(
  'ripgrep'
  'cargo-add'
  'cargo-asm'
  'cargo-expand'
  'cargo-count'
  'cargo-fmt'
  'cargo-generate'
  'cargo-outdated'
  'cargo-readme'
  'cargo-tree'
  'cargo-watch'
  'wasm-pack'
)

RUST_COMP=(
  'clippy-preview'
  'rls-preview'
  'rust-analysis'
  'rust-src'
)

COMMANDS=(
  'mkdir -p ~/.nvm'
  'nvim +PlugUpgrade +PlugInstall +PlugClean +PlugUpdate +UpdateRemotePlugins +qall'
  'curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path'
)

printHelp() {
  echo "Usage: [-h] [-v] [sync|install]"
  echo "    setup.sh -h                      Display this help message."
  echo "    setup.sh -v                      Enable verbose logging"
  echo "    setup.sh                         Execute full setup"
  echo "    setup.sh sync                    Sync config files"
  echo "    setup.sh install                 Install packages"
  exit 0
}

VERBOSE=0
DRYRUN=1

run() {
  if [[ $VERBOSE -gt 0 ]]; then
    echo $1
  fi
  if [[ $DRYRUN -eq 0 ]]; then
    $1
  fi
  if [[ $? -ne 0 ]]; then
    echo "Encountered error: $?"
    exit $?
  fi
}

syncFiles() {
  echo "Symlinking config files"
  for file in ${DOTFILES[@]}; do
    run "ln -s $HOME/.config/$file $HOME/.$file"
  done
  for file in ${LINKS[@]}; do
    run "ln -s $HOME/.config/$file $HOME/$file"
  done
}

installPackages() {
  case "$OSTYPE" in
    "darwin"* )
      echo "Detected macOS. Installing xcode..."
      run "xcode-select --install"
      if [[ ! $(which brewd 2> /dev/null) ]]; then
        run "curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh"
      fi
      run "brew update"

      for package in ${BREW[@]}; do
        run "brew install $package"
      done
      ;;
    * )
      echo "Unknown operating system"
      ;;
  esac
}

while getopts ":hv" opt; do
  case "${opt}" in
    v )
      VERBOSE=1
      shift
      ;;
    h|\? )
      printHelp
      ;;
  esac
done

command=$1; shift
case "$command" in
  sync )
    syncFiles
    ;;
  install )
    installPackages
    ;;
  * )
    syncFiles
    installPackages
    ;;
esac
