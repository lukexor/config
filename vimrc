" == Vim Settings   {{{1
" ==================================================================================================

let b:fsize=getfsize(@%)
let mapleader=' '
let maplocalleader=','

set nocompatible                 " Disable VI backwards compatible settings. Must be first
set autoindent                   " Copy indent from current line when adding a new line
set autoread
set autowrite                    " Automatically :write before running commands
                                 " Set directory to store backup files in.
                                 " These are created when saving, and deleted after successfully written
set background=dark
set backspace=indent,eol,start
set backupdir^=/tmp//
set complete-=i
set completeopt+=longest,menuone
if b:fsize <= 1000000
  set cursorline                 " Highlight the cursorline - slows redraw
  if v:version >= 704
    set colorcolumn=+1           " Sets a vertical line highlight at tetwidth - slows redraw
  endif
endif
set cpoptions+=W                 " Don't overwrite readonly files with :w!
set diffopt+=vertical

" Set directory to store swap files in
set directory^=/tmp//
set display+=lastline
set encoding=utf-8
set expandtab                    " Replace the tab key with spaces
set fileformat=unix
set fileformats=unix,dos,mac     " Default file types

" Enable filetype specific settings
if has('autocmd')
  filetype plugin indent on
endif
set foldenable
set foldmethod=indent
set foldnestmax=2                " Deepest folds allowed for indent and syntax methods
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
if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j           " Delete comment character when joining commented lines
endif
set gdefault                     " Never have to type /g at the end of search / replace again
set grepprg=grep\ -nH\ $*:       " Set grep to always print filename headers
set hidden                       " Hide buffers instead of closing them
set history=1000                 " Save the last # commands
set hlsearch                     " Highlight all search matches
set incsearch                    " Highlight incrementally
set ignorecase                   " Case insensitive searching (unless specified)
set laststatus=2
set lazyredraw                   " Don't redraw screen during macros or commands
set linebreak                    " Wrap long lines at a character in breakat
set list                         " Enable visibility of unprintable chars
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

" Set < and > as brackets for jumping with %
set matchpairs+=<:>
set noerrorbells                 " No sound on errors
set noequalalways                " Don't make windos equal size
set nowrap                       " Default line wrap
set number
set nrformats-=octal             " Ignore octal when incrementing/decrementing numbers with CTRL-A and CTRl-X

" Search recursively
set path+=**

set wildmenu                     " Completion mode - match longest then next full match
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
  set relativenumber             " Toggle relative line numbering
endif
set ruler
set sessionoptions-=help,options " Don't save help windows
set scrolloff=8                  " Start scrolling when we're # lines away from margins
if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
  set shell=/bin/bash
endif
set shiftround    " Round to nearest multiple of shiftwidth
set shiftwidth=2  " The amount of space to shift when using >>, << or <tab>
set showcmd                      " Display incomplete command
set showmatch                    " Blink to a matching bracket if on screen
set showmode                     " Show current mode (INSERT, VISUAL)
set sidescrolloff=15             " Start side-scrolling when # characters away
set sidescroll=5                 " Scroll # column at a time
set smartcase                    " Ignores ignorecase when searching for upercase characters
set smarttab
" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
if has('spell')
  set spellfile=$HOME/.vim-spell-en.utf-8.add
  set spelllang=en
endif
set splitbelow                   " New horizontal splits should be below
set splitright                   " New vertical splits should be to the right
set softtabstop=2                " Spaces a tab counts for when backspacing or inserting tabs
if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif
set term=xterm-256color
set textwidth=100                " Max width for text on the screen
set ttimeout                     " Timeout on :mappings and key codes
set ttimeoutlen=100              " Change timeout length to 100 instead of 1000
set ttyfast                      " Smoother redraw
set undolevels=100               " How many undos
set updatetime=1000              " How often to write to the swap file when nothing is pressed

" Tell vim to remember certain things when we exit
" '10  : marks will be remembered for up to 10 previously edited files
" f1   :  enable capital marks
" "100 :  will save up to 100 lines for each register
" :20  :  up to 20 lines of command-line history will be remembered
" %  :  saves and restores the buffer list
" n... :  where to save the viminfo files
set viminfo='10,f1,\"100,:20,%,n~/.viminfo,|
set visualbell                   " stop that ANNOYING beeping

" Keep undo history across sessions by storing in a file
if exists('&undofile')
  silent !mkdir ~/.vim/undodir > /dev/null 2>&1
  set undodir=$HOME/.vim/undodir
  set undofile
endif
" The below allows horizontal and vertical splits to be small and out of the way, giving the active
" window as much room as possible
set winheight=10                 " This has to be set to winminheight first in order to work
set winminheight=10              " Then set min height
set winheight=9999               " Then set win height to maximum possible
set winwidth=110                 " Keepjust  current window wide enough to see numbers textwidth=100
set wrapmargin=0                 " Number of chars from the right before wrapping


