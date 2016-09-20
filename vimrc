" == Vim {{{1
" =======

let mapleader=" "
set nocompatible    " Disable VI backwards compatible settings. Must be first

set autowrite     " Automatically :write before running commands
" Set directory to store backup files in.
" These are created when saving, and deleted after successfully written
set backupdir^=/tmp//
set cpoptions+=W    " Don't overwrite readonly files with :w!
" Always use vertical diffs
set diffopt+=vertical
" Set directory to store swap files in
set directory^=/tmp//
set fileformat=unix
set fileformats=unix,dos,mac    " Default file types
set foldenable
set foldmethod=indent
set foldnestmax=1     " Deepest folds allowed for indent and syntax methods
set gdefault    " Never have to type /g at the end of search / replace again
set grepprg=grep\ -nH\ $*:    " Set grep to always print filename headers
set hidden    " Hide buffers instead of closing them
set history=500     " Save the last # commands
set hlsearch    " Highlight all search matches
set ignorecase    " Case insensitive searching (unless specified)
set lazyredraw    " Don't redraw screen during macros or commands
" Set < and > as brackets for jumping with %
set matchpairs+=<:>
" Completion mode - match longest then next full match
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
if v:version >= 704
  set relativenumber    " Toggle relative line numbering
endif
set sessionoptions-=help    " Don't save help windows
set scrolloff=8     " Start scrolling when we're # lines away from margins
set showcmd     " Display incomplete command
set showmatch     " Blink to a matching bracket if on screen
set showmode    " Show current mode (INSERT, VISUAL)
set sidescrolloff=15    " Start side-scrolling when # characters away
set sidescroll=5    " Scroll # column at a time
set smartcase     " Ignores ignorecase when searching for upercase characters
set tags=./tags     " Use a local tags file instead of the global
set term=xterm-256color
set ttyfast     " Smoother redraw
set undolevels=100    " How many undos
set updatetime=1000    " How often to write to the swap file when nothing is pressed
" Tell vim to remember certain things when we exit
" '10  : marks will be remembered for up to 10 previously edited files
" f1   :  enable capital marks
" "100 :  will save up to 100 lines for each register
" :20  :  up to 20 lines of command-line history will be remembered
" %  :  saves and restores the buffer list
" n... :  where to save the viminfo files
set viminfo='10,f1,\"100,:20,%,n~/.viminfo

" Keep undo history across sessions by storing in a file
if exists('&undofile')
  silent !mkdir ~/.vim/undodir > /dev/null 2>&1
  set undodir=$HOME/.vim/undodir
  set undofile
endif
" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
if has('spell')
  set spellfile=$HOME/.vim-spell-en.utf-8.add
  set spelllang=en
endif

" == Abbreviations {{{1
" =================
iabbrev teh the
iabbrev adn and
iabbrev waht what
iabbrev tehn then
iabbrev @@ lukexor@gmail.com
iabbrev ccopy Copyright Lucas Petherbridge, All Rights Reserved.

" == Autocommands {{{1
" ================

augroup filetype_formats
  autocmd!

  autocmd FileType markdown,html setlocal nowrap
  autocmd FileType html let g:AutoPairs['<']='>'
  autocmd FileType vim if has_key(g:AutoPairs, '"') | unlet g:AutoPairs['"'] | endif
  autocmd FileType markdown,html,text setlocal nofoldenable
  autocmd FileType text,help let g:airline#extensions#wordcount#enabled=1 |
      \ setlocal wrap |
      \ set nolist
  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass,less setlocal iskeyword+=-
  autocmd FileType perl setlocal shiftwidth=4 softtabstop=4

  " Make sure the syntax is always right, even when in the middle of
  " a huge javascript inside an html file.
  autocmd BufNewFile,BufRead *.conf set filetype=yaml
  autocmd BufNewFile,BufRead *.md set filetype=markdown
  autocmd BufNewFile,BufRead *.t set filetype=perl
  autocmd BufNewFile,BufRead *.tt set filetype=tt2html.html.javascript.css
  autocmd BufNewFile,BufRead *.txt set filetype=help
  autocmd BufEnter * :syntax sync fromstart
augroup END

