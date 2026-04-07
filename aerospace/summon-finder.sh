#!/bin/bash
WID=$(aerospace list-windows --monitor all --app-id com.apple.finder --format '%{window-id}' | head -1)
if [ -n "$WID" ]; then
  WS=$(aerospace list-workspaces --focused)
  aerospace move-node-to-workspace --window-id "$WID" "$WS"
fi