" == Abbreviations   {{{1
" ==================================================================================================

iabbrev teh the
iabbrev adn and
iabbrev waht what
iabbrev tehn then
iabbrev @@ lukexor@gmail.com
iabbrev ccopy Copyright Lucas Petherbridge, All Rights Reserved.


" == Autocommands   {{{1
" ==================================================================================================

augroup filetype_formats
  autocmd!
  " Make sure the syntax is always right, even when in the middle of
  " a huge javascript inside an html file.
  autocmd BufNewFile,BufRead *.conf set filetype=yaml
  autocmd BufNewFile,BufRead *.md set filetype=markdown.text.help
  autocmd BufNewFile,BufRead *.t set filetype=perl
  autocmd BufNewFile,BufRead *.tt set filetype=tt2html.html.javascript.css
  autocmd BufNewFile,BufRead *.txt set filetype=help.text
  autocmd BufEnter * :syntax sync fromstart
augroup END

augroup vimrcEx
  autocmd!

  " Automatically rebalance windows on vim resize
  autocmd VimResized * :wincmd =

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
augroup END


" == Functions   {{{1
" ==================================================================================================

let g:test_method=""
function! RunTests(...)
  if &filetype == 'perl'
    let filename = expand('%:p:s?.*lib/??:r:gs?/?::?')
    let cmd = 'Make'
    if !empty(a:1) && a:1 == 'background'
      let cmd = 'Make!'
    endif
    if !empty(g:test_method)
      echom 'Testing ' . filename . '::' . g:test_method
      execute ':' . cmd . ' test TEST=' . filename . ' METHOD=' . g:test_method
    else
      echom 'Testing ' . filename
      execute ':' . cmd . ' test TEST=' . filename
    endif
  else
    echom 'Tests not set up for ' . &filetype 'files'
  endif
endfunction
function! RunCover()
  if &filetype == 'perl'
    execute 'let $HARNESS_PERL_SWITCHES="-MDevel::Cover"'
    call RunTests('background')
  else
    echom 'Coverage not set up for ' . &filetype 'files'
  endif
endfunction
function! SetTestMethod()
  let b:test_method=tagbar#currenttag("%s","")
  if !empty(b:test_method)
    echom 'Test Method set to ' . b:test_method
  else
    echom 'Test Method cleared'
  endif
endfunction
function! ClearTestMethod()
  let b:test_method=""
  echom 'Test Method cleared'
endfunction


" == Plugin Settings   {{{1
" ==================================================================================================

" Load up all of our plugins using vim-plug
if filereadable(expand("~/.vim/plugins.vim"))
  source ~/.vim/plugins.vim
endif

let g:solarized_termtrans=1
colorscheme solarized

let g:EasyClipShareYanks=1    " Share yanks across all vim sessions
let g:EasyClipAlwaysMoveCursorToEndOfPaste=1    " Affects multi-line pastes
" Override find and use ag instead which will honor .gitignore and only search text files
if executable('ag')
  let $FZF_DEFAULT_COMMAND='ag --hidden -g ""'
endif
let g:fzf_buffers_jump=1          " Jump to existing window if possible
let g:fzf_commits_log_options='--graph --pretty=format:"%C(yellow)%h (%p) %ai%Cred%d %Creset%Cblue[%ae]%Creset %s (%ar). %b %N"'
let g:fzf_source='find * -name .git -prune -o -name AppData -prune -o -type f -print -o -type d -print -o -type l -print'
let g:session_autoload='no'       " Loads 'default' session when vim is opened without files
let g:session_autosave='yes'
let g:session_autosave_periodic=3 " Automatically save the current session every 3 minutes
let g:session_autosave_silent=1   " Silence any messages
let g:session_default_to_last=1   " Default opening the last used session
let g:SuperTabDefaultCompletionType="context"
let g:SuperTabLongestEnhanced=1
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=1
let g:syntastic_enable_perl_checker=1
let g:syntastic_error_symbol='❌'
let g:syntastic_javascript_checkers=['eslint', 'jshint']
" let g:syntastic_javascript_jshint_args='--config /Users/caeledh/.jshintrc'
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


" == Mappings   {{{1
" ==================================================================================================

" -- Editing   {{{2
" --------------------------------------------------------------------------------------------------

" Use jk to get out of insert mode
inoremap jk <ESC>
nnoremap <leader>w :write<CR>
" Move current line down one
nnoremap J ddp
" Move current line up one
nnoremap K dd<up>P
" Use enter to create new lines w/o entering insert mode
nnoremap <CR> o<Esc>
augroup enter
  autocmd!
  " Below is to fix issues with the ABOVE mappings in quickfix window
  autocmd CmdwinEnter * nnoremap <CR> <CR>
  autocmd BufReadPost quickfix nnoremap <CR> <CR>
