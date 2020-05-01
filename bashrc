# == Profiling Start {{{1
# ==================================================================================================

hqa() {
    \cp -f ~/Library/ApplicationSupport/nfhud/nfhud_cfg.ini.qa ~/Library/ApplicationSupport/nfhud/nfhud_cfg.ini
}
hst() {
    \cp -f ~/Library/ApplicationSupport/nfhud/nfhud_cfg.ini.stable ~/Library/ApplicationSupport/nfhud/nfhud_cfg.ini
}

# Turns profiling on or off
PROFILE=0
(( $PROFILE )) && start=$(gdate +%s.%N 2>/dev/null || date +%s.%N)

# == Utility Functions {{{1
# ==================================================================================================

sourcefile() { [[ -r "$1" ]] && source $1; }

# Functions to help us manage paths.
# Arguments: $path, $ENV_VAR (default: $PATH)
pathremove () {
    local IFS=':'
    local NEWPATH
    local DIR
    local PATHVARIABLE=${2:-PATH}
    for DIR in ${!PATHVARIABLE}; do
        if [ "$DIR" != "$1" ]; then
            NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
        fi
    done
    export $PATHVARIABLE="$NEWPATH"
}
pathprepend () {
    pathremove $1 $2
    if [[ -d $1 ]]; then
        local PATHVARIABLE=${2:-PATH}
        export $PATHVARIABLE="$1${!PATHVARIABLE:+:${!PATHVARIABLE}}"
    fi
}
pathappend () {
    pathremove $1 $2
    if [[ -d $1 ]]; then
        local PATHVARIABLE=${2:-PATH}
        export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
    fi
}

# Exit if not interactive
case "$-" in
    *i* )
        ;;
    * )
        return
        ;;
esac

# == Source Files {{{1
# ==================================================================================================

sourcefile "$HOME/.fzf.bash"
sourcefile "$HOME/.secure/secure.sh"
for file in ~/.bashrc.d/*.bashrc; do
    sourcefile "${file}"
done

# == ENV Variables {{{1
# ==================================================================================================

# Rust
pathprepend "$HOME/.cargo/bin"
pathprepend "$HOME/www/luke_web/bin"

# Golang
pathprepend "/usr/local/go/" GOROOT
pathprepend "$HOME/dev/" GOPATH

# PATH
pathprepend "/usr/local/go/bin"
pathprepend "$GOPATH/bin"
pathprepend "/usr/local/bin"
pathprepend "$HOME/bin"

# Perl
pathprepend "$HOME/perl5/bin"
pathprepend "$HOME/perl5/lib/perl5/" PERL5LIB
pathprepend "$HOME/perl5" PERL_LOCAL_LIB_ROOT
pathprepend "$HOME/perl5/lib/perl5/" GITPERLLIB
pathprepend "$HOME/lib" PERL5LIB

pathappend "/usr/local/lib" LIBRARY_PATH
pathappend "$HOME/dev/FlameGraph/"

# Android
export ANDROID_HOME=$HOME/Library/Android/sdk
pathappend $ANDROID_HOME/emulator
pathappend $ANDROID_HOME/tools
pathappend $ANDROID_HOME/tools/bin
pathappend $ANDROID_HOME/platform-tools

# == Bash Settings {{{1
# ==================================================================================================

# History
HISTCONTROL="ignoreboth"     # Ignore commands starting with a space and duplicate commands
HISTFILESIZE=100000          # Number of lines saved in HISTFILE
HISTSIZE=2000                # Number of commands saved in command history
HISTTIMEFORMAT='[%F %a %T] ' # YYYY-MM-DD DAY HH:MM:SS

# Misc
EDITOR="vim"
export FZF_DEFAULT_COMMAND='(rg -l "" || ag --hidden -p ~/.gitignore -g "") 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Bash 4.00 specific options
if [[ $BASH_VERSINFO > 3 ]]; then
    shopt -s autocd          # Allow cding to directories by typing the directory name
    shopt -s checkjobs       # Defer exiting shell if any stopped or running jobs
    shopt -s dirspell        # Attempts spell correction on directory names
fi

shopt -s cdable_vars         # Allow passing directory vars to cd
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

# set -o vi

# == Projects {{{1
# ==================================================================================================

# FCS
if [ -d $HOME/lib/fcs ]; then
    sourcefile "/etc/sysconfig/fcs"
    export FON_DIR="$HOME/lib/fcs"
    for dir in $(find "$FON_DIR/bin" -type d); do
        pathprepend $dir
    done
    pathappend "$FON_DIR/bin"
    pathappend "$FON_DIR/lib" PERL5LIB
    pathappend "$HOME/lib/sysapi/lib" PERL5LIB
fi

# == Colors {{{1
# ==================================================================================================

if tput colors &> /dev/null; then
  tput sgr0
  if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
    export BLACK=$(tput setaf 0)
    export RED=$(tput setaf 1)
    export GREEN=$(tput setaf 34)
    export ORANGE=$(tput setaf 11)
    export BLUE=$(tput setaf 12)
    export PURPLE=$(tput setaf 5)
    export CYAN=$(tput setaf 14)
    export WHITE=$(tput setaf 15)
  else
    export BLACK=$(tput setaf 0)
    export RED=$(tput setaf 1)
    export GREEN=$(tput setaf 2)
    export ORANGE=$(tput setaf 3)
    export BLUE=$(tput setaf 4)
    export PURPLE=$(tput setaf 5)
    export CYAN=$(tput setaf 6)
    export WHITE=$(tput setaf 7)
  fi
  export BOLD=$(tput bold)
  export RESET=$(tput sgr0)
else
  export MAGENTA="\033[1;31m"
  export ORANGE="\033[1;33m"
  export GREEN="\033[1;32m"
  export PURPLE="\033[1;35m"
  export WHITE="\033[1;37m"
  export BOLD=""
  export RESET="\033[m"
fi

# == Aliases {{{1
# ==================================================================================================

# CD
# Don't follow symbolic links when cd'ing, e.g. go to the actual path. -L to follow if you must
alias ~='cd ~'
alias ..='cd ../'
alias ...='cd ../../'
alias cdot="cd $HOME/.dotfiles"

# Filesystem improvements
alias rm='rm -i'
alias cp='cp -ia'  # Make cp in archive mode, also enables recursive copy
alias mv='mv -i'
alias md='mkdir -p'  # Make sub-directories as needed
alias rd='rmdir'
alias findbroken='find . -maxdepth 1 -type l ! -exec test -e {} \; -print'  # Find broken symlinks
alias tags='ctags -I ~/.ctags --file-scope=no -R'

# System
alias _='sudo'
alias du='du -kh' # Human readable in 1K block sizes
alias diskspace="du -S | sort -n -r |more"
alias folders="find . -maxdepth 1 -type d -print | xargs du -sk | sort -rn"
alias df='df -kh' # Human readable in 1K block sizes with file system type
alias stop='kill -STOP'
alias info='info --vi-keys'

# Editing
export LESS="-RFX"
alias vi="vim"

# Python
alias dja='django-admin.py'
alias py3='python3'
alias py='python'
alias pym='python manage.py'
alias pyr='python manage.py runserver 0.0.0.0:10128'
alias pys='python manage.py syncdb'

# Perl
alias pd='perl -MData::Dumper'

# RPM
alias rpmi='rpm -ivh' # install rpm
alias rpmls='rpm -qlp' # list rpm contents
alias rpminfo='rpm -qip' # list rpm info

# Edit configurations
alias vb="pushd $HOME/.dotfiles/ >> /dev/null; vi $HOME/.dotfiles/bashrc; popd >> /dev/null"
alias vbp="pushd $HOME/.dotfiles/ >> /dev/null; vi $HOME/.dotfiles/bash_profile; popd >> /dev/null"
alias vp="pushd $HOME/.dotfiles/ >> /dev/null; vi $HOME/.dotfiles/vim/plugins.vim; popd >> /dev/null"
alias vrc="pushd $HOME/.dotfiles/ >> /dev/null; vi $HOME/.dotfiles/vimrc; popd >> /dev/null"

# SSH
alias slp="ssh lp"
alias sls="ssh luc6@linux.cs.pdx.edu"
alias sqz="ssh luc6@quizor2.cs.pdx.edu"
alias ss1='ssh -A lpetherbridge@fcs-stg-app1.lax01.fonality.com'
alias ss1b='ssh -A lpetherbridge@fcs-stg-batch1.fonality.com'
alias ss1cp='ssh -A lpetherbridge@fcs-stg-cp1.fonality.com'
alias ss2='ssh -A lpetherbridge@fcs-stg2-app1.lax01.fonality.com'
alias ss2b='ssh -A lpetherbridge@fcs-stg2-batch1.lax01.fonality.com'
alias ss3='ssh -A lpetherbridge@fcs-app1.stage3.arch.fonality.com'
alias ss3b='ssh -A lpetherbridge@fcs-batch1.stage3.arch.fonality.com'
alias ss3cp='ssh -A lpetherbridge@fcs-cp1.stage3.arch.fonality.com'
alias ss4='ssh -A lpetherbridge@fcs-app1.stage4.arch.fonality.com'
alias ss4b='ssh -A lpetherbridge@fcs-batch1.stage4.arch.fonality.com'
alias ss4cp='ssh -A lpetherbridge@fcs-cp1.stage4.arch.fonality.com'
alias ss5='ssh -A lpetherbridge@fcs-app1.stage5.arch.fonality.com'
alias ss5b='ssh -A lpetherbridge@fcs-batch1.stage5.arch.fonality.com'
alias ss5cp='ssh -A lpetherbridge@fcs-cp1.stage5.arch.fonality.com'
alias ss6='ssh -A lpetherbridge@fcs-app1.stage6.arch.fonality.com'
alias ss6b='ssh -A lpetherbridge@fcs-batch1.stage6.arch.fonality.com'
alias ss6cp='ssh -A lpetherbridge@fcs-cp1.stage6.arch.fonality.com'
alias ss7='ssh -A lpetherbridge@fcs-app.stage7.arch.fonality.com'
alias ssb='ssh -A lpetherbridge@fcs-stg-bastion.lax01.fonality.com'
alias sshl='ssh-add -L' # List ssh-agent identities

# Sourcing
alias b="source $HOME/.bashrc"
alias bp="source $HOME/.bash_profile"

# Misc
alias da='date "+%Y-%m-%d %H:%M:%S"'
alias g='rg'
alias grep='rg'
function mgrep() {
  rg $1 ~/.mysql_history | sed -En 's/\\\040/ /pg'
}
alias offenders='uptime;ps aux | perl -ane"print if \$F[2] > 0.9"'
alias path='echo -e ${PATH//:/"\n"}'
alias perl5lib='echo -e ${PERL5LIB//:/"\n"}'
alias tm='tm.sh'
alias which='type -a'
alias x='extract.sh'

# ls Shortcuts
# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
  ls_colorflag="--color"
else # OS X `ls`
  ls_colorflag="-G"
fi
alias ls="command ls -hF $ls_colorflag" # Add colors for filetype recognition
alias la='ls -lhA' # Show hidden files (minus . and ..)
alias lc='ls -ltcr' # Sort by and show change time, most recent last
alias lk='ls -lSr' # Sort by size, biggest last
alias ll='ls -lh' # Long listing
alias lle='ls -lhA | less' # Pipe through 'less'
alias lr='ls -lR' # Recursive ls
alias ld='ls -ld */' # List only directories
alias lt='ls -ltr' # Sort by date, most recent last
alias lu='ls -ltur' # Sort by and show access time, most recent last
alias lx='ls -lXB' # Sort by extension

# Git
alias g='git'
alias ga='git add'
alias gb='git branch -v'
alias gbm='git branch -v --merged'
alias gbnm='git branch -v --no-merged'
alias gba='git branch -a'
alias gca='gc -a'
alias gcam='gc --amend'
alias gcb='git checkout -b'
alias gcp='git cherry-pick'
alias gd='git diff'
alias gdt='git difftool'
alias gf='git fetch origin'
alias gi='echo $(git_prompt_info)'
alias glg='git log --graph --pretty=format:"%C(yellow)%h (%p) %ai%Cred%d %Creset%Cblue[%ae]%Creset %s (%ar). %b %N"'
alias gll='git --no-pager log --pretty=format:"%C(yellow)%h (%p) %ai%Cred%d %Creset%Cblue[%ae]%Creset %s (%ar). %b %N" --numstat -10'
alias gls='git --no-pager log --pretty=format:"%C(yellow)%h (%p) %ai%Cred%d %Creset%Cblue[%ae]%Creset %s (%ar). %b %N" -20'
alias gm='git merge --no-ff'
alias gpl='echo "use gfr"'
alias gps='git push'
alias grhh='git reset HEAD --hard'
alias grm='git rm'
alias gsl='git --no-pager stash list'
alias gss='git status -s'
alias gst='git status'
alias gt=git_time_since_commit
alias gtoday='git --no-pager log --graph --pretty=format:"%C(yellow)%h %ad%Cred%d %Creset%Cblue[%cn]%Creset  %s (%ar)" --date=iso --all --branches=* --remotes=* --since="23 hours ago" --author="$(git config user.name)"'
alias gun='git reset HEAD --'

# React Native
alias rand='npx react-native run-android --port 8088'
alias rios='npx react-native run-ios'
alias yupd='yarn install && pushd ios && bundle install && bundle exec pod install && popd'

# == Functions {{{1
# ==================================================================================================

