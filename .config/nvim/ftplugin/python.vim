" Sort imports on demand through ALE, without changing its save-time fixers.
function! s:RuffIsort(buffer) abort
  return {
  \ 'cwd': ale#fixers#ruff#GetCwd(a:buffer),
  \ 'command': ale#fixers#ruff#GetCommand(a:buffer)
  \   . ' check --select I --fix --stdin-filename %s -',
  \ }
endfunction

command! -buffer RuffIsort call ale#fix#Fix(bufnr(''), '', function('<SID>RuffIsort'))

let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
  \ . (empty(get(b:, 'undo_ftplugin', '')) ? '' : ' | ')
  \ . 'delcommand -buffer RuffIsort'
