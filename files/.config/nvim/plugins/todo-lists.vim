Plug 'aserebryakov/vim-todo-lists'

" This plugin is great but takes too many liberties with mappings
let g:vimtodolists_plugin = 1

fun! TodoListsSetNormalMode()
  setlocal indentexpr=b:pindentexpr
  setlocal formatoptions=b:pformatoptions
  nunmap <buffer> o
  nunmap <buffer> O
  iunmap <buffer> <CR>
  noremap <buffer> <leader>te :silent call TodoListsSetItemMode()<CR>
endfun

fun! TodoListsSetItemMode()
  let b:pindentexpr=&indentexpr
  let b:pformatoptions=&formatoptions
  setlocal indentexpr=
  setlocal formatoptions-=ro
  nnoremap <buffer><silent> o :silent call VimTodoListsCreateNewItemBelow()<CR>
  nnoremap <buffer><silent> O :silent call VimTodoListsCreateNewItemAbove()<CR>
  inoremap <buffer><silent> <CR> <ESC>:silent call VimTodoListsCreateNewItemBelow()<CR>
  noremap <buffer><silent> <leader>te :silent call TodoListsSetNormalMode()<CR>
endfun

fun! TodoListsInit()
  let g:VimTodoListsKeepSameIndent = 0
  let g:VimTodoListsUndoneItem = '- [ ]'
  let g:VimTodoListsDoneItem = '- [x]'
  let g:VimTodoListsMoveItems = 0

  call VimTodoListsInitializeTokens()
  call VimTodoListsInitializeSyntax()

  nnoremap <buffer> <leader>tt :silent call VimTodoListsToggleItem()<CR>
  nnoremap <buffer> <leader>tn :silent call VimTodoListsCreateNewItem()<CR>
  nnoremap <buffer> <leader>tO :silent call VimTodoListsCreateNewItemAbove()<CR>
  nnoremap <buffer> <leader>to :silent call VimTodoListsCreateNewItemBelow()<CR>
  noremap <buffer> <leader>te :silent call TodoListsSetItemMode()<CR>
endfun

augroup TodoLists
    autocmd!
    autocmd BufRead,BufNewFile *.todo.md call TodoListsInit()
augroup end
