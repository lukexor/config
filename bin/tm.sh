#!/bin/bash

# abort if we're already inside a TMUX session
[ "$TMUX" == "" ] || exit 0
# startup a "default" session if non currently exists
# tmux has-session -t _default || tmux new-session -s _default -d

# present menu for user to choose which workspace to open
PS3="Please choose your session: "
options=($(tmux list-sessions -F "#S" 2>/dev/null) "New Dev Session" "New Session")
echo "Available sessions"
echo "------------------"
echo " "
select opt in "${options[@]}"
do
  case $opt in
    "New Dev Session")
      SESSION=dev-$RANDOM
      tmux new-session -s $SESSION -n editor -d vim
      tmux new-window -n shell -t $SESSION
      tmux select-window -t editor
      tmux attach-session -t $SESSION
      break
      ;;
    "New Session")
      read -p "Enter new session name: " SESSION_NAME
      tmux new -s "$SESSION_NAME"
      break
      ;;
    *)
      tmux attach-session -t $opt
      break
      ;;
  esac
done
