source ~/.vim/setup/keybindings/whitespace.vim
source ~/.vim/setup/keybindings/fugitive.vim
source ~/.vim/setup/keybindings/splits.vim
source ~/.vim/setup/keybindings/buffers.vim
source ~/.vim/setup/keybindings/quickfix.vim
source ~/.vim/setup/keybindings/ctrlp.vim
source ~/.vim/setup/keybindings/fist.vim

nnoremap <c-c> <esc>
noremap <Tab> <C-w>w
noremap <F1> <Esc>
noremap Z zz
" Mappings for write
noremap <Leader>w :w<CR>

" Clear search highlights
noremap <silent><Leader>/ :nohls<CR>

nnoremap <F3> :NumbersToggle<CR>


" copy file name or parent path from current file
noremap cp :let @" = expand("%")<cr>


noremap <leader>r :redraw!<cr>

" jk is escape
inoremap jk <esc>
nnoremap <leader>ex :e .exrc<cr>


" plain annotations
map <silent> <F10> !xmpfilter -a<cr>
nmap <silent> <F10> V<F10>
imap <silent> <F10> <ESC><F10>a

" Test::Unit assertions; use -s to generate RSpec expectations instead
map <silent> <S-F10> !xmpfilter -u<cr>
nmap <silent> <S-F10> V<S-F10>
imap <silent> <S-F10> <ESC><S-F10>a

" Annotate the full buffer
" I actually prefer ggVG to %; it's a sort of poor man's visual bell 
nmap <silent> <F11> mzggVG!xmpfilter -a<cr>'z
imap <silent> <F11> <ESC><F11>

" assertions
nmap <silent> <S-F11> mzggVG!xmpfilter -u<cr>'z
imap <silent> <S-F11> <ESC><S-F11>a

" Add # => markers
vmap <silent> <F12> !xmpfilter -m<cr>
nmap <silent> <F12> V<F12>
imap <silent> <F12> <ESC><F12>a

" Remove # => markers
vmap <silent> <S-F12> ms:call RemoveRubyEval()<CR>
nmap <silent> <S-F12> V<S-F12>
imap <silent> <S-F12> <ESC><S-F12>a


function! RemoveRubyEval() range
  let begv = a:firstline
  let endv = a:lastline
  normal Hmt
  set lz
  execute ":" . begv . "," . endv . 's/\s*# \(=>\|!!\).*$//e'
  normal 'tzt`s
  set nolz
  redraw
endfunction

nnoremap ,,t :!taste the soup<cr>
nnoremap <tab><tab>r :!open "http://www.youtube.com/watch?v=Eky6bCnCLOI\#t=171"<cr>
nnoremap ,,gr :GoldenRatioToggle<cr>
nnoremap ,,re :GoldenRatioResize<cr>

nnoremap <C-f> :CtrlPFunky<Cr>




nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>
let test#strategy = "dispatch"
map <C-n> :NERDTreeToggle<CR>
