" UltiSnip key bindings
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
imap <c-l> <c-r>=UltiSnips_ListSnippets()<cr>
noremap <leader>u :UltiSnipsEdit<cr>

