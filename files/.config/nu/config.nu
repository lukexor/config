#
#                                    i  t
#                                   LE  ED.
#                                  L#E  E#K:
#                                 G#W.  E##W;
#                                D#K.   E#E##t
#                               E#K.    E#ti##f
#                             .E#E.     E#t ;##D.
#                            .K#E       E#ELLE##K:
#                           .K#D        E#L;;;;;;,
#                          .W#G         E#t
#                         :W##########WtE#t
#                         :,,,,,,,,,,,,,.
#
#
#    Personal nushell configuration of Luke Petherbridge <me@lukeworks.tech>



# =============================================================================
# Config   {{{1
# =============================================================================

let $theme = {
    separator: yellow_dimmed
    leading_trailing_space_bg: white_bold
    header: cyan_bold
    empty: yellow_bold
    bool: purple
    int: green
    filesize: yellow
    duration: blue
    date: blue
    range: green
    float: green
    string: white
    nothing: yellow_bold
    binary: cyan
    cellpath: cyan
    row_index: red_dimmed
    record: white
    list: white
    block: white
    hints: dark_gray

    # shapes are used to change the cli syntax highlighting
    shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: b}
    shape_bool: light_cyan
    shape_int: purple_bold
    shape_float: purple_bold
    shape_range: yellow_bold
    shape_internalcall: cyna_bold
    shape_external: cyan
    shape_externalarg: green_bold
    shape_literal: blue
    shape_operator: yellow
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_list: cyan_bold
    shape_table: blue_bold
    shape_record: cyan_bold
    shape_block: blue_bold
    shape_filepath: cyan
    shape_globpattern: cyan_bold
    shape_variable: purple
    shape_flag: blue_bold
    shape_custom: green
    shape_nothing: light_cyan
}

let menu_style = {
  text: green
  selected_text: green_reverse
  description_text: yellow
}
let-env config = {
  filesize_metric: true
  table_mode: rounded
  use_ls_colors: true
  rm_always_trash: true
  color_config: $theme
  use_grid_icons: true
  footer_mode: "30"
  quick_completions: true
  animate_prompt: false
  float_precision: 2
  use_ansi_coloring: true
  filesize_format: "auto"
  edit_mode: vi
  max_history_size: 10000
  log_level: error
  menus: [
    {
      name: completion_menu
      only_buffer_difference: false
      marker: "≡ "
      type: {
        layout: columnar
        columns: 4
        col_padding: 2
      }
      style: $menu_style
    }
    {
      name: history_menu
      only_buffer_difference: true
      marker: "? "
      type: {
        layout: list
        page_size: 10
      }
      style: $menu_style
    }
    {
      name: help_menu
      only_buffer_difference: true
      marker: "? "
      type: {
        layout: description
        columns: 4
        col_padding: 2
        selection_rows: 4
        description_rows: 10
      }
      style: $menu_style
    }
    {
      name: commands_menu
      only_buffer_difference: false
      marker: "# "
      type: {
        layout: columnar
        columns: 4
        col_width: 20
        col_padding: 2
      }
      style: $menu_style
      source: { |buffer, position|
          $nu.scope.commands
          | where command =~ $buffer
          | each { |it| {value: $it.command description: $it.usage} }
      }
    }
  ]
  keybindings: [
    {
      name: backspaceword
      modifier: control
      keycode: char_w
      mode: vi_insert
      event: [
        { edit: backspaceword }
      ]
    }
    {
      name: movewordleft
      modifier: control
      keycode: char_b
      mode: vi_insert
      event: [
        { edit: movewordleft }
      ]
    }
    {
      name: movewordright
      modifier: control
      keycode: char_f
      mode: vi_insert
      event: [
        { edit: movewordright }
      ]
    }
    {
      name: movetolinestart
      modifier: control
      keycode: char_o
      mode: vi_insert
      event: [
        { edit: movetolinestart }
      ]
    }
    {
      name: movetolineend
      modifier: control
      keycode: char_e
      mode: vi_insert
      event: [
        { edit: movetolineend }
      ]
    }
    {
      name: completion_menu
      modifier: none
      keycode: tab
      mode: vi_insert
      event: {
        until: [
          { send: menu name: completion_menu }
          { send: menunext }
        ]
      }
    }
    {
      name: completion_previous
      modifier: shift
      keycode: backtab
      mode: vi_insert
      event: { send: menuprevious }
    }
     {
      name: history_menu
      modifier: control
      keycode: char_r
      mode: vi_insert
      event: {
        until: [
          { send: menu name: history_menu }
          { send: menupagenext }
        ]
      }
    }
    {
      name: history_previous
      modifier: "control | shift"
      keycode: char_r
      mode: vi_insert
      event: { send: menupageprevious }
    }
    {
      name: hint
      modifier: control
      keycode: char_t
      mode: vi_insert
      event:[
        [{ send: historyhintcomplete }]
        [{ send: menu name: commands_menu }]
        [{ send: menunext }]
      ]
    }
    {
      name: historyhintwordcomplete
      modifier: control
      keycode: char_n
      mode: vi_insert
      event: [
        { send: historyhintwordcomplete }
      ]
    }
    {
      name: clearscreen
      modifier: control
      keycode: char_l
      mode: vi_insert
      event: [
        { send: clearscreen }
      ]
    }
    {
      name: fzf_cd
      modifier: control
      keycode: char_y
      mode: vi_insert
      event: [
        { edit: clear }
        { edit: insertString value: 'cd (ls | where type == dir | get name | str collect (char nl) | fzf-tmux)' }
        { send: enter }
      ]
    }
    {
      name: fzf_edit
      modifier: control
      keycode: char_s
      mode: vi_insert
      event: [
        { edit: clear }
        { edit: insertString value: 'vf' }
        { send: enter }
      ]
    }
    {
      name: exit
      modifier: control
      keycode: char_d
      mode: vi_insert
      event: [
        { send: ctrld }
      ]
    }
  ]
}

