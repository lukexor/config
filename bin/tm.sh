#!/bin/bash

# abort if we're already inside a TMUX session
[ "$TMUX" == "" ] || (echo "Already in a TMUX session" && exit 0)

# present menu for user to choose which workspace to open
options=($(tmux list-sessions -F "#S" 2>/dev/null) "New Session")
if [ ${#options[@]} -eq 1 ]; then
  read -p "Enter new session name: " SESSION_NAME
  tmux new-session -s $SESSION_NAME -n "shell" \; \
    source $HOME/.tmux.conf
else
  PS3="Please choose your session: "
  echo "Available sessions"
  echo "------------------"
  select opt in "${options[@]}"
  do
    case $opt in
      "New Session")
        read -p "Enter new session name: " SESSION_NAME
        tmux new-session -s $SESSION_NAME -n "shell" \; \
          source $HOME/.tmux.conf
        break
        ;;
      *)
        tmux attach-session -t $opt
        break
        ;;
    esac
  done
fi
