#!/usr/bin/env bash

set -euxo pipefail

sudo mv /etc/nixos/configuration.nix{,.orig}
sudo ln -s $HOME/config/nixos/configuration.nix /etc/nixos/configuration.nix
if [ ! -f $HOME/.local/configuration.nix ]; then
    echo '{}' > $HOME/.local/configuration.nix
fi
sudo nix-channel --add http://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
sudo nix-channel --update
sudo nixos-rebuild switch
