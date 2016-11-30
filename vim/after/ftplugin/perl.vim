runtime after/ftplugin/global/formatoptions.vim
runtime after/ftplugin/global/shiftfour.vim
runtime after/ftplugin/global/indent.vim
runtime custom_plugins/trackperlvars.vim

let perl_sub_pat = '^\s*\%(sub\|func\|method\|package\)\s\+\k\+'

Xnoremap          <buffer> <leader>f  [Run perltidy] :!perltidy --quiet --standard-output --nostandard-error-output<CR>
Nmap              <buffer> cpv        [Rename perl variable] :call TPV_rename_perl_var('normal')<CR>
Vmap              <buffer> cpv        [Visual rename perl variable] :call TPV_rename_perl_var('visual')<CR>gv
Nmap     <silent> <buffer> *          [Search for next instance of perl variable] :let @/ = TPV_locate_perl_var()<CR>
Nmap     <silent> <buffer> gd         [Locate perl variable declaration] :let @/ = TPV_locate_perl_var_decl()<CR>
Nmap     <silent> <buffer> tt         [Lock tracking of perl variable] :let b:track_perl_var_locked = ! b:track_perl_var_locked<CR>:call TPV_track_perl_var()<CR>

Nmap     <silent> <expr>   zp         [Create folds around perl subroutines] FS_FoldAroundTarget(perl_sub_pat,{'context':1})
Nmap     <silent> <expr>   za         [Create folds showing only subroutines and comments] FS_FoldAroundTarget(perl_sub_pat.'\zs\\|^\s*#.*',{'context':0, 'folds':'invisible'})

let g:syntastic_enable_perl_checker=1
let g:syntastic_perl_checkers=['perl', 'perlcritic']
let g:syntastic_perl_lib_path=[ './lib' ]
let b:cmt = exists('b:cmt') ? b:cmt : '#'
" These settings are for perl.vim syntax
let perl_include_pod=1    " Syntax highlight pod documentation correctly
let perl_extended_vars=1    " Syntax color complex things like @{${'foo'}}
