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
  nginx = true,
}

treesitter.setup({})

local function setup_windows_ts_install_workarounds()
  if vim.uv.os_uname().sysname ~= 'Windows_NT' then
    return
  end

  local system32 = 'C:\\Windows\\System32'
  local path = vim.env.PATH or ''
  if not vim.startswith(path:lower(), (system32 .. ';'):lower()) then
    vim.env.PATH = system32 .. ';' .. path
  end

  local parsers = require('ts-install.parsers')
  for i = 1, 32 do
    local name, value = debug.getupvalue(parsers.get_parser_info, i)
    if not name then
      break
    end

    if name == 'get_nvim_treesitter_dir' and type(value) == 'function' then
      debug.setupvalue(parsers.get_parser_info, i, function()
        local runtime_dirs = vim.api.nvim_get_runtime_file('runtime', true)
        for _, dir in ipairs(runtime_dirs) do
          if dir:match('[\\/]nvim%-treesitter[\\/]') then
            return vim.fs.dirname(dir)
          end
        end
        error('nvim-treesitter is not installed')
      end)
      break
    end
  end
end

setup_windows_ts_install_workarounds()

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
