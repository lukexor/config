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

fish_config theme choose "ayu Dark"
set fish_color_valid_path
set fish_pager_color_prefix 'normal' '--bold'


# =============================================================================
# Prompt   {{{1
# =============================================================================

starship init fish | source


# =============================================================================
# Environment   {{{1
# =============================================================================

fish_add_path -gm \
    ~/bin \
    $local_bin \
    ~/snap/bin \
    ~/.cargo/bin \
    $npm_dir \
    ~/.fzf/bin \
    /usr/local/go/bin \
    /usr/local/bin \
    /usr/bin \
    /bin \
    /usr/sbin \
    /sbin

if macos
    fish_add_path -gm \
        /Applications/kitty.app/Contents/MacOS \
        (brew --prefix)/opt/llvm/bin
else if linux 
    fish_add_path -gm \
        /usr/games
end

set -gx CLICOLOR 1
set -gx EDITOR "nvim"
set -gx PAGER "nvim +Man!"
set -gx MANPAGER "nvim +Man!"

# Tools
set -gx FZF_DEFAULT_OPTS "--height 50% --layout=reverse --border --inline-info"
set -gx FZF_CTRL_T_COMMAND "rg --files --hidden --no-ignore --glob !.git --glob !node_modules"
set -gx FZF_DEFAULT_COMMAND "rg --files --hidden --no-ignore --glob !.git --glob !node_modules"
set -gx LESS "-RFX"
# set -gx RA_LOG "info,salsa=off,chalk=off"
set -gx CARGO_TARGET_DIR ~/.cargo-target
set -gx RUST_LOG debug
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

# TODO: virtualenv with .env
if test -d ~/preveil
    set -gx ARCADEROOT ~/preveil/ARCADE/arcade_2.5/
    set -gx RUST_LOG debug,lapin=off,hyper=off,reqwest::connect=off
end

function fish_title
    set -q argv[1]; or set argv fish
    echo (fish_prompt_pwd_dir_length=1 prompt_pwd): $argv;
end

# =============================================================================
# Keybindings   {{{1
# =============================================================================

function fish_user_key_bindings
    fish_vi_key_bindings

    bind -M insert \cw backward-kill-path-component
    bind -M insert \cb prevd-or-backward-word
    bind -M insert \cf nextd-or-forward-word
    bind -M insert \co beginning-of-line
    bind -M insert \ce end-of-line
    bind -M insert \ct forward-char
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
abbr -aU ct cargo test
abbr -aU da "date +'%Y-%m-%d %H:%M:%S'"
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
abbr -aU grhh git reset HEAD --hard
abbr -aU grm git rm
abbr -aU gs git switch
abbr -aU gsl git stash list
abbr -aU gst git status
abbr -aU gt git tag
abbr -aU gun git reset HEAD --
abbr -aU h "history | head -"
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

alias gmd="git pull && git merge origin/develop"
alias gmm="git pull && git merge origin/main"

alias la="ls -a"
alias lc="ls -U"
alias lk="ls -S"
alias ll="ls -l"

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
