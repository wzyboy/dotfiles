require('lualine').setup({
  options = {
    theme = 'tokyonight',
    section_separators = '',
    component_separators = '|',
  },
  sections = {
    -- lualine_a = {'mode'},
    -- lualine_b = {'branch', 'diff', 'diagnostics'},
    -- lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype', 'lsp_status'},
    -- lualine_y = {'progress'},
    -- lualine_z = {'location'}
  },
  extensions = {
    'fzf',
    'fugitive',
    'nvim-tree',
  }
})
