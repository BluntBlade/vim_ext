" LZSoft VIM Extension : Alignment
" Liang Tao
" 2012-07-29
"
" Usage :
" <range>Al [LINE]
"
" LINE  Specify the line whose leading spaces shall be added before each other
"       lines.

function! LZS_map_items(first, last, func, data)
  let re_lst = []
  call add(re_lst, '[^[:space:]"]*"[^[:space:]"]*\([[:space:]]\+[^[:space:]"]*\)*"[^[:space:]"]*')
  call add(re_lst, '[^[:space:]'']*''[^[:space:]'']*\([[:space:]]\+[^[:space:]'']*\)*''[^[:space:]'']*')
  call add(re_lst, '[^[:space:]]\+')

  let re = join(re_lst, '\|')
  let Func = function(a:func)

  for n in range(a:first, a:last)
    let ln   = getline(n)
    let lnsz = len(ln)
    let str  = matchstr(ln, '^[[:space:]]\+', 0)
    let pos  = strlen(str)

    while pos < lnsz
      let str = matchstr(ln, re, pos)
      call call(Func, [a:data, n, 'column', str])
      let pos += strlen(str)

      let str = matchstr(ln, '[[:space:]]\+', pos)
      let pos += strlen(str)
      call call(Func, [a:data, n, 'delimiter', str])
    endwhile

    call call(Func, [a:data, n, 'column', ''])
  endfor
endfunction " LZS_map_items

function! LZS_count_parens(data, str)
  let pos = 0
  while 1
    let substr = matchstr(a:str, '[()]', pos)
    if substr == '('
      let a:data.parens += 1
    elseif substr == ')'
      let a:data.parens -= 1
    else
      return
    endif

    let pos = match(a:str, '[()]', pos) + 1
  endwhile
endfunction! " LZS_count_parens

function! LZS_calc_max_size(data, n, case, str)
  if a:case != 'column'
    if a:data.parens > 0
      let a:data.accu_sz += strlen(a:str)
    end

    return
  end

  if a:str == ''
    let a:data.pos = 0
    return
  end

  call LZS_count_parens(a:data, a:str)

  if len(a:data.sizes) <= a:data.pos
    " New column
    call add(a:data.sizes, strlen(a:str))
  else
    let a:data.accu_sz += strlen(a:str)
    if a:data.parens > 0
      return
    end

    " Longer than the same column in the previous line
    if a:data.sizes[a:data.pos] < a:data.accu_sz
      let a:data.sizes[a:data.pos] = a:data.accu_sz
    end

    let a:data.accu_sz = 0
  end

  let a:data.pos += 1
endfunction " LZS_calc_max_size

function! LZS_fmt_item(data, n, case, str)
  if a:case != 'column'
    if a:data.parens > 0
      let a:data.items[a:data.pos] .= a:str
    end

    return
  end

  if a:str == ''
    let ln = a:data.leading . join(a:data.items, " ")
    let ln = substitute(ln, ' \+$', '', '') " Trim the tailing spaces
    call setline(a:n, ln)

    let a:data.pos = 0
    let a:data.items = []
    return
  end

  if a:data.parens > 0
    let a:data.items[a:data.pos] .= a:str
  else
    call add(a:data.items, a:str)
  end

  call LZS_count_parens(a:data, a:str)

  if a:data.parens == 0
    let a:data.items[a:data.pos] = printf(a:data.formats[a:data.pos], a:data.items[a:data.pos])
    let a:data.pos += 1
  endif
endfunction " LZS_fmt_item

function! LZS_align(...) range
  let data = {'pos': 0, 'parens': 0, 'accu_sz': 0, 'sizes': []}
  call LZS_map_items(a:firstline, a:lastline, 'LZS_calc_max_size', data)

  let leading_line = a:0 == 1 ? a:1 : -1
  let leading_line = leading_line > 0 ? leading_line :  a:firstline
  let leading = matchstr(getline(leading_line), '^[[:space:]]\+')

  let formats = map(data.sizes, 'printf("%%-%ds", v:val)')

  let data = {'pos': 0, 'parens': 0, 'leading': leading, 'formats': formats, 'items': []}
  call LZS_map_items(a:firstline, a:lastline, 'LZS_fmt_item', data)
endfunction " LZS_align

command! -range -nargs=* Al <line1>,<line2>call LZS_align(<f-args>)

" vim:set sw=2 ts=2:
