noremap <leader>f :CtrlP<CR>
nnoremap <leader>b :CtrlPBuffer<CR>
nnoremap <leader>m :CtrlPMRUFiles<CR>

nnoremap <leader>gs :CtrlP spec<cr>
nnoremap <leader>ga :CtrlP app<cr>
nnoremap <leader>gl :CtrlP lib<cr>


function! CmdTNoOp()
endfunction

command! -nargs=0 CommandTFlush :call CmdTNoOp()
com! -n=? -com=dir CommandT         cal ctrlp#init(0, { 'dir': <q-args> })
nnoremap <leader><leader>cs :CtrlPColorScheme<cr>
