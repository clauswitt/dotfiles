source ~/.vim/setup/keybindings/whitespace.vim
source ~/.vim/setup/keybindings/fugitive.vim
source ~/.vim/setup/keybindings/make.vim
source ~/.vim/setup/keybindings/splits.vim
source ~/.vim/setup/keybindings/buffers.vim
source ~/.vim/setup/keybindings/quickfix.vim

map <Tab> <C-w>w
noremap <F1> <Esc>
map Z zz
" Mappings for write
map <C-W> :w<CR>
map <Leader>w :w<CR>

" Clear search highlights
noremap <silent><Leader>/ :nohls<CR>

nnoremap <F3> :NumbersToggle<CR>


" copy file name or parent path from current file
nmap cf :let @" = expand("%")<cr>
nmap cp :let @" = expand("%:h")<cr>


map <leader>r :redraw!<cr>

" jk is escape
inoremap jk <esc>
