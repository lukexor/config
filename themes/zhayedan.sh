# ==========================================================
# == zhayedan bash theme

# GIT
BASH_THEME_GIT_PROMPT_PREFIX=" ${FGcyan}["
BASH_THEME_GIT_PROMPT_SUFFIX="${FGcyan}]${RCLR}"
BASH_THEME_GIT_PROMPT_CLEAN="${FGgreen}=${RCLR}"

BASH_THEME_GIT_PROMPT_AHEAD="$FGbred}!${RCLR}"
# BASH_THEME_GIT_PROMPT_DIRTY="${FGred} *${RCLR}"
BASH_THEME_GIT_PROMPT_DIRTY="" # Commented since we have other flags to indicate dirty below
BASH_THEME_GIT_PROMPT_ADDED="${FGgreen}+${RCLR}"
BASH_THEME_GIT_PROMPT_MODIFIED="${FGblue}x${RCLR}"
BASH_THEME_GIT_PROMPT_DELETED="${FGred}-${RCLR}"
BASH_THEME_GIT_PROMPT_RENAMED="${FGmagenta}>${RCLR}"
BASH_THEME_GIT_PROMPT_UNMERGED="${FGyellow}^${RCLR}"
BASH_THEME_GIT_PROMPT_UNTRACKED="${FGcyan}.${RCLR}"

# Format for git_prompt_long_sha() and git_prompt_short_sha()
BASH_THEME_GIT_PROMPT_SHA_BEFORE="${FGyellow}"
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
BASH_THEME_SVN_PROMPT_DIRTY="${FGred}*${RCLR}"
BASH_THEME_SVN_PROMPT_CLEAN="${FGgreen}=${RCLR}"
BASH_THEME_SVN_PROMPT_REV_BEFORE="${FGyellow}"
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
        PR_CLR="${BGred}${FGred}"
    else
        if [[ "${USER}" == "${LOGNAME}" ]]; then
            PR_CLR="${RCLR}${FGblue}"
        else
            PR_CLR="${RCLR}${FGyellow}"
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
            PROMPT_COMMAND=${PROMPT_COMMAND}'echo -ne "\033k${SCREEN_TITLE:-${HOSTNAME}}\033\\";'
            ;;
        * )
            PROMPT_COMMAND=''
            ;;
    esac

    # Left command prompt
    case ${OSTYPE} in
        darwin*) export PS1_HOST="mac" ;;
        *) export PS1_HOST="${HOSTNAME}" ;;
    esac

    for plugin in "${plugins[@]}"; do
        if [[ "$plugin" == "git" ]]; then
            BASH_THEME_GIT_PROMPT_DIRTY="$BASH_THEME_GIT_PROMPT_DIRTY$(git_prompt_status)"
        fi
    done

    export PROMPT_COMMAND=${PROMPT_COMMAND}'PS1="\n\
$GRY[$WHI\@$GRY] \
`if [[ $(active_screens) ]]; then echo " $GRY[$BLU$(active_screens)$GRY]"; fi`\
`if [[ $(bg_jobs) ]]; then echo "$GRY[$YEL$(bg_jobs)$GRY]"; fi`\
`if [[ $(st_jobs) ]]; then echo "$GRY[$HCYA$(st_jobs)$GRY]"; fi`\
`if [[ $PS1_HOST ]]; then echo "$GRY{$PR_CLR$PS1_HOST$GRY} "; fi`\
`if [[ $(parse_git_branch) ]]; then echo "$GRY($GRE$(parse_git_branch)$GRY) "; fi`\
$CYA\W\n$NC\
> "'

    # PS2 continuation prompt
    export PS2=" >> "
}

function prompt_off() {
    PROMPT_COMMAND='PS1="$(prompt_pwd) > "'
}

prompt_on