topc() {
    echo " %CPU %MEM   PID USER     ARGS";
    ps -eo pcpu,pmem,pid,user,args | sort -k 1 -r -n | head -10 | cut -d- -f1;
}
topm() {
    echo " %MEM %CPU   PID USER     ARGS";
    ps -eo pmem,pcpu,pid,user,args | sort -k 1 -r -n | head -10 | cut -d- -f1;
}
sw2() {
    TERM=${TERM/"screen-256color"/"xterm-256color"}
    ssh -A lpetherbridge@web-dev2.fonality.com
    TERM=${TERM/"xterm-256color"/"screen-256color"}
}
purge_git() {
    if _ask_yes_no "Fully purge $1 from repo?"; then
        git filter-branch --force --index-filter "git rm --cached --ignore-unmatch $1" --prune-empty --tag-name-filter cat -- --all
    fi
}
# function vim() {
#     # Only run if we're inside tmux
#     if [[ $TMUX != "" ]]; then
#         $HOME/bin/vim_tmux "$@"
#     else
#         command vim "$@"
#     fi
# }
myip() {
    wget http://ipecho.net/plain -O - -q; echo
}
ssh() {
    TERM=${TERM/tmux/screen}
    command ssh "$@"
}
pprofile() {
    perl -d:NYTProf $*;
    nytprofhtml --open;
}
_ask_yes_no() {
    echo -en "${RED}$@ [y/n] ${RESET}" ; read ans
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
    for file in $(git status|egrep '(.pl|.pm)$' |cut -d: -f2|cut -d' ' -f4); do
        perl -cw "$file"
    done
    for file in $(git status|egrep '(.pm)$' |cut -d: -f2|cut -d' ' -f4|sed 's/\//::/g'|sed 's/lib:://'|sed 's/.pm//'); do
        echo -n "$file "
        perl -cw -e"use $file"
    done
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
hu() { history -n; }

n() { echo -n -e "\033]0;$*\007"; TERM_TITLE=$*; }
sn() { echo -n -e "\033k$*\033\\"; SCREEN_TITLE=$*; tmux rename-window $*; }

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


btd() { perlo '%d' "0b$1"; }
xtd() { perlo '%d' "0x$1"; }
btx() { perlo '0x%04X' "0b$1"; }
dtx() { perld '0x%04X' $1; }
dtb() { perld '0b%08b' $1; }
xtb() { perlo '0b%08b' "0x$1"; }
perld() { perl -e'print sprintf("$ARGV[0]\n", $ARGV[1])' $1 $2; }
perlo() { perl -e'print sprintf("$ARGV[0]\n", oct($ARGV[1]))' $1 $2; }

myps() { ps -f $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }

source_agent() {
    sourcefile /tmp/ssh-agent-$HOSTNAME-info
}
start_agent() {
    agent_running && return 0;
    echo `ssh-agent -s -a /tmp/ssh-agent-$HOSTNAME` >| /tmp/ssh-agent-$HOSTNAME-info
    source_agent
}
kill_agent() {
    unset SSH_AUTH_SOCK
    unset SSH_AGENT_PID
    pkill -f ssh-agent
    rm -f /tmp/ssh-agent-$HOSTNAME
    rm -f /tmp/ssh-agent-$HOSTNAME-info
}
agent_running() {
    if [ $(pg ssh-agent-$HOSTNAME|grep -v grep -c) -gt 0 ]; then
        return 0;
    fi;
    return 1;
}
ra() {
    if agent_running; then
        if [ ! -z $1 ] || _ask_yes_no "Restart ssh-agent?"; then
            kill_agent
            start_agent
        fi
    else
        start_agent
    fi
}
arsa() {
    [[ -f "$HOME/.ssh/id_rsa" ]] || return 1;
    agent_running && [ $(ssh-add -L | grep -c "id_rsa") -gt 0 ] && return 0;
    start_agent && ssh-add "$HOME/.ssh/id_rsa"
}
sac_status() {
    sudo launchctl list|grep -i com.SafeNet.SACSrv
}
restart_sac() {
    sudo launchctl unload /Library/Frameworks/eToken.framework/Versions/A/com.SafeNet.SACSrv.plist
    sudo launchctl load /Library/Frameworks/eToken.framework/Versions/A/com.SafeNet.SACSrv.plist
    sudo launchctl start com.SafeNet.SACSrv
}
akey() {
    [ $(system_profiler SPUSBDataType 2> /dev/null| grep "SafeNet" -c) -gt 0 ] || return 1;
    agent_running && [ $(ssh-add -L | grep -c "libeTPkcs11.dylib.1") -gt 0 ] && return 0;
    start_agent && ssh-add -s '/usr/local/lib/libeTPkcs11.dylib.1'
}
dkey() {
    agent_running && ssh-add -D
}

# Get current host related info
ii() {
    echo -e "\nYou are logged on ${BLU}${HOSTNAME}${RESET}";
    echo -e "\n${RED}Additionnal information:${RESET} " ; uname -a
    echo -e "\n${RED}Users logged on:${RESET} " ; w -h
    echo -e "\n${RED}Current date :${RESET} " ; date
    echo -e "\n${RED}Machine stats :${RESET} " ; uptime
    if [ $(which free 2> /dev/null) ]; then
        echo -e "\n${RED}Memory stats :${RESET} " ; free
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

# Git
git() {
  if [ $1 = "merge" ] && [ $2 != "--no-ff" ]; then
    echo "Use gm which uses --no-ff"
  else
    command git "$@"
  fi
}
gfr() {
  branch=$(current_branch)
  echo "git fetch origin && git rebase -p origin/$branch"
  git fetch origin
  git rebase -p origin/$branch
}
gh() {
    echo "Git Help:"
    echo "  Git Status Symbols:"
    echo "    x : Local modifications"
    echo "    + : Files added"
    echo "    - : Files deleted"
    echo "    > : Files renamed"
    echo "    . : Untracked files"
    echo "    ! : Ahead of origin"
    echo "    ^ : Unmerged changes"
    echo "    * : Dirty"
    echo "    = : Clean"
}
# Checkout a ticket branch
gbt() { git checkout tickets/$@; }
gbtn() { git checkout -b tickets/$@; }
# Will return the current branch name
# Usage example: git pull origin $(current_branch)
#
current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}
gc() {
    git commit "$@"
    # tags > /dev/null 2>&1 &
}
gco() {
    git checkout "$@"
    # tags > /dev/null 2>&1 &
}
gops() {
    git push origin $(current_branch) $@ -u
}
git_prompt_info() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "$BASH_THEME_GIT_PROMPT_PREFIX$(current_branch) $(parse_git_dirty) $(git_prompt_short_sha) $(git_time_since_commit)$BASH_THEME_GIT_PROMPT_SUFFIX"
}
# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.
git_time_since_commit() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
    # Only proceed if there is actually a commit.
    if [[ $(git log 2>&1 > /dev/null | grep -c "^fatal: bad default revision") == 0 ]]; then
        # Get the last commit.
        last_commit=`git log --pretty=format:'%at' -1 2> /dev/null`
        now=`date +%s`
        seconds_since_last_commit=$((now-last_commit))

        # Totals
        MINUTES=$((seconds_since_last_commit / 60))
        HOURS=$((seconds_since_last_commit/3600))

        # Sub-hours and sub-minutes
        DAYS=$((seconds_since_last_commit / 86400))
        SUB_HOURS=$((HOURS % 24))
        SUB_MINUTES=$((MINUTES % 60))

        if [ "$HOURS" -gt 24 ]; then
        echo "${BASH_THEME_GIT_TIME_SINCE_COMMIT_LONG}${BASH_THEME_GIT_TIME_SINCE_COMMIT_BEFORE}${DAYS}d${SUB_HOURS}h${SUB_MINUTES}m${BASH_THEME_GIT_TIME_SINCE_COMMIT_AFTER}${RCLR}"
        elif [ "$MINUTES" -gt 60 ]; then
        echo "${BASH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM}${BASH_THEME_GIT_TIME_SINCE_COMMIT_BEFORE}${HOURS}h${SUB_MINUTES}m${BASH_THEME_GIT_TIME_SINCE_COMMIT_AFTER}${RCLR}"
        else
        echo "${BASH_THEME_GIT_TIME_SINCE_COMMIT_SHORT}${BASH_THEME_GIT_TIME_SINCE_COMMIT_BEFORE}${MINUTES}m${BASH_THEME_GIT_TIME_SINCE_COMMIT_AFTER}${RCLR}"
        fi
    else
        echo "${BASH_THEME_GIT_TIME_SINCE_COMMIT_BEFORE}~${BASH_THEME_GIT_TIME_SINCE_COMMIT_AFTER}"
    fi
    fi
}
# Checks if working tree is dirty
parse_git_dirty() {
  local SUBMODULE_SYNTAX=''
  if [[ $POST_1_7_2_GIT -gt 0 ]]; then
    SUBMODULE_SYNTAX="--ignore-submodules=dirty"
  fi
  if [[ -n $(git status -s ${SUBMODULE_SYNTAX}  2> /dev/null) ]]; then
    echo "$BASH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$BASH_THEME_GIT_PROMPT_CLEAN"
  fi
}
# Checks if there are commits ahead from remote
git_prompt_ahead() {
  if $(echo "$(git log origin/$(current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    echo "$BASH_THEME_GIT_PROMPT_AHEAD"
  fi
}
# Formats prompt string for current git commit short SHA
git_prompt_short_sha() {
  SHA=$(git rev-parse --short HEAD 2> /dev/null) && echo "$BASH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$BASH_THEME_GIT_PROMPT_SHA_AFTER"
}
# Formats prompt string for current git commit long SHA
git_prompt_long_sha() {
  SHA=$(git rev-parse HEAD 2> /dev/null) && echo "$BASH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$BASH_THEME_GIT_PROMPT_SHA_AFTER"
}
parse_git_branch() {
  branch=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/' )
  echo $branch
}
# Get the status of the working tree
git_prompt_status() {
  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$BASH_THEME_GIT_PROMPT_UNTRACKED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^A  ' &> /dev/null); then
    STATUS="$BASH_THEME_GIT_PROMPT_ADDED$STATUS"
  elif $(echo "$INDEX" | grep '^M  ' &> /dev/null); then
    STATUS="$BASH_THEME_GIT_PROMPT_ADDED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^ M ' &> /dev/null); then
    STATUS="$BASH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
    STATUS="$BASH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
    STATUS="$BASH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^R  ' &> /dev/null); then
    STATUS="$BASH_THEME_GIT_PROMPT_RENAMED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
    STATUS="$BASH_THEME_GIT_PROMPT_DELETED$STATUS"
  elif $(echo "$INDEX" | grep '^AD ' &> /dev/null); then
    STATUS="$BASH_THEME_GIT_PROMPT_DELETED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
    STATUS="$BASH_THEME_GIT_PROMPT_UNMERGED$STATUS"
  fi
  echo $STATUS
}

# == Prompt {{{1
# ==================================================================================================

# GIT
BASH_THEME_GIT_PROMPT_PREFIX=" ${ORANGE}["
BASH_THEME_GIT_PROMPT_SUFFIX="${ORANGE}]${RESET}"
BASH_THEME_GIT_PROMPT_CLEAN="${GREEN}=${RESET}"

BASH_THEME_GIT_PROMPT_AHEAD="${RED}!${RESET}"
BASH_THEME_GIT_PROMPT_DIRTY="${RED} *${RESET}"
BASH_THEME_GIT_PROMPT_DIRTY="" # Commented since we have other flags to indicate dirty below
BASH_THEME_GIT_PROMPT_ADDED="${GREEN}+${RESET}"
BASH_THEME_GIT_PROMPT_MODIFIED="${BLUE}x${RESET}"
BASH_THEME_GIT_PROMPT_DELETED="${RED}-${RESET}"
BASH_THEME_GIT_PROMPT_RENAMED="${MAGENTA}>${RESET}"
BASH_THEME_GIT_PROMPT_UNMERGED="${ORANGE}^${RESET}"
BASH_THEME_GIT_PROMPT_UNTRACKED="${ORANGE}.${RESET}"

# Format for git_prompt_long_sha() and git_prompt_short_sha()
BASH_THEME_GIT_PROMPT_SHA_BEFORE="${ORANGE}"
BASH_THEME_GIT_PROMPT_SHA_AFTER="${RESET}"

# Colors vary depending on time lapsed.
BASH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="${GREEN}"
BASH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="${ORANGE}"
BASH_THEME_GIT_TIME_SINCE_COMMIT_LONG="${RED}"

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

    echo -ne "$ORANGE"
    if [[ $(declare -f bg_jobs) && $(bg_jobs) ]]; then
        echo -ne "[$(bg_jobs)] "
    fi
    if [[ $(declare -f st_jobs) && $(st_jobs) ]]; then
        echo -ne "{$(st_jobs)} "
    fi
    if [[ ! $TERM =~ screen ]]; then
        echo -ne "$(date +'%F %R') "
    fi
    if [[ $PS1_HOST ]]; then
        echo -ne "$USER @ $PS1_HOST "
    fi
    if [[ $(declare -f parse_git_branch) && $(parse_git_branch) ]]; then
        echo -ne "($(parse_git_branch)) "
    fi
    echo -e "$(prompt_pwd)$RESET"
}
PS1="> "
PS2=">> "

