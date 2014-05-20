#!/bin/bash

set -e

SESSION_NAME=$1
FILENAME="$HOME/.tmuxinator/${2:-$SESSION_NAME}.yml"
WINDOW_NAMES=`tmux list-windows -t $SESSION_NAME -F "#{window_name}"`
SESSION_PATH=`tmux list-panes -t $SESSION_NAME -F "#{pane_start_path}"`
echo $FILENAME
touch "$FILENAME"
echo "name: $SESSION_NAME" >> "$FILENAME"
echo "root: $SESSION_PATH" >> "$FILENAME"
echo "#pre: " >> "$FILENAME"
echo "pre_window: reattach-to-user-namespace -l zsh"
echo "#tmux_options: "
echo "windows:"  >> "$FILENAME"
for WINDOW in $WINDOW_NAMES; do
  echo "  - $WINDOW: " >> "$FILENAME"
done
$EDITOR "$FILENAME"
