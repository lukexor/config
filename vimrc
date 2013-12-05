"=============================================================
" .vimrc
"=============================================================

" Returns operating system
fun! MySys()
  return "$1"
endfun

set runtimepath=~/.vim-runtime,$VIMRUNTIME,~/.vim-runtime/after

let srcfile=$HOME.'/.vim-runtime/vimrc-'.$HOSTNAME
if filereadable(srcfile)
  source $HOME/.vim-runtime/vimrc-$HOSTNAME
endif
source $HOME/.vim-runtime/vimrc
"helptags ~/.vim-runtime/doc
