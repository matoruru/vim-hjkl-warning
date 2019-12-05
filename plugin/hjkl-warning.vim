function! s:getLineCol()
  let l:curPos = getcurpos()
  return { "line": l:curPos[1], "col": l:curPos[2] }
endfunction

let s:oldPos = s:getLineCol()

function! s:update(newPos)
  let l:lineDiff =                   abs(s:oldPos["line"] - a:newPos["line"])
  let l:colDiff  = l:lineDiff == 0 ? abs(s:oldPos["col" ] - a:newPos["col" ]) : 0
  if (0 < l:lineDiff && l:lineDiff < g:hjkl_warning_min_line) || (0 < l:colDiff && l:colDiff < g:hjkl_warning_min_column)
    let s:curNum += 1
  else
    let s:curNum = 0
  endif
  let s:oldPos = a:newPos
endfunction

function! s:warn()
  echo g:hjkl_warning_warning_message
endfunction

function! s:main()
  call s:update(s:getLineCol())
  if g:hjkl_warning_max_repeat < s:curNum
    call s:warn()
  endif
endfunction

let g:hjkl_warning_min_column      = exists('g:hjkl_warning_min_column'      ) ? g:hjkl_warning_min_column      : 4
let g:hjkl_warning_min_line        = exists('g:hjkl_warning_min_line'        ) ? g:hjkl_warning_min_line        : 4
let g:hjkl_warning_max_repeat      = exists('g:hjkl_warning_max_repeat'      ) ? g:hjkl_warning_max_repeat      : 5
let g:hjkl_warning_warning_message = exists('g:hjkl_warning_warning_message' ) ? g:hjkl_warning_warning_message : "[hjkl-warning]: You use too much h/j/k/l to move"

augroup hjkl-makeinu
  autocmd!
  autocmd CursorMoved * call s:main()
augroup END
