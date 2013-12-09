#============================================================================#
# .zshrc -- loaded if interactive shell  .zprofile .zshrc .zlogin
#============================================================================#

# Set custom colors
eval `dircolors ${HOME}/.dircolors-custom`
cd $HOME

##--------------------------------------------------------------------------##
# Options
##--------------------------------------------------------------------------##

setopt hist_reduce_blanks # consolidate whitespace
setopt hist_ignore_space # Ignore commands starting with space
setopt hist_ignore_dups # Ignore repeated duplicates
setopt hist_find_no_dups # Ignores dupes when history searching
setopt hist_no_store # Don't store the 'history' command
setopt share_history # Imports new history entries and appends
setopt extendedhistory # Save timestamp and runtime information

# Changing directories
setopt auto_cd # cd to directories without typing cd
setopt auto_name_dirs # Makes named directories
setopt auto_pushd # Make cd put old directories into stack
setopt cdable_vars # Allow cd to variable names
setopt chase_links # Resolve symbolic links to their true directory
setopt pushd_ignore_dups # Ignore multiple copies of the same directory on the stack

# Expansion and globbing
setopt no_case_glob # Case insensitive
setopt glob_dots # Do not require leading '.' to be matched
setopt extended_glob # Allows extended expansion
setopt prompt_subst # Allows variables in the PROMPT

# Enable command-line editing
autoload -U edit-command-line
zle -N edit-command-line

# Input/Output
unsetopt clobber # Prevent clobbering with > and >>. Use >! or >>! instead
setopt hash_cmds # Look up commands first in hash table instead of PATH
setopt check_jobs # Check for bg jobs before exiting shell
setopt notify # Report job status immediately

# Smart urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# Jobs
setopt long_list_jobs

# ls colors
autoload colors; colors;

# Enable ls colors
if [ "${DISABLE_LS_COLORS}" != "true" ]; then
  # Find the option for using colors in ls, depending on the version: Linux or BSD
  ls --color -d . &>/dev/null 2>&1 && alias ls='ls --color=tty' || alias ls='ls -G'
fi

# Misc
setopt no_beep # Disable terminal beep
setopt multios # Perform implicit tee and cat when doing multiple redirects
setopt prompt_subst # parameter, command subst, and aritmetic expansion in prompts

# Screen apperance
if [[ x${WINDOW} != x ]]; then
    SCREEN_NO="%B${WINDOW}%b "
else
    SCREEN_NO=""
fi

# Enable ssh agent forwarding
zstyle :omz:plugins:ssh-agent agent-forwarding on

#----------------------------------------------------------------------------#
# Source files
#----------------------------------------------------------------------------#

# Source function
sourcefile() { [ -r "${1}" ] && source ${1} }
path_check() { [ -d "${1}" ] && [[ ! ${PATH} =~ (^|:)${1}(:|$) ]] }
pathadd() { [ -d "$1" ] && [[ ! $PATH =~ (^|:)$1(:|$) ]] && PATH=$1:$PATH }

# Host specific settings/vars
sourcefile ${HOME}/.host/zshrc-${HOSTNAME}

# Autojump
if [ $commands[autojump] ]; then # check if autojump is installed
  if [ -r /usr/share/autojump/autojump.zsh ]; then # debian and ubuntu package
    sourcefile /usr/share/autojump/autojump.zsh
  elif [ -r /etc/profile.d/autojump.zsh ]; then # manual installation
    sourcefile /etc/profile.d/autojump.zsh
  elif [ -r "${HOME}/.autojump/etc/profile.d/autojump.zsh" ]; then # non-root installation
    sourcefile "${HOME}/.autojump/etc/profile.d/autojump.zsh"
  fi
fi

#----------------------------------------------------------------------------#
# Aliases
#----------------------------------------------------------------------------#

# Set color based on host
case "${HOSTNAME}" in
  edgenet ) MYCLR="$fg[cyan]" ;;
  ds3753 ) MYCLR="$fg[blue]" ;;
  tech ) MYCLR="$fg[yellow]" ;;
  tech2 ) MYCLR="$fg[green]" ;;
  tech-new.fonality.com ) MYCLR="$fg[white]" ;;
  web-dev2 ) MYCLR="$fg[red]" ;;
  * ) MYCLR="$bg[white]$fg[black]" ;;
esac

export MYCLR
export ZSH_PLUGINS=${HOME}/.plugins/
export ZSH_THEME=${HOME}/.themes/zhayedan.zsh

sourcefile ${HOME}/.aliases

# Plugins:  ${HOME}/.plugins
plugins+=(git github perl python django battery zsh-syntax-highlighting prompt-info svn)
# heroku rails3 ruby rake rvm

is_plugin() {
  local base_dir=$1
  local name=$2
  test -f $base_dir/$ZSH_PLUGINS/$name/$name.plugin.zsh \
    || test -f $base_dir/$ZSH_PLUGINS/$name/_$name
}

# Add all defined plugins to fpath. This must be done
# before running compinit.
for plugin ($plugins); do
    is_plugin $HOME $plugin && fpath=($ZSH_PLUGINS/$plugin $fpath)
done

# Load and run compinit
autoload -U compinit
compinit -i

