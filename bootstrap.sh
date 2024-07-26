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

    sudo nix-channel --add http://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
    sudo nix-channel --update

    sudo nixos-rebuild switch
}

set_preferences() {
  xdg-settings set default-web-browser chromium.desktop
  plasma-apply-desktoptheme breeze-dark
  plasma-apply-wallpaperimage "$HOME"/config/wallpapers/nier-automata.png
  kwriteconfig5 --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image "file:///$HOME/config/wallpapers/bladerunner.jpeg"
}

# TODO: Add macOs/Linux support using home-manager
bootstrap_nixos
set_preferences

echo "Bootstrap Complete!"
