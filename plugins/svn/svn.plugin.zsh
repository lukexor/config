alias conflicts='svn status -u | grep "^C"'
alias sst='svn status'
alias sd='svn diff'
alias sr='svn revert'
alias sc='svn commit'

function si() {
    _echodo "svn info $*"
}
function sco() {
    _echodo "svn co svn+ssh://lpetherbridge@svn/$*"
}
function sls() {
    _echodo "svn ls svn+ssh://lpetherbridge@svn/$*"
}

function svn_prompt_info {
    if [ $(in_svn) ]; then
        echo "$ZSH_THEME_SVN_PROMPT_PREFIX$(svn_get_full_name)$(svn_dirty)$ZSH_THEME_SVN_PROMPT_SUFFIX"
    fi
}


function in_svn() {
    if [[ -d .svn ]]; then
        echo 1
    fi
}

function svn_get_repo_name {
    if [ $(in_svn) ]; then
        svn info 2> /dev/null | sed -n 's/Repository\ Root:\ .*\///p' | read SVN_ROOT
        svn info 2> /dev/null | sed -n "s/URL:\ .*$SVN_ROOT\///p" | sed "s/\/.*$//"
    fi
}

function svn_get_full_name {
    if [ $(in_svn) ]; then
        svn info 2> /dev/null | grep URL | perl -pe 's/^URL:.*\/\/(.*@\w+\/)?//'
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
        if [ $s ]; then
            echo $1
        else
            echo $2
        fi
    fi
}

function svn_dirty {
    svn_dirty_choose $ZSH_THEME_SVN_PROMPT_DIRTY $ZSH_THEME_SVN_PROMPT_CLEAN
}
