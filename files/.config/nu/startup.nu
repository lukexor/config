alias _ = sudo
alias cb = cargo build
alias cbr = cargo build --release
alias cc = cargo clippy
alias cfg = cd ~/config
alias cr = cargo run
alias cre = cargo run --example
alias crr = cargo run --release
alias ct = cargo test
alias da = (date now | date format '%Y-%m-%d %H:%M:%S')
alias g = git
alias ga = git add
alias gb = git --no-pager branch -v
alias gba = git branch -a
alias gbm = git --no-pager branch -v --merged
alias gbnm = git --no-pager branch -v --no-merged
alias gc = git commit
alias gcam = git commit --amend
alias gcb = git checkout -b
alias gco = git checkout
alias gcp = git cherry-pick
alias gd = git diff
alias gdt = git difftool
alias gf = git fetch origin
alias glg = git log --graph --pretty=format:'%C(yellow)%h (%p) %ai%Cred%d %Creset%Cblue[%ae]%Creset %s (%ar). %b %N'
alias gm = git merge
alias gops = git push origin (git rev-parse --abbrev-ref HEAD) -u
alias gpl = git pull
alias gps = git push
alias grhh = git reset HEAD --hard
alias grm = git rm
alias gsl = git --no-pager stash list
alias gst = git status
alias gt = git tag
alias gtoday = git --no-pager log --graph --pretty=format:'%C(yellow)%h %ad%Cred%d %Creset%Cblue[%cn]%Creset  %s (%ar)' --date=iso --all --branches=* --remotes=* --since='23 hours ago' --author=$(git config user.email)
alias gun = git reset HEAD --
alias h = (history | wrap | rename command)
alias fbroken = find . -maxdepth 1 -type l ! -exec test -e '{}' ';' -print
alias k = kubectl
alias ls = ls -s
alias la = ls -sa
alias ll = ls -sl
alias lc = (ls -s | sort-by modified | reverse)
alias lk = (ls -s | sort-by size | reverse)
alias cp = ^cp -ia
alias myip = curl http://ipecho.net/plain
alias mv = ^mv -i
alias md = ^mkdir -p
alias rm = ^rm -i
alias rd = rmdir
alias pwd = (^pwd | str trim | str find-replace $nu.env.HOME '~')
alias py = python
alias sshl = ssh-add -L
alias topc = (ps | sort-by cpu | reverse | first 10)
alias topm = (ps | sort-by mem | reverse | first 10)
alias v = nvim
alias vf = nvim (fzf-tmux)
alias vi = nvim
alias vim = nvim
alias vnu = nvim ($nu.config-path)
alias vnus = nvim ~/.config/nu/startup.nu
alias vrc = nvim ~/.config/nvim/init.vim
alias x = extract.sh

# Output last N git commits.
def gl [count: int] {
  git log --pretty=%h»¦«%s»¦«%aN»¦«%aD | lines | first $count | split column "»¦«" commit message name date | update date { get date | str to-datetime}
}

# Output last N history commands.
def hl [count: int] {
  history | first $count
}

# Output history containing given text.
def hs [search: string] {
  history | where ($it | str contains $search)
}

# Search process list for a given string.
def pg [search: string] {
  ps -l | where ($it.name | str contains $search)
}

# Output PATH variables.
def "path list" [] {
  $nu.path
}

# Restart ssh-agent.
def ra [] {
  pg ssh-agent | each { kill $it.pid }
  let agent = (ssh-agent -s -a /tmp/ssh-agent)
  $agent | save /tmp/ssh-agent-info
  ssh-add ~/.ssh/id_rsa
}

# Output git branches with last commit.
def gb-age [] {
  git branch -a | lines | str substring 2, | wrap name | where name !~ HEAD | insert "last commit" {
      get name | each {
          git show $it --no-patch --format=%as
      }
  } | sort-by "last commit"
}

# Clean old git branches.
def gb-clean [] {
  git branch -vl | lines | str substring 2, | split column " " branch hash status --collapse-empty | where status == '[gone]' | each { git branch -d $it.branch }
}
