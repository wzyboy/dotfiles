" vim: foldmethod=marker:

" Plugins {{{
lua require('init_plugins')
" }}}

" Basics {{{
set mouse=
set undofile noswapfile
set shiftwidth=2 shiftround
set autoindent smartindent expandtab
set list listchars=tab:»·,trail:·
set formatoptions+=mM
set wildmode=longest,list
set splitright splitbelow
set nohls noincsearch
set rnu signcolumn=yes
set nofoldenable
set ffs=unix,dos

if has('unix')
  let g:python3_host_prog = '/usr/bin/python3'
endif
" }}}

" Looks {{{
lua require('init_treesitter')
lua require('init_neovide')

set termguicolors
set noshowmode
colorscheme tokyonight-night

let g:lightline = {'colorscheme': 'tokyonight'}
" }}}

" Lua Modules {{{
lua require('nvim-tree').setup()
lua require('init_fzf')
lua require('init_lsp')
lua require('init_cmp')
lua require('init_fff')
" }}}

" Mappings {{{
vnoremap D dO[...]<Esc>

nnoremap T :tabnew<CR>
nnoremap gx :tabclose<CR>
nnoremap gs :%s/
nnoremap <C-g> :echo expand('%:p')<CR>
nnoremap <Tab> :NvimTreeFindFileToggle<CR>

nnoremap F <cmd>lua require('fzf-lua').grep_project({resume=true})<CR>
nnoremap <C-f> <cmd>lua require('fzf-lua').files({resume=true})<CR>
nnoremap <M-f> <cmd>lua require('fzf-lua').grep({cwd=vim.fn.expand('%:p:h'), resume=true})<CR>

for i in range(1, 9)
  execute 'nnoremap g' . i . ' ' . i . 'gt'
endfor
" }}}

" Commands {{{
command! -range -nargs=1 CutWrite <line1>,<line2>write <args> | <line1>,<line2>delete
" }}}

" Filetype Detection and Local Settings {{{
let g:sls_use_jinja_syntax = 0

augroup filetype_detection
  autocmd!
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
augroup END

augroup filetype_settings
  autocmd!
  autocmd FileType text setlocal textwidth=78
  autocmd FileType mail setlocal textwidth=72
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType html inoremap <buffer> <F3> <!doctype html><CR>
  autocmd FileType sh inoremap <buffer> <F3> #!/bin/bash -<CR><CR>
  autocmd FileType python inoremap <buffer> <F3> #!/usr/bin/env python<CR><CR>
  autocmd FileType python setlocal softtabstop=4 expandtab shiftwidth=4
  autocmd FileType go setlocal shiftwidth=0
  autocmd FileType csv nnoremap <buffer> <C-k> :WhatColumn!<CR>
  autocmd FileType * setlocal foldmethod=expr foldexpr=v:lua.vim.treesitter.foldexpr()
augroup END
" }}}

" GnuPG {{{
set noshelltemp
nnoremap Ps :%!gpg --clearsign<CR>
nnoremap Pe :%!gpg -er
nnoremap Pb :%!gpg -ser
nnoremap Pd :%!gpg -d<CR>
" }}}

" ALE {{{
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
\  'lua': [],
\}

let g:ale_fixers = {
\  'python': ['ruff'],
\  'markdown': ['trim_whitespace', 'remove_trailing_lines'],
\  'terraform': ['terraform', 'trim_whitespace', 'remove_trailing_lines'],
\  'hcl': ['packer'],
\}
" }}}

" Beancount {{{
augroup beancount_settings
  autocmd!
  autocmd FileType beancount let b:beancount_root = expand('$BEANCOUNT_ROOT')
  autocmd FileType beancount inoremap <buffer> . .<C-\><C-O>:AlignCommodity<CR>
  autocmd FileType beancount nnoremap <C-p> :execute ":!bean-doctor context $BEANCOUNT_ROOT %:" . line('.')<CR>
  autocmd FileType beancount vnoremap L :!bean-format<CR>
  autocmd FileType beancount vnoremap S :!bean-split<CR>
augroup END
" }}}
