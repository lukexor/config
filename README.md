     _____   ________________
    |#####| /################\
    |#####|/##################\
    |#####||#####|      |#####|
    |#####||#####|      |#####|
    |#####||#####|      |#####|
    |#####||#################W
    |#####||################W
    |#####||#####|----------
    |#####||#####|
    |#####||#####|
    |#####||#####|_____
    \##################\
     \##################\
      -------------------

# Config

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

# Setup

The `setup.sh` is a bash script that installs the necessary dependencies based
on operating system to get nushell installed. From there, `install.nu` is
executed to finish installing the remaining packages I normally use on a daily
basis.

To get up and running on a new system:

```sh
# git clone https://github.com/lukexor/config.git
# ./setup.sh
```

Then follow any prompts for configuration.
