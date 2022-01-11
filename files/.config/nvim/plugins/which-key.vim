Plug 'folke/which-key.nvim'

augroup WhichKeySetup
  autocmd!
  autocmd User PlugLoaded :lua require("which-key-setup")
augroup END
