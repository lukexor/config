####################################################################################################
## COLOUR

tm_icon=""
tm_color_active=red
tm_color_inactive=cyan
tm_color_branch=yellow
tm_color_feature=white
tm_color_path=green
tm_color_music=green
tm_active_border_color=yellow

# separators
tm_separator_left_bold="◀"
tm_separator_left_thin="❮"
tm_separator_right_bold="▶"
tm_separator_right_thin="❯"

set -g status-left-length 32
set -g status-right-length 150
set -g status-interval 5


# default statusbar colors
# set-option -g status-bg colour0
set-option -g status-style fg=$tm_color_active

# default window title colors
set-window-option -g window-status-style fg=$tm_color_inactive
set -g window-status-format "#I #W"

# active window title colors
set-window-option -g window-status-current-style fg=$tm_color_active
set-window-option -g  window-status-current-format "#[bold]#I #W"

# pane border
set-option -g pane-border-style fg=$tm_color_inactive
set-option -g pane-active-border-style fg=$tm_active_border_color

# message text
set-option -g message-style fg=$tm_color_active

# pane number display
set-option -g display-panes-active-colour $tm_color_active
set-option -g display-panes-colour $tm_color_inactive

# clock
set-window-option -g clock-mode-colour $tm_color_active

# tm_tunes="#[fg=$tm_color_music]#(osascript ~/.dotfiles/applescripts/tunes.scpt)"
tm_battery="#(~/.dotfiles/bin/battery_indicator.sh)"
tm_branch="#[fg=$tm_color_branch] #(~/.dotfiles/bin/parse_git_branch.sh)"
tm_path="#[fg=$tm_color_path]#{s|$HOME|~|:pane_current_path}"

tm_date="#[fg=$tm_color_feature]|#[fg=$tm_color_inactive] %Y-%m-%d %H:%M"
tm_host="#[fg=$tm_color_feature,bold]#h"
tm_session_name="#[fg=$tm_color_feature,bold]$tm_icon #S"

set -g status-left $tm_session_name' '
set -g status-right $tm_path$tm_branch' '$tm_date' '$tm_host' '$tm_battery
