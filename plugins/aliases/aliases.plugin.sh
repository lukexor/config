# ==========================================================
# == Global Bash Aliases

# Directory aliases
alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias cdot="cd ${HOME}/.dotfiles"

alias vbr='sudo /Library/StartupItems/VirtualBox/VirtualBox restart'

# Yum
alias ys='yum search' # search package
alias yp='yum info' # show package info
alias yl='yum list' # list packages
alias yli='yum list installed' # print all installed packages
alias ywp='yum whatprovides' # find what yum package provides file

alias yu='sudo yum update' # upgrate packages
alias yi='sudo yum install' # install package
alias yr='sudo yum remove' # remove package
alias yrl='sudo yum remove --remove-leaves' # remove package and leaves
alias yc='sudo yum clean all' # clean cache

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

# Prevents clobbering of files
alias rm='rm -i'
alias cp='cp -ia'
alias mv='mv -i'
alias md='mkdir -p' # Make sub-directories as needed
alias rd='rmdir'

# System related
alias _='sudo'
alias du='du -kh' # Human readable in 1K block sizes
alias df='df -kh' # Human readable in 1K block sizes with file system type
alias stop='kill -STOP'

# Editing - All roads lead to vim
alias vi='vim'
alias svi='sudo vim'
alias nano='vim'
alias emacs='vim'

# Edit configurations
alias vv="vi ${HOME}/.vimrc"
alias vvrc="vi ${HOME}/.vim-runtime/vimrc"
alias vbo="vi ${HOME}/.bash_logout"
alias vbp="vi ${HOME}/.bash_profile"
alias vb="vi ${HOME}/.bashrc"
alias vba="vi ${HOME}/.plugins/aliases/aliases.plugin.sh"
alias vbf="vi ${HOME}/.plugins/functions/functions.plugin.sh"
alias vbt="vi ${HOME}/.themes/zhayedan.sh"
alias vbh="vi ${HOME}/.plugins/host/${HOSTNAME}.plugin.sh"
alias vs="vi ${HOME}/.screenrc"

# Networking
alias fixroute='sudo route -nv add -net 10.0.0.0/8 -interface jnc0';
alias ftp='ftp -i' # Turns off interactive prompts
alias slp="ssh lp"
alias sshl='ssh-add -L' # List ssh-agent identities
alias st='ssh -A lpetherbridge@tech.fonality.com'
alias st2='ssh -A lpetherbridge@tech2.fonality.com'
alias sw2='ssh -A lpetherbridge@web-dev2.fonality.com'
alias sfcs='ssh -A lpetherbridge@devbox5.lotsofclouds.fonality.com'
alias sfcsqa='ssh -A lpetherbridge@qa-app.lotsofclouds.fonality.com'
alias sfcsstg='ssh -A lpetherbridge@stg-app.lotsofclouds.fonality.com'

# Sourcing
alias b='source ${HOME}/.bashrc'
alias bp='source ${HOME}/.bash_profile'
alias sa="source ${HOME}/.ssh/ssh-agent-${HOSTNAME}"

# Screen
alias scls='screen -ls'
alias scr='screen -DR'
alias scm='screen -S "main"'

# Misc
alias g='grep -in'
alias da='date "+%Y-%m-%d %H:%M:%S"'
alias which='type -a'
alias tl='tail -f ~/tmp/log4perl.log'
alias path='echo -e ${PATH//:/"\n"}'
alias topmem='ps -eo pmem,pcpu,pid,user,args | sort -k 1 -r | head -20';
alias x='extract'
alias offenders='uptime;ps aux | perl -ane"print if \$F[2] > 0.9"'

# ls
if [[ $(uname) == 'Darwin' ]]; then
    alias ls='ls -hFG' # Add colors for filetype recognition
else
    alias ls='ls -hF --color=tty'
fi
alias ll='ls -l' # Long listing
alias la='ls -Al' # Show hidden files
alias lx='ls -lXB' # Sort by extension
alias lk='ls -lSr' # Sort by size, biggest last
alias lc='ls -ltcr' # Sort by and show change time, most recent last
alias lu='ls -ltur' # Sort by and show access time, most recent last
alias lt='ls -ltr' # Sort by date, most recent last
alias lle='ls -al | less' # Pipe through 'less'
alias lr='ls -lR' # Recursive ls
