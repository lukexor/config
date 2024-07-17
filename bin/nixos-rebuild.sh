#!/usr/bin/env bash

# A rebuild script that commits on a successful build
#
# To execute:
#
# ```
# nixos-rebuild
# ```

set -euo pipefail

$EDITOR ~/config/nix/"${HOSTNAME}".nix

pushd ~/config/

if git diff --quiet '*.nix'; then
    echo "No changes detected, exiting."
    popd
    exit 0
fi

git diff -U0 '*.nix'

echo "NixOS Rebuilding..."

sudo nixos-rebuild switch | tee nixos-switch.log || (grep --color error nixos-switch.log && exit 1)

current=$(nixos-rebuild list-generations | grep current)

git commit -am "nixos $current"

popd

notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
