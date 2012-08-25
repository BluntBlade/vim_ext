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

nmap <C-p> :call LZS_exchange_register()<Cr>

nmap <Tab> <C-W>w
nmap <S-Tab> <C-W>W

" vim:set sw=2 ts=2:
