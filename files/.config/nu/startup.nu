## Aliases

alias _ = sudo
alias cb = cargo build
alias cbr = cargo build --release
alias cc = cargo clippy
alias cca = cargo clippy --all-targets
alias cdoc = cargo doc
alias cdoco = cargo doc --open
alias cfg = cd ~/config
alias cr = cargo run
alias cre = cargo run --example
alias crr = cargo run --release
alias ct = cargo test
alias da = (date now | date format '%Y-%m-%d %H:%M:%S')
alias fbroken = find . -maxdepth 1 -type l ! -exec test -e '{}' ';' -print
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
alias k = kubectl
alias ls = ls -s
alias la = ls -sa
alias ll = ls -sl
alias lc = (ls -s | sort-by modified | reverse)
alias lk = (ls -s | sort-by size | reverse)
alias cp = ^cp -ia
alias myip = curl -s api.ipify.org
alias mv = ^mv -i
alias md = ^mkdir -p
alias rm = ^rm -i
alias rd = rmdir
alias pwd = (^pwd | str trim | str find-replace $nu.env.HOME '~')
alias py = python3
alias slp = ssh caeledh@138.197.217.136
alias sshl = ssh-add -L
alias topc = (^ps -Arco pid,pcpu,pmem,comm | lines | str trim | skip 1 | first 10 | parse -r "(?P<pid>\d+)\s+(?P<pcpu>\d+\.\d+)\s+(?P<pmem>\d+\.\d+)\s+(?P<name>.*)")
alias topm = (^ps -Amco pid,pcpu,pmem,comm | lines | str trim | skip 1 | first 10 | parse -r "(?P<pid>\d+)\s+(?P<pcpu>\d+\.\d+)\s+(?P<pmem>\d+\.\d+)\s+(?P<name>.*)")
alias v = nvim
alias vi = nvim
alias vim = nvim
alias vimdiff = nvim -d


## Commands

# Edit nushell configuration.
def "nu config" [] { nvim ~/.config/nu/config.toml }

# Edit nushell startup script.
def "nu startup" [] { nvim ~/.config/nu/startup.nu }

# Edit neovim configuration.
def "nvim init" [] { nvim ~/.config/nvim/init.vim }

# Edit neovim lsp lua configuration.
def "nvim lsp" [] { nvim ~/.config/nvim/lua/lsp.lua }

# Fuzzy search for file to edit.
def vf [] {
  let file = (fzf-tmux | wrap filename | get filename)
  if ($file | empty?) {} {
    echo "nvim $file"
    echo $file | str trim | pbcopy
    nvim $file
  }
}

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
  # substring 2, skips the currently checked out branch: "* "
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

## Community Commands

# Function querying free online English dictionary API for definition of given word(s)
def dict [
  ...word # word(s) to query the dictionary API but they have to make sense together like "martial law", not "cats dogs"
] {
  let query = ($word | str collect %20)
  let link = (build-string 'https://api.dictionaryapi.dev/api/v2/entries/en/' ($query|str find-replace ' ' '%20'))
  let output = (fetch $link | rename word)
  let w = ($output.word | first)
  if $w == "No Definitions Found" {
    echo $output.word
  } {
    echo $output | get meanings.definitions | select definition example
  }
}

# Print a sorted list of the largest directories.
def filesizes [] {
  ls -d|where type == Dir|sort-by size|reverse|format filesize size MB
}

# Extract a packaged file.
def x [
  name:string # name of the archive to extract
] {
  let exten = [
    [ex com];
    ['.7z' '7za x']
    ['.Z' 'uncompress']
    ['.bz2' 'bunzip2']
    ['.deb' 'ar vx']
    ['.gz' 'gunzip']
    ['.lzma' 'unlzma']
    ['.rar' 'unrar e -ad']
    ['.tar' 'tar xvf']
    ['.tar.bz2' 'tar xvjf']
    ['.tar.gz' 'tar xvzf']
    ['.tar.xz' 'tar --xz -xvf']
    ['.tar.zma' 'tar --lzma -xvf']
    ['.tar.zst' 'tar xvf']
    ['.tbz' 'tar xvjf']
    ['.tbz2' 'tar xvjf']
    ['.tgz' 'tar xvzf']
    ['.tlz' 'tar --lzma -xvf']
    ['.txz' 'tar --xz -xvf']
    ['.xz' 'unxz']
    ['.zip' 'unzip']
  ]
  let command = ($exten|where $name =~ $it.ex|first)
  if ($command|empty?) {
    echo 'Error! Unsupported file extension'
  } {
    nu -c (build-string $command.com ' ' $name)
  }
}

