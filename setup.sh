#!/bin/bash

#--------------#
# Install Rust #
#--------------#

if command -v rustup >/dev/null 2>&1; then
    rustup update
else
    curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path
fi

#-----------------#
# Install nushell #
#-----------------#

cargo install nu --features=extra,table-pager

#--------------#
# Install Stow #
#--------------#

##-------##
## Linux ##
##-------##

# TODO

##-------##
## macOS ##
##-------##

xcode-select --install

if command -v brew >/dev/null 2>&1; then
    brew update
else
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh
fi

brew install stow

#-----------------#
# Symlink Configs #
#-----------------#

stow files

#----------------------#
# Change default shell #
#----------------------#

BIN=$HOME/.cargo/bin/nu
if [[ $(grep $BIN /etc/shells|wc -l) -eq 0 ]]; then
    sudo echo $BIN >> /etc/shells
fi
chsh -s $BIN
nu install.nu
nu
