# == Start Profiling {{{1
# ==================================================================================================


startn=$(date +%s.%N)
starts=$(date +%s)



# == Functions {{{1
# ==================================================================================================

sourcefile() { [[ -r "$1" ]] && source $1; }

# Functions to help us manage paths.
# Arguments: $path, $ENV_VAR (default: $PATH)
pathremove () {
  local IFS=':'
  local NEWPATH
  local DIR
  local PATHVARIABLE=${2:-PATH}
  for DIR in ${!PATHVARIABLE} ; do
    if [ "$DIR" != "$1" ] ; then
      NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
    fi
  done
  export $PATHVARIABLE="$NEWPATH"
}
pathprepend () {
  pathremove $1 $2
  if [[ -d $1 ]] ; then
    local PATHVARIABLE=${2:-PATH}
    export $PATHVARIABLE="$1${!PATHVARIABLE:+:${!PATHVARIABLE}}"
  fi
}
pathappend () {
  pathremove $1 $2
  if [[ -d $1 ]] ; then
    local PATHVARIABLE=${2:-PATH}
    export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
  fi
}



# == Global Bashrc {{{1
# ==================================================================================================

sourcefile '/etc/bashrc'



# == Environment {{{1
# ==================================================================================================

# History
HISTCONTROL="erasedups"  # Erase duplicates in history before saving current command
HISTIGNORE='h:history:&:[bf]g:exit'
HISTFILESIZE=100000 # Number of lines saved in HISTFILE
HISTSIZE=10000 # Number of commands saved in command history
HISTTIMEFORMAT='[%F %a %T] ' # YYYY-MM-DD DAY HH:MM:SS

export FON_DIR="$HOME/fcs"
export FCS_DEVEL=1
export NO_MYSQL_AUTOCONNECT=1
export FCS_APP_URL='http://dev-app.lotsofclouds.fonality.com/'
export FCS_CP_URL='http://dev-cp.lotsofclouds.fonality.com/'

if [[ -d "$HOME/dev/tools/android-sdk-macosx/" ]]; then
  export ANDROID_HOME="$HOME/dev/tools/android-sdk-macosx/"
  pathappend "${ANDROID_HOME}/tools"
  pathappend "${ANDROID_HOME}/platform-tools"
fi

export WORKON_HOME="$HOME/.virtualenvs"

pathprepend "$HOME/.rvm/bin"
pathprepend "$HOME/fcs/bin"
pathprepend "$HOME/bin"
pathprepend "/usr/local/opt/coreutils/libexec/gnubin"

pathprepend "$HOME/perl5/lib/perl5/" PERL5LIB
pathprepend "$HOME/perl5/lib" PERL5LIB
pathprepend "$HOME/fcs/lib" PERL5LIB
pathprepend "$HOME/lib" PERL5LIB

pathappend "$HOME/perl5/lib/perl5/" GITPERLLIB
pathappend "$HOME/perl5/perlbrew/perls/perl-5.16.0/lib/site_perl/5.16.0/App/gh" GITPERLLIB

pathprepend "/usr/local/opt/coreutils/libexec/gnuman" MANPATH

# VI style line editing
EDITOR="vim"
# set -o vi

# Exit if not interactive
case "$-" in
  *i* )
    ;;
  * )
    return
    ;;
esac



# == Source {{{1
# ==================================================================================================

[ $SHLVL -eq 1 ] && eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"
sourcefile "$HOME/perl5/perlbrew/etc/bashrc"
# sourcefile "$HOME/.rvm/scripts/rvm"
# sourcefile '/usr/local/bin/virtualenvwrapper.sh'



# == Colors {{{1
# ==================================================================================================

function setfg() { tput sgr0; tput setaf $1; }
function setbfg() { tput sgr0; tput bold; tput setaf $1; }
function setbg() { tput sgr0; tput setab $1; }

FGblack=$(setfg 0)
FGred=$(setfg 1)
FGgreen=$(setfg 2)
FGyellow=$(setfg 3)
FGblue=$(setfg 4)
FGmagenta=$(setfg 5)
FGcyan=$(setfg 6)
FGwhite=$(setfg 7)

