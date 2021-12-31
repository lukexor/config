export EDITOR="nvim"
export PAGER="nvim +Man!"

export PROMPT="%F{cyan}%~ %F{yellow}[%T] %F{green}❯%f "

path=("~/bin" "~/.cargo/bin" "~/.fzf/bin" $path)

alias rm="rm -i"
alias cp="cp -ia"
alias mv="mv -i"
alias vim="nvim"
alias grep="rg"
alias ls="ls --color=auto"
alias ll="ls -lh"
alias la="ls -alh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
