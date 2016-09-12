" ==================================================================================================
" .vimrc
"
" AUTHOR
"    Lucas Petherbridge
" ==================================================================================================


" ==================================================================================================
" == General

" Use Vim settings, rather then Vi settings. This setting must be as early as
" possible, as it has side effects.
set nocompatible

set runtimepath=~/.vim,$VIMRUNTIME

" Leader - ( Spacebar )
let mapleader=" "

" ==================================================================================================
" == Plugins

" Load up all of our plugins
if filereadable(expand("~/.vim/bundles.vim"))
  source ~/.vim/bundles.vim
endif

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" Define symbols and seting for Airline status bar
let g:airline_section_y = ''    " Disable fileencoding and fileformat info
let g:airline_powerline_fonts = 1
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = '☰'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_right_sep = ''
let g:airline#extensions#whitespace#trailing_format = 'trail[%s]'
let g:airline#extensions#whitespace#mixed_indent_format = 'mixi[%s]'
let g:airline#extensions#whitespace#long_format = 'long[%s]'
let g:airline#extensions#whitespace#mixed_indent_file_format = 'mix-i-f[%s]'

let g:easytags_async=1    " Generate ctags in the background
set tags=./tags     " Use a local tags file instead of the global
let g:easytags_dynamic_files=1
let g:easytags_syntax_keyword='always'
let g:easytags_opts = ['--exclude=@$HOME/.ctagsexclude']

let NERDTreeMouseMode = 2     " Single click for directories, double click for files
let NERDChristmasTree = 1
let g:nerdtree_tabs_open_on_console_startup = 0
let g:nerdtree_tabs_focus_on_files = 1
let NERDTreeAutoCenter = 1
let NERDTreeDirArrows = 1
let NERDTreeWinSize = 35
let NERDTreeMapOpenInTab = '<CR>'
let g:tagbar_width = 25

let g:syntastic_mode_map = { 'mode': 'passive' }
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_auto_loc_list = 1
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_enable_perl_checker = 1
let g:syntastic_perl_checkers = ['perl', 'perlcritic']
let g:syntastic_perl_lib_path = [ './lib' ]
let g:syntastic_error_symbol = '❌'
let g:syntastic_style_error_symbol = '[]'
let g:syntastic_warning_symbol = '^'
let g:syntastic_style_warning_symbol = '??'

let g:showmarks_enable = 0

" Tell vim to remember certain things when we exit
" '10  : marks will be remembered for up to 10 previously edited files
" f1   :  enable capital marks
" "100 :  will save up to 100 lines for each register
" :20  :  up to 20 lines of command-line history will be remembered
" %  :  saves and restores the buffer list
" n... :  where to save the viminfo files
set viminfo='10,f1,\"100,:20,%,n~/.viminfo

set lazyredraw
set grepprg=grep\ -nH\ $*:    " Set grep to always print filename headers

set nobackup        " Don't save backup files - version control does this for us
set nowritebackup
set noswapfile
set history=50
set showcmd         " Display incomplete command
set showmode        " Show current mode (INSERT, VISUAL)
set autowrite       " Automatically :write before running commands
set hidden          " Hide buffers instead of closing them
set cpoptions+=W    " Don't overwrite readonly files with :w!


" ==================================================================================================
" == History

set undolevels=100 " How many undos
" Keep undo history across sessions by storing in a file
if exists('&undofile')
  silent !mkdir ~/.vim/undodir > /dev/null 2>&1
  set undodir=~/.vim/undodir
  set undofile
endif


" Trigger autoread when changing buffers or coming back to vim in terminal.
au FocusGained,BufEnter * :silent! !


" ==================================================================================================
" == Status Settings

" Returns [PASTE] if pastemode is enabled
function! HasPaste()
  if &paste
    return '[PASTE] '
  else
    return ''
  endif
endfunction

