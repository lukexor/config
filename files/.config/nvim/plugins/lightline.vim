Plug 'itchyny/lightline.vim'

let g:lightline = {
  \ 'colorscheme': 'gruvbox_material',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'readonly', 'filename', 'modified', 'function' ] ],
  \   'right': [ [ 'lineinfo' ],
  \              [ 'percent' ],
  \              [ 'gitstatus', 'filetype' ],
  \              [ 'charvaluehex' ] ],
  \ },
  \ 'component_function': {
  \   'function': 'CurrentFunction',
  \   'filename': 'LightlineFilename',
  \   'gitstatus': 'FugitiveHead',
  \ },
\ }

func! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfun
