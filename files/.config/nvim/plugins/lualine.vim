Plug 'nvim-lualine/lualine.nvim'

augroup Lualine
  autocmd!
  autocmd User PlugLoaded lua require("lualine-setup")
augroup END
