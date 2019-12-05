let s:is_window_open = v:false
let s:curNum = 0

function! s:getLineCol()
  let l:curPos = getcurpos()
  return { "line": l:curPos[1], "col": l:curPos[2] }
endfunction

let s:oldPos = s:getLineCol()

function! s:create_window()
  if !s:is_window_open
    let l:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(buf, 0, 0, v:true, ["[hjkl-warning]:"] + g:hjkl_warning_message)
    let s:win_id = nvim_open_win(l:buf, v:false, {
        \ 'width': g:hjkl_warning_win_width,
        \ 'height': g:hjkl_warning_win_height,
        \ 'relative': 'cursor',
        \ 'row': 1,
        \ 'col': 0,
        \ 'external': v:false,
        \})
    let s:is_window_open = v:true
  endif
endfunction

function! s:close_window()
  if s:is_window_open
    call nvim_win_close(s:win_id, v:false)
    let s:is_window_open = v:false
  endif
endfunction

function! s:update(newPos)
  let l:lineDiff =                   abs(s:oldPos["line"] - a:newPos["line"])
  let l:colDiff  = l:lineDiff == 0 ? abs(s:oldPos["col" ] - a:newPos["col" ]) : 0
  if (0 < l:lineDiff && l:lineDiff < g:hjkl_warning_min_line) || (0 < l:colDiff && l:colDiff < g:hjkl_warning_min_column)
    let s:curNum += 1
  elseif l:lineDiff != 0 || l:colDiff != 0
    call s:close_window()
    let s:curNum = 0
  endif
  let s:oldPos = a:newPos
endfunction

function! s:warn(win_id)
  call nvim_win_set_config(a:win_id, {
      \ 'width': g:hjkl_warning_win_width,
      \ 'height': g:hjkl_warning_win_height,
      \ 'relative': 'cursor',
      \ 'row': 1,
      \ 'col': 0,
      \})
endfunction

function! s:main()
  if !g:hjkl_warning_enable
    return
  endif
  call s:update(s:getLineCol())
  if g:hjkl_warning_max_repeat < s:curNum
    call s:create_window()
    call s:warn(s:win_id)
  endif
endfunction

let g:hjkl_warning_win_width  = exists('g:hjkl_warning_win_width'  ) ? g:hjkl_warning_win_width  : 39
let g:hjkl_warning_win_height = exists('g:hjkl_warning_win_height' ) ? g:hjkl_warning_win_height : 2
let g:hjkl_warning_min_column = exists('g:hjkl_warning_min_column' ) ? g:hjkl_warning_min_column : 4
let g:hjkl_warning_min_line   = exists('g:hjkl_warning_min_line'   ) ? g:hjkl_warning_min_line   : 4
let g:hjkl_warning_max_repeat = exists('g:hjkl_warning_max_repeat' ) ? g:hjkl_warning_max_repeat : 5
let g:hjkl_warning_message    = exists('g:hjkl_warning_message'    ) ? g:hjkl_warning_message    : ["You press too much h/j/k/l to move!"]
let g:hjkl_warning_enable     = exists('g:hjkl_warning_enable'     ) ? g:hjkl_warning_enable     : v:true

command! HJKLWarningToggle :let g:hjkl_warning_enable = !g:hjkl_warning_enable

augroup hjkl-warning
  autocmd!
  autocmd CursorMoved * call s:main()
  autocmd CmdwinEnter,CmdlineEnter * call s:close_window()
augroup END
