setlocal iskeyword-=:
setlocal shiftwidth=4
setlocal softtabstop=4
vnoremap <buffer> <leader>f :!perltidy --quiet --standard-output --nostandard-error-output<CR>
setlocal foldignore-=#