augroup vimrcEx
  autocmd!

  " Automatically rebalance windows on vim resize
  autocmd VimResized * :wincmd =

  " Follow symlink and set working directory
  autocmd BufEnter * call FollowSymlink() | call SetProjectRoot()
  " Don't do it for commit messages, when the position is invalid, or when
  " When editing a file, always jump to the last known cursor position.
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  " Trigger autoread when changing buffers or coming back to vim in terminal.
  autocmd FocusGained,BufEnter * :silent! !
  " Closes if NERDTree is the only open window
  autocmd BufEnter *
    \ if winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary" |
    \ qall! |
    \ endif

  " Save whenever switching windows or leaving vim. This is useful when running
  " the tests inside vim without having to save all files first.
  autocmd FocusLost,WinLeave * :silent! wa

  " Change Color when entering Insert Mode
  autocmd InsertEnter * highlight CursorLine ctermbg=235 ctermfg=None
  " Revert Color to default when leaving Insert Mode
  autocmd InsertLeave * highlight CursorLine ctermbg=017 ctermfg=None

  " Turns relative line numbers on and off when entering and exiting insert mode
  if v:version >= 704
    autocmd FocusLost * call ToggleRelativeOn()
    autocmd FocusGained * call ToggleRelativeOn()
    autocmd InsertEnter * call ToggleRelativeOn()
    autocmd InsertLeave * call ToggleRelativeOn()
  endif

augroup END

" == Functions {{{1
" =============

function! FollowSymlink()
  let current_file=expand('%:p')
  " Check if file type is a symlink
  if getftype(current_file) == 'link'
    " If it is a symlink resolve to the actual file path and open the actual file
    let actual_file=resolve(current_file)
    silent! execute 'file ' . actual_file
    if !&readonly
      silent! execute 'w!'
    endif
  end
endfunction
" Set working directory to git project root or directory of current file if not git project
function! SetProjectRoot()
  " Default to the current file's directory
  let curr_dir=expand('%:p:h')
  if isdirectory(curr_dir)
    lcd %:p:h
    let git_dir=system("git rev-parse --show-toplevel")
    " See if the command output starts with 'fatal' (if it does, not in a git repo)
    let is_not_git_dir=matchstr(git_dir, '^fatal:.*')
    " If git project, change local directory to git project root
    if empty(is_not_git_dir) && !empty(git_dir)
      lcd `=git_dir`
    endif
  endif
endfunction

" Enables toggling of relative line number with absolute
if v:version >= 704
  function! ToggleNumbersOn()
    set number!
    set relativenumber
  endfunction
  function! ToggleRelativeOn()
    set relativenumber!
    set number
  endfunction
endif

" Closes current buffer without destroying splits, and if it's the last buffer, exits vim
function! CloseBuffer()
  let buf_count=len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
  if buf_count > 1
    bprevious
    bdelete #
  else
    quit
  endif
endfunction

" == Format {{{1
" ==========

" Enable filetype specific settings
filetype plugin indent on
set autoindent    " Copy indent from current line when adding a new line
set expandtab     " Replace the tab key with spaces
" Set formatting options
" 1   Don't break after a one-letter word
" a   Auto-format paragraphs. When combined with c, only happens for comments
" c   Auto-wrap comments using textwidth, auto-inserting comment leader
" n   Regonized numbered lists and indent properly. autoindent must be set
" j   Remove a comment leader when joining lines
" l   Don't format long lines in insert mode if it was longer than textwidth
" q   Allow using gq to format comments
" r   Insert comment after hitting <Enter> in Insert mode
set formatoptions+=1clnq
" t   Auto-wrap using textwidth
set formatoptions-=t
if v:version >= 704
  set formatoptions+=j
endif
set linebreak     " Wrap long lines at a character in breakat
set nowrap    " Default line wrap
set shiftround    " Round to nearest multiple of shiftwidth
set shiftwidth=2    " The amount of space to shift when using >>, << or <tab>
set softtabstop=2     " Spaces a tab counts for when backspacing or inserting tabs
set textwidth=100     " Max width for text on the screen
set wrapmargin=0    " Number of chars from the right before wrapping

" == Plugins {{{1
" ===========

" Load up all of our plugins using vim-plug
if filereadable(expand("~/.vim/plugins.vim"))
  source ~/.vim/plugins.vim
endif

" Ensure dictionary is defined but don't overwrite it
if !exists('g:airline_symbols')
  let g:airline_symbols={}
endif

let g:airline#extensions#tabline#enabled=1    " Enable buffers as tabs at the top
let g:airline#extensions#tabline#show_splits=0    " Disable showing number of splits
let g:airline#extensions#tabline#buffer_nr_show=1     " Show buffer numbers
let g:airline#extensions#whitespace#long_format='long[%s]'
let g:airline#extensions#whitespace#mixed_indent_file_format='mix-i-f[%s]'
let g:airline#extensions#whitespace#mixed_indent_format='mixi[%s]'
let g:airline#extensions#whitespace#trailing_format='trail[%s]'
let g:airline_powerline_fonts=1     " Enable special font symbols for airline status
let g:airline_right_sep=''
let g:airline_section_y=''    " Disable fileencoding and fileformat info
let g:airline_symbols.crypt='🔒'
let g:airline_symbols.linenr='¶'
let g:airline_symbols.maxlinenr='☰'
let g:airline_symbols.notexists='∄'
let g:airline_symbols.paste='ρ'
let g:airline_symbols.spell='Ꞩ'
let g:airline_symbols.whitespace='Ξ'
let g:airline#extensions#tmuxline#enabled=0
let g:EasyClipShareYanks=1
let g:easytags_file='./tags'
let g:easytags_async=1    " Generate ctags in the background
let g:easytags_dynamic_files=1
" Uses less accurate, but faster highlighting
let g:easytags_syntax_keyword='always'
" Update tags every minute instead of every 4 seconds
let g:easytags_updatetime_min=60000
let g:easytags_resolve_links=1
let g:fzf_buffers_jump=1    " Jump to existing window if possible
let g:fzf_commits_log_options='--graph --pretty=format:"%C(yellow)%h (%p) %ai%Cred%d %Creset%Cblue[%ae]%Creset %s (%ar). %b %N"'
let g:fzf_source='find * -name .git -prune -o -name AppData -prune
  \ -o -type f -print -o -type d -print -o -type l -print'