augroup END
" Stop highlight after searching
nnoremap <silent> <leader><CR> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
" Count the number of words in the current document
nnoremap <leader>cw :!wc -w %<CR>
" Remove trailing whitespace
nnoremap <leader>rs mz:silent! %s/\s\+$//<CR>:noh<CR>`z
" Replace tabs with spaces
nnoremap <leader>rt :%retab!<CR>
" Reindent entire file. NOTE: This may indent unexpectedly
nnoremap <leader>ri mzgg=G`z
vnoremap <buffer> <leader>f :!perltidy --quiet --standard-output --nostandard-error-output<CR>


" -- Movement   {{{2
" --------------------------------------------------------------------------------------------------

" Remap add mark, because vim-easyclip uses m as 'move'
nnoremap gm m
" Navigate properly when lines are wrapped
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk


" -- Plugins   {{{2
" --------------------------------------------------------------------------------------------------

let g:AutoPairsShortcutToggle='<C-\>'
let g:SuperTabMappingTabLiteral='<c-t>'
nnoremap <leader>cf <Plug>EasyClipToggleFormattedPaste
inoremap <C-p> <Plug>EasyClipInsertModePaste
nnoremap M <Plug>MoveMotionEndOfLinePlug
noremap <localleader>1 :NERDTreeToggle<CR>
noremap <localleader>2 :TagbarToggle<CR>
" Start interactive EasyAlign for a visual selection (e.g. vipga)
vmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" FZF Open various files
noremap <leader>B :Buffers<CR>
noremap <leader>F :Files<CR>
noremap <leader>S :Snippets<CR>
noremap <leader>H :History<CR>
noremap <leader>T :Tags<CR>
noremap <leader>P :IPaste<CR>
" Fugitive
nnoremap <leader>gst :Gstatus<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gpl :Gpull<CR>
nnoremap <leader>gm :Gmerge<space>
nnoremap <leader>gps :Gpush<CR>
nnoremap <leader>glg :Glog<CR>
nnoremap <leader>gb :Gblame<CR>
noremap <leader>sc :SyntasticCheck<CR>
if v:version >= 704 && has("python")
  noremap <leader>ep :UltiSnipsEdit<CR>
endif
noremap <leader>ME :MirrorEdit<space>
noremap <leader>MP :MirrorPush<space>
noremap <leader>ML :MirrorPull<space>


" -- System   {{{2
" --------------------------------------------------------------------------------------------------

noremap <leader>ev :vsplit $MYVIMRC<CR>
noremap <leader>m :Make!<CR>
noremap <leader>C :Dispatch! ctags -R<CR>:echom "Tags Generated"<CR>
noremap <leader>sm :call SetTestMethod()<CR>
noremap <leader>cm :call ClearTestMethod()<CR>
noremap <leader>sv :write<CR>:source $MYVIMRC<CR>:edit<CR>
noremap <leader>t :call RunTests("")<CR>
noremap <leader>ct :call RunCover()<CR>
noremap <leader>z <C-Z>

" -- Tab/Window Control   {{{2
" --------------------------------------------------------------------------------------------------

" Create and move between buffers
noremap <leader>n :enew<CR>
noremap <leader>h :bprevious<CR>
noremap <leader>l :bnext<CR>
noremap <leader>k :b #<CR>
nnoremap cd :exe 'lcd ' . fnamemodify(resolve(expand('%')), ':h')<CR>:echo 'cd ' . fnamemodify(resolve(expand('%')), ':h')<CR>
" Zoom a vim pane
nnoremap <leader>- :wincmd _<CR>:wincmd \|<CR>
nnoremap <leader>= :wincmd =<CR>
" Resize panes
nnoremap <silent> <Right> :vertical resize +5<CR>
nnoremap <silent> <Left> :vertical resize -5<CR>
nnoremap <silent> <Up> :resize +5<CR>
nnoremap <silent> <Down> :resize -5<CR>
noremap <leader>q :quit<CR>
noremap <leader>Q :qall<CR>
noremap <leader>x :x<CR>
noremap <leader>d :bdelete<CR>
" Disable EX mode
noremap Q <NOP>


" -- Syntax Highlighting   {{{1
" --------------------------------------------------------------------------------------------------

" These settings are for perl.vim syntax
let perl_include_pod=1    " Syntax highlight pod documentation correctly
let perl_extended_vars=1    " Syntax color complex things like @{${'foo'}}

highlight CursorLine ctermbg=017 ctermfg=None
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


" }}}

" vim:foldmethod=marker:foldlevel=0
