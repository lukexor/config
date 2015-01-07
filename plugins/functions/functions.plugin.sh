# ==========================================================
# == Global Bash Functions

function schk() {
	for file in $(git status|egrep 'new file|modified'|egrep '.pm|.pl' |cut -d: -f2|cut -d' ' -f4); do perl -c $file; done
}

cwa() {
    cd ${HOME}/fcs/lib/Fap/WebApp/Action/
}
cl() {
    cd ${HOME}/fcs/lib/Fap/
}

tags() {
    ctags --exclude=@${HOME}/.ctagsexclude
}

syncf() {
    scp $1 lpetherbridge@devbox5.lotsofclouds.fonality.com:~/fcs/$1
}

# Echos and executes a command
_echodo () {
  echo "$*"
  eval "$*"
}

push() {
    _echodo "scp $* cael@lp:~/"
}

pull() {
    _echodo "scp cael@lp:~/$1 ./"
}

# mkdir & cd to it
mcd() {
    mkdir -p "$1" && cd "$1";
}

hist_stats() {
    history | cut -d] -f2 | sort | uniq -c | sort -rn | head
}

wow_sync() {
    # -a: archive - recursive, preserver symlinks, permissions, times, owner, group, device files and specials
    # -u: Skip files that are newer in destination

    # Sync from Dropbox
    echo "Syncing from Dropbox"
    rsync -au "/Volumes/shadow/Dropbox/bak/wow_settings/" "/Applications/World of Warcraft/"

    # echo "Syncing to Dropbox"
    # rsync -au "/Applications/World of Warcraft/" "/Volumes/shadow/Dropbox/bak/wow_settings/"
}

dl() {
    DEVDIR="${HOME}/.devlog/"
    YEAR=$(date "+%Y")
    FILE=$(date "+%Y_%m.txt")
    if [ ! -d "${DEVDIR}/${YEAR}" ]; then
        mkdir -p "${DEVDIR}/${YEAR}"
    fi
    ENTRY=$(date "+[%Y-%m-%d %H:%M:%S] ")" $*"
    echo ${ENTRY} >> "${DEVDIR}/${YEAR}/${FILE}"
}
jl() {
    command journal "$*"
}
jls() {
    # Allow to list past 7 days
    local date
    if [[ "$1" -gt 0 ]]; then
        date=$(date --date="$1 months ago" "+%Y-%m-%d")
    else
        date=$(date "+%Y-%m-%d")
    fi
    command journal -v $date | less
}

n() {
	echo -n -e "\033]0;$*\007"
	export TERM_TITLE=$*
}

sn() {
	echo -n -e "\033k$*\033\\"
	export SCREEN_TITLE=$*
}

_xtitle_do() { # sets screen/term title and executes command
    if [[ -f "$2" ]]; then
        title="$1 $(basename $2)"
    else
        title="$*"
    fi

    case "${TERM}" in
        xterm* | rxvt ) echo -n -e "\033]0;$title\007" ;;
        screen* )      echo -n -e "\033k$title\033\\" ;;
        * ) ;;
    esac

    command "$@"

    case "${TERM}" in
        xterm* | rxvt ) echo -n -e "\033]0;${TERM_TITLE:-${HOSTNAME}}\007" ;;
        screen* )      echo -n -e "\033k${SCREEN_TITLE:-${HOSTNAME}}\033\\" ;;
        * ) ;;
    esac
}

# Title setting commands
ssh() { _xtitle_do ssh "$@"; }
vim() { _xtitle_do vim "$@"; }
less() { _xtitle_do less "$@"; }

# Grep commands
h() { if [ -z "$*" ]; then history; else history | egrep "$@"; fi; }
pg() {
    CMD=''
    case "${OSTYPE}" in
        darwin*) CMD='ps aux' ;;
        *) CMD='ps auxf' ;;
    esac

    if [ -z $1 ]; then
        ${CMD}
    else
        ${CMD} | grep $*
    fi
}

# Convert unix epoc to current timezone
unixtime() { date --date="1970-01-01 $* sec GMT"; }

# File & string-related functions:

# Find a file with a pattern in name:
ff() { find . -type f -iname '*'$*'*' -ls ; }

# Find a file with pattern $1 in name and Execute $2 on it:
fe() { find . -type f -iname '*'${1:-}'*' -exec ${2:-file} {} \;  ; }

