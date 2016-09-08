set shiftwidth=4 " Number of spaces used for each spent of indent
set softtabstop=4 " Spaces a tab counts for when backspacing or inserting tabs
set tabstop=4 " The number of spaces a tab counts as

"     ,t   --  Run tests
"     ,s   --  Set current file as test file. Only this test will run.
"     ,S   --  Unset current test file. All tests will run.

nnoremap <leader>t :call Prove("")<cr>
nnoremap <leader>T :call Prove("-T ")<cr>
nnoremap <leader>v :call CompilePerl()<cr>
nnoremap <leader>st :let g:testfile = expand("%")<cr>:echo "testfile is now" g:testfile<cr>
nnoremap <leader>S :unlet g:testfile<cr>:echo "testfile undefined; will run all tests" g:testfile<cr>

function! Prove(taint)
  if !exists("g:testfile")
    let g:testfile = "t/*.t"
  endif
  if g:testfile == "t/*.t" || g:testfile =~ "\.t$"
    execute "!prove " . a:taint . g:testfile
  elseif match(g:testfile, "lib/Fap")
    let g:testfile = substitute(g:testfile, "t/lib/", "", "")
    let g:testfile = substitute(g:testfile, "/", "::", "g")
    let g:testfile = substitute(g:testfile, ".pm", "", "")
    execute "!prove t/manual_tests/run_one_test_class.t :: " . g:testfile
  else
    call CompilePerl()
  endif
endfunction

function! CompilePerl()
  if !exists("g:compilefile")
    let g:compilefile = expand("%")
  endif
  execute "!perl -wc -Ilib " . g:compilefile
endfunction
