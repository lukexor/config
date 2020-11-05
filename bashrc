# == Profiling Start {{{1
# ==================================================================================================

# Turns profiling on or off
PROFILE=0
(( $PROFILE )) && start=$(gdate +%s.%N 2>/dev/null || date +%s 2>/dev/null)

# == Utility Functions {{{1
# ==================================================================================================

sourcefile() { [[ -r "$1" ]] && source $1; }
hascmd() { [[ $(which "$1" 2> /dev/null) ]] && [[ $? -eq 0 ]]; }

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

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
sourcefile "$HOME/.secure/secure.sh"
for file in ~/.bashrc.d/*.bashrc; do
    sourcefile "${file}"
done

# == ENV Variables {{{1
# ==================================================================================================

# Golang
pathprepend "/usr/local/go/" GOROOT
pathprepend "$HOME/dev/" GOPATH

# PATH
pathprepend "/usr/local/go/bin"
pathprepend "/usr/local/bin"
pathprepend "$GOPATH/bin"
pathprepend "$HOME/.cargo/bin"
pathprepend "$HOME/www/luke_web/bin"
pathprepend "$HOME/bin"

# Node/NVM
export NVM_DIR="$HOME/.nvm"
sourcefile "/usr/local/opt/nvm/nvm.sh"
sourcefile "/usr/local/opt/nvm/etc/bash_completion.d/nvm"

# == Bash Settings {{{1
# ==================================================================================================

# History
export HISTCONTROL="ignoreboth"     # Ignore commands starting with a space and duplicate commands
export HISTFILESIZE=100000          # Number of lines saved in HISTFILE
export HISTSIZE=2000                # Number of commands saved in command history
export HISTTIMEFORMAT='[%F %a %T] ' # YYYY-MM-DD DAY HH:MM:SS

# Misc
export EDITOR="vim"
export LANG="en_US.UTF-8"
export FZF_DEFAULT_COMMAND='(rg --files || ag --hidden -p ~/.gitignore -g "") 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Required by latest macOS
export BASH_SILENCE_DEPRECATION_WARNING=1

# Bash 4.00 specific options
if [[ $BASH_VERSINFO > 3 ]]; then
    shopt -s autocd          # Allow cding to directories by typing the directory name
    shopt -s checkjobs       # Defer exiting shell if any stopped or running jobs
    shopt -s dirspell        # Attempts spell correction on directory names
fi

shopt -s cdable_vars             # Allow passing directory vars to cd
shopt -s cdspell                 # Correct slight mispellings when cd'ing
shopt -s checkhash               # Try to check hash table before path search
shopt -s cmdhist                 # Saves multi-line commands to history
shopt -s expand_aliases          # Allows use of aliases
shopt -s extglob                 # Extended pattern matching
shopt -s extquote                # String quoting within parameter expansions
shopt -s histappend              # Append history from a session to HISTFILE instead of overwriting
shopt -s no_empty_cmd_completion # Don't try to path search on an empty line
shopt -s nocaseglob              # Case insensitive pathname expansion
shopt -s progcomp                # Programmable completion capabilities
shopt -s promptvars              # Expansion in prompt strings

# Prevent clobbering of files with redirects
set -o noclobber

# == Colors {{{1
# ==================================================================================================

if tput colors &> /dev/null; then
  tput sgr0
  if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
    export BLACK=$(tput setaf 0)
    export RED=$(tput setaf 1)
    export GREEN=$(tput setaf 2)
    export ORANGE=$(tput setaf 166)
    export BLUE=$(tput setaf 4)
    export PURPLE=$(tput setaf 10)
    export CYAN=$(tput setaf 9)
    export YELLOW=$(tput setaf 3)
    export WHITE=$(tput setaf 15)
    export GRAY=$(tput setaf 7)
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
if hascmd gdu; then
  alias du="gdu -kh"
else
  alias du="du -kh"
fi
alias diskspace="du -S | sort -n -r | more"
alias folders="find . -maxdepth 1 -type d -print | xargs du -skh | sort -rn"
alias df='df -kh' # Human readable in 1K block sizes with file system type
alias stop='kill -STOP'

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

# Rust
alias cc='cargo clippy'
alias ct='cargo test'
alias cb='cargo build'
alias cr='cargo run'
alias cre='cargo run --example'
alias cbr='cargo build --release'
alias crr='cargo run --release'

# RPM
alias rpmi='rpm -ivh' # install rpm
alias rpmls='rpm -qlp' # list rpm contents
alias rpminfo='rpm -qip' # list rpm info

# Edit configurations
alias vb="pushd $HOME/.dotfiles/ >> /dev/null; vi $HOME/.dotfiles/bashrc; popd >> /dev/null"
alias vbp="pushd $HOME/.dotfiles/ >> /dev/null; vi $HOME/.dotfiles/bash_profile; popd >> /dev/null"
alias vrc="pushd $HOME/.dotfiles/ >> /dev/null; vi $HOME/.dotfiles/vimrc; popd >> /dev/null"

# SSH
alias slp="ssh lp"
alias sshl='ssh-add -L' # List ssh-agent identities

# Sourcing
alias b="source $HOME/.bashrc"
alias bp="source $HOME/.bash_profile"

# Kubernetes
alias k="kubectl"

# Misc
if hascmd gdate; then
  alias date='gdate';
fi
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
alias gb='GIT_PAGER= git branch -v'
alias gbm='GIT_PAGER= git branch -v --merged'
alias gbnm='GIT_PAGER= git branch -v --no-merged'
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
alias gp='git prune && git remote prune origin'
alias gpl='git pull'
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
purge_git() {
    if _ask_yes_no "Fully purge $1 from repo?"; then
        git filter-branch --force --index-filter "git rm --cached --ignore-unmatch $1" --prune-empty --tag-name-filter cat -- --all
    fi
}
myip() {
    wget http://ipecho.net/plain -O - -q; echo
}
ssh() {
    TERM=${TERM/tmux/screen}
    command ssh "$@"
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

myps() { ps -f $@ -u $USER -o pid,%cpu,%mem,bsdtime,command | more ; }

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
drsa() {
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
gmm() {
  branch=$(current_branch)
  echo "Merging main into $branch"
  echo "gco main && gpl && gco $branch && gm main  -m \"Merge branch 'main' into $branch\""
  gco main && gpl && gco $branch && gm main -m "Merge branch 'main' into $branch"
}
gh() {
    echo "Git Help:"
    echo "  Git Status Symbols:"
    echo "    * : Local changes"
    echo "    + : Changes staged"
    echo "    ? : Untracked files"
    echo "    ! : Ahead/Diverged origin"
    echo "    ^ : Behind origin"
}
# Checkout a ticket branch
gbt() { git checkout tickets/$@; }
gbtn() { git checkout -b tickets/$@; }
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
parse_git_branch() {
  BRANCH=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
  STATUS=$(git status --porcelain 2> /dev/null)
  BSTATUS=$(git status --porcelain -b 2> /dev/null | rg 'ahead|diverged|behind')

  shopt -u nocasematch
  shopt -u nocaseglob

  CHANGES=""
  if [[ ! -z $STATUS ]]; then
    if [[ $STATUS =~ [[:space:]][AMD][[:space:]] ]]; then
      CHANGES="$CHANGE*"
    fi
    if [[ $STATUS =~ [AMD][[:space:]]{2} ]]; then
      CHANGES="$CHANGES+"
    fi
    if [[ $STATUS =~ [?]{2} ]]; then
      CHANGES="$CHANGES?"
    fi
  fi

  if [[ ! -z $BSTATUS ]]; then
    if [[ $BSTATUS =~ "ahead" ]] || [[ $BSTATUS =~ "diverged" ]]; then
      CHANGES="$CHANGES!"
    fi
    if [[ $BSTATUS =~ "behind" ]]; then
      CHANGES="$CHANGES^"
    fi
  fi

  if [[ ! -z $BRANCH ]]; then
    if [[ ! -z $CHANGES ]]; then
      CHANGES=" $CHANGES"
    fi
    echo " ($BRANCH$CHANGES)"
  else
    echo ""
  fi
  shopt -s nocasematch
  shopt -s nocaseglob
}

# == Prompt {{{1
# ==================================================================================================

PROMPT_DIRTRIM=2
PS1="\[$GRAY\][\A] \[$BLUE\]\w\[$YELLOW\]\$(parse_git_branch) \[$RESET\]\$ "

PROMPT_COMMAND="history -a;"

profile() {
    (( $PROFILE )) || return
    clear
    end=$(gdate +%s.%N 2>/dev/null || date +%s 2>/dev/null)
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
