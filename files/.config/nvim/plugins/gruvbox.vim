Plug 'sainnhe/gruvbox-material'

let g:gruvbox_material_transparent_background = 1
let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_diagnostic_virtual_text = 'colored'
let g:gruvbox_material_better_performance = 1
let g:gruvbox_material_visual = 'reverse'
let g:gruvbox_material_menu_selection_background = 'green'
let g:gruvbox_material_ui_contrast = 'high'
let g:gruvbox_material_better_performance = 1

set background=dark

augroup Gruvbox
  autocmd!
  autocmd User PlugLoaded ++nested colorscheme gruvbox-material
  autocmd User PlugLoaded ++nested highlight Comment ctermfg=208 guifg=#e78a4e
augroup end
