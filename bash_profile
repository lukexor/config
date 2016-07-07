# ==========================================================
# == .bash_profile
# Loaded if interactive login or non-interactive login shell

startn=$(date +%s.%N)
starts=$(date +%s)
PS1="\W > "

# ----------------------------------------------------------
# -- Source

[[ -d "/etc/profile" ]] && source "/etc/profile"
[[ -d "$HOME/.profile" ]] && source "$HOME/.profile"
case "$-" in *i*) [[ -r "$HOME/.bashrc" ]] && source "$HOME/.bashrc"; esac

# ----------------------------------------------------------
# -- Global Shell Variables

export GIT_MERGE_AUTOEDIT=no

# History
export HOSTNAME=$(hostname)
export HISTCONTROL='ignoreboth'
export HISTIGNORE='h:history:&:[bf]g:exit'
export HISTFILE="$HOME/.bhist"
export HISTFILESIZE=10000 # Number of commands saved in HISTFILE
export HISTSIZE=5000 # Number of commands saved in command history
export HISTTIMEFORMAT='[%F %a %T] ' # YYYY-MM-DD DAY HH:MM:SS

if [[ -z "$JAVA_HOME" && -x '/usr/libexec/java_home ]]' ]] ; then
	export JAVA_HOME=$(/usr/libexec/java_home)
fi
if [[ -z "$MAVEN_HOME" && -d '/usr/local/Cellar/maven/3.2.2/libexec' ]] ; then
	export MAVEN_HOME='/usr/local/Cellar/maven/3.2.2/libexec'
fi
if [[ -d "$HOME/fcs" ]] ; then
	export FON_DIR="$HOME/fcs"
	export NO_MYSQL_AUTOCONNECT=1
  pathprepend "$HOME/fcs" PERL5LIB
  if [[ ! "$HOSTNAME" =~ fcs-app ]]; then
      export FCS_DEVEL=1
			export FCS_APP_URL='http://portal.fonality.com/'
      export FCS_CP_URL='http://cp.fonality.com/'
  fi
  if [[ "$HOSTNAME" =~ devbox5 ]]; then
      export FCS_APP_URL='http://dev-app.lotsofclouds.fonality.com/'
      export FCS_CP_URL='http://dev-cp.lotsofclouds.fonality.com/'
  fi
	if [[ "$HOSTNAME" =~ zhayedan ]]; then
      export FCS_APP_URL='http://dev-app.lotsofclouds.fonality.com/'
      export FCS_CP_URL='http://dev-cp.lotsofclouds.fonality.com/'
  fi
fi
if [[ -d "$HOME/dev/tools/android-sdk-macosx/" ]]; then
	export ANDROID_HOME="$HOME/dev/tools/android-sdk-macosx/"
    pathappend "${ANDROID_HOME}/tools"
    pathappend "${ANDROID_HOME}/platform-tools"
fi

export PERL_MM_OPT='INSTALL_BASE='${HOME}'/perl5'

# Grep
export GREP_COLORS='1;32'

# Pager
export PAGER='less'

# Virtualenvwrapper
if [[ -d "$HOME/Dropbox/dev/virtualenvs" ]]; then
	export WORKON_HOME="$HOME/Dropbox/dev/virtualenvs"
fi
# Load virtualenvwrapper
if [[ -e '/usr/local/bin/python' ]]; then
    export VIRTUALENVWRAPPER_PYTHON='/usr/local/bin/python'
else
    export VIRTUALENVWRAPPER_PYTHON='/usr/bin/python'
fi

# Fix YCM with vim
# export DYLD_FORCE_FLAT_NAMESPACE=1

# ----------------------------------------------------------
# -- Global Paths

if [[ -d "$HOME/lib" ]]; then
	for dir in $(find "$HOME/lib" -type d -name perl*); do
		pathprepend $dir PERL5LIB
	done
fi
if [[ -d "$HOME/bin" ]]; then
    for dir in $(find "$HOME/bin" -type d -name bin); do
        pathprepend $dir
    done
fi

pathprepend "/opt/local/man" MANPATH

pathprepend "${MAVEN_HOME}/bin"
pathprepend "${JAVA_HOME}/bin"
pathprepend "/usr/local/bin"
pathprepend "$HOME/.rvm/bin"
pathprepend "$HOME/opt/bin"
pathprepend "$HOME/fcs/bin"
pathprepend "$HOME/bin/fon"
pathprepend "$HOME/bin"
pathappend "/var/adm/bin-5.0"
pathappend "/usr/local/bin-5.0"
pathappend "/opt/local/sbin"
pathappend "/opt/local/bin"

pathprepend '/usr/git-2.2.2/perl' PERL5LIB
pathprepend "$HOME/perl5/lib/perl5/" PERL5LIB
pathprepend "$HOME/perl5/lib" PERL5LIB
pathprepend "$HOME/fcs/lib" PERL5LIB
pathprepend "$HOME/lib" PERL5LIB

pathappend "$HOME/perl5/lib/perl5/" GITPERLLIB
pathappend "$HOME/perl5/perlbrew/perls/perl-5.16.0/lib/site_perl/5.16.0/App/gh" GITPERLLIB

# ----------------------------------------------------------
# -- Inputrc

if [[ -z "$INPUTRC" && ! -f "$HOME/.inputrc" ]]; then
    INPUTRC='/etc/inputrc'
fi
export INPUTRC

# ----------------------------------------------------------
# -- Time profiling

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
