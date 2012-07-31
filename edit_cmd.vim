" LZSoft VIM Extension : Alignment
" Liang Tao
" 2012-07-31

function! LZS_exchange_register ()
  let reg = getreg('"')

  if reg =~ '\n'
    normal m`""P``dd
  else
    normal ""Pldel
  endif
endfunction " LZS_exchange_register

nmap Xp :call LZS_exchange_register()<Cr>

" vim:set sw=2 ts=2:
