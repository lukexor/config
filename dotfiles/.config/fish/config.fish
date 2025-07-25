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

# Boot into hyprland, if available
if type -q Hyprland; and test -z "$DISPLAY"; and test (tty) = /dev/tty1
    exec Hyprland
end

# Bail out if not interactive
status is-interactive; or exit $status

# =============================================================================
# OS Utils   {{{1
# =============================================================================

set -U os (uname)
function macos
    test $os = Darwin
end
function linux
    test $os = Linux
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
set fish_pager_color_prefix normal --bold

# =============================================================================
# Prompt   {{{1
# =============================================================================

# starship init fish | source

# Copied from above to cut out additional cruft, increasing shell startup time
function fish_prompt
    set STARSHIP_KEYMAP insert
    set STARSHIP_CMD_PIPESTATUS $pipestatus
    set STARSHIP_CMD_STATUS $status
    # Account for changes in variable name between v2.7 and v3.0
    set STARSHIP_DURATION "$CMD_DURATION$cmd_duration"
    set STARSHIP_JOBS (count (jobs -p))
    starship prompt --terminal-width="$COLUMNS" \
        --status=$STARSHIP_CMD_STATUS \
        --pipestatus="$STARSHIP_CMD_PIPESTATUS" \
        --keymap=$STARSHIP_KEYMAP \
        --cmd-duration=$STARSHIP_DURATION \
        --jobs=$STARSHIP_JOBS
end

# Disable virtualenv prompt, it breaks starship
set -g VIRTUAL_ENV_DISABLE_PROMPT 1

# Remove default mode prompt
builtin functions -e fish_mode_prompt

set -gx STARSHIP_SHELL fish

# Set up the session key that will be used to store logs
# We don't use `random [min] [max]` because it is unavailable in older versions of fish shell
set -gx STARSHIP_SESSION_KEY (string sub -s1 -l16 (random)(random)(random)(random)(random)0000000000000000)

# =============================================================================
# Environment   {{{1
# =============================================================================

fish_add_path --path -gm \
    ~/.local/share/omarchy/bin \
    ~/.fzf/bin \
    ~/snap/bin \
    ~/.npm-packages/bin \
    ~/.cargo/bin \
    ~/.local/sbin \
    ~/.local/bin \
    /opt/docker-desktop/bin \
    ~/bin

if macos
    fish_add_path --path -ga \
        /Applications/kitty.app/Contents/MacOS \
        (brew --prefix)/opt/llvm/bin
    set -gx LDFLAGS -L(brew --prefix)/lib
    set -gx CPPFLAGS -I(brew --prefix)/include
    set -gx LIBRARY_PATH (brew --prefix)/lib
else if linux
    fish_add_path --path -ga \
        /usr/games
    set -gx LD_LIBRARY_PATH "$LD_LIBRARY_PATH:/usr/local/lib:/usr/lib"
end

fish_add_path --path -ga \
    /sbin \
    /bin \
    /usr/sbin \
    /usr/bin \
    /usr/local/bin \
    /usr/local/go/bin

set -g activity_log ~/.activity_log

# ssh-agent
set -g agent_info /tmp/ssh-agent-info
set -g agent_file /tmp/ssh-agent

function sa
    set -l agents_running (ps -A | rg [s]sh-agent | wc -l | string trim)
    if test -e $agent_info
        and test $agents_running -gt 0
        set -gx SSH_AUTH_SOCK $agent_file
        set -gx SSH_AGENT_PID (rg -o '=\d+' $agent_info | string replace '=' '')
        echo "SSH_AGENT_PID: $SSH_AGENT_PID"
    else
        ra
    end
end

function fish_title
    set -q argv[1]; or set argv fish
    echo (fish_prompt_pwd_dir_length=1 prompt_pwd): $argv
end

function refresh-xcompose
    pkill fcitx5
    setsid fcitx5 &>/dev/null &
end

if test -e ~/.local/config.fish
    source ~/.local/config.fish
end

set -gx CARGO_TARGET_DIR ~/.cargo-target
set -gx EDITOR nvim
set -gx SYSTEMD_EDITOR nvim
set -gx FZF_CTRL_T_COMMAND "rg --files --hidden"
set -gx FZF_DEFAULT_COMMAND "rg --files --hidden"
set -gx FZF_DEFAULT_OPTS "--height 50% --layout=reverse --border --inline-info"
set -gx LESS -RFX
set -gx MANPAGER "nvim +Man!"
set -gx PAGER "nvim +Man!"
set -gx TERMINAL kitty
set -gx VISUAL nvim
set -gx CM_LAUNCHER bemenu

# =============================================================================
# Keybindings   {{{1
# =============================================================================

function fish_user_key_bindings
    fish_default_key_bindings -M insert
    fish_vi_key_bindings --no-erase insert

    bind -M insert \cH backward-kill-word # ctrl-backspace
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

