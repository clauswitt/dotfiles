""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
map <leader>a :call RunTests('')<cr>
nnoremap <leader>. :call OpenTestAlternate()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SWITCH BETWEEN TEST AND PRODUCTION CODE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction

function! AlternateGoFileForCurrentFile(current_file)
  let current_file = a:current_file
  let new_file = current_file
  if match(current_file, '\(_test.go\)$') != -1
      let new_file = substitute(new_file, '_test\.go', '.go', '')
  else
    let new_file = substitute(new_file, '\.go', '_test.go', '')
  endif
  return new_file
endfunction
function! AlternateRubyFileForCurrentFile(current_file)
  let current_file = a:current_file
  let in_spec = match(current_file, '^spec/') != -1
  let going_to_spec = !in_spec
  let new_file = current_file
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

function! AlternatePhpFileForCurrentFile(current_file)
  if (exists ("g:phpunit_testroot")) && g:phpunit_testroot != ''
    let test_dir = g:phpunit_testroot ."/"
  else
    let test_dir = "Tests/"
  endif
  if (exists ("g:phpunit_sourceroot")) && g:phpunit_sourceroot != ''
    let root_dir = g:phpunit_sourceroot ."/"
  else
    let root_dir = ""
  endif

  let current_file = a:current_file
  let in_tests = match(current_file, '^'.test_dir) != -1
  let going_to_tests = !in_tests
  let new_file = current_file

  let in_classes = match(current_file, '\<Classes\>') != -1
  let in_src = match(current_file, '\<src\>') != -1

  if going_to_tests
    if in_classes
      let new_file = substitute(new_file, '^Classes/', '', '')
    end
    if in_src
      let new_file = substitute(new_file, '^src/', '', '')
    endif
    let new_file = substitute(new_file, '\.php$', 'Test.php', '')
    let new_file = test_dir . new_file
  else
    let new_file = substitute(new_file, 'Test\.php$', '.php', '')
    let new_file = substitute(new_file, '^'.test_dir, root_dir, '')
  endif
  return new_file
endfunction


function! AlternateForCurrentFile()
  let current_file_type = &filetype
  let current_file = expand("%")
  let new_file = current_file

  if current_file_type == 'go'
    let new_file = AlternateGoFileForCurrentFile(current_file)
  endif
  if current_file_type == 'ruby'
    let new_file = AlternateRubyFileForCurrentFile(current_file)
  endif
  if current_file_type == 'php'
    let new_file = AlternatePhpFileForCurrentFile(current_file)
  endif

  return new_file
endfunction

function! InTestFile()
  let current_file_type = &filetype
  if current_file_type == 'ruby'
    return match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
  endif
  if current_file_type == 'php'
    return match(expand("%"), '\(Test.php\)$') != -1
  endif
  if current_file_type == 'go'
    return match(expand("%"), '\(_test.go\)$') != -1
  endif
endfunction

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = InTestFile()
    if in_test_file
        call SetTestFile()
    elseif !exists("t:cw_test_file")
        return
    end
    call RunTests(t:cw_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number . " -b")
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:cw_test_file=@%
endfunction

function! GetRubyTestCommand(filename)
      if match(a:filename, '\.feature$') != -1
          return "script/features " . a:filename
      else
          if filereadable("script/test")
              return "script/test " . a:filename
          elseif filereadable("Gemfile")
              return "bundle exec rspec --color " . a:filename
          else
              return "rspec --color " . a:filename
          end
      end
      return ''
endfunction

function! GetGoTestCommand(filename)
  return "go test " . a:filename . " " . AlternateGoFileForCurrentFile(a:filename)
endfunction

function! GetTestCommand(filename)
  let current_file_type = &filetype
  if current_file_type == ''
    if (exists ("g:test_default_command"))
      return g:test_default_command
    elseif filereadable("script/test")
      return "script/test " . a:filename
    elseif filereadable("Gemfile")
      return "bundle exec rspec --color " . a:filename
    elseif filereadable("phpunit.xml")
      return "phpunit " . a:filename
    elseif filereadable("phpunit.xml.dist")
      return "phpunit " . a:filename
    elseif filereadable("karma.conf")
      return "node_modules/karma/bin/karma start karma.conf --single-run"
    elseif filereadable("karma-conf.js")
      return "node_modules/karma/bin/karma start karma-conf.js --single-run"
    elseif filereadable("Gruntfile.js")
      return "grunt test"
    elseif filereadable("package.xml")
      return "npm test"
    endif
  endif
  if current_file_type == 'go'
    return GetGoTestCommand(a:filename)
  endif
  if current_file_type == 'ruby'
    return GetRubyTestCommand(a:filename)
  endif
  if current_file_type == 'php'
    return 'phpunit ' . a:filename
  endif
endfunction

function! RunTests(filename)
    let test_command = GetTestCommand(a:filename)
    :w
    exec ":Dispatch ".test_command
endfunction
