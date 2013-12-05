alias conflicts='svn status -u | grep "^C"'
alias sst='svn status'
alias sd='svn diff'
alias sr='svn revert'
alias sc='svn commit'
alias sl='svn log -l 100 | less'

function si() {
    _echodo "svn info $*"
}
function sco() {
    _echodo "svn co svn+ssh://lpetherbridge@svn/$*"
}
function sls() {
    _echodo "svn ls svn+ssh://lpetherbridge@svn/$*"
}
function slast() {
    ${HOME}/bin/svn_diff $@
}

function svn_prompt_info {
    if [ $(in_svn) ]; then
        echo "${BASH_THEME_SVN_PROMPT_PREFIX}$(svn_get_full_name)$(svn_dirty)$(svn_prompt_rev)${BASH_THEME_SVN_PROMPT_SUFFIX}"
    fi
}
function svn_prompt_rev {
    if [ $(in_svn) ]; then
        echo "${BASH_THEME_SVN_PROMPT_REV_BEFORE}$(svn_get_rev_nr)${BASH_THEME_SVN_PROMPT_REV_AFTER}"
    fi
}

function in_svn() {
    if [[ -d .svn ]]; then
        echo 1
    fi
}

function svn_get_rev_nr {
    if [ $(in_svn) ]; then
        svn info 2> /dev/null | sed -n s/Revision:\ //p
    fi
}

function svn_dirty_choose {
    if [ $(in_svn) ]; then
        s=$(svn status 2>/dev/null | grep -E '^\s*[ACDIM!?L]' 2>/dev/null)
        if [[ "${s}" ]]; then
            echo "${1}"
        else
            echo "${2}"
        fi
    fi
}

function svn_dirty {
    svn_dirty_choose "${BASH_THEME_SVN_PROMPT_DIRTY}" "${BASH_THEME_SVN_PROMPT_CLEAN}"
}

# Returns (svn:<revision>:<branch|tag>[*]) if applicable
svn_get_full_name() {
    if [ -d ".svn" ]; then
        local branch info=$(svn info 2>/dev/null)

        branch=$(svn_parse_branch "$info")

        if [ "$branch" != "" ] ; then
           echo "svn:$branch"
        fi
    fi
}

# Returns the current branch or tag name from the given `svn info` output
svn_parse_branch() {
    local chunk url=$(echo "$1" | awk '/^URL: .*/{print $2}')

    echo $url | grep -q "/trunk\b"
    if [ $? -eq 0 ] ; then
        echo trunk
        return
    else
        chunk=$(echo $url | grep -o "/releases.*")
        if [ "$chunk" == "" ] ; then
            chunk=$(echo $url | grep -o "/branches.*")
            if [ "$chunk" == "" ] ; then
                chunk=$(echo $url | grep -o "/tags.*")
            fi
        fi
    fi

    echo $chunk | awk -F/ '{print $3}'
}
