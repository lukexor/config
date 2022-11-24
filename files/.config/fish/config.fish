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

if not status is-interactive
    return
end

set -U os $(uname)

function macos
    test $os = "Darwin"
end
function linux
    test $os = "Linux"
end


# =============================================================================
# Environment   {{{1
# =============================================================================

starship init fish | source

fish_add_path -gm \
    ~/bin \
    $local_bin \
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

set -g agent_info /tmp/ssh-agent-info
set -g agent_file /tmp/ssh-agent
set -l agents_running $(ps -A | rg [s]sh-agent | wc -l | string trim)
if test -e $agent_info
    and test $agents_running -gt 0
    set -gx SSH_AUTH_SOCK $agent_file
    set -gx SSH_AGENT_PID $(rg -o '=\d+' $agent_info | string replace '=' '')
end

# TODO: virtualenv with .env


# =============================================================================
# Tools   {{{1
# =============================================================================

set -gx CLICOLOR 1
set -gx EDITOR "nvim"
set -gx FZF_DEFAULT_OPTS "--height 50% --layout=reverse --border --inline-info"
set -gx FZF_CTRL_T_COMMAND "rg --files --hidden --no-ignore --glob !.git --glob !node_modules"
set -gx FZF_DEFAULT_COMMAND "rg --files --hidden --no-ignore --glob !.git --glob !node_modules"
set -gx LESS "-RFX"
set -gx PAGER "nvim +Man!"
set -gx MANPAGER "nvim +Man!"
# set -gx RA_LOG "info,salsa=off,chalk=off"
set -gx CARGO_TARGET_DIR "~/.cargo-target"


# =============================================================================
# Keybindings   {{{1
# =============================================================================

bind \cw backward-kill-path-component
bind \cb prevd-or-backward-word
bind \cf nextd-or-forward-word
bind \co beginning-of-line
bind \ce end-of-line
bind \ct forward-char
bind \cr fzf_history
bind \cs fzf_file
bind \cy fzf_dir


# =============================================================================
# Completions   {{{1
# =============================================================================

# TODO: git/cargo/npm/yarn/tldr

# vim: foldmethod=marker foldlevel=0


# =============================================================================
# Abbreviations   {{{1
# =============================================================================

set -g activity_log ~/.activity_log.txt
# fish_clipboard_copy fish_clipboard_paste

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
abbr -aU slp kitty +kitten ssh caeledh@138.197.217.136
abbr -aU sshl ssh-add -L
abbr -aU v nvim
abbr -aU vi nvim
abbr -aU vim nvim
abbr -aU vimdif nvim -d

if macos
    abbr -aU topc "ps -Ao user,uid,pid,pcpu,tty,comm -r | head"
    abbr -aU topm "ps -Ao user,uid,pid,pcpu,tty,comm -m | head"
    abbr -aU o open
else if linux
    abbr -aU topc "ps -Ao user,uid,pid,pcpu,tty,comm --sort=-pcpu | head"
    abbr -aU topm "ps -Ao user,uid,pid,pcpu,tty,comm --sort=-pmem | head"
    abbr -aU o xdg-open
end


# =============================================================================
# Aliases   {{{1
# =============================================================================

# TODO: Cargo tag version/publish?

alias cal="echo -n "" > $activity_log"
alias cp="cp -i"
alias dirsize="fd -t d | xargs du -sh"
alias glg="git log --graph --pretty=format:'%C(yellow)%h (%p) %ai%Cred%d %Creset%Cblue[%ae]%Creset %s (%ar). %b %N'"
alias gmd="git pull && git merge origin/develop"
alias gmm="git pull && git merge origin/main"
alias gops='git push origin $(git rev-parse --abbrev-ref HEAD | string trim) -u'
alias gopsn='git push origin $(git rev-parse --abbrev-ref HEAD | string trim) -u --no-verify'
alias la="ls -a"
alias lal="cat $activity_log | head"
alias lc="ls -U"
alias lk="ls -S"
alias ll="ls -l"
alias mv="mv -i"
alias rm="rm -i"


# =============================================================================
# Aliases   {{{1
# =============================================================================
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
" | lolcat