" Override find and use ag instead which will honor .gitignore and only search text files
if executable('ag')
  let $FZF_DEFAULT_COMMAND='ag --hidden -g ""'
endif
let g:rooter_change_directory_for_non_project_files='current'
let g:rooter_resolve_links=1
let g:rooter_silent_chdir=1
" Ignore directories; CD for all files
let g:rooter_targets='*'
let g:rooter_use_lcd=1
let g:session_autoload='no'    " Loads 'default' session when vim is opened without files
let g:session_autosave='yes'
let g:session_autosave_periodic=3     " Automatically save the current session every 3 minutes
let g:session_autosave_silent=1     " Silence any messages
let g:session_default_to_last=1     " Default opening the last used session
let g:showmarks_enable=0
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=1
let g:syntastic_enable_perl_checker=1
let g:syntastic_error_symbol='❌'
let g:syntastic_javascript_checkers=['eslint']
let g:syntastic_loc_list_height=5
let g:syntastic_mode_map={ 'mode': 'passive' }
let g:syntastic_perl_checkers=['perl', 'perlcritic']
let g:syntastic_perl_lib_path=[ './lib' ]
let g:syntastic_style_error_symbol='[]'
let g:syntastic_style_warning_symbol='??'
let g:syntastic_warning_symbol='^'
let g:tagbar_width=40
if v:version >= 704
  let g:UltiSnipsEditSplit='vertical'
  let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips', $HOME.'/.vim/plugged/vim-snippets/UltiSnips/']
endif
let vim_markdown_preview_browser='Google Chrome'

" == Mappings {{{1
" ============

" -- Editing Mappings {{{2

augroup mappings
  autocmd!
  " Run perltidy in visual mode
  autocmd FileType perl vnoremap <buffer> <leader>t :!perltidy --quiet --standard-output --nostandard-error-output<CR>
augroup END

" Use jk to get out of insert mode
inoremap jk <ESC>
nnoremap <leader>w :write<CR>
" Move current line down one
nnoremap <leader>j ddp
" Move current line up one
nnoremap <leader>k dd<up>P
" Use enter to create new lines w/o entering insert mode
nnoremap <CR> o<Esc>
augroup enter
  autocmd!
  " Below is to fix issues with the ABOVE mappings in quickfix window
  autocmd CmdwinEnter * nnoremap <CR> <CR>
  autocmd BufReadPost quickfix nnoremap <CR> <CR>