# Bold Foreground
FGgray=$(setbfg 0)
FGbred=$(setbfg 1)
FGbgreen=$(setbfg 2)
FGbyellow=$(setbfg 3)
FGbblue=$(setbfg 4)
FGbmagenta=$(setbfg 5)
FGbcyan=$(setbfg 6)
FGbwhite=$(setbfg 7)

# Background
BGblack=$(setbg 0)
BGred=$(setbg 1)
BGgreen=$(setbg 2)
BGyellow=$(setbg 3)
BGblue=$(setbg 4)
BGmagenta=$(setbg 5)
BGcyan=$(setbg 6)
BGwhite=$(setbg 7)
RCLR=$(tput sgr0)

GRY='\[\033[1;33m\]'
WHI='\[\033[0;37m\]'
BLU='\[\033[0;34m\]'
YEL='\[\033[0;33m\]'
MAG='\[\033[0;35m\]'
GRE='\[\033[0;32m\]'
CYA='\[\033[0;36m\]'
RED='\[\033[0;31m\]'
BRED='\[\033[0;41m\]'
NC='\[\033[0m\]'



# == Shell Options {{{1
# ==================================================================================================

# [ -f /usr/local/etc/bash_completion  ] && . /usr/local/etc/bash_completion

# Bash 4.00 specific options
if [[ $BASH_VERSINFO > 3 ]]; then
  shopt -s autocd # Allow cding to directories by typing the directory name
  shopt -s checkjobs # Defer exiting shell if any stopped or running jobs
  shopt -s dirspell # Attempts spell correction on directory names
fi

shopt -s cdable_vars # Allow passing directory vars to cd
shopt -s cdspell # Correct slight mispellings when cd'ing
shopt -s checkhash # Try to check hash table before path search
shopt -s cmdhist # Saves multi-line commands to history
shopt -s expand_aliases # Allows use of aliases
shopt -s extglob # Extended pattern matching
shopt -s extquote # String quoting within parameter expansions
shopt -s histappend # Append history from a session to HISTFILE instead of overwriting
shopt -s no_empty_cmd_completion # Don't try to path search on an empty line
shopt -s nocaseglob # Case insensitive pathname expansion
shopt -s progcomp # Programmable completion capabilities
shopt -s promptvars # Expansion in prompt strings

# Prevent clobbering of files with redirects
set -o noclobber



# == Aliases {{{1
# ==================================================================================================

# Filesystem
alias ~='cd ~'
alias ..='cd ../'
alias ...='cd ../../'
alias cdot="cd $HOME/.dotfiles"
# Don't follow symbolic links when cd'ing, e.g. go to the actual path. -L to follow if you must
alias cd="cd -P"
# Make basic commands interactive to prompt overwriting, confirming, etc
alias rm='rm -i'
alias cp='cp -ia'  # Make cp in archive mode, also enables recursive copy
alias mv='mv -i'
alias md='mkdir -p'  # Make sub-directories as needed
alias rd='rmdir'
alias p='pwd'
alias cdc='cd ~/Dropbox/classes/'

# Various CD shortcuts
if [[ -d "$HOME/fcs/" ]]; then
  alias wa="cd $HOME/fcs/lib/Fap/WebApp/Action/"
  alias f="cd $HOME/fcs/lib/Fap/"
  alias dbregen="perl -I$HOME/fcs/lib $HOME/fcs/bin/tools/database/regenerate_DBIx"
fi
if [[ -d "$HOME/Dropbox/dev" ]]; then
  export DEVHOME="$HOME/Dropbox/dev"
  alias s="cd $DEVHOME/websites/"
  alias d="cd $DEVHOME"
  alias ios="cd $DEVHOME/ios"
fi

# System
alias u='history -n'  # Sync history from other terminals
alias _='sudo'
alias du='du -kh' # Human readable in 1K block sizes
alias df='df -kh' # Human readable in 1K block sizes with file system type
alias stop='kill -STOP'
alias info='info --vi-keys'

