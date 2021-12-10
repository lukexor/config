export BASH_SILENCE_DEPRECATION_WARNING=1
export CLICOLOR=1
export EDITOR="nvim"
export PAGER="nvim +Man!"
export PATH="~/bin:~/.cargo/bin:~/.fzf/bin:$PATH"

alias rm="rm -i"
alias cp="cp -ia"
alias mv="mv -i"
alias vim="nvim"
alias grep="rg"
alias ls="ls --color=auto"
alias ll="ls -lh"
alias la="ls -alh"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
