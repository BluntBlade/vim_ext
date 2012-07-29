" LZSoft VIM Extension : Alignment
" Liang Tao
" 2012-07-29

function! LZS_split_items(first, last)
  let re = '\(["'']\)[^[:space:]]*\([[:space:]]\+[^[:space:]]*\)*\1\|[^[:space:]]\+'
  let rows = []
  let leading = matchstr(getline(a:first), '^[[:space:]]\+')

  for n in range(a:first, a:last)
    let items = []

    let line = getline(n)
    let len = strlen(line)
    let pos = 0
    
    while pos < len
      let str = matchstr(line, re, pos)

      if str == ""
        break
      endif

      call add(items, str)
      let pos = match(line, re, pos) + strlen(str)
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

  for items in a:rows
    let items = map(range(0, len(fmt) - 1), 'printf(fmt[v:val], items[v:val])')
    call add(ret, a:leading . join(items, " "))
  endfor

  return ret
endfunction " LZS_align_items

function! LZS_align() range
  let sp_ret = LZS_split_items(a:firstline, a:lastline)
  let rows = LZS_align_items(sp_ret['leading'], sp_ret['rows'])

  for n in range(a:firstline, a:lastline)
    call setline(n, rows[n - a:firstline])
  endfor
endfunction " LZS_align

command! -range Al <line1>,<line2>call LZS_align()