# =============================================================================
# Completions   {{{1
# =============================================================================

use ~/.config/nu/completions/git.nu *
use ~/.config/nu/completions/cargo.nu *
use ~/.config/nu/completions/npm.nu *

# =============================================================================
# Aliases   {{{1
# =============================================================================

alias _ = sudo
alias cat = bat -P
alias cb = cargo build
alias cbr = cargo build --release
alias cc = cargo clippy
alias cca = cargo clippy --all-targets
alias cd = fnmcd
alias cdoc = cargo doc
alias cdoco = cargo doc --open
alias cfg = cd ~/config
alias cr = ^cargo run --quiet
alias crd = ^cargo run --quiet --profile dev-opt
alias cre = cargo run --quiet --example
alias crr = cargo run --quiet --release
alias ct = cargo test
alias open = ^open
alias find = ^fd
alias ni = npm i
alias nci = npm ci
alias ns = npm start
alias nr = npm run
alias da = (date now | date format '%Y-%m-%d %H:%M:%S')
alias ga = git add
alias gb = git branch -v
alias gba = git branch -a
alias gbm = git branch -v --merged
alias gbnm = git branch -v --no-merged
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
alias gops = git push origin (git rev-parse --abbrev-ref HEAD | str trim) -u
alias gopsn = git push origin (git rev-parse --abbrev-ref HEAD | str trim) -u --no-verify
alias gpl = ^git pull
alias gps = git push
alias grhh = git reset HEAD --hard
alias grm = git rm
alias gsl = git stash list
alias gst = git status
alias gt = git tag
alias gun = git reset HEAD --
alias ls = exa
alias la = ls -a
alias ll = ls -l
alias lc = (ls | sort-by modified | reverse)
alias lk = (ls | sort-by size | reverse)
alias cp = ^cp -ia
alias myip = curl -s api.ipify.org
alias mv = ^mv -i
alias md = ^mkdir -p
alias rm = ^rm -i
alias rd = rmdir
alias pwd = (^pwd | str replace $nu.home-path '~')
alias pc = procs
alias py = python3
alias slp = ssh caeledh@138.197.217.136
alias sshl = ssh-add -L
alias topc = (ps | sort-by -r cpu | first 10)
alias topm = (ps | sort-by -r mem | first 10)
alias v = nvim
alias vi = nvim
alias vim = nvim
alias vimdiff = nvim -d


# =============================================================================
# Commands   {{{1
# =============================================================================

# Find broken symlinks
def fbroken [path: path] {
  ^find $path -maxdepth 1 -type l ! -exec test -e '{}' ';' -print
}

# Edit neovim configuration.
def "init nvim" [] { nvim ([$nu.home-path .config/nvim/init.lua] | path join) }

