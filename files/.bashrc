export BASH_SILENCE_DEPRECATION_WARNING=1
export CLICOLOR=1
export EDITOR="nvim"
export PAGER="nvim +Man!"
export PATH="~/bin:~/.cargo/bin:~/.fzf/bin:$PATH"

export BLACK=$(tput setaf 0)
export RED=$(tput setaf 1)
export GREEN=$(tput setaf 2)
export YELLOW=$(tput setaf 3)
export BLUE=$(tput setaf 4)
export PURPLE=$(tput setaf 5)
export CYAN=$(tput setaf 6)
export WHITE=$(tput setaf 7)
export RESET=$(tput sgr0)

export PS1="\[$CYAN\]\w \[$YELLOW\][\A] \[$GREEN\]❯\[$RESET\] "

alias rm="rm -i"
alias cp="cp -ia"
alias mv="mv -i"
alias vim="nvim"
alias grep="rg"
alias ls="ls"
alias ll="ls -lh"
alias la="ls -alh"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