# Find a pattern in a set of files and highlight them:
fstr() {
    OPTIND=1
    local case=""
    local usage="fstr: find string in files.
Usage: fstr [-i] \"pattern\" [\"filename pattern\"] "
    while getopts :it opt
    do
        case "$opt" in
            i) case="-i " ;;
            *) echo "$usage"; return;;
        esac
    done
    shift $(( $OPTIND - 1 ))
    if [ "$#" -lt 1 ]; then
        echo "$usage"
        return;
    fi
    find . -type f -name "${2:-*}" -print0 | \
    xargs -0 egrep --color=always -sn ${case} "$1" 2>&- | more
}

# Swap 2 filenames around, if they exist
swap() {
    local TMPFILE=tmp.$$

    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1

    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

# Process/system related functions:
sinfo() {
    echo ""
    echo -e "${FGblue}OS: ${FGgray}"`cat /etc/redhat-release`${RCLR}
    echo -e "${FGblue}Kernel: ${FGgray}" `uname -smr`${RCLR}
    echo -e "${FGblue}BASH: ${FGgray}"`bash --version|head -1`${RCLR}
    echo -e "${FGblue}VIM: ${FGgray}"`vim --version|head -1`${RCLR}
    echo -ne "${FGblue}Uptime: ${FGgray}`uptime | awk '{print $3, $4}' | tr -d ','`${RCLR}"
    echo ""; echo ""
    echo -ne "${FGblue}Hello ${FGred}${USER}${FGblue}, today is: ${FGgray}"; date; echo -e "${RCLR}"
}

myps() { ps -f $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }

ra()
{
    if ask_yes_no "Restart ssh-agent?"; then
        case "${TERM}" in
            screen* )
                echo "We're in a screen. I refuse to restart ssh-agent."
                ;;
            * )
                echo "Killing existing ssh-agent instances..."
                while [ $(ps aux | grep ssh-agent | grep -v grep | wc -l) -gt 0 ]; do
                    pkill -f ssh-agent
                done
                unset SSH_AUTH_SOCK
                unset SSH_AGENT_PID

                sourcefile "$PLUGIN_DIR/ssh-agent/ssh-agent.plugin.sh"
                ;;
        esac
    fi
}

aweb()
{
    # If default RSA key present
    [ -f "${HOME}/.ssh/webhost_key" ] && /usr/bin/ssh-add "${HOME}/.ssh/webhost_key"
}

akey()
{
	ra
    # If Aladdin etoken connected
    if [ $(system_profiler SPUSBDataType 2> /dev/null| grep OMNIKEY -c) -gt 0 ]
    then
        /usr/bin/ssh-add -s "/usr/local/lib/libaetpkss.dylib"
    fi
}

# Get current host related info
ii() {
    echo -e "\nYou are logged on ${FGblue}${HOSTNAME}${RCLR}";
    echo -e "\n${FGred}Additionnal information:${RCLR} " ; uname -a
    echo -e "\n${FGred}Users logged on:${RCLR} " ; w -h
    echo -e "\n${FGred}Current date :${RCLR} " ; date
    echo -e "\n${FGred}Machine stats :${RCLR} " ; uptime
    echo -e "\n${FGred}Memory stats :${RCLR} " ; free
    my_ip 2>&- ;
    echo -e "\n${FGred}Local IP Address :${RCLR}" ; echo ${MY_IP:-"Not connected"}
    # echo -e "\n${FGred}Public IP Address :${RCLR}" ; echo ${MY_ISP:-"Not connected"}
    # echo -e "\n${FGred}Open connections :${RCLR} "; netstat -pan --inet;
    echo
}

# Misc utilities:
ask_yes_no() {
    echo -en "${FGred}$@ [y/n] ${RCLR}" ; read ans
    case "$ans" in
        y*|Y*) return 0 ;;
        *) return 1 ;;
    esac
}

# Get name of app that created a corefile.
corename() {
    for file ; do
        echo -n $file : ; gdb --core=$file --batch | head -1
    done
}

hide() {
    defaults write com.apple.finder AppleShowAllFiles TRUE
    defaults write com.apple.finder AppleShowAllFiles FALSE

    # force changes by restarting Finder
    killall Finder
}

show() {
    defaults write com.apple.finder AppleShowAllFiles TRUE

    # force changes by restarting Finder
    killall Finder
}
