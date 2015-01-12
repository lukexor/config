# ==========================================================
# == .bash_profile
# Loaded if interactive login or non-interactive login shell

# Functions to help us manage paths.  Second argument is the name of the
# path variable to be modified (default: PATH)
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

# pathadd() {
#     [[ $BASH_VERSINFO > 3 ]] && shopt -s compat31
#     [ -d "${1}" ] && [[ ! "$PATH" =~ "(^|:)$1(:|$)" ]] && PATH="$1":"$PATH"
# }

# ----------------------------------------------------------
# -- Global Shell Variables

# History
export HISTCONTROL="ignoreboth"
export HISTIGNORE="h:history:&:[bf]g:exit"
export HISTFILE="${HOME}/.bhist"
export HISTFILESIZE="10000" # Number of commands saved in HISTFILE
export HISTSIZE="1000" # Number of commands saved in command history
export HISTTIMEFORMAT="[%F %a %T] " # YYYY-MM-DD DAY HH:MM:SS
# export JAVA_HOME="/usr"
if [[ -z "$JAVA_HOME" && -x /usr/libexec/java_home ]] ; then
	export JAVA_HOME=$(/usr/libexec/java_home)
fi
if [[ -d /usr/local/Cellar/maven/3.2.2/libexec ]] ; then
	export MAVEN_HOME=/usr/local/Cellar/maven/3.2.2/libexec
fi
if [[ -d ${HOME}/fcs ]] ; then
	export FON_DIR=${HOME}/fcs
fi

# Grep
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="1;32"

# Pager
export PAGER="less"

# Virtualenvwrapper
if [ -d "${HOME}/Dropbox/dev/virtualenvs" ]; then
	export WORKON_HOME=${HOME}/Dropbox/dev/virtualenvs
fi

# Fix YCM with vim
# export DYLD_FORCE_FLAT_NAMESPACE=1

# ----------------------------------------------------------
# -- Host-Specific Shell Variables

case "${HOSTNAME}" in
  tech ) export CPVER=5; export PERLLIB=/code-5.0/ ;;
  zhayedan ) export GITPERLLIB=${HOME}/perl5/lib/perl5/:${HOME}/perl5/perlbrew/perls/perl-5.16.0/lib/site_perl/5.16.0/App/gh ;;
esac

# ----------------------------------------------------------
# -- Global Paths

if [ -d "${HOME}/lib" ]; then
	for dir in $(find "${HOME}/lib" -type d -name perl*); do
		pathprepend $dir PERL5LIB
	done
fi

if [ -d "${HOME}/fcs/lib" ]; then
    pathappend "${HOME}/fcs/lib" PERL5LIB
    export FON_DIR="${HOME}/fcs"
    export FCS_DEVEL=1
	export NO_MYSQL_AUTOCONNECT=1
fi

pathprepend "${HOME}/.rvm/bin"
pathprepend "/usr/local/bin"
pathprepend "${HOME}/fcs/bin"

if [ -d "${HOME}/bin" ]; then
    for dir in $(find "${HOME}/bin" -type d -name bin); do
        pathprepend $dir
    done
fi

pathprepend "${HOME}/opt/bin"
pathprepend "${HOME}/bin"

# ----------------------------------------------------------
# -- Host-Specific Paths

pathprepend ${HOME}/bin/fon
pathappend /var/adm/bin-5.0
pathappend /usr/local/bin-5.0

# ----------------------------------------------------------
# -- Java
pathprepend "${MAVEN_HOME}/bin"
pathprepend "${JAVA_HOME}/bin"

# ----------------------------------------------------------
# -- MacPorts Installer addition on 2014-05-14_at_09:06:16: adding an appropriate PATH variable for use with MacPorts.
# export PATH=/opt/local/bin:/opt/local/sbin:$PATH
pathprepend "/opt/local/sbin"
pathprepend "/opt/local/bin"
# Finished adapting your PATH environment variable for use with MacPorts.

# ----------------------------------------------------------
# -- Inputrc

if [ -z "${INPUTRC}" -a ! -f "${HOME}/.inputrc" ]; then
    INPUTRC="/etc/inputrc"
fi
export INPUTRC

# ----------------------------------------------------------
# -- Cleanup

# unset pathremove
# unset pathappend
# unset pathprepend

# ----------------------------------------------------------
# -- Source

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

[ -d "${HOME}/.profile" ] && . "${HOME}/.profile"
case "$-" in *i*) [ -r "${HOME}/.bashrc" ] && . "${HOME}/.bashrc"; esac
# pathprepend "${HOME}/vagrant_dir/fcs-f" PERL5LIB
