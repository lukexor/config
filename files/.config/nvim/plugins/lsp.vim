Plug 'kosayoda/nvim-lightbulb'
" Has other uses, but currently only using rust inlay feature
Plug 'simrat39/rust-tools.nvim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'neovim/nvim-lspconfig' | Plug 'williamboman/nvim-lsp-installer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'gfanto/fzf-lsp.nvim'
Plug 'ojroques/nvim-lspfuzzy'

augroup Lsp
  autocmd!
  autocmd User PlugLoaded lua require("lsp-setup")
  autocmd DiagnosticChanged * lua vim.diagnostic.setqflist({ open = false }); 
augroup END
