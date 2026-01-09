#!/bin/bash
# Get git info for current tmux pane directory

STARSHIP="/opt/homebrew/bin/starship"

# Strip ANSI codes
strip_ansi() {
  echo "$1" | sed 's/\x1b\[[0-9;]*m//g' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

# Get the pane's current path from tmux
PANE_PATH="$1"

if [[ -z "$PANE_PATH" ]]; then
  exit 0
fi

# Get git branch
branch=$($STARSHIP module git_branch --path "$PANE_PATH" 2>/dev/null)
if [[ -z "$branch" ]]; then
  exit 0
fi

# Get git status
status=$($STARSHIP module git_status --path "$PANE_PATH" 2>/dev/null)

branch=$(strip_ansi "$branch")
status=$(strip_ansi "$status")

echo " ${branch}${status}"
