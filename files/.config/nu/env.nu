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
# Prompt   {{{1
# =============================================================================

let-env PROMPT_COMMAND = {
  let starship = (starship prompt --cmd-duration $env.CMD_DURATION_MS | str collect)
  let version = ((version).version)
  build-string $starship (ansi ub) "v" $version (ansi gb) " "
}
let-env PROMPT_COMMAND_RIGHT = ""
let-env PROMPT_INDICATOR = "❯ "
let-env PROMPT_INDICATOR_VI_NORMAL = ": "
let-env PROMPT_INDICATOR_VI_INSERT = "❯ "
let-env PROMPT_MULTILINE_INDICATOR = "::: "

let-env STARSHIP_SHELL = "nu"
let-env STARSHIP_SESSION_KEY = (random chars -l 16)

# =============================================================================
# Path   {{{1
# =============================================================================

let-env PATH = [
  ([$nu.home-path bin] | path join)
  ([$nu.home-path .cargo/bin] | path join)
  ([$nu.home-path .fzf/bin] | path join)
  /usr/local/bin
  /usr/games
  /usr/bin
  /bin
  /usr/sbin
  /sbin
]
let-env JAVA_HOME = "/usr/local/opt/openjdk"

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
let-env ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | str collect (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) }
    to_string: { |v| $v | str collect (char esep) }
  }
}

# =============================================================================
# Tools   {{{1
# =============================================================================

let-env CLICOLOR = 1
let-env EDITOR = "nvim"
let-env FZF_DEFAULT_OPTS = "--height 50% --layout=reverse --border --inline-info"
let-env FZF_CTRL_T_COMMAND = "rg --files --hidden"
let-env FZF_DEFAULT_COMMAND = "rg --files --hidden"
let-env LESS = "-RFX"
let-env PAGER = "nvim +Man!"
let-env MANPAGER = "nvim +Man!"

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
let-env NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
let-env NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]
