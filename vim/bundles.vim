call plug#begin('~/.vim/plugged')

" NOTE: Make sure you use single quotes

" == Formatting/Display {{{1
" ======================

Plug 'altercation/vim-colors-solarized'   " Crisp colorscheme
Plug 'nelstrom/vim-markdown-folding'    " Folding for markdown by heading
Plug 'tpope/vim-sensible'   " A set of base vimrc settings. Loaded first so later settings override
Plug 'vim-airline/vim-airline'    " Fantastic status line

" == Source Control {{{1
" ==================

Plug 'airblade/vim-gitgutter'   " Displays modification symbols in gutter
Plug 'junegunn/vim-github-dashboard', { 'on': 'GHD' }   " Browse GitHub activity in Vim
Plug 'tpope/vim-fugitive'   " Git integration

" == File Management {{{1
" ===================

" Fuzzy-finder written in Go
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } |
      \ Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'    " Displays tags in a sidebar
Plug 'scrooloose/nerdtree'    " FileTree
Plug 'vim-scripts/a.vim'    " Easy open 'Alternate' files
Plug 'xolox/vim-misc' |
      \ Plug 'xolox/vim-easytags'   " Ctags quality of life improvements
Plug 'airblade/vim-rooter'    " Auto cd to project directory

" == Window Management {{{1
" =====================

Plug 'christoomey/vim-tmux-navigator'   " Easily jump between splits or tmux windows
Plug 'edkolev/tmuxline.vim'   " Tmux/Airline integration
Plug 'xolox/vim-session'    " Extended session support

" == Editing {{{1
" ===========

Plug 'christoomey/vim-sort-motion'    " Easier sorting
Plug 'christoomey/vim-system-copy'    " Better OS clipboard integration
Plug 'christoomey/vim-titlecase'    " Easier title casing
Plug 'ciaranm/detectindent'     " Autodetect indent style for current file to stay consistent
Plug 'easymotion/vim-easymotion'    " Move around vim easier
Plug 'ervandew/supertab'    " Auto-completion
Plug 'jiangmiao/auto-pairs'   " Auto-complete bracket pairs
Plug 'junegunn/vim-easy-align'    " Makes aligning chunks of code super easy
Plug 'justinmk/vim-ipmotion'    " Improves { and } motions
Plug 'kana/vim-textobj-user'    " Core textobj dependency
Plug 'kana/vim-textobj-entire'    " Provides more text objects to work with entire buffers
Plug 'kana/vim-textobj-indent'    " Provides indent text objects
Plug 'kana/vim-textobj-line'    " Provides current line text object
Plug 'reedes/vim-pencil'    " Makes vim like a writing editor
Plug 'nelstrom/vim-textobj-rubyblock'     " Ruby textobj
Plug 'sheerun/vim-polyglot'   " Syntax support for a variety of languages
Plug 'svermeulen/vim-easyclip'    " Better clipboard interaction
Plug 'tmhedberg/matchit'    " Advanced % matching
Plug 'tommcdo/vim-exchange'     " Allows easy exchanging of text
Plug 'tpope/vim-abolish'    " Adds useful shorthand for abbreviations and search/replace
Plug 'tpope/vim-commentary'     " Commenting quality of life improvements
Plug 'tpope/vim-endwise'    " Adds ending structures to blocks e.g. endif
Plug 'tpope/vim-speeddating'    " Makes interacting with dates easier
Plug 'tpope/vim-surround'   " Enables surrounding text with quotes or brackets easier
Plug 'tpope/vim-unimpaired'     " Adds a lot of shortcuts complimentary pairs of mappings
Plug 'vim-scripts/HTML-AutoCloseTag'    " Auto-closes HTML tags e.g. </body>
Plug 'vim-scripts/ShowMarks'    " Shows marks in the gutter
Plug 'vim-scripts/argtextobj.vim'     " Select/Modify inner arguments inside parens or quotes
Plug 'vim-scripts/ReplaceWithRegister'    " Better register management

" == Utility/Support {{{1
" ===================

Plug 'JamshedVesuna/vim-markdown-preview'    " Preview markdown in a browser
Plug 'SirVer/ultisnips'    " Code Snippets
Plug 'fatih/vim-go', { 'for': 'go' }    " GoLang support
Plug 'honza/vim-snippets'     " Snippet files
Plug 'jez/vim-superman'   " Allows editing of man pages in vim with syntax highlighting
Plug 'nsf/gocode', { 'for': 'go' }    " GoLang autocomplete
Plug 'othree/html5.vim'     " Improved HTML syntax
Plug 'scrooloose/syntastic'   " Syntax checking
Plug 'tpope/vim-dispatch'     " Allows building/testing to go on in the background
Plug 'tpope/vim-repeat'     " Repeat last command using .
Plug 'vim-perl/vim-perl'    " Improved perl syntax

" }}}

call plug#end()

" vim:foldmethod=marker:foldlevel=0
