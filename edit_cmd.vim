" LZSoft VIM Extension : Alignment
" Liang Tao
" 2012-07-31

function! LZS_exchange_register (preserve)
  let reg = getreg('"')

  if reg =~ '\n'
    normal ""pkdd

    if a:preserve == 1
        normal yy
    endif
  else
    normal ""PldeB

    if a:preserve == 1
        normal ye
    endif
  endif
endfunction " LZS_exchange_register

nmap <C-x> :call LZS_exchange_register(0)<Cr>
nmap <C-p> :call LZS_exchange_register(1)<Cr>

nmap <Tab> <C-W>w
nmap <S-Tab> <C-W>W

" vim:set sw=2 ts=2:
