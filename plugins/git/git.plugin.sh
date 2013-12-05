# Aliases
alias g='git'
alias ga='git add'
alias gap='git add -p'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbv='git branch -v'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gcam='git commit --amend'
alias gcb='git checkout -b'
alias gcex='echo "gc #time 1w 2d 5h 30m #comment Task completed #send-for-code-review +review CR-FCS @mcadiz @jweitz"'
alias gcm='git checkout master'
alias gco='git checkout'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gd='git diff --color-words'
alias gdt='git difftool'
alias gf='git fetch'
alias gfo='git fetch origin'
alias gfr='git fetch && git rebase'
alias gi='git_info.sh'
alias gif='git_info.sh full'
alias gl='git log'
alias glf='git log --pretty=format:"%h - %an, %ar : %s"'
alias glg='git log --stat --max-count=5'
alias glgg='git log --graph --pretty=format:"%h - %an, %ar : %s"'
alias glp='git log -p'
alias gls='git log -1 HEAD'
alias gm='git merge'
alias gpl='git pull'
alias gplo='git pull origin'
alias gps='git push'
alias gpso='git push origin master'
alias gpt='git push --tags'
alias gr='git rebase'
alias grhh='git reset HEAD --hard'
alias gsd='git svn dcommit'
alias gsha=git_prompt_short_sha
alias gshal=git_prompt_long_sha
alias gsr='git svn rebase'
alias gss='git status -s'
alias gst='git status'
alias gt=git_time_since_commit
alias gun='git reset HEAD --'

# Functions
function gdv() { git diff -w "$@" | view -; }

# Git and svn mix
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
#
# Will return the current branch name
# Usage example: git pull origin $(current_branch)
#
function current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "git:${ref#refs/heads/}"
}

# these aliases take advantage of the previous function
alias ggpl='git pull origin $(current_branch)'
alias ggps='git push origin $(current_branch)'
alias ggpnp='git pull origin $(current_branch) && git push origin $(current_branch)'
alias ggbd='git push $(current_branch) :'

# Get git info
function git_prompt_info() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "$BASH_THEME_GIT_PROMPT_PREFIX$(current_branch)$(parse_git_dirty)$(git_prompt_short_sha)$BASH_THEME_GIT_PROMPT_SUFFIX"
}

# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.
function git_time_since_commit() {
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
                echo "${BASH_THEME_GIT_TIME_SINCE_COMMIT_BEFORE}${DAYS}d${SUB_HOURS}h${SUB_MINUTES}m${BASH_THEME_GIT_TIME_SINCE_COMMIT_AFTER}"
            elif [ "$MINUTES" -gt 60 ]; then
                echo "${BASH_THEME_GIT_TIME_SINCE_COMMIT_BEFORE}${HOURS}h${SUB_MINUTES}m${BASH_THEME_GIT_TIME_SINCE_COMMIT_AFTER}"
            else
                echo "${BASH_THEME_GIT_TIME_SINCE_COMMIT_BEFORE}${MINUTES}m${BASH_THEME_GIT_TIME_SINCE_COMMIT_AFTER}"
            fi
        else
            echo "${BASH_THEME_GIT_TIME_SINCE_COMMIT_BEFORE}~${BASH_THEME_GIT_TIME_SINCE_COMMIT_AFTER}"
        fi
    fi
}

# Checks if working tree is dirty
function parse_git_dirty() {
  local SUBMODULE_SYNTAX=''
  if [[ $POST_1_7_2_GIT -gt 0 ]]; then
        SUBMODULE_SYNTAX="--ignore-submodules=dirty"
  fi
  if [[ -n $(git status -s ${SUBMODULE_SYNTAX}  2> /dev/null) ]]; then
    echo "$BASH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$BASH_THEME_GIT_PROMPT_CLEAN"
  fi
}

# Checks if there are commits ahead from remote
function git_prompt_ahead() {
  if $(echo "$(git log origin/$(current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    echo "$BASH_THEME_GIT_PROMPT_AHEAD"
  fi
}

# Formats prompt string for current git commit short SHA
git_prompt_short_sha() {
  SHA=$(git rev-parse --short HEAD 2> /dev/null) && echo "$BASH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$BASH_THEME_GIT_PROMPT_SHA_AFTER"
}

# Formats prompt string for current git commit long SHA
git_prompt_long_sha() {
  SHA=$(git rev-parse HEAD 2> /dev/null) && echo "$BASH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$BASH_THEME_GIT_PROMPT_SHA_AFTER"
}

# Get the status of the working tree
function git_prompt_status() {
  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$BASH_THEME_GIT_PROMPT_UNTRACKED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^A  ' &> /dev/null); then
    STATUS="$BASH_THEME_GIT_PROMPT_ADDED$STATUS"
  elif $(echo "$INDEX" | grep '^M  ' &> /dev/null); then
    STATUS="$BASH_THEME_GIT_PROMPT_ADDED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^ M ' &> /dev/null); then
    STATUS="$BASH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
    STATUS="$BASH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
    STATUS="$BASH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^R  ' &> /dev/null); then
    STATUS="$BASH_THEME_GIT_PROMPT_RENAMED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
    STATUS="$BASH_THEME_GIT_PROMPT_DELETED$STATUS"
  elif $(echo "$INDEX" | grep '^AD ' &> /dev/null); then
    STATUS="$BASH_THEME_GIT_PROMPT_DELETED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
    STATUS="$BASH_THEME_GIT_PROMPT_UNMERGED$STATUS"
  fi
  echo $STATUS
}

#compare the provided version of git to the version installed and on path
#prints 1 if input version <= installed version
#prints -1 otherwise
function git_compare_version() {
  local INPUT_GIT_VERSION=$1;
  local INSTALLED_GIT_VERSION
  INPUT_GIT_VERSION=(${INPUT_GIT_VERSION//./ });
  INSTALLED_GIT_VERSION=($(git --version));
  INSTALLED_GIT_VERSION=(${INSTALLED_GIT_VERSION[2]//./ });

  for i in {0..3}; do
    if [[ ${INSTALLED_GIT_VERSION[$i]} -lt ${INPUT_GIT_VERSION[$i]} ]]; then
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
