# Aliases
alias g='git'
compdef g=git
alias gst='git status'
compdef _git gst=git-status
alias gpl='git pull'
compdef _git gpl=git-pull
alias gf='git fetch'
compdef _git gf=git-fetch
alias gfr='git fetch && git rebase'
compdef _git gfr=git-fetch
alias gr='git rebase'
compdef _git gr=git-rebase
alias gfo='git fetch origin'
compdef _git gfo=git-fetch
alias gps='git push'
compdef _git gps=git-push
alias gpt='git push --tags'
compdef _git gpt=git-push
alias gd='git difftool'
compdef _git gd=git-difftool
gdv() { git diff -w "$@" | view - }
compdef _git gdv=git-diff
alias gc='git commit -v'
compdef _git gc=git-commit
alias gca='git commit -v -a'
compdef _git gca=git-commit
alias gcam='git commit --amend'
compdef _git gcam=git-commit
alias gco='git checkout'
compdef _git gco=git-checkout
alias gcm='git checkout master'
compdef _git gcm=git-checkout
alias gcb='git checkout -b'
compdef _git gcb=git-checkout
alias gb='git branch'
compdef _git gb=git-branch
alias gba='git branch -a'
compdef _git gba=git-branch
alias gbd='git branch -d'
compdef _git gbd=git-branch
alias gbv='git branch -v'
compdef _git gbv=git-branch
alias gcount='git shortlog -sn'
compdef gcount=git
alias gcp='git cherry-pick'
compdef _git gcp=git-cherry-pick
alias gl='git log'
compdef _git gl=git-log
alias glg='git log --stat --max-count=5'
compdef _git glg=git-log
alias glgg='git log --graph --max-count=5'
compdef _git glgg=git-log
alias glf='git log --pretty=format:"%h - %an, %ar : %s"'
compdef _git glf=git-log
alias gls='git log -1 HEAD'
compdef _git gls=git-log
alias gss='git status -s'
compdef _git gss=git-status
alias ga='git add'
compdef _git ga=git-add
alias gap='git add -p'
compdef _git gap=git-add
alias gm='git merge'
compdef _git gm=git-merge
alias gun='git reset HEAD --'
compdef _git gun=git-reset
alias grhh='git reset HEAD --hard'
compdef _git grhh=git-reset

alias gsha=git_prompt_short_sha
alias gshal=git_prompt_long_sha
alias gt=git_time_since_commit

# Git and svn mix
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
compdef git-svn-dcommit-push=git

alias gsr='git svn rebase'
alias gsd='git svn dcommit'
#
# Will return the current branch name
# Usage example: git pull origin $(current_branch)
#
function current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

# these aliases take advantage of the previous function
alias ggpl='git pull origin $(current_branch)'
compdef _git ggpl=git-pull
alias ggps='git push origin $(current_branch)'
compdef _git ggps=git-pull
alias ggpnp='git pull origin $(current_branch) && git push origin $(current_branch)'
compdef _git gpnp=git-pull
alias ggbd='git push $(current_branch) :'
compdef _git ggbd=git-push

# Get git info
git_prompt_info() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.
git_time_since_commit() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        # Only proceed if there is actually a commit.
        if [[ $(git log 2>&1 > /dev/null | grep -c "^fatal: bad default revision") == 0 ]]; then
            # Get the last commit.
            last_commit=`git log --pretty=format:'%at' -1 2> /dev/null`
            now=`date +%s`
            seconds_since_last_commit=$((now-last_commit))

            # Totals
            MINUTES=$((seconds_since_last_commit / 60))
            HOURS=$((seconds_since_last_commit/3600))

            # Sub-hours and sub-minutes
            DAYS=$((seconds_since_last_commit / 86400))
            SUB_HOURS=$((HOURS % 24))
            SUB_MINUTES=$((MINUTES % 60))

            if [ "$HOURS" -gt 24 ]; then
                echo "${ZSH_THEME_GIT_TIME_SINCE_COMMIT_BEFORE}${DAYS}d${SUB_HOURS}h${SUB_MINUTES}m${ZSH_THEME_GIT_TIME_SINCE_COMMIT_AFTER}"
            elif [ "$MINUTES" -gt 60 ]; then
                echo "${ZSH_THEME_GIT_TIME_SINCE_COMMIT_BEFORE}${HOURS}h${SUB_MINUTES}m${ZSH_THEME_GIT_TIME_SINCE_COMMIT_AFTER}"
            else
                echo "${ZSH_THEME_GIT_TIME_SINCE_COMMIT_BEFORE}${MINUTES}m${ZSH_THEME_GIT_TIME_SINCE_COMMIT_AFTER}"
            fi
        else
            echo "${ZSH_THEME_GIT_TIME_SINCE_COMMIT_BEFORE}~${ZSH_THEME_GIT_TIME_SINCE_COMMIT_AFTER}"
        fi
    fi
}

# Checks if working tree is dirty
parse_git_dirty() {
  local SUBMODULE_SYNTAX=''
  if [[ $POST_1_7_2_GIT -gt 0 ]]; then
        SUBMODULE_SYNTAX="--ignore-submodules=dirty"
  fi
  if [[ -n $(git status -s ${SUBMODULE_SYNTAX}  2> /dev/null) ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

# Checks if there are commits ahead from remote
git_prompt_ahead() {
  if $(echo "$(git log origin/$(current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    echo "$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi
}

# Formats prompt string for current git commit short SHA
git_prompt_short_sha() {
  SHA=$(git rev-parse --short HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

# Formats prompt string for current git commit long SHA
git_prompt_long_sha() {
  SHA=$(git rev-parse HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

# Get the status of the working tree
git_prompt_status() {
  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_UNTRACKED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^A  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
  elif $(echo "$INDEX" | grep '^M  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^ M ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^R  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_RENAMED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
  elif $(echo "$INDEX" | grep '^AD ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_UNMERGED$STATUS"
  fi
  echo $STATUS
}

#compare the provided version of git to the version installed and on path
#prints 1 if input version <= installed version
#prints -1 otherwise
git_compare_version() {
  local INPUT_GIT_VERSION=$1;
  local INSTALLED_GIT_VERSION
  INPUT_GIT_VERSION=(${(s/./)INPUT_GIT_VERSION});
  INSTALLED_GIT_VERSION=($(git --version));
  INSTALLED_GIT_VERSION=(${(s/./)INSTALLED_GIT_VERSION[3]});

  for i in {1..3}; do
    if [[ $INSTALLED_GIT_VERSION[$i] -lt $INPUT_GIT_VERSION[$i] ]]; then
      echo -1
      return 0
    fi
  done
  echo 1
}

#this is unlikely to change so make it all statically assigned
POST_1_7_2_GIT=$(git_compare_version "1.7.2")
#clean up the namespace slightly by removing the checker function
unset -f git_compare_version
