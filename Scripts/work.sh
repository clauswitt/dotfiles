#!/bin/sh
function startSession {
  tmux new-session -d -s work
  tmux new-window -t work:1 -n 'VIM' 'vim'
  tmux new-window -t work:2 -n 'Systemet' 'ssh asys'
  tmux new-window -t work:3 -n 'Tweaker 1' 'ssh root@tweaker.arnsbopropertymedia.com'
  tmux new-window -t work:4 -n 'Tweaker 2' 'ssh root@tweaker2.arnsbopropertymedia.com'
  tmux new-window -t work:5 -n 'Poi' 'ssh root@poi.arnsbopropertymedia.com'
  tmux select-window -t work:1
  tmux -2 attach-session -t work
}

tmux -2 attach-session -t work || startSession 
