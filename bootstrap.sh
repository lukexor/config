#!/usr/bin/env bash

set -euxo pipefail

run_as() {
    local owner
    owner=$(stat -c '%U' "$1")
    if [ "$owner" = "root" ]; then
        echo "sudo"
    fi
}

# Symlink a folder, if it doesn't exist
symlink() {
    local run_as
    run_as=$(run_as "$2")
    if [ -f "$2" ] && [ ! -L "$2" ]; then
        $run_as mv "$2" "$2.orig"
    fi
    [ ! -f "$2" ] && $run_as ln -s "$1" "$2"
}

bootstrap_nixos() {
    echo "Bootstrapping NixOS..."

    symlink "$HOME"/config/nixos/configuration.nix /etc/nixos/configuration.nix
     # TODO: prompt for optional hostname to link, falling back to lukex as the
     # default

    sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
    sudo nix-channel --add http://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
    sudo nix-channel --update

    sudo nixos-rebuild switch --upgrade
}

apply_preferences() {
  xdg-settings set default-web-browser chromium.desktop
  konsave -f -i kde-profile.knsv
  konsave -a kde-profile
}

# TODO: Add macOs/Linux support using home-manager
bootstrap_nixos

echo "Bootstrap Complete!"
