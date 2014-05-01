if exists('$TMUX')
  let g:VimuxOrientation = "h"
  let VimuxUseNearest = 1

  noremap <leader>rr :call VimuxRunCommand("irb")<CR>
  noremap <leader>nr :call VimuxRunCommand("node")<cr>

  function! VimuxSlime()
    call VimuxSendText(@v)
  endfunction

  " If text is selected, save it in the v buffer and send that buffer it to tmux
  vmap <leader><leader>tm "vy :call VimuxSlime()<CR>

  " Select current paragraph and send it to tmux
  nmap <leader><leader>tm vip<leader><leader>tm<CR>

  " Prompt for a command to run
  map <Leader>vp :VimuxPromptCommand<CR>

  " Run last command executed by VimuxRunCommand
  map <Leader>vl :VimuxRunLastCommand<CR>

  " Inspect runner pane
  map <Leader>vi :VimuxInspectRunner<CR>

  " Close vim tmux runner opened by VimuxRunCommand
  map <Leader>vq :VimuxCloseRunner<CR>

  " Interrupt any command running in the runner pane
  map <Leader>vx :VimuxInterruptRunner<CR>

  " Zoom the runner pane (use <bind-key> z to restore runner pane)
  map <Leader>vz :call VimuxZoomRunner()<CR>

endif