set title
let NERDTreeStatusline='NERDTree'
" Format the statusline
set statusline=%f
set statusline+=\ %y            " Filetype
set statusline+=%m              " Modified flag
set statusline+=%r              " Read only flag
set statusline+=%{HasPaste()}\  " Whether pastemode is on or not
set statusline+=%*
set statusline+=%=              " Left/right separator
set statusline+=%l/%L           " Cursor line/total lines
set statusline+=\:%c            " Cursor column
set statusline+=\ %p%%          " Percent through file


" ==================================================================================================
" == Display

colorscheme solarized
let g:solarized_termcolors=256
set background=dark
set t_Co=256 " Force 256 colors

set ff=unix
set ffs=unix,dos,mac " Default file types

" Set default font in mac vim and gvim
set guifont=Literation\ Mono\ for\ Powerline:s12
set visualbell    " stop that ANNOYING beeping
set noerrorbells  " No sound on errors
set wildmode=list:longest,full
" Stuff to ignore when tab completing
set wildignore=*.o,*.obj,*~
set wildignore+=*vim/undodir*
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*.swp,*.bak,*.pyc,*.class
set wildignore+=*/build/**

" Default Colors for CursorLine
set cursorline
highlight CursorLine ctermbg=017 ctermfg=None
augroup hilight
  autocmd!
  " Change Color when entering Insert Mode
  autocmd InsertEnter * highlight CursorLine ctermbg=235 ctermfg=None

  " Revert Color to default when leaving Insert Mode
  autocmd InsertLeave * highlight CursorLine ctermbg=017 ctermfg=None
augroup END

" Allow usage of mouse in iTerm
set ttyfast
set mouse=a
set ttymouse=xterm2
set term=xterm-256color

" Make searching better
set gdefault      " Never have to type /g at the end of search / replace again
set ignorecase    " case insensitive searching (unless specified)
set smartcase
set hlsearch
set showmatch
" Stop highlight after searching
nnoremap <silent> <leader><CR> :nohlsearch<CR>


" ==================================================================================================
" == Formatting

" Softtabs, 2 spaces
set tabstop=2
set softtabstop=2     " Spaces a tab counts for when backspacing or inserting tabs
set shiftwidth=2
set shiftround
set expandtab
set formatoptions=rql " Allow line-width formatting with <leader>gq
set linebreak " Wrap long lines at a character in breakat

" Make it obvious where 100 characters is
set textwidth=100
set formatoptions=qrn1
set wrapmargin=0
set colorcolumn=+1
set wrap " wrap default

augroup filetype_formats
  autocmd!
  autocmd FileType markdown,html setlocal nowrap
  autocmd FileType text setlocal nolist nonumber | let g:airline#extensions#wordcount#enabled = 1
  autocmd FileType markdown,html,text setlocal nofoldenable

  " Run perltidy in visual mode
  autocmd FileType perl vnoremap <buffer> <leader>t :!perltidy --quiet --standard-output --nostandard-error-output<CR>

  if getfsize(expand(@%)) > 5000
    let g:easytags_auto_highlight=0
  endif

  " Make sure the syntax is always right, even when in the middle of
  " a huge javascript inside an html file.
  autocmd BufEnter * :syntax sync fromstart
  autocmd BufEnter *.txt set ft=text
  autocmd BufEnter *.conf set ft=yaml
  autocmd BufEnter *.t set ft=perl
augroup END

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Auto resize Vim splits to active split
set winwidth=104
set winheight=5
set winminheight=5
set winheight=999

" HTML Editing
set matchpairs+=<:>

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add
if has('spell')
  set spelllang=en
endif
" Toggle spellcheck
noremap <leader>ss :setlocal spell!<CR>
" Next misspelled word
noremap <leader>sn ]s
" Previous misspelled word
noremap <leader>sp [s
" Add highlighted word
noremap <leader>sa zg
" Remove highlighted word
noremap <leader>sr zw
" List spelling corrections
noremap <leader>s? z=



" ==================================================================================================
" == Editing

" Surround word in various symbols. This works faster than surround.vim
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel
nnoremap <leader>< viw<esc>a><esc>hbi<<esc>lel
nnoremap <leader>[ viw<esc>a]<esc>hbi[<esc>lel
nnoremap <leader>( viw<esc>a)<esc>hbi(<esc>lel

" Uppercase curent word in insert/normal modes
inoremap <c-u> <esc>viwU
nnoremap <c-u> viwU

" TODO: Move this to perl only file

" Count the number of words in the current document
nnoremap <leader>cw :!wc -w %<CR>

" Call makeprg and display first error
noremap <c-m> <esc>:make!<CR>

" Source vimrc
nnoremap <leader>sv :so ~/.vimrc<CR>

" Edit vimrc
nnoremap <leader>ev :tabe ~/.vimrc<CR>

" Remove trailing whitespace
nnoremap <leader>rs :%s/\s\+$//<CR>:noh<CR>

" Replace tabs with spaces
nnoremap <leader>rt :%retab!<CR>


" ==================================================================================================
" == Scrolling

set scrolloff=8   " Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1
set ttyfast   " Smoother changes

" Toggle relative numbering, and set to absolute on loss of focus or insert mode
set rnu
function! ToggleNumbersOn()
    set nu!
    set rnu
endfunction

function! ToggleRelativeOn()
    set rnu!
    set nu
endfunction
autocmd FocusLost * call ToggleRelativeOn()
autocmd FocusGained * call ToggleRelativeOn()
autocmd InsertEnter * call ToggleRelativeOn()
autocmd InsertLeave * call ToggleRelativeOn()


" ==================================================================================================
" == Fold options

set foldenable
if exists('&foldenable')
  set foldmethod=indent " Fold based on indent
  set foldnestmax=4 " Deepest fold
  set foldlevel=1 " The default depth to fold
  set foldminlines=1
endif


" ==================================================================================================
" == Movement

" Use enter to create new lines w/o entering insert mode
nnoremap <CR> o<Esc>
" Below is to fix issues with the ABOVE mappings in quickfix window
autocmd CmdwinEnter * nnoremap <CR> <CR>
autocmd BufReadPost quickfix nnoremap <CR> <CR>

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
" Warning: C-h may be interpreted as <BS> in neovim

" Move current line down one
nnoremap - ddp
" Move current line up one
nnoremap _ dd<up>P

" Navigate properly when lines are wrapped
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" Use tab to jump between blocks, because it's easier
nnoremap <tab> %
vnoremap <tab> %

" Always use vertical diffs
set diffopt+=vertical


" ==================================================================================================
" == System clipboard copy & paste support

" Copy paste to/from clipboard
vnoremap <C-c> "*y
noremap <silent><Leader>p :set paste<CR>o<esc>"*p:set nopaste<CR>"
noremap <silent><Leader><S-p> :set paste<CR>O<esc>"*p:set nopaste<CR>"


" ==================================================================================================
" == Saving and window control

" Tab configuration
noremap <C-n> <esc>:tabnew<CR>
nnoremap <C-a> :tabp<CR>
nnoremap <C-d> :tabn<CR>
inoremap <C-a> <esc>:tabp<CR>a
inoremap <C-d> <esc>:tabn<CR>a

inoremap <C-f> <plug>(fzf-complete-line)
nnoremap <C-o> :Files<CR>
nnoremap <C-h> :History<CR>
nnoremap <C-t> :Tags<CR>
nnoremap <C-p> :Snippets<CR>

" Makes a new buffer to the right
noremap <leader>l :rightbelow vnew<CR>

" Save current file if changed
noremap <silent><leader>s :update<CR>
" Save all changed buffers if file exists and is not read-only
noremap <silent><leader>w :wall<CR>

" Quickly close windows
nnoremap <leader>x :x<CR>
nnoremap <leader>X :q!<CR>
" Quit all windows without saving
noremap <leader>q :qall!<CR>

" Zoom a vim pane, <C-w>= to re-balance
nnoremap <leader>- :wincmd _<CR>:wincmd \|<CR>
nnoremap <leader>= :wincmd =<CR>

" Resize panes
nnoremap <silent> <Right> :vertical resize +5<CR>
nnoremap <silent> <Left> :vertical resize -5<CR>
nnoremap <silent> <Up> :resize +5<CR>
nnoremap <silent> <Down> :resize -5<CR>

" Switch between the last two files
nnoremap <leader><leader> <c-^>


" ==================================================================================================
" == Utility Functions

function! FollowSymlink()
  let current_file = expand('%:p')
  " Check if file type is a symlink
  if getftype(current_file) == 'link'
    " If it is a symlink resolve to the actual file path and open the actual file
    let actual_file = resolve(current_file)
    silent! execute 'file ' . actual_file
  end
endfunction

" Set working directory to git project root or directory of current file if not git project
function! SetProjectRoot()
  " Default to the current file's directory
  lcd %:p:h
  " let git_dir = system("git rev-parse --show-toplevel")
  " " See if the command output starts with 'fatal' (if it does, not in a git repo)
  " let is_not_git_dir = matchstr(git_dir, '^fatal:.*')
  " " If git project, change local directory to git project root
  " if empty(is_not_git_dir)
  "   lcd `=git_dir`
  " endif
endfunction

" ==================================================================================================
" == F Shortcuts

nnoremap <F1> :17split ~/.vim/help<CR>gg:wincmd j<CR>
inoremap <F1> <Esc>:17split ~/.vim/help<CR>gg:wincmd j<CR>i
set pastetoggle=<F3> "F3 before pasting to preserve indentation
nnoremap <F2> :NERDTreeMirrorToggle<CR>
inoremap <F2> <Esc>:NERDTreeMirrorToggle<CR>i
nnoremap <F4> :TagbarToggle<CR>


" ==================================================================================================
" == Auto-Commands

" Closes if NERDTree is the only open window
augroup NERDTree
  autocmd!
  autocmd BufEnter *
    \ if winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary" |
    \ qall! |
    \ endif
augroup END

" This should come last after everything else
augroup vimrcEx
  autocmd!

  " Save whenever switching windows or leaving vim. This is useful when running
  " the tests inside vim without having to save all files first.
  autocmd FocusLost,WinLeave * :silent! wa

  " Automatically rebalance windows on vim resize
  autocmd VimResized * :wincmd =

  " Follow symlink and set working directory
  autocmd BufRead * call FollowSymlink() | call SetProjectRoot()

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " Enable spellchecking for certain file types
  autocmd FileType markdown,text,gitcommit setlocal spell
  autocmd FileType vim-plug setlocal nospell

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass,less setlocal iskeyword+=-

  " Make sure to refresh AirLine for any filetype changes
  autocmd BufEnter * AirlineRefresh
augroup END


" ==================================================================================================
" == Highlighting

" These settings are for perl.vim syntax
let perl_include_pod = 1 " Syntax highlight pod documentation correctly
let perl_extended_vars = 1 " Syntax color complex things like @{${'foo'}}

highlight ShowMarksHLl ctermfg=grey ctermbg=235     " a-z marks
highlight ShowMarksHLu ctermfg=grey ctermbg=235     " A-Z marks
highlight ShowMarksHLo ctermfg=grey ctermbg=235     " All other marks
highlight ShowMarksHLm ctermfg=grey ctermbg=235     " Multiple marks on same line
highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn


" ==================================================================================================
" == Abbreviations
iabbrev teh the
iabbrev adn and
iabbrev waht what
iabbrev tehn then
iabbrev @@ lukexor@gmail.com
iabbrev ccopy Copyright Lucas Petherbridge, All Rights Reserved.
