alias _ = sudo
alias cb = cargo build
alias cbr = cargo build --release
alias cc = cargo clippy
alias cdot = cd ~/.dotfiles
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
alias gcb = git checkout -b
alias gco = git checkout
alias gcp = git cherry-pick
alias gd = git diff
alias gdt = git difftool
alias gf = git fetch origin
alias glg = git log --graph --pretty=format:'%C(yellow)%h (%p) %ai%Cred%d %Creset%Cblue[%ae]%Creset %s (%ar). %b %N'
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
alias h = history
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
alias tags = ctags -I ~/.ctags --file-scope=no -R
alias tm = tm.sh
alias topc = (ps | sort-by cpu | reverse | first 10)
alias topm = (ps | sort-by mem | reverse | first 10)
alias v = nvim
alias vi = nvim
alias vf = (let f = (fzf-tmux); if $f | empty? {} { nvim $f })
alias vim = nvim
alias vnu = nvim ~/cargo.toml
alias vrc = nvim ~/.vimrc
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
  ps | where ($it.name | str contains $search)
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

# Edit file using FZF.
def vf [] {
  (fzf-tmux) | compact | each { nvim $it }
}