abbr -a ! sudo
abbr -a cat bat -P
abbr -a bat bat -P
abbr -a cb cargo build --keep-going
abbr -a cbr cargo build --release --keep-going
abbr -a cc cargo clippy --all-features --keep-going
abbr -a ccw cargo clippy --keep-going --all-features --target wasm32-unknown-unknown
abbr -a cca cargo clippy --all-targets --all-features --keep-going
abbr -a cdoc cargo doc --keep-going
abbr -a cdoco cargo doc --keep-going --open
abbr -a cfg cd ~/config
abbr -a cgc fd . -t d --change-older-than 1week $CARGO_TARGET_DIR -x rm -rf {}
abbr -a cm cargo make
abbr -a cr cargo run
abbr -a cr cargo run
abbr -a crd cargo run --profile dev-opt
abbr -a cre cargo run --example
abbr -a crr cargo run --release
abbr -a ct cargo test --no-fail-fast
abbr -a ctw cargo test --workspace --no-fail-fast
abbr -a cta cargo test --workspace --all-targets --no-fail-fast
abbr -a curl xh
abbr -a cw cargo watch
abbr -a da "date +'%Y-%m-%d %H:%M:%S'"
abbr -a d docker
abbr -a dc docker compose
abbr -a dcr docker compose run
abbr -a df df -h
abbr -a dsp docker system prune
abbr -a du dust
abbr -a find fd
abbr -a flg CARGO_PROFILE_RELEASE_DEBUG=true cargo flamegraph --root
abbr -a ga git add
abbr -a gba git branch -a
abbr -a gbd git branch -d
abbr -a gb git branch -v
abbr -a gbm git branch -v --merged
abbr -a gbnm git branch -v --no-merged
abbr -a gcam git commit --amend
abbr -a gcb git checkout -b
abbr -a gc git commit
abbr -a gco git checkout
abbr -a gcp git cherry-pick
abbr -a gdc git diff --cached
abbr -a gd git diff
abbr -a gdt git difftool -y
abbr -a gf git fetch origin
# %h - abbreviated commit hash
# %p - abbreviated parent hashes
# %ae - author email
# %s - subject
# %ar - author date, relative
# %d - ref names
# %b - body
# %N - commit notes
abbr -a glg git log --graph --decorate --oneline --pretty=format:\"%C\(yellow\)%h \(%p\) %Cgreen[%as] %Cblue[%ae]%Creset %s%Cred%d%Creset. %b %N\"
abbr -a gm git rebase
abbr -a gpl git pull
abbr -a gps git push
abbr -a gpsf git push --force-with-lease
abbr -a grep rg
abbr -a gr git restore
abbr -a grhh git reset HEAD --hard
abbr -a grm git rm
abbr -a gs git switch
abbr -a gsl git stash list
abbr -a gst git status -sb
abbr -a gt git tag
abbr -a gun git reset HEAD --
abbr -a h "history | head -"
abbr -a ir irust
abbr -a la eza -a
abbr -a lk eza -lrs size
abbr -a ll eza -al
abbr -a ls eza
abbr -a lt eza --tree
abbr -a mkdir mkdir -p
abbr -a myip curl -s api.ipify.org
abbr -a nci npm ci
abbr -a ns nix-shell --command \"exec fish\"
abbr -a ps procs
abbr -a py python3
abbr -a python python3
abbr -a rd rmdir
abbr -a sed sd
abbr -a s fd --type f --exec sd
abbr -a sshl ssh-add -L
abbr -a _ sudo
abbr -a vimdiff nvim -d
abbr -a vd nvim -d
abbr -a vim nvim
abbr -a vi nvim
abbr -a v nvim

function pg
    procs | rg "PID|$argv"
end

if macos
    abbr -a topc "ps -Ao user,uid,pid,pcpu,tty,comm -r | head"
    abbr -a topm "ps -Ao user,uid,pid,pmem,tty,comm -m | head"
    abbr -a o open
else if linux
    abbr -a topc "ps -Ao user,uid,pid,pcpu,tty,comm --sort=-pcpu | head"
    abbr -a topm "ps -Ao user,uid,pid,pmem,tty,comm --sort=-pmem | head"
    abbr -a o xdg-open
end

# =============================================================================
# Aliases   {{{1
# =============================================================================

alias cal="echo -n "" > $activity_log"
alias lal="[ -r $activity_log ] && cat $activity_log | head || echo 'nothing logged'"

alias cp="cp -ia"
alias mv="mv -i"
abbr -a rm "trash put"

alias dirsize="fd -t d | xargs du -sh"
function path
    echo $PATH | string split " "
end

alias gmd="git pull && git rebase origin/develop"
alias gmm="git pull && git rebase origin/main"

alias nrs="nixos-rebuild.sh"

# Starts kitty with software rendering
function start_kitty
    set -gx LIBGL_ALWAYS_SOFTWARE 1
    kitty &
    disown
    exit
end

# =============================================================================
# Init   {{{1
# =============================================================================

direnv hook fish | source

if type -q mise
    mise activate fish | source
end

if type -q zoxide
    zoxide init fish | source
end

if type -q fzf
    if test -f /usr/share/fish/completions/fzf.fish
        source /usr/share/fish/completions/fzf.fish
    end
end

function fish_greeting
    echo -n -s "$nix_shell_info"
    if test $SHLVL -gt 1
        return
    end
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
    " | dotacat
    sa
end

# vim: foldmethod=marker foldlevel=0