# List installed Node versions.
def "nvm list" [] {
  bash -ic "nvm list || exit"
}

# Install Node version via nvm.
def "nvm install" [version?: string] {
  bash -ic $"nvm install ($version) || exit"
}

# Uninstall Node version via nvm.
def "nvm uninstall" [version?: string] {
  bash -ic $"nvm uninstall ($version) || exit"
}

# Fuzzy search a file to edit.
def vf [] {
  let file = (fzf-tmux | str trim)
  if ($file | empty? | first) {} else {
    echo $"vim ($file)"
    echo $file | pbcopy
    nvim $file
  }
}

# Fuzzy cargo run a file.
def crf [] {
  let-env FZF_DEFAULT_COMMAND = "rg --files --hidden --no-ignore"
  let file = (fzf-tmux | str trim)
  if ($file | empty? | first) {} else {
    echo $"crd ($file)"
    echo $file | pbcopy
    crd $file
  }
}

let log_file = ([$nu.home-path .activity_log.txt] | path join);
alias lal = (open $log_file | lines | last 10)
# Log activity
def al [...rest] {
  touch $log_file
  open $log_file | append (build-string (date format "[%Y-%m-%d %H:%M]: ") ($rest | str collect " ") (char nl)) | str collect | save $log_file
}

# Fuzzy search a file to edit.
def ff [] {
  let file = (fzf-tmux | str trim)
  echo $file | pbcopy
  echo $file
}

# Fuzzy search a file to edit, including .gitignore.
def ffi [] {
  let-env FZF_DEFAULT_COMMAND = "rg --files --hidden --no-ignore-vcs"
  let file = (fzf-tmux | str trim)
  echo $file | pbcopy
  echo $file
}

# Output last N ^git commits.
def gl [count: int] {
  ^git log --pretty=%h»¦«%s»¦«%aN»¦«%aD | lines | first $count | split column "»¦«" commit message name date | update date { get date | into datetime }
}

# Output last N history commands.
def hl [count: int] {
  history | last $count
}

# Search process list for a given string.
def pg [search: string] {
  ps -l | where ($it.name | str contains $search)
}

# Restart ssh-agent.
def ra [] {
  pg ssh-agent | each { |p| kill $p.pid }
  ^rm -f /tmp/ssh-agent-info /tmp/ssh-agent
  let agent = (ssh-agent -s -a /tmp/ssh-agent)
  $agent | save /tmp/ssh-agent-info
  ssh-add ~/.ssh/id_rsa
}

# Output commits since yesterday.
def gnew [] {
  ^git --no-pager log --graph --pretty=format:'%C(yellow)%h %ad%Cred%d %Creset%Cblue[%cn]%Creset  %s (%ar)' --date=iso --all --since='23 hours ago'
}

# Output ^git branches with last commit.
def gage [] {
  # substring 2, skips the currently checked out branch: "* "
  ^git branch -a | lines | str substring 2, | wrap name | where name !~ HEAD | insert "last commit" {
      get name | each { |commit| ^git show $commit --no-patch --format=%as | str collect }
  } | sort-by "last commit"
}

# Clean old ^git branches.
def gb-clean [] {
  ^git branch -vl | lines | str substring 2, | split column " " branch hash st      atus --collapse-empty | where status == '[gone]' | each { |line| ^git branch -d $line.branch }
}

## Community Commands

# Function querying free online English dictionary API for definition of given word(s)
def dict [
  ...word # word(s) to query the dictionary API but they have to make sense together like "martial law", not "cats dogs"
] {
  let query = ($word | str collect %20)
  let link = (build-string 'https://api.dictionaryapi.dev/api/v2/entries/en/' ($query | str replace ' ' '%20'))
  let output = (fetch $link)
  if ($output | any? title == "No Definitions Found") {
    echo $output.title
  } else {
    echo $output | get meanings.definitions | flatten | flatten | select definition example
  }
}

