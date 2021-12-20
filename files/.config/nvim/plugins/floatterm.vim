Plug 'voldikss/vim-floaterm'

let g:floaterm_shell = 'nu'
let g:floaterm_title = 'nvim $1/$2'

let g:floaterm_keymap_new = '<c-0>'
let g:floaterm_keymap_toggle = '<c-t>'
let g:floaterm_keymap_prev = '<c-[>'
let g:floaterm_keymap_next = '<c-]>'

let g:floaterm_gitcommit='floaterm'
let g:floaterm_autoinsert=1
let g:floaterm_width=0.8
let g:floaterm_height=0.8
let g:floaterm_wintitle=0
let g:floaterm_autoclose=1

augroup FloatermCustomisations
  autocmd!
  autocmd ColorScheme * highlight FloatermBorder guibg=none
augroup END