augroup END
" Stop highlight after searching
nnoremap <silent> <leader><CR> :nohlsearch<CR>
" Toggle spellcheck
nnoremap <leader>st :setlocal spell!<CR>
" Count the number of words in the current document
nnoremap <leader>cw :!wc -w %<CR>
" Remove trailing whitespace
nnoremap <leader>rs mz:silent! %s/\s\+$//<CR>:noh<CR>`z
" Replace tabs with spaces
nnoremap <leader>rt :%retab!<CR>
" Reindent entire file. NOTE: This may indent unexpectedly
nnoremap <leader>ri mzgg=G`z

" -- Function Mappings {{{2

" Display custom help window with shortcut references
noremap <F2> :NERDTreeToggle<CR>
inoremap <F2> <Esc>:NERDTreeToggle<CR>i
noremap <F3> :TagbarToggle<CR>
inoremap <F3> <Esc>:TagbarToggle<CR>i
noremap <F12> :help lp-help<CR>
inoremap <F12> <Esc>:help lp-help<CR>

" -- Movement Mappings {{{2

" Remap add mark, because vim-easyclip uses m as 'move'
nnoremap gm m
" Quicker window movement
" Warning: C-h may be interpreted as <BS> in neovim
" noremap <C-h> <C-w>h
" noremap <C-j> <C-w>j
" noremap <C-k> <C-w>k
" noremap <C-l> <C-w>l
nnoremap K <PageUp>
nnoremap J <PageDown>
" Navigate properly when lines are wrapped
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
" Use tab to jump between blocks, because it's easier
nnoremap <tab> %
vnoremap <tab> %

" -- Plugin Mappings {{{2

let g:AutoPairsShortcutToggle='<C-0>'
let g:AutoPairsShortcutFastWrap='<C-l>'
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" FZF Open various files
inoremap <C-f> <plug>(fzf-complete-line)
noremap <leader>b :call SetProjectRoot()<CR>:Buffers<CR>
noremap <C-o> :call SetProjectRoot()<CR>:Files<CR>
noremap <C-i> :call SetProjectRoot()<CR>:Snippets<CR>
noremap <leader>h :call SetProjectRoot()<CR>:History<CR>
noremap <C-t> :call SetProjectRoot()<CR>:Tags<CR>
" Fugitive
nnoremap <leader>gst :Gstatus<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gpl :Gpull<CR>
nnoremap <leader>gm :Gmerge<space>
nnoremap <leader>gps :Gpush<CR>
nnoremap <leader>glg :Glog<CR>
nnoremap <leader>gb :Gblame<CR>
" Session
nnoremap <leader>s :SaveSession<space>
nnoremap <leader>o :OpenSession<space>
let vim_markdown_preview_hotkey='<leader>pm'

" -- System Mapping {{{2

if v:version >= 704
  noremap <leader>ep :UltiSnipsEdit<CR>
endif
noremap <leader>ev :vsplit $MYVIMRC<CR>
noremap <leader>m :make<CR>
noremap <leader>sv :source $MYVIMRC<CR>
noremap <leader>t :echom "Run Tests not setup yet"<CR>
" Make CTRL-C exit the same as escape
inoremap <C-c> <Esc>

" -- Windows Mapping {{{2

nnoremap <leader>1 :b1<CR>
nnoremap <leader>2 :b2<CR>
nnoremap <leader>3 :b3<CR>
nnoremap <leader>4 :b4<CR>
nnoremap <leader>5 :b5<CR>
nnoremap <leader>6 :b6<CR>
nnoremap <leader>7 :b7<CR>
nnoremap <leader>8 :b8<CR>
nnoremap <leader>9 :b9<CR>
" Create and move between buffers
noremap <leader>n <esc>:enew<CR>
noremap <leader>a :bprevious<CR>
noremap <leader>d :bnext<CR>
" Zoom a vim pane, <C-w>= to re-balance
nnoremap <leader>- :wincmd _<CR>:wincmd \|<CR>
nnoremap <leader>= :wincmd =<CR>
" Resize panes
nnoremap <silent> <Right> :vertical resize +5<CR>
nnoremap <silent> <Left> :vertical resize -5<CR>
nnoremap <silent> <Up> :resize +5<CR>
nnoremap <silent> <Down> :resize -5<CR>
" Switch between the last two files
noremap <leader>l :b#<CR>
noremap <leader>q :quit<CR>
noremap <leader>Q :quit!<CR>
noremap <leader>x :call CloseBuffer()<CR>
" Switch to alternate file/header
noremap <leader>A :A<CR>
" Disable EX mode
noremap Q <NOP>

" == Syntax {{{1
" ==========

colorscheme solarized
set background=dark
" Set default font in mac vim and gvim
set guifont=Literation\ Mono\ for\ Powerline:s12
set list    " Enable visibility of unprintable chars
set noerrorbells  " No sound on errors
set visualbell    " stop that ANNOYING beeping
" Default Colors for CursorLine
set cursorline    " Highlight the cursorline - slows redraw
set colorcolumn=+1    " Sets a vertical line highlight at tetwidth - slows redraw
highlight CursorLine ctermbg=017 ctermfg=None

" Disable syntax highlighting for really large files
autocmd Filetype * if getfsize(@%) > 1000000 |
  \ syntax off |
  \ setlocal nocursorline |
  \ setlocal colorcolumn="" |
  \ endif

" These settings are for perl.vim syntax
let perl_include_pod=1    " Syntax highlight pod documentation correctly
let perl_extended_vars=1    " Syntax color complex things like @{${'foo'}}

" a-z marks
highlight ShowMarksHLl ctermfg=grey ctermbg=235
" A-Z marks
highlight ShowMarksHLu ctermfg=grey ctermbg=235
" All other marks
highlight ShowMarksHLo ctermfg=grey ctermbg=235
" Multiple marks on same line
highlight ShowMarksHLm ctermfg=grey ctermbg=235
highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn

" == Windows {{{1
" ===========

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright
" Auto resize Vim splits to active split
set noequalalways     " Don't make windos equal size
set winminheight=0
set winwidth=110
set winheight=9999
set helpheight=9999

" }}}

" vim:foldmethod=marker:foldlevel=0
