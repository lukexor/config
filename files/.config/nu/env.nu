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
#    Personal nushell env configuration of Luke Petherbridge <me@lukeworks.tech>


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

# =============================================================================
# Prompt   {{{1
# =============================================================================

use ~/.cache/starship/init.nu
$env.PROMPT_INDICATOR_VI_NORMAL = ": "
$env.PROMPT_INDICATOR_VI_INSERT = ""

# =============================================================================
# Path   {{{1
# =============================================================================

$env.PATH = [
  ([$nu.home-path bin] | path join)
  ([$nu.home-path .local/bin] | path join)
  ([$nu.home-path .local/share/nvim/mason/bin/] | path join)
  ([$nu.home-path .cargo/bin] | path join)
  ([$nu.home-path .npm-packages/bin] | path join)
  ([$nu.home-path snap/bin] | path join)
  ([$nu.home-path .fzf/bin] | path join)
  /usr/local/go/bin
  /usr/local/bin
  /usr/bin
  /usr/sbin
  /bin
  /sbin
]

$env.PATH = if $nu.os-info.name == "macos" {
  ($env.PATH | append [
    "/Applications/kitty.app/Contents/MacOS",
    ([(brew --prefix | str trim) opt/llvm/bin] | path join)]
  )
} else {
  $env.PATH | append [
    /usr/games
  ]
}

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | str join (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | str join (char esep) }
  }
}

# =============================================================================
# Tools   {{{1
# =============================================================================

$env.CLICOLOR = 1
$env.TERMINAL = "kitty"
$env.VISUAL = "nvim"
$env.EDITOR = "nvim"
$env.PAGER = "nvim +Man!"
$env.MANPAGER = "nvim +Man!"
$env.LESS = "-RFX"

$env.FZF_DEFAULT_OPTS = "--height 50% --layout=reverse --border --inline-info"
$env.FZF_CTRL_T_COMMAND = "rg --files --hidden --no-ignore --glob !.git --glob !node_modules"
$env.FZF_DEFAULT_COMMAND = "rg --files --hidden --no-ignore --glob !.git --glob !node_modules"

# NOTE: To debug rust-analyzer
# $env.RA_LOG = "info,salsa=off,chalk=off"
$env.CARGO_TARGET_DIR = ([$nu.home-path .cargo-target] | path join)
$env.ACTIVITY_LOG = ([$nu.home-path .activity_log.txt] | path join)

$env.AGENT_INFO = "/tmp/ssh-agent-info"
$env.AGENT_FILE = "/tmp/ssh-agent"
let agents_running = (ps | where name =~ ssh-agent | length)
if ($env.AGENT_INFO | path exists) and $agents_running > 0 {
    $env.SSH_AUTH_SOCK = $env.AGENT_FILE
    $env.SSH_AGENT_PID = (rg -o '=\d+' $env.AGENT_INFO | str replace '=' '')
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
$env.NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
$env.NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]
