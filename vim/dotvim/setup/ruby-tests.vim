
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SWITCH BETWEEN TEST AND PRODUCTION CODE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction
function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file
  let in_spec = match(current_file, '^spec/') != -1
  let going_to_spec = !in_spec
  let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1 || match(current_file, '\<helpers\>') != -1
  if going_to_spec
    if in_app
      let new_file = substitute(new_file, '^app/', '', '')
    end
    let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
    let new_file = 'spec/' . new_file
  else
    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    let new_file = substitute(new_file, '^spec/', '', '')
    if in_app
      let new_file = 'app/' . new_file
    end
  endif
  return new_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
map <leader>a :call RunTests('')<cr>

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
    if in_test_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number . " -b")
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTests(filename)
    if exists('$TMUX')
      if match(a:filename, '\.feature$') != -1
          call VimuxRunCommand("script/features " . a:filename)
      else
          if filereadable("script/test")
              call VimuxRunCommand("script/test " . a:filename)
          elseif filereadable("Gemfile")
              call VimuxRunCommand("bundle exec rspec --color " . a:filename)
          else
              call VimuxRunCommand("rspec --color " . a:filename)
          end
      end
    else
      " Write the file and run tests for the given filename
      :w
      :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
      :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
      :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
      :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
      :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
      :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
      if match(a:filename, '\.feature$') != -1
          exec ":!script/features " . a:filename
      else
          if filereadable("script/test")
              exec ":!script/test " . a:filename
          elseif filereadable("Gemfile")
              exec ":!bundle exec rspec --color " . a:filename
          else
              exec ":!rspec --color " . a:filename
          end
      end
    end
endfunction
