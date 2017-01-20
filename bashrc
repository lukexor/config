# == Start Profiling {{{1
# ==================================================================================================

startn=$(date +%s)
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

# == Environment {{{1
# ==================================================================================================

# History
HISTCONTROL="erasedups"  # Erase duplicates in history before saving current command
HISTIGNORE='h:history:&:[bf]g:exit'
HISTFILESIZE=100000 # Number of lines saved in HISTFILE
HISTSIZE=10000 # Number of commands saved in command history
HISTTIMEFORMAT='[%F %a %T] ' # YYYY-MM-DD DAY HH:MM:SS

pathprepend "/usr/local/bin"

# local::lib
pathprepend "$HOME/perl5/bin"; export PATH;
pathprepend "$HOME/perl5/lib/perl5/" PERL5LIB; export PERL5LIB;
pathprepend "$HOME/perl5" PERL_LOCAL_LIB_ROOT; export PERL_LOCAL_LIB_ROOT;
pathprepend "$HOME/perl5/lib/perl5/" GITPERLLIB; export GITPERLLIB;

if [ -d $HOME/lib/fcs ]; then
	export FON_DIR="$HOME/lib/fcs"
	export FCS_DEVEL=1
	export NO_MYSQL_AUTOCONNECT=1
	export FCS_APP_URL='http://dev-app.lotsofclouds.fonality.com/'
	export FCS_CP_URL='http://dev-cp.lotsofclouds.fonality.com/'
	# export NF_API_URL='https://swagger-arch.fonality.com:10113/'
	export NF_API_URL='http://sandbox-nf.lax01.fonality.com:10113/'
	pathprepend "$FON_DIR/bin"
	pathprepend "$FON_DIR/lib" PERL5LIB
fi

if [[ -d "$HOME/dev/tools/android-sdk-macosx/" ]]; then
	export ANDROID_HOME="$HOME/dev/tools/android-sdk-macosx/"
	pathappend "${ANDROID_HOME}/tools"
	pathappend "${ANDROID_HOME}/platform-tools"
fi

# Home directory
pathprepend "$HOME/.rvm/bin"
pathprepend "$HOME/bin"
pathprepend "$HOME/lib" PERL5LIB

export PERL_MB_OPT="--install_base \"$HOME/perl5\""
export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"

export HOSTNAME
export EDITOR="vim"
export WORKON_HOME="$HOME/.virtualenvs"
export WALLPAPER_PATH="$HOME/Pictures/girls/wallpaper/"
export WALLPAPER_INTERVAL=300
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

# Exit if not interactive
case "$-" in
	*i* )
		;;
	* )
		return
		;;
esac



# == Sources {{{1
# ==================================================================================================

sourcefile "$HOME/.secure/nas_info"
sourcefile "$HOME/.fzf.bash"
[[ `which dircolors >/dev/null 2>&1` ]] && eval $(dircolors ~/.dircolors) > /dev/null

# == Colors {{{1
# ==================================================================================================

if tput setaf 1 &> /dev/null; then
  tput sgr0
  if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
    # Changed these colors to fit Solarized theme
    RED=$(tput setaf 125)
    GREEN=$(tput setaf 64)
    ORANGE=$(tput setaf 166)
    BLUE=$(tput setaf 33)
    PURPLE=$(tput setaf 61)
    CYAN=$(tput setaf 87)
    WHITE=$(tput setaf 244)
  else
    RED=$(tput setaf 1)
    GREEN=$(tput setaf 2)
    ORANGE=$(tput setaf 3)
    BLUE=$(tput setaf 4)
    PURPLE=$(tput setaf 5)
    CYAN=$(tput setaf 6)
    WHITE=$(tput setaf 7)
  fi
  BOLD=$(tput bold)
  RESET=$(tput sgr0)
else
  MAGENTA="\033[1;31m"
  ORANGE="\033[1;33m"
  GREEN="\033[1;32m"
  PURPLE="\033[1;35m"
  WHITE="\033[1;37m"
  BOLD=""
  RESET="\033[m"
fi

export MAGENTA
export ORANGE
export GREEN
export PURPLE
export WHITE
export BOLD
export RESET

# == Shell Options {{{1
# ==================================================================================================

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
if [[ -d "$FON_DIR" ]]; then
	alias wa="cd $FON_DIR/lib/Fap/WebApp/Action/"
	alias f="cd $FON_DIR/lib/Fap/"
	alias dbregen="perl -I$FON_DIR/lib $FON_DIR/bin/tools/database/regenerate_DBIx"
fi
if [[ -d "$HOME/Dropbox/dev" ]]; then
	export DEVHOME="$HOME/Dropbox/dev"
	alias s="cd $DEVHOME/websites/"
	alias d="cd $DEVHOME"
	alias ios="cd $DEVHOME/ios"
fi

# System
alias u='history -n'	# Sync history from other terminals
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
alias topm='ps -eo pcpu,pmem,pid,user,args | sort -k 1 -r | head -10 | cut -d- -f1;ps -eo pmem,pcpu,pid,user,args | sort -k 1 -r | head -10 | cut -d- -f1';
alias which='type -a'
alias x='extract.sh'
alias tm='tm.sh'
alias mnas="sudo mount -t cifs -o username=$NAS_USER,password=$NAS_PW,port=$NAS_PORT //$NAS_IP/NAS /mnt/NAS"

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
  colorflag="--color"
