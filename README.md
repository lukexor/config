# Config

```text
               i  t
              LE  ED.
             L#E  E#K:
            G#W.  E##W;
           D#K.   E#E##t
          E#K.    E#ti##f
        .E#E.     E#t ;##D.
       .K#E       E#ELLE##K:
      .K#D        E#L;;;;;;,
     .W#G         E#t
    :W##########WtE#t
    :,,,,,,,,,,,,,.
```

This is my system configuration for unix based machines, formerly known as
`dotfiles`.

The file tree is pretty straight forward:

```text
├──  .config
│  ├──  .gitignore
│  ├──  direnv
│  ├──  fish
│  ├──  kitty
│  ├──  nvim
│  └──  starship.toml
├──  .gitconfig
├──  .gitignore
├──  .hushlogin
├──  .luarc.json
├──  .markdownlint.json
├──  .protolint.yaml
├──  .rgignore
├──  .stylua.toml
├──  bin
├──  nixos
│  ├──  bootstrap.sh
│  └──  configuration.nix
└──  README.md
```

Most files/directories get symlinked into `$HOME`
using [home-manager](https://github.com/nix-community/home-manager).

## Setup

The `bootstrap.sh` script installs the necessary dependencies based
on operating system, symlinks each dotfile, and sets up the system.

`git`, `bash`, and `nix` must be installed.

To get up and running on a new system:

```sh
cd ~/
git clone https://github.com/lukexor/config
cd config/
./bootstrap.sh
```
