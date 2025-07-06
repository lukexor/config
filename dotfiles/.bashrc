#!/usr/bin/env bash

[[ $- == *i* ]] || return

export BASH_SILENCE_DEPRECATION_WARNING=1
export CLICOLOR=1
export EDITOR="nvim"
export PAGER="nvim +Man!"
export PATH="$HOME/.local/bin:$HOME/bin:$HOME/.cargo/bin:$HOME/.fzf/bin:$PATH"
export LESS="-RFX"

RESET=$(tput sgr0)
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
PURPLE=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
RESET=$(tput sgr0)
export RESET
export BLACK
export RED
export GREEN
export YELLOW
export BLUE
export PURPLE
export CYAN
export WHITE
export RESET

export PS1="\[$CYAN\]\w \[$YELLOW\][\A] \[$GREEN\]❯\[$RESET\] "
export PROMPT_COMMAND=""

alias rm="rm -i"
alias cp="cp -ia"
alias mv="mv -i"
alias vim="nvim"
alias grep="rg"
alias ls="ls"
alias ll="ls -lh"
alias la="ls -alh"
alias vim="nvim"
alias vimdiff="nvim -d"
. "$HOME/.cargo/env"