# Load all of the plugins that were defined in ~/.zshrc
for plugin ($plugins); do
    local p="$ZSH_PLUGINS/$plugin/$plugin.plugin.zsh"
    [ -f $p ] && source $p
done

# Load the theme
[ ! "$ZSH_THEME" = ""  ] && [ -f $ZSH_THEME ] && source $ZSH_THEME

# Alert if no journal entries have been added in the last day
if [ -d $HOME/.journal ]; then
    local date=$(date "+%Y-%m-%d")
    local entries=$(journal -v $date | grep -Pc '^\[')
    if [ $entries -lt 8 ]; then
        local remaining=$(expr 8 - $entries)
        local entry='entries'
        if [[ $remaining == 1 ]]; then entry='entry'; fi
        echo ""
        echo -e "$fg[yellow]Don't forget to add at least $remaining more journal $entry this month!!$fg[reset]"
        echo ""
    fi
fi

#----------------------------------------------------------------------------#
# Key bindings
#----------------------------------------------------------------------------#

bindkey -e # emacs style bindings

# Delete/Kill related
bindkey '^[[3~' delete-char # del
bindkey '^[[2;3~' backward-kill-word # alt+insert
bindkey '^?' backward-delete-char # delete
bindkey "^[[3~" delete-char # delete on screen/xterm
bindkey "^[3;5~" delete-char # ctrl+delete on screen/xterm (Fn delete on Mac)
bindkey "\e[3~" delete-char # delete
bindkey '^[[3;3~' kill-word # alt+del
bindkey '\ew' kill-region # for screen

# Navigation
bindkey '^[[1;3C' forward-word # alt+right-arrow
bindkey "^[[1;5C" forward-word # ctrl+right-arrow
bindkey '^[[1;3D' backward-word # alt+left-arrow
bindkey "^[[1;5D" backward-word # ctrl+right-arrow
bindkey '^[[1;5A' beginning-of-line # ctrl+up
bindkey '^[[1~' beginning-of-line # home on screen
bindkey "^[[H" beginning-of-line # home
bindkey "^[OH" beginning-of-line # home on xterm
bindkey '^[[1;5B' end-of-line # ctrl+down
bindkey "^[[4~" end-of-line # end on screen
bindkey "^[[F"  end-of-line # end
bindkey "^[OF" end-of-line # end on xterm

# Misc
bindkey '^[[5;3~' clear-screen # alt+page-up
bindkey '^[[6;3~' undo # alt+page-down
bindkey '\C-x\C-e' edit-command-line
bindkey '^[[Z' reverse-menu-complete
bindkey -s '\el' "ls\n" # Alt-L = ls
bindkey -s '\e.' "..\n" # Alt-. = ..

# History
bindkey '^r' history-incremental-search-backward
bindkey "^[[5~" up-line-or-history
bindkey "^[[6~" down-line-or-history
bindkey ' ' magic-space    # also do history expansion on space

# make search up and down work, so partially type and hit up/down to find relevant stuff
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

##--------------------------------------------------------------------------##
# Completion
##--------------------------------------------------------------------------##

unsetopt menu_complete # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu # show completion menu on succesive tab press

setopt complete_in_word
setopt always_to_end

WORDCHARS=''

zmodload -i zsh/complist

## case-insensitive (all),partial-word and then substring completion
if [ "x$CASE_SENSITIVE" = "xtrue" ]; then
  zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  unset CASE_SENSITIVE
else
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
fi

zstyle ':completion:*' list-colors ''

# should this be in keybindings?
bindkey -M menuselect '^o' accept-and-infer-next-history

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
cdpath=(.)

# use /etc/hosts and known_hosts for hostname completion
[ -r /etc/ssh/ssh_known_hosts ] && _global_ssh_hosts=(${${${${(f)"$(</etc/ssh/ssh_known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r $HOME/.ssh/known_hosts ] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r /etc/hosts ] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
hosts=(
  "$_global_ssh_hosts[@]"
  "$_ssh_hosts[@]"
  "$_etc_hosts[@]"
  "$HOST"
  localhost
)
zstyle ':completion:*:hosts' hosts $hosts

# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $HOME/.zshcache/

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
        dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
        hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
        mailman mailnull mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
        operator pcap postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs

# ... unless we really want to.
zstyle '*' single-ignored show

if [ "x$COMPLETION_WAITING_DOTS" = "xtrue" ]; then
  expand-or-complete-with-dots() {
    echo -n "\e[31m......\e[0m"
    zle expand-or-complete
    zle redisplay
  }
  zle -N expand-or-complete-with-dots
  bindkey "^I" expand-or-complete-with-dots
fi

##--------------------------------------------------------------------------##
# Corrections
##--------------------------------------------------------------------------##

setopt correct_all

# Load nocorrect aliases
if [ -f ${HOME}/.zsh_nocorrect ]; then
    while read -r COMMAND; do
        alias ${COMMAND}="nocorrect ${COMMAND}"
    done < ~/.zsh_nocorrect
fi

##--------------------------------------------------------------------------##
# Cleanup functions
##--------------------------------------------------------------------------##

unset -f sourcefile
unset -f path_check
unset -f pathadd
unset -f is_plugin

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
