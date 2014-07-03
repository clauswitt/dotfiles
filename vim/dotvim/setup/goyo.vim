"" Map Goyo toggle to <Leader> + spacebar
nnoremap <Leader><Space> :Goyo<CR> 
nnoremap <Leader>l :Limelight!!<CR>

function! GoyoBefore()
  silent !tmux set status off
  set noshowmode
  set noshowcmd
  Limelight
  " ...
endfunction

function! GoyoAfter()
  silent !tmux set status on
  set showmode
  set showcmd
  Limelight!
  " ...
endfunction

let g:goyo_callbacks = [function('GoyoBefore'), function('GoyoAfter')]

