set nonumber " No Line numbers
set wrap " Soft wrap
set linebreak " Linebreak using breakat
set nolist " Allow linebreak
set formatoptions=1 " Don't break after 1 letter word
" set noexpandtab " Don't expand tabs to spaces
set nojoinspaces " Don't use a double space when joining
set nosmartindent " No Smart indenting
" au VimEnter * if &columns > 100 | rightb vnew | wincmd p | endif

function! FormatText()
    %s/\s\+$//
    noh
    %s/\(\S\)\n\(\S\)/\1 \2/
    %s/\] /\]\r/
endfunction

com! FT call FormatText()
