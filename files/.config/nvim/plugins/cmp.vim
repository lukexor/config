Plug 'hrsh7th/nvim-cmp' | Plug 'hrsh7th/cmp-buffer'
Plug 'honza/vim-snippets'
      \ | Plug 'SirVer/ultisnips'
      \ | Plug 'quangnguyen30192/cmp-nvim-ultisnips'

let g:snips_author = system('git config --get user.name | tr -d "\n"')
let g:snips_author_email = system('git config --get user.email | tr -d "\n"')
let g:snips_github = "https://github.com/lukexor"

" Fixes Ctrl-X Ctrl-K
" https://github.com/SirVer/ultisnips/blob/master/doc/UltiSnips.txt#L264
inoremap <C-x><C-k> <C-x><C-k>

augroup Cmp
  autocmd!
  autocmd User PlugLoaded lua require("cmp-setup")
augroup END
