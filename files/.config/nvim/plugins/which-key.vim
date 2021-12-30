Plug 'folke/which-key.nvim'

fun! s:WhichKeySetup()
lua << EOF
require("which-key").setup {}
EOF
endfun

augroup WhichKeySetup
  autocmd!
  autocmd User PlugLoaded call <SID>WhichKeySetup()
augroup END
