call plug#begin('~/.vim/plugins')

" NOTE: Make sure you use single quotes

" == Editing   {{{1
" ==================================================================================================

Plug 'christoomey/vim-sort-motion'   " Easier sorting
Plug 'junegunn/vim-easy-align'       " Makes aligning chunks of code super easy
Plug 'vim-scripts/YankRing.vim'          " Makes pasting previous yanks easier
Plug 'justinmk/vim-ipmotion'         " Improves { and } motions
Plug 'reedes/vim-pencil'             " Makes vim like a writing editor
Plug 'tmhedberg/matchit'             " Advanced % matching
Plug 'tommcdo/vim-exchange'          " Allows easy exchanging of text
Plug 'tpope/vim-commentary'          " Commenting quality of life improvements
Plug 'tpope/vim-endwise'             " Adds ending structures to blocks e.g. endif
" Plug 'kshenoy/vim-signature'         " Adds vim marks to gutter
Plug 'tpope/vim-surround'            " Enables surrounding text with quotes or brackets easier
Plug 'tpope/vim-unimpaired'          " Adds a lot of shortcuts complimentary pairs of mappings
Plug 'garbas/vim-snipmate' |
  Plug 'marcweber/vim-addon-mw-utils' |
  Plug 'tomtom/tlib_vim'
Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'
Plug 'rust-lang/rust'

" == File Management   {{{1
" ==================================================================================================

" Fuzzy-finder written in Go
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } |
      \ Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'    " Displays tags in a sidebar
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }  " FileTree

" == Formatting/Display   {{{1
" ==================================================================================================

Plug 'altercation/vim-colors-solarized' " Crisp colorscheme
Plug 'nelstrom/vim-markdown-folding'    " Folding for markdown by heading

" == Source Control   {{{1
" ==================================================================================================

Plug 'airblade/vim-gitgutter' " Displays modification symbols in gutter
Plug 'tpope/vim-fugitive'     " Git integration

" == Text Objects   {{{1
" ==================================================================================================

Plug 'bkad/CamelCaseMotion'           " Text objects for working inside CamelCase words
Plug 'christoomey/vim-titlecase'      " Easier title casing
Plug 'kana/vim-textobj-entire'        " Provides more text objects to work with entire buffers
Plug 'kana/vim-textobj-fold'          " Text object for folded lines
Plug 'kana/vim-textobj-indent'        " Provides indent text objects
Plug 'kana/vim-textobj-line'          " Provides current line text object
Plug 'kana/vim-textobj-user'          " Core textobj dependency
Plug 'nelstrom/vim-textobj-rubyblock' " Ruby textobj
Plug 'vim-scripts/argtextobj.vim'     " Select/Modify inner arguments inside parens or quotes

" == Utility/Support   {{{1
" ==================================================================================================

Plug 'scrooloose/syntastic' " Syntax checking
Plug 'tpope/vim-dispatch'   " Allows building/testing to go on in the background
Plug 'tpope/vim-repeat'     " Repeat last command using .
Plug 'zenbro/mirror.vim'    " Easily edit mirror files across systems using SCP

" == Language Support   {{{1
" ==================================================================================================

Plug 'sheerun/vim-polyglot'          " Syntax support for a variety of languages
Plug 'vim-perl/vim-perl'             " vim Perl support
Plug 'vim-scripts/HTML-AutoCloseTag' " Auto-closes HTML tags e.g. </body>

" == Window Control   {{{1
" ==================================================================================================

Plug 'christoomey/vim-tmux-navigator' " Easily jump between splits or tmux windows

" }}}

call plug#end()

" vim:foldmethod=marker:foldlevel=0
