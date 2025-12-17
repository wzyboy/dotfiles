-- Setup nvim-cmp.
local cmp = require'cmp'

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

cmp.setup({
  -- REQUIRED - you must specify a snippet engine
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  -- Supertab-like completion.
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-c>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert
    }),
    ['<Tab>'] = function(fallback)
      if not cmp.select_next_item() then
        if vim.bo.buftype ~= 'prompt' and has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if not cmp.select_prev_item() then
        if vim.bo.buftype ~= 'prompt' and has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    end,
  }),
  -- Disable preselect behaviour (needed for go.nvim)
  -- https://github.com/hrsh7th/nvim-cmp/blob/5260e5e8ecadaf13e6b82cf867a909f54e15fd07/doc/cmp.txt#L918-L929
  preselect = cmp.PreselectMode.None,
  -- Groups of sources.
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    --{ name = 'omni' },
    {
      name = 'beancount',
      option = { account = vim.fn.expand('$BEANCOUNT_ROOT') },
    },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'emoji' },
  }),
  -- Looks.
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        omni = '[O]',
        path = '[F]',
        vsnip = '[S]',
        emoji = '[絵]',
        buffer = '[B]',
        nvim_lsp = '[LSP]',
        beancount = '[BC]',
      })[entry.source.name]
      return vim_item
    end,
  },
})

-- Setup go.nvim
local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
   require('go.format').goimports()
  end,
  group = format_sync_grp,
})

require('go').setup({
  lsp_inlay_hints = {
    enable = false,
  },
})
