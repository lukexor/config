#!/usr/bin/env bash

[[ $- == *i* ]] || return

export BASH_SILENCE_DEPRECATION_WARNING=1
export CLICOLOR=1
export EDITOR="nvim"
export PAGER="nvim +Man!"
export OMARCHY_PATH=$HOME/.local/omarchy
export PATH="$HOME/.local/bin:$HOME/bin:$HOME/.cargo/bin:$HOME/.fzf/bin:$OMARCHY_PATH/bin:$PATH"
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

# Load acme-bisf CLI completions
test -r /home/luke/.bash_completion.d/bisf-cli.bash && . /home/luke/.bash_completion.d/bisf-cli.bash
alias k="kubectl"
alias ka="kubectl -n acme-bisf"
alias ks="kubectl -n kube-system"
alias k9sa="k9s -n acme-bisf"
alias less="less -R"
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -ia"
export RUST_LOG=off
export TERM=xterm
export KUBECONFIG="/etc/rancher/rke2/rke2.yaml"
export CONTAINERD_ADDRESS="/run/k3s/containerd/containerd.sock"
export CONTAINER_RUNTIME_ENDPOINT="/run/k3s/containerd/containerd.sock"

# Load acme-bisf CLI completions
test -r /home/luke/.bash_completion.d/bisf-cli.bash && . /home/luke/.bash_completion.d/bisf-cli.bash
alias k="kubectl" 
alias ka="kubectl -n acme-bisf" 
alias ks="kubectl -n kube-system" 
alias k9sa="k9s -n acme-bisf" 
alias less="less -R" 
alias rm="rm -i" 
alias mv="mv -i" 
alias cp="cp -ia" 
export RUST_LOG=off 
export TERM=xterm 
export KUBECONFIG="/etc/rancher/rke2/rke2.yaml" 
export CONTAINERD_ADDRESS="/run/k3s/containerd/containerd.sock" 
export CONTAINER_RUNTIME_ENDPOINT="/run/k3s/containerd/containerd.sock"
# Added by flyctl installer
export FLYCTL_INSTALL="/home/luke/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"