prompt_off() {
    PROMPT_COMMAND="history -a;"
    PS1='$(prompt_pwd) > '
}

PROMPT_COMMAND="history -a; prompt_on"

ascii() {
    clear
    echo -n $BLUE
#     cat << 'EOF'
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$=X><<<<<<>>X
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*$$#X><<<<<<<<>>
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$&$$$X<<//////<<>
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$=&$>/////////<>
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$%><<//??????//<<
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$@&8$$+<//?????????//<
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$##$$=>//???????????//
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$^{$&$>/??|||||||????/
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$.,-:;//;:=,$$$$$$$$$$$$$$o>x$$<?|||||||||||??/
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$. :H@@@MM@M#H/.,+%;,$$%8%*$$${<///?||||||||||||??/
# $$$$$$$$$$@8$$$$$$$$$$$$$$$,/X+ +M@@M@MM%=,-%HMMM@X/,o%$$$</??||||!!!!!!!||||??
# $$$$$$$$$$##8$$*$$$$$$$$$$-+@MM; $M@@MH+-,;XMMMM@MMMM@+-$</?|||!!!!!!!!!!!!|||?
# $$$$$$$$$&^{$^^&$$$$$$$$$;@M@@M- XM@X;. -+XXXXXHHH@M@M#@/.?||!!!!!!!!!!!!!!!|||
# $$$$$$$$$#=++={#$$$$&$,%MM@@MH ,@%=            .---=-=:=,.||!!!!!!---!!!!!!!!||
# $$$$$$$$%#+XXX=^$$$%{{-@#@@@MX .,              -%HX$$%%%+;|!!!----------!!!!!||
# $$$$$$$8{+><>>^%O=*+X=-./@M@M$                  .;@MMMM@MM:!--------------!!!!|
# $$*$&$$$%><//<OOX>>>>X@/ -$MM/                    .+MM@@@M$----------------!!!|
# $$${#$$=O>/??/>$<///,@M@H: :@:                    . -X#@@@@-----------------!!|
# #${++{$X</????/<???/,@@@MMX, .                    /H- ;@M@M=-oooooooo--------!!
# {=*>>==</?||||||||??.H@@@@M@+,                    %MM+..%#$.oooooooooooo-----!!
# {X<//+O>?||!!!!||||??/MMMM@MMH/.                  XM@MH; -; ooooooooooooo-----!
# *+<??/#&/|!!!!!!!!||??/%+%$XHH@$=              , .H@@@@MX,--oooooooooooooo-----
# $+/||||/|!-----!!!!?/<>.=--------.           -%H.,@@@@@MX,--ooooooooooooooo----
# @+?!!!!!--------!!!?<^^X.%MM@@@HHHXX$$$%+- .:$MMX -M@@MM%.oo;;;;;;oooooooooo---
# +?|!------oo-----!!/^&{={$=XMMM@MM@MM#H;,-+HMM@M+ /MMMX=oooo;;;;;;;;;oooooooo--
# /|!--oooooooooo---!<O=>$&{+/=%@M@M#@$-.=$@MM@@@M; %M%=oooooo;;;;;;;;;;;ooooooo-
# x|--oooooooooooo--!%%X<<</?|!,:+$+-,/H#MMMMMMM@- -,ooooooooo;;;;;;;;;;;;oooooo-
# >|-oooo;;;;oooooo-!^{O</?||!---oooo=++%%%%+/:-.!-oooooooo;;;;;;;;;;;;;;;;ooooo-
# ?-oo;;;;;;;;;;ooo--|?<^^={$8#//$$|!--------!|=|-ooooo;;;;;;;;;;;;;;;;;;;;;ooooo
# oo;;;;;;;;;;;;;ooo-!/*%>/?|!--oooo;;;;;;;;;;;;;;;;;;;;;::::;;;;;;;;;;;;;;;;oooo
# ;;;;;;;;;;;;;;;;oo-O+**%^/|!-ooo;;;;;;;;;;;;;;;:::::::::::::::::;;;;;;;;;;;;ooo
# ;;;::::::::;;;;;;o-||/+=$X<|-oo;;;;;;;;:::::::::::::::::::::::::::;;;;;;;;;;;oo
# ::::::::::::::;;;;oo-!|?<O+|-o;;;;;;::::::::::::::::::::::::::::::::;;;;;;;;;oo
# ::::::::::::::::;;;oo--|/&/=oo;;;;::::::::::::::::::::::::::::::::::::;;;;;;;;o
# :::::::::::::::::;;;;o->{X--o;;;:::::::::::::::::::::::::::::::::::::::;;;;;;;;
# :::::::::::::::::::;;o-%?-o;;;;:::::::::::::::::::::::::::::::::::::::::;;;;;;;
# ~~~~~~~~~:::::::::::;;o!/o;;;:::::::::::::::::::::::::::::::::::::::::::::;;;;;
# EOF
    cat << 'EOF'
::::::;;;;;;;;;;;;;;;;;;;;oooooooo---!|^O>/?||!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!||||||||||||||||||||||||||||||||??????????????//////<<<<<<<>>>>XX+++={O&$@O^{=+XXX>><<</////????
::::::;;;;;;;;;;;;;;;;;;;;ooooooo----!!|/$X</??||||||!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!||||||||||||?????????????????????????????????????//////<<>+X>>>>>>XX+={$$#$O{==={$O$8&$^=++#+><<</////
::::::;;;;;;;;;;;;;;;;;;;oooooooo---!!|?/<==X><<<>/??|||||||!!!!!!!!!!!!!!!!!!!!!!!!!!!!!||||||||||||||||?????/<>++<//?????????????????????????///////<<<>X{O&^==++++=^%#^%^+XXXXXXXXX+{#*$$%^+XXX>>X=OX
:::::;;;;;;;;;;;;;;;;;;;;oooooooo---!!?<////<>X+=%8+=#$/?|||||||||||||||||||||||||||||||||||||||||||?????////<<+{%X><//////???????????????/////////<<<<>>>X+^$$*&OOO%&%{=+X>>>><<<<<>>XO$++=${{$@#O@#+X>
:::::;;;;;;;;;;;;;;;;;;;;oooooooo-----!!!|||?//<XO$+><//????||||||||||||||||||||||||||||||||||????????//<#@=++=${+X><<</////////////////////////<<<<>X$===={O$$$$@&#=++=#X><<<<<//////<<<<<<>>>>X+=8${++
:::::;;;;;;;;;;;;;;;;;;;;ooooooooo-----!!!!||?<X+#=X>><<///??????????|||?????????//<<//????????????////<<>>X+=O&{+X>>><<<<<</////////////////<<<<<<>>X+=^%&#O^^8$$%=X>><<<<//////////////////<<<>+=O$%&$
:::::;;;;;;;;;;;;;;;;;;;;oooooooooo-----!!!!||??<{O+&%{X><//////?????????????///<>=OX><///////////////<<<>>XX+O$%{=+XXX>>><<<<<<<<<<<<<<<<<<<<<<>>>XX+==O&^=++XXX+={><</////????????????????///<<X^O8+XX
:::::;;;;;;;;;;;;;;;;;;;;oooooooooo------!!!!|||??/<X&#=X>><<<<<<<<</////////<<<>+%$8O>><<<<</<<<<<<<<>>>>XX++={#8#@%#=+XX>>>>>>>>><<<<<<<<<>>>>>XX+={@$&{=XX>>><<<<////???????????????????????/&X>X<///
:::::;;;;;;;;;;;;;;;;;;;;oooooooooo------!!!!|||??//<>X=%{==={++$=+={{X>><<<>>>>X+^&=+XX>>>>>>>>>>>>X+8=++++==={^O$$O{==+++++#=={*+X>>>>>>>>>>XXXX+={##{=+XX>><<<////????????|||||||||||||||||||||??????
:::::;;;;;;;;;;;;;;;;;;;;oooooooooo-----!!!!|||??//<<>X+$^+++++++={#$${++X+++^++={O%^{==++X++O{+++++={#$*O^#&#OOO#%@$%OO%@^^^#$O{=++XXXXXXXXXX+++=={O$^{++X>><<<////??????||||||||||||||||||||||||||||||
:::::;;;;;;;;;;;;;;;;;;;;oooooooooo----!!!||??/>=X>X+%==X><<<<<<>X+OO$8&@%@{^8&%^{=={{O$@O^^O@#^^O^O@$$$$$$$$*@8$8@8$$$$$$$&&$@%^{==++++++++={^&8#8%^^^%$^{%X><<///????|||||||||||!!!!!!!!!!!!!!!!!!!!!!
:::::;;;;;;;;;;;;;;;;;;;;oooooooooo---!|%<=<<=%XXX&=>X></////////<<<<>>X8XX>>>>XXXXXX++=={{{{^^O#%%&8$$$$$$$$$$$$$$$$$$$$$$$$$8&##%O{{===={^O$#O##=++XXX+=O8@=XX>//???||||||||!!!!!!!!!!!!!!!!!!!!!!!!!!
:::::;;;;;;;;;;;;;;;;;;;;;ooooooooo----!!||/O</???????????????????///////<<<<<<<>>>>>XXXX+++=={{^O#%@*$$$$$$$$$$$$$$$$$$$$$$$$$$$*&#O^^^^O#8%^{=+XX>>>>>>>>>>>X$>/???||||||!!!!!!!!!!!!!!!!!------------
:::::;;;;;;;;;;;;;;;;;;;;;oooooooooo-----!!!!||||||||||||||||||????????///////<<<<<>>>>XXX+++={^8@8$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$@&%%*@%O^^#&%+X>><<<<<///////???||||||!!!!!!!!!!!!!------------------
:::::;;;;;;;;;;;;;;;;;;;;;;ooooooooooo-------!!!!!!!!!!!|||||||||||???????//////<<<<>>>XX+++=={^O#%&8$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$&%#O{=++XX>><<<</////?????|||||||!!!!!!!!!!!----------------------
:::::;;;;;;;;;;;;;;;;;;;;;;oooooooooooo----------!!!!!!!!!!!|||||||||??????//////<<<>>X*{{{{{O$##&@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$8@#O^{=++XX>><<<////?????|||||||!!!!!!!!!!!--------------------oooo
:::::;;;;;;;;;;;;;;;;;;;;;;;ooooooooooooo-----------!!!!!!!!!!||||||||??????/////<<<>>X+{#&&$8&&@88$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*#O^{{&+X><<<////????|||||||!!!!!!!!!!------------------oooooooo
:::::;;;;;;;;;;;;;;;;;;;;;;;oooooooooooooo------------!!!!!!!!!!||||||?????/////<<<<>>XX+=={^^O#%8*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*8$%^{=+X><<<///????||||||!!!!!!!!!----------------oooooooooooo
:::::;;;;;;;;;;;;;;;;;;;;;;;;ooooooooooooooo------------!!!!!!!!|||||????/////<<<<>>XXX++=={&##%&@*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$#^{=+XX>>>><<<</??|||||!!!!!!!!!--------------ooooooooooooooo
:::::;;;;;;;;;;;;;;;;;;;;;;;;oooooooooooooooo------------!!!!!!!!||||?//<<<<<<>>>X+@{===={^^#&@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$&O^{======+{O=>//??||||!!!!!!!!-------------ooooooooooooooooo
:::::;;;;;;;;;;;;;;;;;;;;;;;;oooooooooooooooo-------------!!!!!!!||||?/XX+*=++++===^#@$@&$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*@$@*%@$#{==+++{8+>/??||||!!!!!!!-------------oooooooooooooooooo
:::::;;;;;;;;;;;;;;;;;;;;;;;;ooooooooooooooooo------------!!!!!!!||||???/<>X{O{{$^#{{{{^^O#@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$8&#O{==++=+X>><<<<<<+/?|||!!!!!!!------------oooooooooooooooooooo
:::::;;;;;;;;;;;;;;;;;;;;;;;;ooooooooooooooooo------------!!!!!!!!||||??/<X>>>>>XXX+++={O#%$8$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$8%O^=++X>><<<<////????||||!!!!!!!-----------ooooooooooooooooooo;;
::::;;;;;;;;;;;;;;;;;;;;;;;;;ooooooooooooooooo------------!!!!!!!!|||||???///<<<>>XX++={^#%@*$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$*8$&&O+X><<<////????||||||!!!!!!!-----------ooooooooooooooooo;;;;
::::;;;;;;;;;;;;;;;;;;;;;;;;;ooooooooooooooooo------------!!!!!!!!||||||????///<<>XOOO#*&@8$$$$$$$$$$$$$$$$$$$$$*@&%%%&$$&%%##%$&%88$$$8{=++XX><<<////?????||||||!!!!!!!----------oooooooooooooooo;;;;;;
::::;;;;;;;;;;;;;;;;;;;;;;;;ooooooooooooooooo-------------!!!!!!!!|||||?????///<<>>X+{O%$$$$$$8*$&&$$@&$*$$@&###%&#^^^O8%8$^{{{=={^&&$^{=++XX>><<<////?????|||||||!!!!!!!---------oooooooooooooo;;;;;;;;
::::;;;;;;;;;;;;;;;;;;;;;;;ooooooooooooooooo-------------!!!!!!!!|||||????////<<>>+==O$8$&##%$&#O^^OO^^^O@$&#^^{{===+++={O#$^+XXX++=O&O$#*=+XX>><<<<////?????||||||!!!!!!!--------ooooooooooooo;;;;;;;;;
::::;;;;;;;;;;;;;;;;;;;;;;;oooooooooooooooo-------------!!!!!!!!|||||??///<<<<>>XX+{%^{======{O*O{=++++=={^@%O{{=++XXXXXXXX>>>>>>>>XXXX+{O#{=++XX>>>><<///?????|||||||!!!!!!------oooooooooooo;;;;;;;;;;
:::;;;;;;;;;;;;;;;;;;;;;;;ooooooooooooooo-------------!!!!!!!!!|||||??/X@%#O++++=O$8{++XXXXXX+^+XXX>>XXX+O@{{^&@{+XX>>><<<<<<<<<<<<<<>>>X+{8{==O*$8#^+X>>><///???????||||||!!!-----oooooooooo;;;;;;;;;;;
:::;;;;;;;;;;;;;;;;;;;;;;oooooooooooooo--------------!!!!!!!!!||||||??//<<>X+={^@^=+XX>>>>>><<<<<<<<<<<>>>>XX+{&^=+X>><</////////////<<>=^8OX>>>>>>X{$$@*=X><<<<<<<%<<{<//<{?|!----ooooooooo;;;;;;;;;;;;
:::;;;;;;;;;;;;;;;;;;;;oooooooooooooo-------------!!!!!!!!!!!||||||????///<<>X+=^#=X>>><<<<<<<////////<<<<<>>X+=${{${><///??????????///<XOX<<//////<<>>X={{@O++{$^^X+8X<>//X^>!---ooooooooo;;;;;;;;;;;;;
:::;;;;;;;;;;;;;;;;;;;oooooooooooo-------------!!!!!!!!!!!!|||||||????///<<<>X+O^=+X><<<<//////////////////<<XOOX<<<<//??????||||||??????????????????////<<>>+*X><//???|||!!!!----oooooooo;;;;;;;;;;;;;;
::;;;;;;;;;;;;;;;;;;;;ooooooooo-----------!!!!!!!!!!!!!|||||||||?????///<>>XX+=^@*{X><<//////?????????????///>&X</????||||||||||||||||||||||||||||||?????///<O@^>/??|||!!!!-----oooooooo;;;;;;;;;;;;;;;;
::;;;;;;;;;;;;;;;;;;;oooooooo-----!!!!!!!!!!!!!!|||||||||||||??????///<<X{$&%$#^X>><<////????????????????????????|||||||||||!!!!!!!!!!!!!!!!!!||||||||||???//<X{$^/?||!!!-----ooooooooo;;;;;;;;;;;;;;;;;
::;;;;;;;;;;;;;;;;;;ooooooo---!//|||||||||||||||????????????????////<>X+=%8O{{{OX><////????????|||||||||||||||||||||!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!||||?/<X%#+><?||!!-----oooooooo;;;;;;;;;;;;;;;;;;;
::;;;;;;;;;;;;;;;;;;ooooooo---!><<XO</???//+><<<#{+</////////////<<<>>X=&=XX>>><<////???????|||||||||||||||!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!|||??/<^X<?||!!----oooooooo;;;;;;;;;;;;;;;;;;::
::;;;;;;;;;;;;;;;;;;ooooooo----!!|?/<==#{8%+XX^###OX>><<<<<<>>>>>>>>X{@OOX>><<<////??????||||||||||||!!!!!!!!!!!!!!!!!!!!!!-------------------------!!!!!!!!|||?/<$>></|!--ooooooo;;;;;;;;;;;;;;;;;;::::
::;;;;;;;;;;;;;;;;;;oooooooo----!!|?>^X///////<>X#==*^{=@#%{%$O{=&@^O*{+X>><<<///??????||||||||||!!!!!!!!!!!!!!!!!!!--------------------------------------!!!!!||/+>?|!!--ooooooo;;;;;;;;;;;;;;;;;::::::
:;;;;;;;;;;;;;;;;;;;;oooooooo----!!|?||||||||???/////<>$X><<>>>>X>>XX+=OO+><<<///?????|||||||||!!!!!!!!!!!!!!!!-----------------------------------------------!!!|>>|!--ooooooo;;;;;;;;;;;;;;;;;::::::::
:;;;;;;;;;;;;;;;;;;;;oooooooooo-----!!!!!!!!!|||||||???????//////<<<>>+%8{X>><///????||||||||!!!!!!!!!!!!!!-------------------------------ooooooooooooooo------------oooooooo;;;;;;;;;;;;;;;;;::::::::::
:;;;;;;;;;;;;;;;;;;;;;oooooooooo---------!!!!!!!!!||||||||??????////<<>>+{%^*#X//????|||||||!!!!!!!!!!!!-------------------------ooooooooooooooooooooooooooooooooooooooooo;;;;;;;;;;;;;;;;;;::::::::::::
:;;;;;;;;;;;;;;;;;;;;;;oooooooooooo----------!!!!!!!!!||||||||????///<<>X=^{X><//????||||||!!!!!!!!!!!---------------------oooooooooooooooooooooooooooooooooooooooooo;;;;;;;;;;;;;;;;;;;;:::::::::::::::
:;;;;;;;;;;;;;;;;;;;;;;oooooooooooooo-----------!!!!!!!!!||||||????/<>XX=$#{==^<//???|||||!!!!!!!!!!-------------------ooooooooooooooooooooooooooooooooooooooo;;;;;;;;;;;;;;;;;;;;;;;;::::::::::::::::::
:;;;;;;;;;;;;;;;;;;;;;;;oooooooooooooo------------!!!!!!!!!|||||????/<O+={%O+X><//???|||||!!!!!!!!!-----------------oooooooooooooooooooooooooooooooooo;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::::::::::::::::::::
:;;;;;;;;;;;;;;;;;;;;;;;;ooooooooooooooo-----------!!!!!!!!!|||||???//<>X#{+>><///???|||||!!!!!!!!----------------ooooooooooooooooooooooooooooo;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:::::::::::::::::::::::
:;;;;;;;;;;;;;;;;;;;;;;;;oooooooooooooooo-----------!!!!!!!!||||||???//>XX=$=><<///???||||!!!!!!!--------------oooooooooooooooooooooooooooo;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:::::::::::::::::::::::::::
:;;;;;;;;;;;;;;;;;;;;;;;;oooooooooooooooo------------!!!!!!!!|||||????//<<>+%+X>><<///??|||!!!!!!------------oooooooooooooooooooooooooo;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::::::::::::::::::::::::::::::
:;;;;;;;;;;;;;;;;;;;;;;;;;oooooooooooooooo-----------!!!!!!!||||||????///<>>+{^=++{^$^=/?||!!!!!------------oooooooooooooooooooooooo;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:::::::::::::::::::::::::::::::::
:;;;;;;;;;;;;;;;;;;;;;;;;;oooooooooooooooo-----------!!!!!!!|||||????///<<>X#=X><///????||!!!!!-----------ooooooooooooooooooooooo;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::::::::::::::::::::::::::::::::::::
;;;;;;;;;;;;;;;;;;;;;;;;;;oooooooooooooooo----------!!!!!!||||||????//<>O+{*=X<//???|||||!!!!!-----------oooooooooooooooooooooo;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:::::::::::::::::::::::::::::::::::::::
EOF
    echo -n $RESET
}

profile() {
    clear
    (( $PROFILE )) || return
    end=$(gdate +%s.%N 2>/dev/null || date +%s.%N)
    echo -n $ORANGE
    if [[ $(which bc 2>/dev/null) ]]; then
    dt=$(echo "$end - $start" | bc)
    dd=$(echo "$dt/86400" | bc)
    dt2=$(echo "$dt-86400*$dd" | bc)
    dh=$(echo "$dt2/3600" | bc)
    dt3=$(echo "$dt2-3600*$dh" | bc)
    dm=$(echo "$dt3/60" | bc)
    ds=$(echo "$dt3-60*$dm" | bc)
    printf "\nTotal runtime: %d:%02d:%02d:%02.4f" $dd $dh $dm $ds
    else
    start=${start%.*}
    end=${end%.*}
    dt=$(($end - $start))
    printf "Total runtime: %ds" $dt
    fi
    echo -e $RESET
}


# == Profiling End {{{1
# ==================================================================================================

# ascii
profile
source_agent

# vim: foldmethod=marker foldlevel=0

export BASH_SILENCE_DEPRECATION_WARNING=1

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
