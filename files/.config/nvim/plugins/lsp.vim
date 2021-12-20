Plug 'kosayoda/nvim-lightbulb'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'williamboman/nvim-lsp-installer'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
" Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'
Plug 'SirVer/ultisnips'

let g:snips_author = system('git config --get user.name | tr -d "\n"')
let g:snips_author_email = system('git config --get user.email | tr -d "\n"')

" Fixes Ctrl-X Ctrl-K
" https://github.com/SirVer/ultisnips/blob/master/doc/UltiSnips.txt
inoremap <c-x><c-k> <c-x><c-k>

" Default LSP shortcuts to no-ops for non-supported file types
nmap gt <nop>
nmap gh <nop>
nmap gH <nop>
nmap gi <nop>
nmap gr <nop>
nmap gR <nop>
nmap ga <nop>
nmap gO <nop>
nmap gp <nop>
nmap gn <nop>
nmap ge <nop>

augroup Lsp
  autocmd!
  autocmd User PlugLoaded ++nested lua require("lsp")
augroup end
