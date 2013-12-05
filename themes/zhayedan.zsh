##############################################################################
#
# zhayedan zsh theme
#
##############################################################################

# GIT
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[cyan]%}%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} *%{$reset_color%}$(git_prompt_status)"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} =%{$reset_color%}"
 
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[red]%}!%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}+%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%}x%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}-%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%}>%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%}^%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}$%{$reset_color%}"

# Format for git_prompt_long_sha() and git_prompt_short_sha()
# ZSH_THEME_GIT_PROMPT_SHA_BEFORE="%{$fg[yellow]%}➤"
# ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="> "
ZSH_THEME_GIT_PROMPT_SHA_AFTER=""

# Colors vary depending on time lapsed.
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[cyan]%}"

# Git time since commit
ZSH_THEME_GIT_TIME_SINCE_COMMIT_BEFORE=""
ZSH_THEME_GIT_TIME_SINCE_COMMIT_AFTER=""

# SVN
ZSH_PROMPT_BASE_COLOR=""
ZSH_THEME_REPO_NAME_COLOR=""
ZSH_THEME_SVN_PROMPT_PREFIX="%{$fg[cyan]%}"
ZSH_THEME_SVN_PROMPT_SUFFIX="%{$fg[cyan]%}%{$reset_color%} "
ZSH_THEME_SVN_PROMPT_DIRTY="%{$fg[red]%} *%{$reset_color%}"
ZSH_THEME_SVN_PROMPT_CLEAN="%{$fg[green]%} =%{$reset_color%}"

# Trim working path to 1/2 of screen width
function prompt_pwd() {
    local pwd_max_len=$(($COLUMNS/2))
    local trunc_symbol="..."
    PWD="${PWD/$HOME/~}"
    if [ ${#PWD} -gt $pwd_max_len ]; then
        local pwd_offset=$(( ${#PWD} - $pwd_max_len + 3 ))
        PWD="${trunc_symbol}$PWD[$pwd_offset,${#PWD}]"
    fi
    echo "$PWD"
}

# Executes after pressing enter but before displaying the prompt
function preexec() {
    # (w) turns variable $1 into an array
    # (r) filters out variable assignment, sudo, program args
    local CMD=${1[(wr)^(*=*|sudo|-*)]}

    case $TERM in
        screen* )
            echo -ne "\ek$CMD\e\\"
            ;;
    esac
}

function prompt_on() {
    # User is colored differently based on root user
    if [ "$UID" -eq 0 ]; then
        USERCLR=$bg[red]$fg[white]
    else
        if [[ "$USER" == "$LOGNAME" ]]; then
            USERCLR=$MYCLR # host-specific color
        else 
            USERCLR=$fg[green]
        fi
    fi

    # Set terminal title
    case "$TERM" in
        xterm* )
            PR_TITLEBAR=$'%{\e]0;%n(%L): $(prompt_pwd) | %y\a%}'
            ;;
        screen* )
            PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %n(%L): $(prompt_pwd) | %y\e\\%}'
            ;;
        * )
            PR_TITLEBAR=''
            ;;
    esac

    # Set screen title
    case "$TERM" in
        screen* )
            PR_STITLE=$'%{\ek%m\e\\%}'
            ;;
        * )
            PR_STITLE=''
            ;;
    esac

    # Check battery status
    if [ $(battery_pct_remaining) ]; then
        PR_BATT='$(battery_pct_prompt)'
    else
        PR_BATT=''
    fi

    # Check active screens
    if [ $(active_screens) ]; then
        PR_SCRN='$(active_screens_prompt)'
    else
        PR_SCRN=''
    fi

    # Check background jobs
    if [ $(bg_jobs) ]; then
        PR_BGJOBS='$(bg_jobs_prompt)'
    else
        PR_BGJOBS=''
    fi
    
    # Check stopped jobs
    if [ $(st_jobs) ]; then
        PR_STJOBS='$(st_jobs_prompt)'
    else
        PR_STJOBS=''
    fi

    # Left command prompt
    # PROMPT='$PR_STITLE${(e)PR_TITLEBAR}
# %{$USERCLR%}%m(%L):${(e)PR_SCRN}${(e)PR_BGJOBS}${(e)PR_STJOBS} %{$fg[yellow]%}$(prompt_pwd)
# %{$fg[green]%}%h %{$fg[blue]%}>%{$reset_color%} '
    PROMPT='$PR_STITLE${(e)PR_TITLEBAR}$(git_prompt_info)$(svn_prompt_info)\
${(e)PR_SCRN}${(e)PR_BGJOBS}${(e)PR_STJOBS}\
%{$USERCLR%}>%{$reset_color%} '

    # Right command prompt 
    RPROMPT='${(e)PR_BATT}'

    # PS2 continuation prompt
    PS2='%{$USERCLR%}%_ >>%{$reset_color%} '
}

function prompt_off() {
    PROMPT='\$ '
}

prompt_on
