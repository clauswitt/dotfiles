#!/bin/bash
# Wezterm + Tmux integration
# Source this in your .zshrc or .bashrc

# Notify wezterm when we're inside tmux
if [[ -n "$TMUX" && -n "$WEZTERM_PANE" ]]; then
  # Set a wezterm user variable to indicate we're in tmux
  printf "\033]1337;SetUserVar=%s=%s\007" "IN_TMUX" "$(echo -n "1" | base64)"
fi
