#!/bin/bash
SESSION=main
tmux="tmux "

# if the session is already running, just attach to it.
$tmux has-session -t $SESSION
if [ $? -eq 0 ]; then
  echo "Session $SESSION already exists. Attaching."
  sleep 1
  $tmux attach -t $SESSION
  exit 0;
fi
# create a new session, named $SESSION, and detach from it
$tmux new-session -d -s $SESSION

$tmux new-window    -t $SESSION:0 -k -n jab mcabber
$tmux new-window    -t $SESSION:1 -k -n irc irssi
$tmux new-window    -t $SESSION:2 -k -n mp3 ncmpc
$tmux new-window    -t $SESSION:3

$tmux select-window -t $SESSION:3
$tmux attach -t $SESSION
