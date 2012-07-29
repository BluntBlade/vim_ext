" LZSoft VIM Extension : Aligment
" Liang Tao
" 2012-07-29

function! LZS_align_columns() range
  let ret = []
  let sz = []

  for ln in range(a:firstline, a:lastline)
    let cols = split(getline(ln))

    for i in range(0, len(cols) - 1)
      if get(sz, i) == 0
        call add(sz, strlen(cols[i]))
      elseif sz[i] < strlen(cols[i])
        let sz[i] = strlen(cols[i])
      endif
    endfor
  endfor

  let fmt = []
  for i in range(0, len(sz) - 1)
    call add(fmt, printf("%%-%ds", sz[i]))
  endfor

  for ln in range(a:firstline, a:lastline)
    let cols = split(getline(ln))
    call add(ret, join(map(range(0, len(fmt) - 1), 'printf(fmt[v:val], cols[v:val])'), " "))
  endfor

  return ret
endfunction " LZS_align_columns
