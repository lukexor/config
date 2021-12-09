Plug 'sainnhe/gruvbox-material'

let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_diagnostic_virtual_text = 'colored'
let g:gruvbox_material_better_performance = 1

set background=dark

augroup Gruvbox
  autocmd!
  autocmd User PlugLoaded ++nested colorscheme gruvbox-material
augroup end