# Editing - All roads lead to $EDITOR
alias vi="$EDITOR"
alias svi="sudo $EDITOR"
alias nano=$EDITOR
alias emacs=$EDITOR

# Git
alias sg='for file in $(git status|egrep "modified|new file"|cut -d: -f2|tr -d " "|sort|uniq); do scp $file lpetherbridge@devbox5.lotsofclouds.fonality.com:~/fcs/$file; done'

# Python
alias py='python'
alias dja='django-admin.py'
alias pym='python manage.py'
alias pyr='python manage.py runserver 0.0.0.0:10128'
alias pys='python manage.py syncdb'

# RPM
alias rpmi='rpm -ivh' # install rpm
alias rpmls='rpm -qlp' # list rpm contents
alias rpminfo='rpm -qip' # list rpm info

# Edit configurations
alias vrc="pushd $HOME/.dotfiles/ >> /dev/null; vi $HOME/.dotfiles/vimrc; popd >> /dev/null"
alias vp="pushd $HOME/.dotfiles/ >> /dev/null; vi $HOME/.dotfiles/vim/plugins.vim; popd >> /dev/null"
alias vbp="pushd $HOME/.dotfiles/ >> /dev/null; vi $HOME/.dotfiles/bash_profile; popd >> /dev/null"
alias vb="pushd $HOME/.dotfiles/ >> /dev/null; vi $HOME/.dotfiles/bashrc; popd >> /dev/null"

# SSH
alias slp="ssh lp"
alias spi="ssh pi@192.168.1.110"
alias spir="ssh pi@24.22.74.212 -p2222"
alias sls="ssh luc6@linux.cs.pdx.edu"
alias sqz="ssh luc6@quizor2.cs.pdx.edu"
alias sshl='ssh-add -L' # List ssh-agent identities
alias st='ssh -A lpetherbridge@tech.fonality.com'
sw2() {
  TERM=${TERM/"screen-256color"/"xterm-256color"}
  ssh -A lpetherbridge@web-dev2.fonality.com
  TERM=${TERM/"xterm-256color"/"screen-256color"}
}
alias sp='ssh -A lpetherbridge@fcs-app1.fonality.com'
alias sf='ssh -A lpetherbridge@devbox5.lotsofclouds.fonality.com'
alias sq='ssh -A lpetherbridge@qa-app.lotsofclouds.fonality.com'
alias ss='ssh -A lpetherbridge@fcs-stg-app1.lax01.fonality.com'
alias ss2='ssh -A lpetherbridge@fcs-stg2-app1.lax01.fonality.com'
alias ss3='ssh -A lpetherbridge@fcs-app1.stage3.arch.fonality.com'
alias ss4='ssh -A lpetherbridge@fcs-app1.stage4.arch.fonality.com'
alias ss5='ssh -A lpetherbridge@fcs-app1.stage5.arch.fonality.com'
alias ss6='ssh -A lpetherbridge@fcs-app1.stage6.arch.fonality.com'
alias ssb='ssh -A lpetherbridge@fcs-stg-bastion.lax01.fonality.com'

# Sourcing
alias b="source $HOME/.bashrc"
alias bp="source $HOME/.bash_profile"

# Misc
alias da='date "+%Y-%m-%d %H:%M:%S"'
alias g='grep -n --color=auto'
alias grep='grep -n --color=auto'
alias offenders='uptime;ps aux | perl -ane"print if \$F[2] > 0.9"'
alias path='echo -e ${PATH//:/"\n"}'
alias topmem='ps -eo pmem,pcpu,pid,user,args | sort -k 1 -r | head -20 | cut -d- -f1';
alias topcpu='ps -eo pmem,pcpu,pid,user,args | sort -k 2 -r | head -20 | cut -d- -f1';
alias which='type -a'
alias x='extract'

# ls
if [[ "$OSTYPE" =~ 'darwin' ]]; then
  alias ls='ls -NhFG --color' # Add colors for filetype recognition
else
  alias ls='ls -NhF --color=tty'