# Print a sorted list of the largest directories.
def filesizes [] {
  ls -d | where type == dir | sort-by size | reverse
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
  let command = ($exten | where $name =~ $it.ex | first)
  if ($command|empty?) {
    echo 'Error! Unsupported file extension'
  } else {
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
  let max_len = (help commands | each { |cmd| $cmd.name | str length } | math max)
  let max_indent = ($max_len / $tablen | into int)

  def pad-tabs [input-name] {
    let input_length = ($input-name | str length)
    let required_tabs = $max_indent - ($"($input_length / $tablen | into int)" | into int)
    "" | str rpad -l $required_tabs -c (char tab)
  }

  help (echo (help commands | each { |cmd|
    let name = ($cmd.name | ansi strip)
    $"($name)(pad-tabs $name)($cmd.usage)"
  }) | str collect (char nl) | fzf-tmux | split column (char tab) | get column1 | first )
}

# Fuzzy search history.
alias hs = history search
def "history search" [] { cat $nu.history-path | fzf-tmux | pbcopy }

alias deactivate = (source ~/.config/nu/envs/deactivate.nu)
# Activate a virtual environment.
def venv [
  venv_dir: string # The virtual environment directory
] {
  let venv_name = ($venv_dir | path expand | path basename)
  let venv_path = ([$venv_dir "bin"] | path join)
  {
    VENV_OLD_PATH: $env.PATH,
    VIRTUAL_ENV: $venv_name,
    PATH: ($env.PATH | prepend $venv_path)
  }
}

# CD using `fnm` which manages node versions
def-env fnmcd [path: path] {
  let path = ($path | path expand)
  let-env PWD = (if ($path | path exists) {
    $path
  } else {
    $env.PWD
  })
  if (['.node-version' '.nvmrc'] | any? ($path | path join $it | path exists)) {
    fnm use --silent-if-unchanged
  }
  ^cd $path
}

# Print out personalized ASCII logo.
def init [] {
  if ($env.SHLVL | into int) == 1 {
    let load = (uptime | parse -r "averages: (?P<avg>.*)" | get avg)
    let sys = (sys)
    let macos = $sys.host.name =~ Darwin
    let os = (if $macos {
      let vers = (sw_vers | parse -r '(?P<name>\w+):(?P<value>.*)' | transpose -r | str trim)
      $"($vers.ProductName | str collect) ($vers.ProductVersion | str collect)"
    } else {
      uname -srm
    })
    let cpu = (if $macos {
      sysctl -n machdep.cpu.brand_string | str trim
    } else {
      cat /proc/cpuinfo | rg 'model name\s+: (.*)' -r '$1' | uniq | str trim
    })
    echo $"
               i  t             (date now | date format '%Y-%m-%d %H:%M:%S')
              LE  ED.           ($os)
             L#E  E#K:
            G#W.  E##W;         Uptime......: ($sys.host.uptime)
           D#K.   E#E##t        Memory......: ($sys.mem.free) [Free] / ($sys.mem.total) [Total]
          E#K.    E#ti##f       CPU.........: ($cpu)
        .E#E.     E#t ;##D.     Load........: ($load) [1, 5, 15 min]
       .K#E       E#ELLE##K:    IP Address..: (ifconfig en0 | rg 'inet (([0-9]{1,3}+.){4})' -or '$1' | str trim)
      .K#D        E#L;;;;;;,
     .W#G         E#t
    :W##########WtE#t
    :,,,,,,,,,,,,,.
" | lolcat
  }
}


# =============================================================================
# Startup   {{{1
# =============================================================================

let level = if (env | any? name == SHLVL) { $env.SHLVL | into int } else { 0 }
let-env SHLVL = (if (env | any? name == TMUX) && $level >= 3 {
    $level - 2
  } else {
    $level + 1
  }
)

load-env (
  fnm env --shell bash
    | lines
    | str replace 'export ' ''
    | str replace -a '"' ''
    | split column =
    | rename name value
    | where name != "FNM_ARCH" && name != "PATH"
    | reduce -f {} { |it, acc| $acc | upsert $it.name $it.value }
)
let-env PATH = ($env.PATH | prepend $"($env.FNM_MULTISHELL_PATH)/bin")

init

# =============================================================================
# Reference   {{{1
# =============================================================================

# color, abbreviation
# green  g
# red    r
# blue   u
# black  b
# yellow y
# purple p
# cyan   c
# white  w
# attribute, abbreviation
# bold       b
# underline  u

# italic     i
# dimmed     d
# reverse    r
# abbreviated: green bold = gb, red underline = ru, blue dimmed = ud
# or verbose: green_bold, red_underline, blue_dimmed


# vim: foldmethod=marker foldlevel=0
