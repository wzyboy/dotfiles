require('fzf-lua').setup {
  winopts = {
    fullscreen = true,
    preview = {
      layout = 'vertical',
    },
  },
}

vim.keymap.set(
  'n',
  'F',
  function() require('fzf-lua').grep_project({ resume = true }) end
)
vim.keymap.set(
  'n',
  '<C-f>',
  function() require('fzf-lua').files({ resume = true }) end
)
vim.keymap.set(
  'n',
  '<M-f>',
  function()
    require('fzf-lua').grep({ cwd = vim.fn.expand('%:p:h'), resume = true })
  end
)
