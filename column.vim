" LZSoft VIM Extension : Number Column Edit Commands
" Liang Tao
" 2012-12-25
"
" Usage :
" <range>Nd [STEP]

let s:num_part_re   = '[0-9]\+'
let s:begin_part_re = '^[^0-9]*'
let s:end_part_re   = '[^0-9]*$'

function! LZS_nc_parse_integer (col)
    let begin_part = matchstr(a:col, s:begin_part_re)
    let pos        = strlen(begin_part)

    let num_part   = matchstr(a:col, s:num_part_re, pos)
    let pos        = pos + strlen(num_part)

    let end_part   = matchstr(a:col, s:end_part_re, pos)

    return [begin_part, num_part, end_part]
endfunction " LZS_nc_parse_integer

function! LZS_nc_accumulate_integer(...)
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

    for n in range(firstline, lastline)
        let ln = getline(n)
        let parts = LZS_nc_parse_integer(strpart(ln, firstcol, lastcol - firstcol))

        if !exists("num")
            let num = parts[1]
            continue
        endif

        let first_part = strpart(ln, 0, firstcol)
        let last_part = strpart(ln, lastcol, strlen(ln) - lastcol)

        let num += step
        let new_ln = printf('%s%s%d%s%s', first_part, parts[0], num, parts[2], last_part)
        call setline(n, new_ln)
    endfor
endfunction " LZS_nc_accumulate_integer

function! LZS_nc_copy_integer(...)
    let pos = getpos("'<")
    let firstline = pos[1]
    let firstcol = pos[2] - 1

    let pos = getpos("'>")
    let lastline = pos[1]
    let lastcol = pos[2]

    if firstline == lastline
        return
    endif

    let ln = getline(firstline)
    let num = strpart(ln, firstcol, lastcol - firstcol)

    for n in range(firstline + 1, lastline)
        let ln = getline(n)
        let new_ln = printf('%s%d%s',strpart(ln, 0, firstcol), num, strpart(ln, lastcol, len(ln) - lastcol))
        call setline(n, new_ln)
    endfor
endfunction " LZS_nc_copy_integer

command! -range -nargs=* Ni call LZS_nc_accumulate_integer(<f-args>)
command! -range -nargs=* Np call LZS_nc_copy_integer(<f-args>)
