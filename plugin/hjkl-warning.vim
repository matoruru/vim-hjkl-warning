let s:minColMove  = 4
let s:minLineMove = 4
let s:maxNum  = 5
let s:warningMes = "私は負け犬🐶です"
let s:curNum = 0

function! s:getLineCol()
  let l:curPos = getcurpos()
  return { "line": l:curPos[1], "col": l:curPos[2] }
endfunction

let s:oldPos = s:getLineCol()

function! s:update(newPos)
  let l:lineDiff =                   abs(s:oldPos["line"] - a:newPos["line"])
  let l:colDiff  = l:lineDiff == 0 ? abs(s:oldPos["col" ] - a:newPos["col" ]) : 0
  if (0 < l:lineDiff && l:lineDiff < s:minLineMove) || (0 < l:colDiff && l:colDiff < s:minColMove)
    let s:curNum += 1
  else
    let s:curNum = 0
  endif
  let s:oldPos = a:newPos
endfunction

function! s:warn()
  echo s:warningMes
endfunction

function! s:main()
  call s:update(s:getLineCol())
  if s:maxNum < s:curNum
    call s:warn()
  endif
endfunction

augroup hjkl-makeinu
  autocmd!
  autocmd CursorMoved * call s:main()
augroup END
