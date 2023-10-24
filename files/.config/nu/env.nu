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
  ~/bin
  ~/.local/bin
  ~/.local/share/nvim/mason/bin/
  ~/.cargo/bin
  ~/.npm-packages/bin
  ~/snap/bin
  ~/.fzf/bin
  /usr/local/go/bin
  /usr/local/bin
  /usr/bin
  /usr/sbin
  /bin
  /sbin
]

$env.PATH = if $nu.os-info.name == "macos" {
  ($env.PATH | append [
    "/Applications/kitty.app/Contents/MacOS"
    "~/.local/opt/llvm/bin"
  ])
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
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
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
if ($env.AGENT_INFO | path exists) {
    $env.SSH_AUTH_SOCK = $env.AGENT_FILE
    $env.SSH_AGENT_PID = (~/.cargo/bin/rg -o '=\d+' $env.AGENT_INFO | str replace = '' | str trim)
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
$env.NU_LIB_DIRS = [
  ~/.config/nu/scripts
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
$env.NU_PLUGIN_DIRS = [
  ~/.config/nu/plugins
]

# vim: foldmethod=marker foldlevel=0
