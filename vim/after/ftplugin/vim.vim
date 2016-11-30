runtime after/ftplugin/formatoptions.vim
runtime after/ftplugin/shifttwo.vim
runtime after/ftplugin/indent.vim

if exists('g:AutoPairs') && has_key(g:AutoPairs, '"')
  unlet g:AutoPairs['"']
endif

let b:undo_ftplugin = "let g:AutoPairs['\"'] = '\"'"
let b:cmt = exists('b:cmt') ? b:cmt : '"'

let vim_sub_pat  = '^\s*fu\%[nction!]\s\+\k\+'

Nmap <silent> <expr>  zp [Create folds around vim functions] FS_FoldAroundTarget(vim_sub_pat,{'context':1})
Nmap <silent> <expr>  za [Create folds showing vim functions and comments] FS_FoldAroundTarget(vim_sub_pat.'\\|^\s*".*',{'context':0, 'folds':'invisible'})
