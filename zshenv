#============================================================================#
# .zshenv -- always loaded                  .zshenv .zprofile .zshrc .zlogin
#============================================================================#

# Checks if path is present and appends it to the front if not
pathadd() { [ -d "$1" ] && [[ ! $PATH =~ (^|:)$1(:|$) ]] && PATH=$1:$PATH }

# Add personal HOME bins
pathadd ${HOME}/bin/dotfiles/bin
pathadd ${HOME}/.rvm/bin
pathadd ${HOME}/opt/bin
pathadd ${HOME}/bin
pathadd ${HOME}/perl/share/perl/5.8.4
pathadd ${HOME}/perl/lib/perl/5.8.4

# Removes duplicates
typeset -U PATH
