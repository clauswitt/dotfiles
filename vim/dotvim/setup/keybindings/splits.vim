" Easy split navigation remapping splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" split resizing
:map - <C-W><
:map + <C-W>>

:map <A-j> <C-W>-
:map <A-k> <C-W>+

" Open splits with leader
map <leader>vs :vs %<cr>
map <leader>ss :split %<cr>