fi
alias ll='ls -Nl' # Long listing
alias la='ls -NAl' # Show hidden files
alias lx='ls -NlXB' # Sort by extension
alias lk='ls -NlSr' # Sort by size, biggest last
alias lc='ls -Nltcr' # Sort by and show change time, most recent last
alias lu='ls -Nltur' # Sort by and show access time, most recent last
alias lt='ls -Nltr' # Sort by date, most recent last
alias lle='ls -Nal | less' # Pipe through 'less'
alias lr='ls -NlR' # Recursive ls



# == Functions {{{1
# ==================================================================================================

myip() {
  wget http://ipecho.net/plain -O - -q; echo
}
ssh() {
  TERM=${TERM/tmux/screen}
  command ssh $*
}
vf() {
  vim scp://lpetherbridge@devbox5.lotsofclouds.fonality.com/~/fcs/$*
}
vs() {
  vim scp://lpetherbridge@fcs-stg-app1.lax01.fonality.com/~/fcs/$*
}
vs2() {
  vim scp://lpetherbridge@fcs-stg2-app1.lax01.fonality.com/~/fcs/$*
}
pprofile() {
  perl -d:NYTProf $*;
  nytprofhtml --open;
}
_ask_yes_no() {
  echo -en "${FGred}$@ [y/n] ${RCLR}" ; read ans
  case "$ans" in
    y*|Y*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

# Converts SQL output to CSV formatting
sqlcsv() { cat | sed "s/'/\'/;s/\t/\",\"/g;s/^/\"/;s/$/\"/;s/\n//g"; }

# Syntax checks all new or modified perl files
schk() {
  for file in $(git status|egrep 'new file|modified'|egrep '(.pm|.pl)$' |cut -d: -f2|cut -d' ' -f4); do
    perl -c $file
  done
}

gmf() {
  local branch_file='.gmf_branches'
  if [[ -f ${branch_file} ]]; then
    local current_branch=$(current_branch)
    local branches=()
    local i=0
    while read line; do
      branches[$i]=$line
      i=$(($i + 1))
    done < ${branch_file}
    local main_branch=${branches[0]}

    command="GIT_MERGE_AUTOEDIT=no;echo 'Merging ${current_branch} into ${main_branch}' &&"
    command="$command git checkout ${main_branch} && "
    command="$command git pull && "
    command="$command git merge ${current_branch} && "
    command="$command git push origin ${main_branch} "
    for this_branch in "${branches[@]}"; do
      if [ "${this_branch}" = "${main_branch}" ]; then
        continue
      fi
      command="$command && echo 'Merging ${main_branch} into ${this_branch}' &&"
      command="$command git checkout ${this_branch} && "
      command="$command git pull && "
      command="$command git merge ${main_branch} && "
      command="$command git push origin ${this_branch}"
    done
    command="$command && git checkout ${main_branch}"
    echo $command
    if _ask_yes_no "Proceed?"; then
      eval $command
    fi
  fi
}

updatedb() {
  case "$OSTYPE" in
    darwin*)
      sudo /usr/libexec/locate.updatedb
      ;;
    *)
      updatedb
      ;;
  esac
}

# mkdir & cd to it
mcd() { mkdir -p "$1" && cd "$1"; }

hist_stats() { history | cut -d] -f2 | sort | uniq -c | sort -rn | head; }

n() { echo -n -e "\033]0;$*\007"; TERM_TITLE=$*; }
sn() { echo -n -e "\033k$*\033\\"; SCREEN_TITLE=$*; }

# Grep commands
h() { if [ -z "$*" ]; then history; else history | egrep "$@"; fi; }
pg() {
  CMD=''
  case "$OSTYPE" in
    darwin*) CMD='ps aux'
      ;;
    *) CMD='ps auxf'
      ;;
  esac
  if [ -z $1 ]; then
    $CMD
  else
    $CMD | grep $*
  fi
}

# Convert unix epoc to current timezone
unixtime() { date --date="1970-01-01 $* sec GMT"; }

myps() { ps -f $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }

sa() {
  sourcefile /tmp/ssh-agent-$HOSTNAME-info
}
ra() {
  if [ $1 ] || [ _ask_yes_no "Restart ssh-agent?" ]; then
    rm -f /tmp/ssh-agent-$HOSTNAME
    pkill -f ssh-agent
    echo `ssh-agent -s -a /tmp/ssh-agent-$HOSTNAME` >| /tmp/ssh-agent-$HOSTNAME-info
    source /tmp/ssh-agent-$HOSTNAME-info
  fi
}
aweb() { [[ -f "$HOME/.ssh/webhost_key" ]] && ssh-add "$HOME/.ssh/webhost_key"; }
als() { [[ -f "$HOME/.ssh/id_rsa_psu" ]] && ssh-add "$HOME/.ssh/id_rsa_psu"; }
akey() {
  ra "1"
  # If Aladdin etoken connected
  if [ $(system_profiler SPUSBDataType 2> /dev/null| grep OMNIKEY -c) -gt 0 ]; then
    ssh-add -s '/usr/local/lib/libaetpkss.dylib'
  fi
}

# Get current host related info
ii() {
  echo -e "\nYou are logged on ${BLU}${HOSTNAME}${RCLR}";
  echo -e "\n${RED}Additionnal information:${RCLR} " ; uname -a
  echo -e "\n${RED}Users logged on:${RCLR} " ; w -h
  echo -e "\n${RED}Current date :${RCLR} " ; date
  echo -e "\n${RED}Machine stats :${RCLR} " ; uptime
  if [ $(which free 2> /dev/null) ]; then
    echo -e "\n${RED}Memory stats :${RCLR} " ; free
  fi
  echo
}

if [[ "$OSTYPE" =~ 'darwin' ]]; then
  hide() {
    echo "Hiding hidden files..."
    defaults write com.apple.finder AppleShowAllFiles TRUE
    defaults write com.apple.finder AppleShowAllFiles FALSE
    # force changes by restarting Finder
    killall Finder
  }
  show() {
    echo "Showing hidden files...";
    defaults write com.apple.finder AppleShowAllFiles TRUE
    # force changes by restarting Finder
    killall Finder
  }
fi

# Prompt functions
bg_jobs() {
  jobs=$(jobs -r | wc -l | tr -d '[[:space:]]')
  if [[ $jobs > 0 ]]; then
    echo $jobs
  fi
}
st_jobs() {
  jobs=$(jobs -s | wc -l | tr -d '[[:space:]]')
  if [[ $jobs -gt 0 ]]; then
    echo $jobs
  fi
}



# == Theme/Plugins {{{1
# ==================================================================================================

export PLUGIN_DIR="${HOME}/.plugins"
export BASH_THEME="${HOME}/.themes/zhayedan.sh"

plugins=(host git)
export SSH_AGENT_FWD="yes"

# Load all of the plugins
for plugin in ${plugins[@]}
do
  if [ "${plugin}" == "host" ]
  then
    pfile="$PLUGIN_DIR/$plugin/${HOSTNAME}.plugin.sh"
    sfile="$PLUGIN_DIR/$plugin/secure/${HOSTNAME}.plugin.sh"
  else
    pfile="$PLUGIN_DIR/$plugin/$plugin.plugin.sh"
  fi
  sourcefile $pfile
  sourcefile $sfile
  unset pfile
done
unset plugin

# GIT
BASH_THEME_GIT_PROMPT_PREFIX=" ${FGcyan}["
BASH_THEME_GIT_PROMPT_SUFFIX="${FGcyan}]${RCLR}"
BASH_THEME_GIT_PROMPT_CLEAN="${FGgreen}=${RCLR}"

BASH_THEME_GIT_PROMPT_AHEAD="${FGred}!${RCLR}"
BASH_THEME_GIT_PROMPT_DIRTY="${FGred} *${RCLR}"
BASH_THEME_GIT_PROMPT_DIRTY="" # Commented since we have other flags to indicate dirty below
BASH_THEME_GIT_PROMPT_ADDED="${FGgreen}+${RCLR}"
BASH_THEME_GIT_PROMPT_MODIFIED="${FGblue}x${RCLR}"
BASH_THEME_GIT_PROMPT_DELETED="${FGred}-${RCLR}"
BASH_THEME_GIT_PROMPT_RENAMED="${FGmagenta}>${RCLR}"
BASH_THEME_GIT_PROMPT_UNMERGED="${FGyellow}^${RCLR}"
BASH_THEME_GIT_PROMPT_UNTRACKED="${FGcyan}.${RCLR}"

