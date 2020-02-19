setlocal bufhidden=delete

if !exists("*s:BDeleteNetrw")
  function! s:BDeleteNetrw()
    for i in range(bufnr('$'), 1, -1)
      if buflisted(i)
        if getbufvar(i, 'netrw_browser_active') == 1
          silent exe 'bdelete ' . i
        endif
      endif
    endfor
  endfunction
endif

augroup netrw_buffergator
  autocmd! * <buffer>
  autocmd BufLeave <buffer> call s:BDeleteNetrw()
augroup END
