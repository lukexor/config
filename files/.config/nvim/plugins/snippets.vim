Plug 'SirVer/ultisnips'

let g:snips_author = system('git config --get user.name | tr -d "\n"')
let g:snips_author_email = system('git config --get user.email | tr -d "\n"')

" Fixes Ctrl-X Ctrl-K
" https://github.com/SirVer/ultisnips/blob/master/doc/UltiSnips.txt
inoremap <c-x><c-k> <c-x><c-k>
