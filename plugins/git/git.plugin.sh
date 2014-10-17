# Aliases
alias g='git'
alias ga='git add'
alias gap='git add -p'
alias gassume='git update-index --assume-unchanged'
alias gunassume='git update-index --no-assume-unchanged'
alias gassumed='git ls-files -v | grep ^h | cut -c 3-'
alias gunassumeall='gassumed | xargs git update-index --no-assume-unchanged'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbv='git branch -v'
alias gc='git commit -v'
alias gcn='git commit -v --no-verify'
alias gca='git commit -v -a'
alias gcam='git commit --amend'
alias gcb='git checkout -b'
alias gcex='echo "gc #time 1w 2d 5h 30m #comment Task completed #send-for-code-review +review CR-FCS @mcadiz @jweitz"'
alias gcm='git checkout master'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gd='git diff --color-words -w'
alias gdt='git difftool'
alias gf='git fetch origin'
alias gfg='git ls-files | grep -i'
alias gg='git grep -Ii'
alias gi='git_info.sh'
alias gif='git_info.sh full'
alias gla='alias|grep git|cut -c 7-'
alias glf='git log -p'
alias glg='git log --graph --pretty=format:"%C(yellow)%h (%p) %ai%Cred%d %Creset%Cblue[%ae]%Creset %s (%ar). %b %N"'
alias glg5='glg --max-count=5'
alias glp='git log -p'
alias gls='git --no-pager log --pretty=format:"%C(yellow)%h (%p) %ai%Cred%d %Creset%Cblue[%ae]%Creset %s (%ar). %b %N" -20'
alias glt='git describe --tags --abbrev=0'
alias gll='git --no-pager log --pretty=format:"%C(yellow)%h (%p) %ai%Cred%d %Creset%Cblue[%ae]%Creset %s (%ar). %b %N" --numstat -10'
alias glnc='git log --pretty=format:"%h%d [%cn]  %s (%ar)"'
alias gm='git merge --no-ff'
alias gfm='git pull'
alias gfr='git pull --rebase'
alias gps='git push'
alias gpso='git push origin master'
alias gpt='git push --tags'
alias gr='git rebase'
alias grhh='git reset HEAD --hard'
alias grm='git rm'
alias gsd='git svn dcommit'
alias gsha=git_prompt_short_sha
alias gshal=git_prompt_long_sha
alias gsr='git svn rebase'
alias gss='git status -s'
alias gst='git status'
alias gsl='git --no-pager stash list'
alias gt=git_time_since_commit
alias gtoday='git --no-pager log --graph --pretty=format:"%C(yellow)%h %ad%Cred%d %Creset%Cblue[%cn]%Creset  %s (%ar)" --date=iso --all --branches=* --remotes=* --since="23 hours ago" --author="$(git config user.name)"'
alias gun='git reset HEAD --'

# Functions
gdv() { git diff -w "$@" | view -; }

fu() {
	echo "sudo /usr/local/fonality/bin/fcs_update ${1:--s}"
	sudo /usr/local/fonality/bin/fcs_update ${1:--s}
}

# git merge branch into develop
gmd() {
	current_branch=$(current_branch)

	echo "git checkout develop && git pull && git merge $current_branch && git push origin develop && fu '-s'"
	git checkout develop && git pull && git merge $current_branch && git push origin develop && fu '-s'
}

gdone() {
    branch=$(current_branch)
    git branch -m $branch done-$branch
}

gtg() {
    git fetch --tag
    git tag | grep $1 | sort -t$1 -k2n
}

# Checkout a ticket branch
gbt() { git checkout tickets/$1; }

# gfm() {
#     git fetch origin
#     git merge origin/$(current_branch)
# }
# gfr() {
#     git fetch origin
#     git rebase origin/$(current_branch)
# }
# grr() {
    #git filter-branch --tree-filter "rm -f $*" HEAD
# }

# Git and svn mix
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
#
# Will return the current branch name
# Usage example: git pull origin $(current_branch)
#
current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

# these aliases take advantage of the previous function
alias gopl='git pull origin $(current_branch)'
alias goplps='git pull origin $(current_branch) && git push origin $(current_branch)'
alias gbps='git push $(current_branch) :'
alias gstm='glg $(current_branch) ^origin/master'
alias gstbm='glg origin/master ^$(current_branch)'
alias gstbd='glg $(current_branch) ^origin/develop'
alias gstdb='glg origin/develop ^$(current_branch)'

gco() {
    git checkout $@
    tags > /dev/null 2>&1 &
}
gops() {
    git push origin $(current_branch) $@
    tags > /dev/null 2>&1 &
}

# Get git info
git_prompt_info() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "$BASH_THEME_GIT_PROMPT_PREFIX$(current_branch)$(parse_git_dirty)$(git_prompt_short_sha)$BASH_THEME_GIT_PROMPT_SUFFIX"
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
parse_git_dirty() {
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
git_prompt_ahead() {
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
git_prompt_status() {
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
git_compare_version() {
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
