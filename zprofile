#============================================================================#
# .zprofile -- loaded if login shell        .zshenv .zprofile .zshrc .zlogin
#============================================================================#

# History
export HISTFILE=${HOME}/.zhist
export HISTSIZE=6000 # number of commands saved for current session
export SAVEHIST=5000 # number of commands saved to HISTFILE

# Misc
export EDITOR='vim'
export HOSTNAME=`uname -n`
export SHELL=`builtin which zsh`
export LSCOLORS="Gxfxcxdxbxegedabagacad"

# Grep
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'

## Pager
export PAGER=less
export LC_CTYPE=$LANG
