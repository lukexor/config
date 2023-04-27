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

# Bail out if not interactive
status is-interactive; or exit $status

# =============================================================================
# OS Utils   {{{1
# =============================================================================

set -U os (uname)
function macos
    test $os = "Darwin"
end
function linux
    test $os = "Linux"
end

# =============================================================================
# Settings   {{{1
# =============================================================================

set -U fish_color_normal B3B1AD
set -U fish_color_command 39BAE6
set -U fish_color_quote C2D94C
set -U fish_color_redirection FFEE99
set -U fish_color_end F29668
set -U fish_color_error FF3333
set -U fish_color_param B3B1AD
set -U fish_color_comment 626A73
set -U fish_color_match F07178
set -U fish_color_selection --background=E6B450
set -U fish_color_search_match --background=E6B450
set -U fish_color_history_current --bold
set -U fish_color_operator E6B450
set -U fish_color_escape 95E6CB
set -U fish_color_cwd 59C2FF
set -U fish_color_cwd_root red
set -U fish_color_valid_path --underline
set -U fish_color_autosuggestion 4D5566
set -U fish_color_user brgreen
set -U fish_color_host normal
set -U fish_color_cancel -r
set -U fish_pager_color_completion normal
set -U fish_pager_color_description B3A06D yellow
set -U fish_pager_color_prefix normal --bold --underline
set -U fish_pager_color_progress brwhite --background=cyan
set fish_color_valid_path
set fish_pager_color_prefix 'normal' '--bold'


# =============================================================================
# Prompt   {{{1
# =============================================================================

starship init fish | source


# =============================================================================
# Environment   {{{1
# =============================================================================

fish_add_path --path -gm \
    ~/.fzf/bin \
    $npm_dir \
    ~/.cargo/bin \
    ~/snap/bin \
    $local_bin \
    ~/bin

if macos
    fish_add_path --path -ga \
        /Applications/kitty.app/Contents/MacOS \
        (brew --prefix)/opt/llvm/bin
else if linux 
    fish_add_path --path -ga \
        /usr/games
end

fish_add_path --path -ga \
    /bin \
    /sbin \
    /usr/bin \
    /usr/sbin \
    /usr/local/bin \
    /usr/local/go/bin \

set -gx CLICOLOR 1
set -gx VISUAL "nvim"
set -gx EDITOR "nvim"
set -gx PAGER "nvim +Man!"
set -gx MANPAGER "nvim +Man!"

# Tools
set -gx FZF_DEFAULT_OPTS "--height 50% --layout=reverse --border --inline-info"
set -gx FZF_CTRL_T_COMMAND "rg --files --hidden"
set -gx FZF_DEFAULT_COMMAND "rg --files --hidden"
set -gx LESS "-RFX"
# NOTE: To debug rust-analyzer
# set -gx RA_LOG "info,salsa=off,chalk=off"
set -gx CARGO_TARGET_DIR ~/.cargo-target
set -gx CARGO_INCREMENTAL 0 # Required for SCCACHE
set -gx RUSTC_WRAPPER ~/.cargo/bin/sccache
set -g activity_log ~/.activity_log.txt

# ssh-agent
set -g agent_info /tmp/ssh-agent-info
set -g agent_file /tmp/ssh-agent
set -l agents_running (ps -A | rg [s]sh-agent | wc -l | string trim)
if test -e $agent_info
    and test $agents_running -gt 0
    set -gx SSH_AUTH_SOCK $agent_file
    set -gx SSH_AGENT_PID (rg -o '=\d+' $agent_info | string replace '=' '')
end

function fish_title
    set -q argv[1]; or set argv fish
    echo (fish_prompt_pwd_dir_length=1 prompt_pwd): $argv;
end

if test -e ~/.local/config.fish
    source ~/.local/config.fish
end

# =============================================================================
# Keybindings   {{{1
# =============================================================================

function fish_user_key_bindings
    fish_default_key_bindings -M insert
    fish_vi_key_bindings --no-erase insert

    bind -M insert \eb prevd-or-backward-word
    bind -M insert \ef nextd-or-forward-word
    bind -M insert \cr fzf_history
    bind -M insert \cs fzf_file
    bind -M insert \cy fzf_dir
