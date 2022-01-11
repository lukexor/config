Plug 'rcarriga/nvim-notify'

augroup Notify
  autocmd!
  autocmd User PlugLoaded lua vim.notify = require('notify')
  autocmd User PlugLoaded lua vim.notify.setup({ background_colour = "#000000" })
augroup END