else # OS X `ls`
  colorflag="-G"
fi

alias ls="command ls -hF $colorflag" # Add colors for filetype recognition
alias ll='ls -lh' # Long listing
alias la='ls -lhA' # Show hidden files (minus . and ..)
alias lsd='ls -l | grep "^d"' # List only directories

alias lx='ls -lXB' # Sort by extension
alias lk='ls -lSr' # Sort by size, biggest last
alias lc='ls -ltcr' # Sort by and show change time, most recent last
alias lu='ls -ltur' # Sort by and show access time, most recent last
alias lt='ls -ltr' # Sort by date, most recent last
alias lle='ls -lhA | less' # Pipe through 'less'
alias lr='ls -lR' # Recursive ls



# == Functions {{{1
# ==================================================================================================

nb() {
	pkill -f random_wallpaper_switcher > /dev/null 2>&1
	(nohup /usr/bin/env perl $HOME/bin/random_wallpaper_switcher.pl >> /tmp/random_wallpaper_switcher.log 2>&1 &)
}
cb() {
	PS3="Please choose your wallpaper set: "
	options=("Girls" "Erotic" "Geek" "Nature" "All SFW" "All Girls")
	select opt in "${options[@]}"
	do
		case $opt in
		"Girls")
			WALLPAPER_PATH=$HOME/Pictures/girls/wallpaper
			break
			;;
		"Erotic")
			WALLPAPER_PATH=$HOME/Pictures/girls/nude
			break
			;;
		"Geek")
			WALLPAPER_PATH=$HOME/Pictures/images/desktop_wallpapers/geek
			break
			;;
		"Nature")
			WALLPAPER_PATH=$HOME/Pictures/images/desktop_wallpapers/nature
			break
			;;
		"All SFW")
			WALLPAPER_PATH=$HOME/Pictures/images/desktop_wallpapers/
			break
			;;
		"All Girls")
			WALLPAPER_PATH=$HOME/Pictures/girls/wallpaper:$HOME/Pictures/girls/nude
			break
			;;
		*)
			echo "Not a valid option"
			;;
		esac
	done
	nb
}
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
	echo -en "${MAGENTA}$@ [y/n] ${RESET}" ; read ans
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
	if [ ! -z $SSH_AGENT_PID ]; then
		if [ ! -z $1 ] || _ask_yes_no "Restart ssh-agent?"; then
			rm -f /tmp/ssh-agent-$HOSTNAME
			unset SSH_AUTH_SOCK
			unset SSH_AGENT_PID
			pkill -f ssh-agent
		fi
	fi
	echo `ssh-agent -s -a /tmp/ssh-agent-$HOSTNAME` >| /tmp/ssh-agent-$HOSTNAME-info
	source /tmp/ssh-agent-$HOSTNAME-info
}
arsa() {
	ra
	[[ -f "$HOME/.ssh/id_rsa" ]] && ssh-add "$HOME/.ssh/id_rsa"
}
akey() {
	ra 1
	if [ $(system_profiler SPUSBDataType 2> /dev/null| grep OMNIKEY -c) -gt 0 ]; then
		ssh-add -s '/usr/local/lib/libaetpkss.dylib'
	fi
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
BASH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="${ORANGE}"

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

	echo -e "$BOLD"
	if [[ ! $TERM =~ screen ]]; then
		echo -ne "$WHITE$(date +'%F %R')$WHITE "
	fi
	if [[ $PS1_HOST ]]; then
		echo -ne "$GREEN$USER$WHITE @ $RED$PS1_HOST "
	fi
	echo -e "$ORANGE$(prompt_pwd)$RESET"

	if [[ $(declare -f bg_jobs) && $(bg_jobs) ]]; then
		echo -ne "$WHITE[$ORANGE$(bg_jobs)$WHITE] "
	fi
	if [[ $(declare -f st_jobs) && $(st_jobs) ]]; then
		echo -ne "$WHITE{$RED$(st_jobs)$WHITE} "
	fi
	if [[ $(declare -f parse_git_branch) && $(parse_git_branch) ]]; then
		echo -e "$WHITE($BLUE$(parse_git_branch)$WHITE) "
	fi
}
PS1="\$ "
PS2=">> "

prompt_off() {
	PROMPT_COMMAND=""
	PS1='$(prompt_pwd) > '
}

PROMPT_COMMAND="history -a; prompt_on"


# == End Profiling {{{1
# ==================================================================================================

endn=$(date +%s)
ends=$(date +%s)
if [[ $(which bc 2>/dev/null) ]]; then
	dt=$(echo "$endn - $startn" | bc)
	dd=$(echo "$dt/86400" | bc)
	dt2=$(echo "$dt-86400*$dd" | bc)
	dh=$(echo "$dt2/3600" | bc)
	dt3=$(echo "$dt2-3600*$dh" | bc)
	dm=$(echo "$dt3/60" | bc)
	ds=$(echo "$dt3-60*$dm" | bc)
	printf "${GREEN}Total runtime: %d:%02d:%02d:%02.4f$RESET" $dd $dh $dm $ds
else
	dt=$(($ends - $starts))
	printf "${GREEN}Total runtime: %ds$RESET" $dt
fi

# }}}
