" Remove trailing whitespace
:nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>
:nnoremap <silent> <F6> :let _s=@/<Bar>:%s/\vecho (\$.{-});/if(isset(\1)) echo \1;/g<Bar>:let @/=_s<Bar>:nohl<CR>
