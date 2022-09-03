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

This is my system configuration for macOS and Linux machines, formerly known as
`dotfiles`.

The file tree is pretty straight forward:

```text
├── README.md
├── files
│   ├── .bash_profile
│   ├── .bashrc
│   ├── .config
│   │   ├── nu
│   │   │   ├── config.toml
│   │   │   ├── envs
│   │   │   ├── keybindings.yml
│   │   │   └── startup.nu
│   │   ├── nvim
│   │   │   ├── UltiSnips
│   │   │   ├── init.vim
│   │   │   ├── lua
│   │   │   ├── plugins
│   ├── .gitconfig
│   ├── .gitignore
│   ├── .tmux.conf
│   └── bin
├── gruvbox-dark.itermcolors
├── install.nu
└── setup.sh
```

Each file/directory in the `files` folder gets symlinked into the `$HOME`
directory using [stow](https://www.gnu.org/software/stow/).

## Setup

The `setup.sh` is a bash script that installs the necessary dependencies based
on operating system to get nushell installed. From there, `install.nu` is
executed to finish installing the remaining packages I normally use on a daily
basis.

`git` and `bash` must be installed and many of the features expect the latest
versions. The setup attempts to update your package manager, but depending on
the system, additional repositories may need to be added.

To get up and running on a new system:

```sh
cd ~/
git clone https://github.com/lukexor/config.git
cd config/
./setup.sh
```

Then follow any prompts for customizing the setup & installation.
