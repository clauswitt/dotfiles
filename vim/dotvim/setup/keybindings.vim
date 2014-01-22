
" Remove trailing whitespace
:nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
:nnoremap <silent> <F6> :let _s=@/<Bar>:%s/\vecho (\$.{-});/if(isset(\1)) echo \1;/g<Bar>:let @/=_s<Bar>:nohl<CR>

" Make mapping
map <Leader>m :make<cr>

" Fugitive mappings
map <Leader><Leader>ga :Gwrite<cr>
map <Leader><Leader>gc :Gcommit<cr>
map <Leader><Leader>gb :Gblame<cr>
map <Leader><Leader>gr :Gread<cr>
map <Leader><Leader>gp :GitPush<cr>
map <Leader><Leader>gs :Gstatus<cr>


" Easy split navigation remapping splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

map <Tab> <C-w>w


map <Leader><Leader>d :bd<cr>
map <Leader><Leader>c :Bclose<cr>
map <Leader><Leader>bd :bufdo bdelete<cr>


map <Leader>n :cn<cr>
map <Leader>p :cp<cr>

" Clear search highlights
noremap <silent><Leader>/ :nohls<CR>

" Protect your fat fingers from the evils of <F1>
noremap <F1> <Esc>
nnoremap <F3> :NumbersToggle<CR>

" split resizing
:map - <C-W><
:map + <C-W>>

:map <A-j> <C-W>-
:map <A-k> <C-W>+


" remap zz to Z
:map Z zz


nmap cf :let @" = expand("%")<cr>
nmap cp :let @" = expand("%:h")<cr>

" Open splits with leader
map <leader>vs :vs %<cr>
map <leader>ss :split %<cr>



map <leader>r :redraw!<cr>

map <C-E> :call g:Execrus()<CR>
map <C-F> :!open .<cr>

" Mappings for write
map <C-W> :w<CR>
map <Leader>w :w<CR>
nnoremap <Leader>x :e .exrc<cr>
nnoremap <F2> <C-]>

inoremap jk <esc>       " jk is escape
