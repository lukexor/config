let opts = { 'on': ['NERDTree', 'NERDTreeFind', 'NERDTreeToggle'] }

Plug 'preservim/nerdtree', opts
Plug 'Xuyuanp/nerdtree-git-plugin', opts
Plug 'ryanoasis/vim-devicons', opts
Plug 'tiagofumo/vim-nerdtree-syntax-highlight', opts

let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeWinSize = 35

let g:NERDTreeDirArrowExpandable = '▹'
let g:NERDTreeDirArrowCollapsible = '▿'

" avoid crashes when calling vim-plug functions while the cursor is on the NERDTree window
let g:plug_window = 'noautocmd vertical topleft new'

nnoremap <expr> <leader>n exists("g:NERDTree") && g:NERDTree.IsOpen()
  \ ? ':NERDTreeClose<CR>' : @% == '' ? ':NERDTree<CR>' : ':NERDTreeFind<CR>'
nmap <leader>N :NERDTreeFind<CR>

" Function to open the file or NERDTree or netrw.
"   Returns: 1 if either file explorer was opened; otherwise, 0.
fun! s:OpenFileOrExplorer(...)
  if a:0 == 0 || a:1 == ''
    NERDTree
  elseif filereadable(a:1)
    execute 'edit '.a:1
    return 0
  elseif a:1 =~? '^\(scp\|ftp\)://' " Add other protocols as needed.
    execute 'Vexplore '.a:1
  elseif isdirectory(a:1)
    execute 'NERDTree '.a:1
  endif
  return 1
endfun

command! -n=? -complete=file -bar Edit :call <SID>OpenFileOrExplorer('<args>')
cnoreabbrev e Edit

augroup NERDTree
  autocmd!
  " Start NERDTree when Vim starts with a directory argument.
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ if <SID>OpenFileOrExplorer(argv()[0]) | wincmd p | enew | bd 1 | execute 'cd '.argv()[0] | wincmd p | endif | endif

  " Closes if NERDTree is the only open window
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  " If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
  autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
augroup END
