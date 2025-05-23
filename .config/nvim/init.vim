" Plugins
call plug#begin()
" looks
Plug 'folke/tokyonight.nvim'
Plug 'itchyny/lightline.vim'
" utilities
Plug 'junegunn/fzf'
Plug 'ibhagwan/fzf-lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'jamessan/vim-gnupg'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'nvim-tree/nvim-tree.lua'
" completion
Plug 'mattn/emmet-vim'
Plug 'dense-analysis/ale'
Plug 'neovim/nvim-lspconfig'
Plug 'ray-x/lsp_signature.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-omni'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/cmp-emoji'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'crispgm/cmp-beancount'
" file types
Plug 'chrisbra/csv.vim',
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'nathangrigg/vim-beancount',       { 'for': 'beancount' }
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'ray-x/go.nvim'
Plug 'vmware-archive/salt-vim',         { 'for': 'sls' }
call plug#end()

" Basics
set modeline
set mouse=
set undofile noswapfile
set shiftwidth=2 shiftround
set autoindent smartindent expandtab
set list listchars=tab:»·,trail:·
set formatoptions+=mM
set wildmode=longest,list
set showcmd laststatus=2
set splitright splitbelow
set nohls noincsearch
set completeopt=menuone
set rnu signcolumn=yes
set nofoldenable
set ffs=unix,dos

if has('unix')
    let g:python3_host_prog = '/usr/bin/python3'
endif

" Looks
lua require('init_treesitter')
lua require('init_neovide')
set termguicolors
colorscheme tokyonight-night
set noshowmode
let g:lightline = {'colorscheme': 'tokyonight'}

" Lua utilities
lua require('nvim-tree').setup()

" Key mapping
vnoremap D dO[...]<Esc>
nnoremap T :tabnew<CR>
nnoremap gx :tabclose<CR>
nnoremap F <cmd>lua require('fzf-lua').grep_project({resume=true})<CR>
nnoremap <C-f> <cmd>lua require('fzf-lua').files({resume=true})<CR>
nnoremap gs :%s/
nnoremap <C-g> :echo expand('%:p')<CR>
nnoremap <Tab> :NvimTreeFindFileToggle<CR>
" Map g1 to g9 to go to tab 1 through 9
for i in range(1, 9)
  execute 'nnoremap g' . i . ' ' . i . 'gt'
endfor

" Filetypes
let g:sls_use_jinja_syntax = 0
autocmd BufNewFile,BufRead /tmp/mutt-* set filetype=mail
autocmd BufNewFile,BufRead *.mail set filetype=mail
autocmd BufNewFile,BufRead /tmp/mail-* set filetype=mail
autocmd BufNewFile,BufRead /tmp/sql* set filetype=sql
autocmd BufNewFile,BufRead /tmp/bash-fc-* set filetype=sh
autocmd BufNewFile,BufRead /var/log/* set filetype=messages
autocmd BufNewFile,BufRead *.lr set filetype=markdown
autocmd BufNewFile,BufRead *.sentinel set filetype=terraform
autocmd BufNewFile,BufRead *.tfvars set filetype=terraform
autocmd BufNewFile,BufRead *.tfstate set filetype=json
autocmd BufNewFile,BufRead *.tfstate.backup set filetype=json
autocmd BufNewFile,BufRead *.nomad set filetype=hcl
autocmd BufNewFile,BufRead uv.lock set filetype=toml
autocmd BufNewFile,BufRead .envrc* set filetype=bash
autocmd BufNewFile,BufRead *.xmp set filetype=xml
autocmd FileType text setlocal textwidth=78
autocmd FileType mail setlocal textwidth=72
autocmd FileType gitcommit setlocal textwidth=72
autocmd FileType html inoremap <buffer> <F3> <!doctype html><CR>
autocmd FileType sh inoremap <buffer> <F3> #!/bin/bash -<CR><CR>
autocmd FileType python inoremap <buffer> <F3> #!/usr/bin/env python<CR><CR>
autocmd FileType python setlocal softtabstop=4 expandtab shiftwidth=4
autocmd FileType go setlocal shiftwidth=0
autocmd FileType csv nnoremap <buffer> <C-k> :WhatColumn!<CR>
autocmd FileType * setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()

" GnuPG
set noshelltemp
nnoremap Ps :%!gpg --clearsign<CR>
nnoremap Pe :%!gpg -er 
nnoremap Pb :%!gpg -ser 
nnoremap Pd :%!gpg -d<CR>

" LSP and CMP
lua require('init_lsp')
lua require('init_cmp')

" ALE
let g:ale_lint_on_enter = 0
let g:ale_fix_on_save = 1
let g:ale_echo_msg_format = '[%linter%] %s'
" ALE is used for linters that do not have optimal LSP support. For every file
" format that already has lspconfig set up (see init_lsp.lua), explicitly
" define the list of enabled linters in ALE, to avoid duplicate diagnostics.
let g:ale_linters = {
\  'python': ['ruff'],
\  'terraform': [],
\  'javascript': ['eslint'],
\  'yaml': ['yamllint'],
\  'ansible': [],
\  'html': [],
\  'css': [],
\  'go': [],
\}
let g:ale_fixers = {
\  'python': ['ruff'],
\  'markdown': ['trim_whitespace', 'remove_trailing_lines'],
\  'terraform': ['terraform', 'trim_whitespace', 'remove_trailing_lines'],
\  'hcl': ['packer'],
\}

" Beancount
autocmd FileType beancount let b:beancount_root = expand('$BEANCOUNT_ROOT')
autocmd FileType beancount inoremap <buffer> . .<C-\><C-O>:AlignCommodity<CR>
autocmd FileType beancount nnoremap <C-p> :execute ":!bean-doctor context $BEANCOUNT_ROOT %:" . line('.')<CR>
autocmd FileType beancount vnoremap L :!bean-format<CR>
autocmd FileType beancount vnoremap S :!bean-split<CR>