# Fuzzy search commands.
# on selection, will display `help` for the commands
# and paste command into clipboard for you to paste right away
alias cs = commands search
def "commands search" [] {
  # calculate required tabs/spaces to get a nicely aligned table
  let tablen = 8
  let max-len = (help commands | get subcommands |  each { $it.name | str length } | math max)
  let max-indent = ($max-len / $tablen | into int)

  def pad-tabs [input-name] {
    let input-length = ($input-name| str length) 
    let required-tabs = $max-indent - ($"($input-length / $tablen | into int)" | str to-int)
    echo $"( seq $required-tabs | reduce -f "" {$acc + (char tab)})"
  }

  help (echo (help commands | get subcommands | each {
    let name = ($it.name | str trim | ansi strip)
    $"(
      $name
    )( pad-tabs $name
    )(
      $it.description
    )" 
  }) ( 
  help commands | reject subcommands | each {
    let name = ($it.name | str trim | ansi strip)
    $"(
      $name
    )(
      pad-tabs $name
    )(
      $it.description
    )" 
  }) | str collect (char nl) | fzf-tmux | split column (char tab)| rename command | get command | pbcopy; pbpaste) 
}

# Fuzzy search history.
def "history search" [] { cat $nu.history-path | fzf-tmux | str trim | pbcopy; pbpaste }
alias hs = history search

alias deactivate = source ~/.config/nu/envs/deactivate.nu

# Activate a virtual environment.
def venv [
  venv_dir: string # The virtual environment directory
] {
  let path_sep = ":"
  let venv_abs_dir = ($venv_dir | path expand)
  let venv_name = ($venv_abs_dir | path basename)
  let old_path = ($nu.path | str collect $path_sep)
  let venv_path = ([$venv_dir "bin"] | path join)
  let new_path = ($nu.path | prepend $venv_path | str collect $path_sep)
  [
    [name, value];
    [VENV_OLD_PATH $old_path]
    [VIRTUAL_ENV $venv_name]
    [PATH $new_path]
  ]
}

# Print out personalized ASCII logo.
def init [] {
  if ($nu.env.SHLVL | into int) == 1 {
    let load = (uptime | parse -r "averages: (?P<avg>.*)" | get avg)
    let sys = (sys)
    let macos = $sys.host.name =~ Darwin
    let os = (if $macos {
      let vers = (sw_vers | parse -r "(?P<name>\w+):(?P<value>.*)" | str trim | pivot -r)
      $"($vers.ProductName) ($vers.ProductVersion)"
    } {
      uname -srm | str trim
    })
    let cpu = (if $macos {
      sysctl -n machdep.cpu.brand_string | str trim
    } {
      cat /proc/cpuinfo | rg "model name\s+: (.*)" -r '$1' | uniq | str trim
    })
    echo $"
               i  t             (date now | date format '%Y-%m-%d %H:%M:%S')
              LE  ED.           ($os)
             L#E  E#K:
            G#W.  E##W;         Uptime......: ($sys.host.uptime)
           D#K.   E#E##t        Memory......: ($sys.mem.free) [Free] / ($sys.mem.total) [Total]
          E#K.    E#ti##f       CPU.........: ($cpu)
        .E#E.     E#t ;##D.     Load........: ($load) [1, 5, 15 min]
       .K#E       E#ELLE##K:    IP Address..: (ifconfig en0 | rg 'inet (\d+.\d+.\d+.\d+)' -or '$1' | str trim) 
      .K#D        E#L;;;;;;,
     .W#G         E#t
    :W##########WtE#t
    :,,,,,,,,,,,,,.
" | lolcat
  } {}
}

## Startup

# Fix tmux adding 2 to the SHLVL
let level = ($nu.env | default SHLVL 1 | get SHLVL | into int)
let-env SHLVL = (
  if ($nu.env | default TMUX $nothing | get TMUX) != "" && $level >= 3 {
    $level - 3
  } {
    $level
  }
)

pathvar reset
pathvar add ~/.fzf/bin
pathvar add ~/.cargo/bin
pathvar add ~/bin

init
