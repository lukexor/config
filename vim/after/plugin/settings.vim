" Set formatting options
" 1   Don't break after a one-letter word
" l   Don't format long lines in insert mode if it was longer than textwidth
" n   Regonized numbered lists and indent properly. autoindent must be set
" q   Allow using gq to format comments
" t   Auto-wrap using textwidth
" c   Auto-wrap comments using textwidth, auto-inserting comment leader
" r   Insert comment after hitting <Enter> in Insert mode
" o   Insert comment after hitting o or O in Normal mode
setlocal formatoptions+=1
setlocal formatoptions+=l
setlocal formatoptions+=n
setlocal formatoptions+=q
setlocal formatoptions-=t
setlocal formatoptions-=c
setlocal formatoptions-=r
setlocal formatoptions-=o
setlocal smartindent
setlocal autoindent
setlocal copyindent
