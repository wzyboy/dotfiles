local gh = function(repo)
  return 'https://github.com/' .. repo
end

vim.g.loaded_nvim_treesitter = 1

vim.pack.add({
  gh('folke/tokyonight.nvim'),
  gh('itchyny/lightline.vim'),
  gh('ibhagwan/fzf-lua'),
  gh('nvim-tree/nvim-web-devicons'),
  gh('jamessan/vim-gnupg'),
  gh('tpope/vim-fugitive'),
  gh('tpope/vim-rhubarb'),
  gh('shumphrey/fugitive-gitlab.vim'),
  gh('nvim-tree/nvim-tree.lua'),
  gh('mattn/emmet-vim'),
  gh('dense-analysis/ale'),
  gh('neovim/nvim-lspconfig'),
  gh('ray-x/lsp_signature.nvim'),
  gh('hrsh7th/nvim-cmp'),
  gh('hrsh7th/cmp-path'),
  gh('hrsh7th/cmp-emoji'),
  gh('hrsh7th/cmp-buffer'),
  gh('hrsh7th/cmp-nvim-lsp'),
  gh('crispgm/cmp-beancount'),
  gh('chrisbra/csv.vim'),
  gh('Glench/Vim-Jinja2-Syntax'),
  gh('nvim-treesitter/nvim-treesitter'),
  gh('lewis6991/ts-install.nvim'),
  gh('ray-x/go.nvim'),
  gh('nathangrigg/vim-beancount'),
  gh('vmware-archive/salt-vim'),
}, { confirm = false })
