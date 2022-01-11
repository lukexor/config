Plug 'sainnhe/gruvbox-material'

let g:gruvbox_material_transparent_background = 1
let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_diagnostic_virtual_text = 'colored'
let g:gruvbox_material_better_performance = 1
let g:gruvbox_material_visual = 'reverse'
let g:gruvbox_material_menu_selection_background = 'green'
let g:gruvbox_material_ui_contrast = 'high'

set background=dark

augroup Gruvbox
  autocmd!
  autocmd User PlugLoaded colorscheme gruvbox-material
  autocmd User PlugLoaded hi! Comment ctermfg=208 guifg=#e78a4e
  autocmd User PlugLoaded hi! SpecialComment ctermfg=108 guifg=#89b482 guisp=#89b482
  autocmd User PlugLoaded hi! ColorColumn ctermbg=237 guibg=#333333
  autocmd User PlugLoaded hi! FloatermBorder ctermbg=none guibg=none
  autocmd User PlugLoaded hi! link Whitespace DiffDelete
  autocmd InsertEnter * hi! CursorLine ctermbg=237 guibg=#333e34
  autocmd InsertLeave * hi! CursorLine ctermbg=235 guibg=#282828
augroup end
