Plug 'kosayoda/nvim-lightbulb'
Plug 'neovim/nvim-lspconfig'
" Has other uses, but currently only using rust inlay feature
Plug 'nvim-lua/lsp_extensions.nvim', { 'for': 'rust' }
Plug 'ray-x/lsp_signature.nvim'
Plug 'williamboman/nvim-lsp-installer'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'
Plug 'SirVer/ultisnips'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'gfanto/fzf-lsp.nvim'
Plug 'ojroques/nvim-lspfuzzy'
Plug 'simrat39/symbols-outline.nvim'

let g:snips_author = system('git config --get user.name | tr -d "\n"')
let g:snips_author_email = system('git config --get user.email | tr -d "\n"')

" Fixes Ctrl-X Ctrl-K
" https://github.com/SirVer/ultisnips/blob/master/doc/UltiSnips.txt
inoremap <c-x><c-k> <c-x><c-k>

" Default LSP shortcuts to no-ops for non-supported file types to avoid
" confusion with default vim shortcuts.
fun! s:NoLspClient()
  echom "No LSP client attached for filetype: `" . &filetype . "`."
endfun
nmap gT :call <SID>NoLspClient()<CR>
nmap gh :call <SID>NoLspClient()<CR>
nmap gH :call <SID>NoLspClient()<CR>
nmap gi :call <SID>NoLspClient()<CR>
nmap gr :call <SID>NoLspClient()<CR>
nmap gR :call <SID>NoLspClient()<CR>
nmap ga :call <SID>NoLspClient()<CR>
nmap gO :call <SID>NoLspClient()<CR>
nmap ge :call <SID>NoLspClient()<CR>

nmap <leader>L :LspInfo<CR>

nmap <leader>to :SymbolsOutline<CR>
lua << EOF
vim.g.symbols_outline = {
  width = 40,
  highlight_hovered_item = false,
}
EOF

augroup Lsp
  autocmd!
  autocmd User PlugLoaded lua require("lsp")
  autocmd DiagnosticChanged * lua vim.diagnostic.setqflist({ open = false }); 
augroup end