end


# =============================================================================
# Completions   {{{1
# =============================================================================

# TODO:
# git
# cargo
# npm
# yarn
# tldr


# =============================================================================
# Abbreviations   {{{1
# =============================================================================

abbr -aU _ sudo
abbr -aU cat bat -P
abbr -aU cb cargo build
abbr -aU cbr cargo build --release
abbr -aU cc cargo clippy
abbr -aU cca cargo clippy --all-targets
abbr -aU cdoc cargo doc
abbr -aU cdoco cargo doc --open
abbr -aU cfg cd ~/config
abbr -aU cp cp -ia
abbr -aU cr cargo run
abbr -aU crd cargo run --profile dev-opt
abbr -aU cre cargo run --example
abbr -aU crr cargo run --release
abbr -aU cw cargo watch
abbr -aU ct cargo test --workspace --all-targets
abbr -aU ct cargo test --workspace
abbr -aU da "date +'%Y-%m-%d %H:%M:%S'"
abbr -aU du dust
abbr -aU find fd
abbr -aU flg CARGO_PROFILE_RELEASE_DEBUG=true cargo flamegraph --root
abbr -aU ga git add
abbr -aU gb git branch -v
abbr -aU gba git branch -a
abbr -aU gbd git branch -d
abbr -aU gbm git branch -v --merged
abbr -aU gbnm git branch -v --no-merged
abbr -aU gc git commit
abbr -aU gcam git commit --amend
abbr -aU gcb git checkout -b
abbr -aU gco git checkout
abbr -aU gcp git cherry-pick
abbr -aU gd git diff
abbr -aU gdc git diff --cached
abbr -aU gdt git difftool
abbr -aU gf git fetch origin
abbr -aU gm git merge
abbr -aU gpl git pull
abbr -aU gps git push
abbr -aU gr git restore
abbr -aU grep rg
abbr -aU grhh git reset HEAD --hard
abbr -aU grm git rm
abbr -aU gs git switch
abbr -aU gsl git stash list
abbr -aU gst git status
abbr -aU gt git tag
abbr -aU gun git reset HEAD --
abbr -aU h "history | head -"
abbr -aU ls exa
abbr -aU la exa -a
abbr -aU lk exa -lrs size
abbr -aU ll exa -l
abbr -aU mkdir mkdir -p
abbr -aU myip curl -s api.ipify.org
abbr -aU nci npm ci
abbr -aU ni npm i
abbr -aU nr npm run
abbr -aU ns npm start
abbr -aU pc procs
abbr -aU pg "ps -Ao user,uid,pid,pcpu,tty,comm | rg"
abbr -aU py python3
abbr -aU rd rmdir
abbr -aU slp ssh caeledh@138.197.217.136
abbr -aU sshl ssh-add -L
abbr -aU v nvim
abbr -aU vi nvim
abbr -aU vim nvim
abbr -aU vimdif nvim -d

if macos
    abbr -aU topc "ps -Ao user,uid,pid,pcpu,tty,comm -r | head"
    abbr -aU topm "ps -Ao user,uid,pid,pmem,tty,comm -m | head"
    abbr -aU o open
else if linux
    abbr -aU topc "ps -Ao user,uid,pid,pcpu,tty,comm --sort=-pcpu | head"
    abbr -aU topm "ps -Ao user,uid,pid,pmem,tty,comm --sort=-pmem | head"
    abbr -aU o xdg-open
end


# =============================================================================
# Aliases   {{{1
# =============================================================================

alias cal="echo -n "" > $activity_log"
alias lal="cat $activity_log | head"

alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

alias dirsize="fd -t d | xargs du -sh"
function path
    echo $PATH | string split " "
end

alias gmd="git pull && git merge origin/develop"
alias gmm="git pull && git merge origin/main"

# =============================================================================
# Init   {{{1
# =============================================================================

function fish_greeting
    echo "
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

   "(uptime)"
    " | lolcat
end


# vim: foldmethod=marker foldlevel=0
