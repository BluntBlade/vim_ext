" LZSoft VIM Extension : Alignment
" Liang Tao
" 2012-07-29
"
" Usage :
" <range>Al [LINE]
"
" LINE  Specify the line whose leading spaces shall be added before each other
"       lines.

function! LZS_split_items(first, last, posi)
  let re = '"[^[:space:]"]*\([[:space:]]\+[^[:space:]"]*\)*"\|''[^[:space:]'']*\([[:space:]]\+[^[:space:]'']*\)*''\|[^[:space:]]\+'
  let rows = []
  let posi = a:posi > 0 ? a:posi :  a:first
  let leading = matchstr(getline(posi), '^[[:space:]]\+')

  for n in range(a:first, a:last)
    let items = []

    let line = getline(n)
    let pos = 0
    let str = matchstr(line, re, pos)
    
    while str != ""
      call add(items, str)
      let pos = match(line, re, pos) + strlen(str)
      let str = matchstr(line, re, pos)
    endwhile

    call add(rows, items)
  endfor

  return {'leading': leading, 'rows': rows}
endfunction " LZS_split_items

function! LZS_align_items(leading, rows)
  let ret = []
  let sz = []

  for items in a:rows
    for i in range(0, len(items) - 1)
      if get(sz, i) == 0
        call add(sz, strlen(items[i]))
      elseif sz[i] < strlen(items[i])
        let sz[i] = strlen(items[i])
      endif
    endfor
  endfor

  let fmt = []
  for i in range(0, len(sz) - 1)
    call add(fmt, printf("%%-%ds", sz[i]))
  endfor

  let sz_cnt = len(sz)
  for items in a:rows
    let new_items = []
    let item_cnt = len(items)

    " Do not output non-exists columns
    for i in range(0, item_cnt - 1)
      call add(new_items, printf(fmt[i], items[i]))
    endfor

    call add(ret, a:leading . join(new_items, " "))
  endfor

  return ret
endfunction " LZS_align_items

function! LZS_align(...) range
  let sp_ret = LZS_split_items(a:firstline, a:lastline, a:0 == 1 ? a:1 : -1)
  let rows = LZS_align_items(sp_ret['leading'], sp_ret['rows'])

  for n in range(a:firstline, a:lastline)
    let ln = substitute(rows[n - a:firstline], ' \+$', '', '')     " Trim the tailing spaces
    call setline(n, ln)
  endfor
endfunction " LZS_align

command! -range -nargs=* Al <line1>,<line2>call LZS_align(<f-args>)

" vim:set sw=2 ts=2:
