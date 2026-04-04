let b:beancount_root = expand('$BEANCOUNT_ROOT')

inoremap <buffer> . .<C-\><C-O>:AlignCommodity<CR>
nnoremap <buffer> <C-p> :execute ":!bean-doctor context $BEANCOUNT_ROOT %:" . line('.')<CR>
vnoremap <buffer> L :!bean-format<CR>
vnoremap <buffer> S :!bean-split<CR>

let b:undo_ftplugin = 'iunmap <buffer> .'
let b:undo_ftplugin .= ' | nunmap <buffer> <C-p>'
let b:undo_ftplugin .= ' | vunmap <buffer> L'
let b:undo_ftplugin .= ' | vunmap <buffer> S'
let b:undo_ftplugin .= ' | unlet! b:beancount_root'
