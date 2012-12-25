" LZSoft VIM Extension : Number Column Edit Commands
" Liang Tao
" 2012-12-25
"
" Usage :
" <range>Nd [STEP]

function! LZS_nc_count_integer(...)
    let pos = getpos("'<")
    let firstline = pos[1]
    let firstcol = pos[2] - 1

    let pos = getpos("'>")
    let lastline = pos[1]
    let lastcol = pos[2]

    if firstline == lastline
        return
    endif

    let step = exists("a:1") ? a:1 : 1
    let ln = getline(firstline)
    let num = strpart(ln, firstcol, lastcol - firstcol)

    for n in range(firstline + 1, lastline)
        let ln = getline(n)

        let num += step
        let new_ln = printf('%s%d%s',strpart(ln, 0, firstcol), num, strpart(ln, lastcol, len(ln) - lastcol))
        call setline(n, new_ln)
    endfor
endfunction " LZS_nc_count_integer

command! -range -nargs=* Ni call LZS_nc_count_integer(<f-args>)
