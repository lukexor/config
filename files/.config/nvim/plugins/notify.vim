Plug 'rcarriga/nvim-notify'

augroup Notify
  autocmd!
  autocmd User PlugLoaded ++nested lua vim.notify = require('notify')
  autocmd User PlugLoaded ++nested lua vim.notify.setup({ background_colour = "#000000" })
augroup end
