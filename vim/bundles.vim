call plug#begin('~/.vim/plugged')

" NOTE: Make sure you use single quotes

" Formatting/Display
Plug 'tpope/vim-sensible'   " A set of base vimrc settings. Loaded first so later settings override
Plug 'altercation/vim-colors-solarized'   " Crisp colorscheme
Plug 'vim-airline/vim-airline'    " Fantastic status line

" Git plugins
Plug 'tpope/vim-fugitive'   " Git integration
Plug 'airblade/vim-gitgutter'   " Displays modification symbols in gutter
Plug 'junegunn/vim-github-dashboard', { 'on': 'GHD' }   " Browse GitHub activity in Vim

" File Management
Plug 'xolox/vim-misc' | Plug 'xolox/vim-easytags'   " Ctags quality of life improvements
Plug 'majutsushi/tagbar'    " Displays tags in a sidebar
Plug 'vim-scripts/a.vim'    " Easy open 'Alternate' files
Plug 'scrooloose/nerdtree' | Plug 'jistr/vim-nerdtree-tabs'    " FileTree and Tabs
" Fuzzy-finder written in Go
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } | Plug 'junegunn/fzf.vim'

" Window Management
Plug 'edkolev/tmuxline.vim'   " Tmux/Airline integration
Plug 'christoomey/vim-tmux-navigator'   " Easily jump between splits or tmux windows

" Editing
Plug 'junegunn/vim-easy-align'    " Makes aligning chunks of code super easy
Plug 'easymotion/vim-easymotion'    " Move around vim easier
Plug 'sheerun/vim-polyglot'   " Syntax support for a variety of languages
Plug 'ervandew/supertab'    " Auto-completion
Plug 'jiangmiao/auto-pairs'   " Auto-complete bracket pairs
Plug 'tomtom/tcomment_vim'    " Commenting shortcuts
Plug 'tpope/vim-surround'   " Enables surrounding text with quotes or brackets easier
Plug 'vim-scripts/HTML-AutoCloseTag'    " Auto-closes HTML tags e.g. </body>
Plug 'reedes/vim-pencil'    " Makes vim like a writing editor
Plug 'tpope/vim-unimpaired'     " Adds a lot of shortcuts complimentary pairs of mappings
Plug 'ciaranm/detectindent'     " Autodetect indent style for current file to stay consistent
Plug 'tpope/vim-endwise'    " Adds ending structures to blocks e.g. endif
Plug 'tpope/vim-abolish'    " Adds useful shorthand for abbreviations and search/replace
Plug 'tommcdo/vim-exchange'     " Allows easy exchanging of text
Plug 'tmhedberg/matchit'    " Advanced % matching
Plug 'justinmk/vim-ipmotion'    " Improves { and } motions
Plug 'vim-scripts/argtextobj.vim'     " Select/Modify inner arguments inside parens or quotes
Plug 'vim-scripts/ShowMarks'    "Shows marks in the gutter

" Utility/Support
Plug 'scrooloose/syntastic'   " Syntax checking
Plug 'fatih/vim-go', { 'for': 'go' }    " GoLang support
Plug 'nsf/gocode', { 'for': 'go' }    " GoLang autocomplete
Plug 'jez/vim-superman'   " Allows editing of man pages in vim with syntax highlighting
Plug 'tpope/vim-dispatch'     " Allows building/testing to go on in the background
Plug 'tpope/vim-repeat'     " Repeat last command using .

call plug#end()
