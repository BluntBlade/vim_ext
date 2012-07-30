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
  call add(re_lst, '[^[:space:]]*"[^[:space:]"]*\([[:space:]]\+[^[:space:]"]*\)*"[^[:space:]]*')
  call add(re_lst, '[^[:space:]]*''[^[:space:]'']*\([[:space:]]\+[^[:space:]'']*\)*''[^[:space:]]*')
  call add(re_lst, '[^[:space:]]\+')

  let re = join(re_lst, '\|')
  let Func = function(a:func)

  for n in range(a:first, a:last)
    let pos = 0
    
    while 1
      let pos = match(getline(n), re, pos)
      if pos == -1
        call call(Func, [a:data, '', n])
        break
      end
      
      let str = matchstr(getline(n), re, pos)
      call call(Func, [a:data, str, n])
      let pos += strlen(str)
    endwhile
  endfor
endfunction " LZS_map_items

function! LZS_calc_max_size(data, str, n)
  if a:str == ''
    let a:data.pos = 0
    return
  end

  if len(a:data.sizes) <= a:data.pos
    call add(a:data.sizes, strlen(a:str))
  elseif a:data.sizes[a:data.pos] < strlen(a:str)
    let a:data.sizes[a:data.pos] = strlen(a:str)
  end

  let a:data.pos += 1
endfunction " LZS_calc_max_size

function! LZS_fmt_item(data, str, n)
  if a:str == ''
    let ln = a:data.leading . join(a:data.items, " ")
    let ln = substitute(ln, ' \+$', '', '') " Trim the tailing spaces
    call setline(a:n, ln)

    let a:data.pos = 0
    let a:data.items = []
    return
  end

  call add(a:data.items, printf(a:data.formats[a:data.pos], a:str))
  let a:data.pos += 1
endfunction " LZS_fmt_item

function! LZS_align(...) range
  let data = {'pos': 0, 'sizes': []}
  call LZS_map_items(a:firstline, a:lastline, 'LZS_calc_max_size', data)

  let leading_line = a:0 == 1 ? a:1 : -1
  let leading_line = leading_line > 0 ? leading_line :  a:firstline
  let leading = matchstr(getline(leading_line), '^[[:space:]]\+')

  let formats = map(data.sizes, 'printf("%%-%ds", v:val)')

  let data = {'pos': 0, 'leading': leading, 'formats': formats, 'items': []}
  call LZS_map_items(a:firstline, a:lastline, 'LZS_fmt_item', data)
endfunction " LZS_align

command! -range -nargs=* Al <line1>,<line2>call LZS_align(<f-args>)

" vim:set sw=2 ts=2:
