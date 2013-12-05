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
        local PATHVARIABLE=${2:-PATH}
        export $PATHVARIABLE="$1${!PATHVARIABLE:+:${!PATHVARIABLE}}"
}
pathappend () {
        pathremove $1 $2
        local PATHVARIABLE=${2:-PATH}
        export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
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
export AWS_RDS_HOME="${HOME}/bin/rdscli"
export JAVA_HOME="/usr"
export AWS_CREDENTIAL_FILE="${AWS_RDS_HOME}/fcs-aws-credential"

# Grep
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="1;32"

# Pager
export PAGER="less"

# ----------------------------------------------------------
# -- Host-Specific Shell Variables

case "${HOSTNAME}" in
  tech ) export CPVER=5; export PERLLIB=/code-5.0/ ;;
  zhayedan ) export GITPERLLIB=${HOME}/perl5/perlbrew/perls/perl-5.16.0/lib/site_perl/5.16.0/App/gh ;;
esac

# ----------------------------------------------------------
# -- Global Paths

if [ -d "${HOME}/fcs/lib" ]; then
    export PERL5LIB="${HOME}/fcs/lib${PERL5LIB:+:$PERL5LIB}"
fi

if [ -d "${HOME}/lib" ]; then
    export PERL5LIB="${HOME}/lib${PERL5LIB:+:$PERL5LIB}"
fi

if [ -d "/usr/local/bin" ]; then
    pathprepend "/usr/local/bin"
fi
if [ -d "${HOME}/fcs/bin" ]; then
    pathprepend "${HOME}/fcs/bin"
fi
if [ -d "${HOME}/bin" ]; then
    for dir in $(find "${HOME}/bin" -type d -name bin); do
        pathprepend $dir
    done
fi
if [ -d "${HOME}/opt/bin" ]; then
    pathprepend "${HOME}/opt/bin"
fi
if [ -d "${HOME}/bin" ]; then
    pathprepend "${HOME}/bin"
fi

# ----------------------------------------------------------
# -- Host-Specific Paths

case "${HOSTNAME}" in
    tech )
        if [ -d "${HOME}/bin/fon" ]; then
            pathprepend ${HOME}/bin/fon
        fi
        if [ -d "/var/adm/bin-5.0" ]; then
            pathappend /var/adm/bin-5.0
        fi
        if [ -d "/usr/local/bin-5.0" ]; then
            pathappend /usr/local/bin-5.0
        fi
        ;;
esac

# ----------------------------------------------------------
# -- Inputrc

if [ -z "${INPUTRC}" -a ! -f "${HOME}/.inputrc" ]; then
    INPUTRC="/etc/inputrc"
fi
export INPUTRC

# ----------------------------------------------------------
# -- Cleanup

unset pathremove
unset pathappend
unset pathprepend

# ----------------------------------------------------------
# -- Source

[ -d "${HOME}/.profile" ] && . "${HOME}/.profile"
case "$-" in *i*) [ -r "${HOME}/.bashrc" ] && . "${HOME}/.bashrc"; esac
