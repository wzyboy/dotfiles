local treesitter = require('nvim-treesitter')
local ts_install = require('ts-install')

local languages = {
  'lua',
  'vim',
  'python',
  'terraform',
  'beancount',
}

local disabled_filetypes = {
  dockerfile = true,
}

treesitter.setup({})
ts_install.setup({
  ensure_install = languages,
  ignore_install = vim.tbl_keys(disabled_filetypes),
  auto_install = true,
})

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local filetype = vim.bo[args.buf].filetype
    if disabled_filetypes[filetype] then
      return
    end

    pcall(vim.treesitter.start, args.buf)
  end,
})