# Format for git_prompt_long_sha() and git_prompt_short_sha()
BASH_THEME_GIT_PROMPT_SHA_BEFORE="${FGyellow}"
BASH_THEME_GIT_PROMPT_SHA_AFTER="${RCLR}"

# Colors vary depending on time lapsed.
BASH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="${FGgreen}"
BASH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="${FGyellow}"
BASH_THEME_GIT_TIME_SINCE_COMMIT_LONG="${FGred}"
BASH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="${FGcyan}"

# Git time since commit
BASH_THEME_GIT_TIME_SINCE_COMMIT_BEFORE=""
BASH_THEME_GIT_TIME_SINCE_COMMIT_AFTER=""

# Trim working path to 1/2 of screen width
prompt_pwd() {
  local pwd_max_len=$(($(tput cols) / 2))
  local trunc_symbol="..."
  PWD=${PWD/$HOME/"~"}
  if [ ${#PWD} -gt ${pwd_max_len} ]
  then
    local pwd_offset=$(( ${#PWD} - ${pwd_max_len} + 3 ))
    PWD="${trunc_symbol}${PWD[${pwd_offset},${#PWD}]}"
  fi
  echo -e "${PWD}"
}

prompt_on() {
  case ${OSTYPE} in
    darwin*)
      PS1_HOST="mac"
      ;;
    *)
      PS1_HOST="${HOSTNAME}"
      ;;
  esac

  echo -ne "\n$FGbgreen[$FGwhite$(date +'%F %R')$FGbgreen]"
  if [[ $(declare -f bg_jobs) && $(bg_jobs) ]]; then
    echo -ne "$FGbgreen[$FGyellow$(bg_jobs)$FGbgreen]"
  fi
  if [[ $(declare -f st_jobs) && $(st_jobs) ]]; then
    echo -ne "$FGbgreen[$FGred$(st_jobs)$FGbgreen]"
  fi
  if [[ $PS1_HOST ]]; then
    echo -ne " $FGbgreen{$FGgreen$PS1_HOST$FGbgreen} "
  fi

  if [[ $(declare -f parse_git_branch) && $(parse_git_branch) ]]; then
    echo -ne "$FGbgreen($FGblue$(parse_git_branch)$FGBgreen) "
  fi
  echo -e "$FGcyan$(prompt_pwd)$RCLR"
}
PS1="> "
PS2=">> "

prompt_off() {
  PROMPT_COMMAND=""
  PS1='$(prompt_pwd) > '
}

PROMPT_COMMAND="history -a; prompt_on"


# == End Profiling {{{1
# ==================================================================================================

endn=$(date +%s.%N)
ends=$(date +%s)
if [[ $(which bc 2>/dev/null) ]]; then
  dt=$(echo "$endn - $startn" | bc)
  dd=$(echo "$dt/86400" | bc)
  dt2=$(echo "$dt-86400*$dd" | bc)
  dh=$(echo "$dt2/3600" | bc)
  dt3=$(echo "$dt2-3600*$dh" | bc)
  dm=$(echo "$dt3/60" | bc)
  ds=$(echo "$dt3-60*$dm" | bc)
  printf "\033[0;33mTotal runtime: %d:%02d:%02d:%02.4f\033[0m\n" $dd $dh $dm $ds
else
  dt=$(($ends - $starts))
  printf "\033[0;33mTotal runtime: %ds\033[0m\n" $dt
fi

# }}}

# vim:foldmethod=marker:foldlevel=0

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
alias mountsilver='sudo mkdir /Volumes/Silver && sudo mount -o rw,auto,nobrowse -t ntfs /dev/disk2s3 /Volumes/Silver'
