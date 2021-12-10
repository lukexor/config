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

fun! ColorOverride()
  let s:configuration = gruvbox_material#get_configuration()
  let s:palette = gruvbox_material#get_palette(s:configuration.background, s:configuration.palette)
  call gruvbox_material#highlight('Comment', s:palette.orange, s:palette.none)
endfun

augroup Gruvbox
  autocmd!
  autocmd User PlugLoaded ++nested colorscheme gruvbox-material
  autocmd User PlugLoaded ++nested call ColorOverride()
augroup end
