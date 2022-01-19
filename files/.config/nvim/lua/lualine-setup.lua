require('lualine').setup{
  options = {
    icons_enabled = true,
    theme = 'gruvbox',
    component_separators = { left = ' ', right = ' '},
    section_separators = { left = ' ', right = ' '},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = { 'SleuthIndicator', 'ObsessionStatus', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  }
}
