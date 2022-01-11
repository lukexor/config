Plug 'kosayoda/nvim-lightbulb'
Plug 'neovim/nvim-lspconfig'
" Has other uses, but currently only using rust inlay feature
Plug 'nvim-lua/lsp_extensions.nvim', { 'for': 'rust' }
Plug 'ray-x/lsp_signature.nvim'
Plug 'williamboman/nvim-lsp-installer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'gfanto/fzf-lsp.nvim'
Plug 'ojroques/nvim-lspfuzzy'

augroup Lsp
  autocmd!
  autocmd User PlugLoaded lua require("lsp-setup")
  autocmd DiagnosticChanged * lua vim.diagnostic.setqflist({ open = false }); 
augroup END
