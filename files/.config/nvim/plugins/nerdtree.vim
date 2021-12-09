Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" ==================================================================================================
" Settings   {{{1
" ==================================================================================================

let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let g:NERDTreeWinSize = 35

let g:NERDTreeDirArrowExpandable = '▹'
let g:NERDTreeDirArrowCollapsible = '▿'

" avoid crashes when calling vim-plug functions while the cursor is on the NERDTree window
let g:plug_window = 'noautocmd vertical topleft new'

" ==================================================================================================
" Key Maps   {{{1
" ==================================================================================================

nnoremap <expr> <leader>n g:NERDTree.IsOpen() ? ':NERDTreeClose<CR>' : @% == '' ? ':NERDTree<CR>' : ':NERDTreeFind<CR>'
nmap <leader>N :NERDTreeFind<CR>

augroup NERDTree
  autocmd!

  " Closes if NERDTree is the only open window
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

  " If more than one window and previous buffer was NERDTree, go back to it.
  autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
augroup END
