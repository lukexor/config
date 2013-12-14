"=============================================================
" .vimrc
"=============================================================

" Returns operating system
fun! MySys()
  return "$1"
endfun

set runtimepath=~/.vim-runtime,$VIMRUNTIME,~/.vim-runtime/after

source $HOME/.vim-runtime/vimrc
" helptags ~/.vim-runtime/doc
