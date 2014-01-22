" UltiSnip key bindings
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
imap <c-l> <c-r>=UltiSnips_ListSnippets()<cr>
map <leader>u :UltiSnipsEdit<cr>
