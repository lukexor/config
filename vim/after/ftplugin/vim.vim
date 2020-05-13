runtime after/ftplugin/formatoptions.vim
runtime after/ftplugin/shifttwo.vim
runtime after/ftplugin/indent.vim

let b:cmt = exists('b:cmt') ? b:cmt : '"'
let vim_sub_pat  = '^\s*fu\%[nction!]\s\+\k\+'

Nnoremap <buffer> <silent> <expr>  zp [Create folds around vim functions] FS_FoldAroundTarget(vim_sub_pat,{'context':1})
Nnoremap <buffer> <silent> <expr>  za [Create folds showing vim functions and comments] FS_FoldAroundTarget(vim_sub_pat.'\\|^\s*".*',{'context':0, 'folds':'invisible'})
