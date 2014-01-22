map <Leader>h :hide<cr>

" Make mapping
map <Leader>m :make<cr>

" Fugitive mappings
map <Leader><Leader>ga :Gwrite<cr>
map <Leader><Leader>gc :Gcommit<cr>
map <Leader><Leader>gb :Gblame<cr>
map <Leader><Leader>gr :Gread<cr>
map <Leader><Leader>gp :GitPush<cr>
map <Leader><Leader>gs :Gstatus<cr>

map <Leader>rj :Rjavascript<CR>
map <Leader>rc :Rcontroller<CR>
map <Leader>rm :Rmodel<CR>
map <Leader>rv :Rview<CR>
map <Leader>rs :Rspec<CR>


" CoffeeScript mappings
map <Leader>cc :silent CoffeeCompile<CR>
map <Leader>cl CoffeeLint<CR>

" Php mappings
map <Leader>pp :!phpunit<CR>
map <Leader>pl :!php -l %<CR>
" Js Mappings
map <Leader>yt :!yeoman test<CR>
map <Leader>yb :!yeoman build<CR>

" Remove trailing whitespace
:nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
:nnoremap <silent> <F6> :let _s=@/<Bar>:%s/\vecho (\$.{-});/if(isset(\1)) echo \1;/g<Bar>:let @/=_s<Bar>:nohl<CR>
" Reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" Easy split navigation remapping splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

map <Tab> <C-w>w


map <Leader><Leader>d :bd<cr>
map <Leader><Leader>c :Bclose<cr>
map <Leader><Leader>bd :bufdo bdelete<cr>
map <Leader>q :cw<cr>


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


nmap cp :let @" = expand("%")<cr>

map ,vs :vs %<cr>
map ,ss :split %<cr>



map <leader>r :redraw!<cr>

map <C-E> :call g:Execrus()<CR>
map <C-F> :!open .<cr>
map <C-W> :w<CR>
map <Leader>w :w<CR>
set exrc" enable per-directory .vimrc files
nnoremap <Leader>x :e .exrc<cr>
set secure" disable Usefulnsafe commands in local .vimrc files
nnoremap <F2> <C-]>

map <Leader>erc :e ~/.vimrc<cr>
map <Leader>src :so ~/.vimrc<cr>
map <Leader>j :e ~/Dropbox/notes/journal.md<cr>


vmap <expr> ++ VMATH_YankAndAnalyse()
nmap ++ vip++

runtime plugin/dragvisuals.vim
vmap  <expr>  <LEFT>   DVB_Drag('left')
vmap  <expr>  <RIGHT>  DVB_Drag('right')
vmap  <expr>  <DOWN>   DVB_Drag('down')
vmap  <expr>  <UP>     DVB_Drag('up')
vmap  <expr>  D        DVB_Duplicate()

nmap  ;l   :call ListTrans_toggle_format()<CR>
vmap  ;l   :call ListTrans_toggle_format('visual')<CR>
inoremap jk <esc>       " jk is escape
