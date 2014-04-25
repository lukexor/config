# ==========================================================
# == zhayedan bash theme

# GIT
BASH_THEME_GIT_PROMPT_PREFIX=" ${FGcyan}["
BASH_THEME_GIT_PROMPT_SUFFIX="${FGcyan}]${RCLR}"
BASH_THEME_GIT_PROMPT_CLEAN="${FGgreen} =${RCLR}"

BASH_THEME_GIT_PROMPT_AHEAD="$FGbred}!${RCLR}"

BASH_THEME_GIT_PROMPT_ADDED="${FGgreen}+${RCLR}"
BASH_THEME_GIT_PROMPT_MODIFIED="${FGblue}x${RCLR}"
BASH_THEME_GIT_PROMPT_DELETED="${FGred}-${RCLR}"
BASH_THEME_GIT_PROMPT_RENAMED="${FGmagenta}>${RCLR}"
BASH_THEME_GIT_PROMPT_UNMERGED="${FGyellow}^${RCLR}"
BASH_THEME_GIT_PROMPT_UNTRACKED="${FGcyan}.${RCLR}"

# Format for git_prompt_long_sha() and git_prompt_short_sha()
BASH_THEME_GIT_PROMPT_SHA_BEFORE=" ${FGyellow}"
BASH_THEME_GIT_PROMPT_SHA_AFTER="${RCLR}"

# Colors vary depending on time lapsed.
BASH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="${FGgreen}"
BASH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="${FGyellow}"
BASH_THEME_GIT_TIME_SINCE_COMMIT_LONG="${FGred}"
BASH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="${FGcyan}"

# Git time since commit
BASH_THEME_GIT_TIME_SINCE_COMMIT_BEFORE=""
BASH_THEME_GIT_TIME_SINCE_COMMIT_AFTER=""

# SVN
PROMPT_BASE_COLOR=""
BASH_THEME_REPO_NAME_COLOR=""
BASH_THEME_SVN_PROMPT_PREFIX=" ${FGcyan}["
BASH_THEME_SVN_PROMPT_SUFFIX="${FGcyan}]${RCLR}"
BASH_THEME_SVN_PROMPT_DIRTY="${FGred} *${RCLR}"
BASH_THEME_SVN_PROMPT_CLEAN="${FGgreen} =${RCLR}"
BASH_THEME_SVN_PROMPT_REV_BEFORE=" ${FGyellow}"
BASH_THEME_SVN_PROMPT_REV_AFTER="${RCLR}"

# Trim working path to 1/2 of screen width
function prompt_pwd() {
    local pwd_max_len=$(($(tput cols) / 2))
    local trunc_symbol="..."
    PWD="${PWD/$HOME/~}"
    if [ ${#PWD} -gt ${pwd_max_len} ]
    then
        local pwd_offset=$(( ${#PWD} - ${pwd_max_len} + 3 ))
        PWD="${trunc_symbol}${PWD[${pwd_offset},${#PWD}]}"
    fi
    echo -e " ${PWD}"
}

function prompt_on() {
    # User is colored differently based on root user
    if [ "${UID}" -eq 0 ]
    then
        PR_CLR="${BGred}${FGwhite}"
    else
        if [[ "${USER}" == "${LOGNAME}" ]]
        then
            PR_CLR="${RCLR}${FGred}"
        else
            PR_CLR="${RCLR}${FGgreen}"
        fi
    fi
    export PR_CLR

    # Set terminal title
    TTY=$(tty)
    case "${TERM}" in
        xterm* )
            PROMPT_COMMAND='history -a; history -c; history -r; echo -ne "${USER}(${SHLVL}): $(prompt_pwd) | ${TTY:5}\007";'
            ;;
        screen* )
            PROMPT_COMMAND='history -a; history -c; history -r; echo -ne "\033_screen \005 (\005t) | ${USER}(${SHLVL}): $(prompt_pwd) | ${TTY:5}\033\\";'
            ;;
        * )
            PROMPT_COMMAND=''
            ;;
    esac

    # Set screen title
    case "${TERM}" in
        screen* )
            PROMPT_COMMAND=${PROMPT_COMMAND}'echo -ne "\033k${HOSTNAME}\033\\";'
            ;;
        * )
            PROMPT_COMMAND=''
            ;;
    esac

    # # Check battery status
    #     PR_BATT='$(battery_pct_prompt)'
    # else
    #     PR_BATT=''
    # fi

    # # Check active screens
    # if [ $(active_screens) ]; then
    #     PR_SCRN='$(active_screens_prompt)'
    # else
    #     PR_SCRN=''
    # fi

    # # Check background jobs
    # if [ $(bg_jobs) ]; then
    #     PR_BGJOBS='$(bg_jobs_prompt)'
    # else
    #     PR_BGJOBS=''
    # fi

    # # Check stopped jobs
    # if [ $(st_jobs) ]; then
    #     PR_STJOBS='$(st_jobs_prompt)'
    # else
    #     PR_STJOBS=''
    # fi

    # Left command prompt
    PS1="\n${PR_CLR}${HOSTNAME}${FGgreen}"'$(prompt_pwd)$(battery_pct_prompt)'

    for plugin in "${plugins[@]}"; do
        [[ "$plugin" == "git" ]] && PS1=${PS1}'$(git_prompt_info)' && BASH_THEME_GIT_PROMPT_DIRTY="${FGred} *${RCLR}$(git_prompt_status)";
        [[ "$plugin" == "svn" ]] && PS1=${PS1}'$(svn_prompt_info)';
    done

    PS1=${PS1}'$(active_screens_prompt)$(bg_jobs_prompt)$(st_jobs_prompt)'"${PR_CLR} >${RCLR} \n> "
    PROMPT_COMMAND=${PROMPT_COMMAND}'PS1=${PS1}'

    # PS2 continuation prompt
    PS2="${PR_CLR} >>${RCLR} "
}

function prompt_off() {
    PROMPT_COMMAND='PS1="${PR_CLR}${HOSTNAME}${FGgreen}$(prompt_pwd)$(active_screens_prompt)\
$(bg_jobs_prompt)$(st_jobs_prompt)${PR_CLR} >${RCLR} \n> "'
}

prompt_on
