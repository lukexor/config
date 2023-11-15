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

let os = ($nu.os-info.name)
let theme = {
    # color for nushell primitives
    separator: white
    leading_trailing_space_bg: { attr: n } # no fg, no bg, attr none effectively turns this off
    header: green_bold
    empty: blue
    # Closures can be used to choose colors for specific values.
    # The value (in this case, a bool) is piped into the closure.
    # eg. { || if $in { 'light_cyan' } else { 'light_gray' } }
    bool: light_cyan
    int: white
    filesize: cyan
    duration: white
    date: purple
    range: white
    float: white
    string: white
    nothing: white
    binary: white
    cell-path: white
    row_index: green_bold
    record: white
    list: white
    block: white
    hints: dark_gray
    search_result: {bg: red fg: white}
    shape_and: purple_bold
    shape_binary: purple_bold
    shape_block: blue_bold
    shape_bool: light_cyan
    shape_closure: green_bold
    shape_custom: green
    shape_datetime: cyan_bold
    shape_directory: cyan
    shape_external: cyan
    shape_externalarg: green_bold
    shape_filepath: cyan
    shape_flag: blue_bold
    shape_float: purple_bold
    # shapes are used to change the cli syntax highlighting
    shape_garbage: { fg: white bg: red attr: b}
    shape_globpattern: cyan_bold
    shape_int: purple_bold
    shape_internalcall: cyan_bold
    shape_list: cyan_bold
    shape_literal: blue
    shape_match_pattern: green
    shape_matching_brackets: { attr: u }
    shape_nothing: light_cyan
    shape_operator: yellow
    shape_or: purple_bold
    shape_pipe: purple_bold
    shape_range: yellow_bold
    shape_record: cyan_bold
    shape_redirection: purple_bold
    shape_signature: green_bold
    shape_string: green
    shape_string_interpolation: cyan_bold
    shape_table: blue_bold
    shape_variable: purple
    shape_vardecl: purple
}

let menu_style = {
  text: green
  selected_text: green_reverse
  description_text: yellow
}

$env.config = {
  completions: {
    case_sensitive: false
    quick: true
    partial: true
    algorithm: "prefix"
    external: {
      enable: true
      max_results: 100
      completer: null
    }
  }
  filesize: {
    metric: true
    format: "auto"
  }
  history: {
    max_size: 10000
    file_format: "sqlite"
    sync_on_enter: true
  }
  ls: {
    use_ls_colors: true
    clickable_links: true
  }
  rm: {
    always_trash: true
  }
  show_banner: false
  error_style: "fancy"
  table: {
    mode: rounded
    index_mode: always
    show_empty: false,
    trim: {
      methodology: wrapping
      wrapping_try_keep_words: true
      truncating_suffix: "..."
    }
    header_on_separator: false
  }
  color_config: $theme
  use_grid_icons: true
  footer_mode: "30"
  float_precision: 2
  use_ansi_coloring: true
  shell_integration: true
  use_kitty_protocol: true
  edit_mode: vi
  hooks: {
    pre_prompt: [{ ||
      let direnv = (direnv export json | from json | default {})
      if ($direnv | is-empty) {
        return
      }
      $direnv
      | items { |key, value|
        {
          key: $key
          value: (if $key in $env.ENV_CONVERSIONS {
            do ($env.ENV_CONVERSIONS | get $key | get from_string) $value
          } else {
            $value
          })
        }
      } | transpose -ird | load-env
    }]
    env_change: {
      PWD: []
    }
  }
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
          | par-each { |it| {value: $it.command description: $it.usage} }
      }
    }
  ]
  keybindings: [
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
          {
            send: executehostcommand
            cmd: "commandline (history
            | get command
            | reverse
            | to text
            | fzf +s)"
          }
          { send: menupagenext }
        ]
      }
    }
    {
      name: history_previous
      modifier: shift_control
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
      event: { send: historyhintwordcomplete }
    }
    {
      name: clearscreen
      modifier: control
      keycode: char_l
      mode: vi_insert
      event: { send: clearscreen }
    }
    {
      name: fzf_dir
      modifier: control
      keycode: char_y
      mode: vi_insert
      event: [
        {
          send: executehostcommand
          cmd: "commandline -i (fzf_dir)"
        }
      ]
    }
    {
      name: fzf_edit
      modifier: control
      keycode: char_s
      mode: vi_insert
      event: [
        {
          send: executehostcommand
          cmd: "commandline -i (fzf_file)"
        }
      ]
    }
    {
      name: exit
      modifier: control
      keycode: char_d
      mode: vi_insert
      event: { send: ctrld }
    }
  ]
}

# =============================================================================
# Completions   {{{1
# =============================================================================

use ~/.config/nu/completions/git.nu *
use ~/.config/nu/completions/cargo.nu *
use ~/.config/nu/completions/npm.nu *
use ~/.config/nu/completions/yarn.nu *
use ~/.config/nu/completions/tldr.nu *

# takes a table of parsed help commands in format [short? long format? description]
def make-completion [command_name: string] {
  # help format  '        -s,                      --long                   <format>                 description   '
  $in
    | parse -r '\s\s+(?:-(?P<short>\w)[,\s]+)?(?:--(?P<long>[\w-]+))\s*(?:<(?P<format>.*)>)?\s*(?P<description>.*)?'
    | build-string "extern \"" $command_name "\" [\n" ($in | par-each { |it|
      build-string "\t--" $it.long (if ($it.short | is-empty) == false {
          build-string "(-" $it.short ")"
      }) (if ($it.description | is-empty) == false {
          build-string "\t\t# " $it.description
      })
  } | str join "\n") "\n\t...args\n]"
}

# =============================================================================
# Aliases   {{{1
# =============================================================================

alias _ = sudo
alias c = cargo
alias cat = bat -P
alias cfg = cd ~/config
# alias clipboard = if $os == "linux" { xclip } else if $os == "macos" { pbcopy } else { echo $"clipboard not supported on ($os)" }
alias cm = cargo make
# FIXME: Switch to default cp when ctrl-c is fixed
alias cp = ^cp -ia
alias curl = xh
alias dc = docker compose
alias du = dust
alias find = fd
alias flg = CARGO_PROFILE_RELEASE_DEBUG=true cargo flamegraph --root
alias ir = irust
alias ls = exa --icons
alias la = ls -a
alias lk = ls -lrs size
alias ll = ls -l
alias lt = ls --tree
alias mv = mv -if
alias myip = curl -s api.ipify.org
alias nci = npm ci
alias ni = npm i
alias nr = npm run
alias ns = npm start
alias nc = ncspot
alias pc = procs
alias py = python3
alias rd = rmdir
alias rm = ^rm -i
alias sed = sd
alias sopen = open
alias sshl = ssh-add -L
alias st = echo ($nu).startup-time
alias v = nvim
alias vi = nvim
alias vim = nvim
alias vimdiff = nvim -d

# =============================================================================
# Commands   {{{1
# =============================================================================

# Make directory
def md [dir: string] {
  ^mkdir -p $dir
}

# Current date.
def da [] {
  date now | format date "%Y-%m-%d %H:%M:%S"
}

# Calculate directory sizes.
def dirsize [] {
  fd -t d | xargs du -sh
}

# Current directory.
def pwd [] {
  ^pwd | str replace $nu.home-path "~"
}

# Top CPU usage.
def topc [] {
  ps | sort-by -r cpu | first 10
}

# Top MEM usage.
def topm [] {
  ps | sort-by -r mem | first 10
}

# Show last $count history entries
def h [count: int = 10] {
  history
  | select item_id command cwd duration exit_status
  | last $count
  | each { |it| update cwd { get cwd | str replace $env.HOME "~" } }
}

# Open file using the default system application.
def o [path: path] {
  if $os == "linux" {
    xdg-open $path
  } else if $os == "macos" {
    ^open $path
  } else {
    echo $"open not supported on ($os)"
  }
}

# Find broken symlinks
def fbroken [path: path = "."] {
  ^find $path -maxdepth 1 -type l ! -exec test -e '{}' ';' -print
}

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

# Fuzzy search file
def fzf_file [flags: string = ""] {
  fzf | str trim
}

# Fuzzy search directory
def fzf_dir [flags: string = ""] {
  fd -t d | fzf | str trim
}

# Fuzzy cargo run a file.
def crf [] {
  let file = (fzf_file)
  if ($file | is-empty) {} else {
    echo $"crd ($file)"
    echo $file | clipboard
    crd $file
  }
}

let log_file = ([$nu.home-path .activity_log.txt] | path join);

# Last 10 lines of activity log.
def lal [] {
  open $log_file | lines | last 10
}

# Log activity.
def al [
  ...rest: string # activity message to log
] {
  if not ($log_file | path exists) {
    touch $log_file
  }

  let date = (date now | format date "%Y-%m-%d %H:%M")
  $"[($date)]: ($rest | str join ' ')(char nl)" | save -a $log_file
}

# Clear activity log.
def cl [] {
  echo "" | save -f $log_file
}

# Fuzzy search a file to edit.
def ff [] {
  let file = (fzf_file)
  echo $file | clipboard
  echo $file
}

# Fuzzy search a file to edit, including .gitignore.
def ffi [] {
  let file = (fzf_file "--no-ignore-vcs")
  echo $file | clipboard
  echo $file
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
def-env ra [] {
  pg ssh-agent | each { |p| kill $p.pid }
  rm -f $env.AGENT_INFO $env.AGENT_FILE

  let agent = (ssh-agent -s -a $env.AGENT_FILE)
  $agent | save $env.AGENT_INFO
  $env.SSH_AUTH_SOCK = $env.AGENT_FILE
  $env.SSH_AGENT_PID = (rg -o '=\d+' $env.AGENT_INFO | str replace = '' | str trim)

  [id_rsa id_ed25519] | each { |file|
    let file = ([$nu.home-path .ssh $file] | path join)
    if ($file | path exists) {
      ssh-add $file
    }
  } | ignore
}

def config_files [] {
  [nvim kitty fish fishl nu nul nue starship]
}

# Edit configuration files
def config [
  config: string@config_files # config file to edit
] {
  let home = $nu.home-path
  if $config == "nvim" {
    nvim $"($home)/.config/nvim/init.lua"
  } else if $config == "kitty" {
    nvim $"($home)/.config/kitty/kitty.conf"
  } else if $config == "fish" {
    nvim $"($home)/.config/fish/config.fish"
  } else if $config == "fishl" {
    nvim $"($home)/.local/config.fish"
  } else if $config == "nu" {
    nvim $"($home)/.config/nu/config.nu"
  } else if $config == "nul" {
    nvim $"($home)/.local/config.nu"
  } else if $config == "nue" {
    nvim $"($home)/.config/nu/env.nu"
  } else if $config == "starship" {
    nvim $"($home)/.config/starship.toml"
  } else {
    echo $"Error! `($config)` is not a valid config"
  }
}

# Community Commands

# Function querying free online English dictionary API for definition of given word(s)
def dict [
  ...word # word(s) to query the dictionary API but they have to make sense together like "martial law", not "cats dogs"
] {
  let query = ($word | str join %20)
  let link = $"https://api.dictionaryapi.dev/api/v2/entries/en/($query | str replace ' ' '%20')"
  let output = (http get -e $link)
  if "title" in $output and $output.title == "No Definitions Found" {
    echo $output.title
  } else {
    echo $output
      | get meanings
      | flatten
      | select partOfSpeech definitions
      | flatten
      | flatten
      | reject "synonyms"
      | reject "antonyms"
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
  if ($command | is-empty) {
    echo 'Error! Unsupported file extension'
  } else {
    nu -c (build-string $command.com ' ' $name)
  }
}

# Fuzzy search commands.
# on selection, will display `help` for the commands
# and paste command into clipboard for you to paste right away
def "commands search" [] {
  # calculate required tabs/spaces to get a nicely aligned table
  let tablen = 8
  let max_len = (help commands | par-each { |cmd| $cmd.name | str length } | math max)
  let max_indent = ($max_len / $tablen | into int)

  def pad-tabs [input_name] {
    let input_length = ($input_name | str length)
    let required_tabs = $max_indent - ($"($input_length / $tablen | into int)" | into int)
    "" | fill -a right -w $required_tabs -c (char tab)
  }

  let command = (help commands | par-each { |cmd|
      let name = ($cmd.name | ansi strip)
      $"($name)(pad-tabs $name)($cmd.usage)"
    } | str join (char nl) | fzf)

  if (not ($command | is-empty)) {
    help ($command | split column (char tab) | get column1 | first)
  }
}
alias cs = commands search


# =============================================================================
# Startup   {{{1
# =============================================================================

use ~/.local/rtx.nu *
use ~/.local/config.nu *

# Load ssh-agent.
def-env load-ssh-agent [] {
  let agent_active = ($env.AGENT_INFO | path exists)
  $env.SSH_AUTH_SOCK = if $agent_active { $env.AGENT_FILE } else { "" }
  $env.SSH_AGENT_PID = if $agent_active { rg -o '=\d+' $env.AGENT_INFO | str replace = '' | str trim } else { "" }
}

let level = if ("SHLVL" in $env) { $env.SHLVL | into int } else { 0 }
$env.SHLVL = $level + 1

# Print out personalized ASCII logo.
def logo [] {
  if ($env.SHLVL | into int) == 1 {
    echo $"
               i  t
              LE  ED.
             L#E  E#K
            G#W.  E##W;
           D#K.   E#E##t
          E#K.    E#ti##f
        .E#E.     E#t ;##D.
       .K#E       E#ELLE##K:
      .K#D        E#L;;;;;;,
     .W#G         E#t
    :W##########WtE#t
    :,,,,,,,,,,,,,.
" | lolcat
  }
}

logo
load-ssh-agent

# =============================================================================
