" == Vim Settings   {{{1
" ==================================================================================================

let b:fsize=getfsize(@%)
let mapleader=' '
let maplocalleader=','

" Load up all of our plugins using vim-plug
if filereadable(expand("$HOME/.vim/plugins.vim"))
  source $HOME/.vim/plugins.vim
endif

" Any plugins should come after colorscheme if they override highlighting
let g:solarized_termtrans=1
silent! colorscheme zhayedan

set nocompatible                 " Disable VI backwards compatible settings. Must be first
set autoindent                   " Copy indent from current line when adding a new line
set autoread
set autowriteall                 " Automatically :write before running commands
set background=dark
set backspace=indent,eol,start
" Set directory to store backup files in.
" These are created when saving, and deleted after successfully written
" ^= prepends to the existing list
set backupdir^=$HOME/.vim/tmp//
set complete+=kspell
set completeopt+=longest,menu,preview
set copyindent
if b:fsize <= 1000000
  set cursorline                 " Highlight the cursorline - slows redraw
  if v:version >= 704
    call matchadd('ColorColumn', '\%102v', 100)
  endif
endif
set cpoptions+=W                 " Don't overwrite readonly files with :w!
set diffopt+=vertical

" Set directory to store swap files in
set directory^=$HOME/.vim/tmp//
set display+=lastline
set encoding=utf-8
set noexpandtab                  " Replace the tab key with spaces
filetype plugin indent on
set fileencoding=utf-8
set fileformat=unix
set fileformats=unix,dos,mac     " Default file types
set nofoldenable
set foldmethod=indent
set foldnestmax=2                " Deepest folds allowed for indent and syntax methods
set foldlevel=0
set foldlevelstart=0
" Set formatting options
" 1   Don't break after a one-letter word
" l   Don't format long lines in insert mode if it was longer than textwidth
"
" n   Regonized numbered lists and indent properly. autoindent must be set
" q   Allow using gq to format comments
" t   Auto-wrap using textwidth
" c   Auto-wrap comments using textwidth, auto-inserting comment leader
" r   Insert comment after hitting <Enter> in Insert mode
" o   Insert comment after hitting o or O in Normal mode
set formatoptions+=1
set formatoptions+=l
set formatoptions+=n
set formatoptions+=q
set formatoptions-=t
set formatoptions-=c
set formatoptions-=r
set formatoptions-=o
set gdefault                     " Never have to type /g at the end of search / replace again
set grepprg=grep\ -nH\ $*:       " Set grep to always print filename headers
set hidden                       " Hide buffers instead of closing them
set history=1000                 " Save the last # commands
set hlsearch                     " Highlight all search matches
set incsearch                    " Highlight incrementally
set ignorecase                   " Case insensitive searching (unless specified)
set infercase
set laststatus=2
set lazyredraw                   " Don't redraw screen during macros or commands
set linebreak                    " Wrap long lines at a character in breakat
set list                         " Enable visibility of unprintable chars
set listchars=tab:\|\ ,trail:-,extends:»,precedes:«,nbsp:~

" Set < and > as brackets for jumping with %
set matchpairs+=<:>
set noerrorbells                 " No sound on errors
set noequalalways                " Don't make windows equal size
set nomore
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
set scrolloff=2                  " Start scrolling when we're # lines away from margins
if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
  set shell=/bin/bash
endif
set shiftround                   " Round to nearest multiple of shiftwidth
" set shiftwidth=2                 " The amount of space to shift when using >>, << or <tab>
set showcmd                      " Display incomplete command
set showmatch                    " Blink to a matching bracket if on screen
set showmode                     " Show current mode (INSERT, VISUAL)
set sidescrolloff=15             " Start side-scrolling when # characters away
set sidescroll=5                 " Scroll # column at a time
set smartcase                    " Ignores ignorecase when searching for upercase characters
set smartindent
set smarttab
                                 " Set spellfile to location that is guaranteed to exist, can be symlinked to
                                 " Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
if has('spell')
  set spellfile=$HOME/.vim-spell.utf-8.add
  set spelllang=en
endif
set splitbelow                     " New horizontal splits should be below
set splitright                     " New vertical splits should be to the right
set statusline=%n:\                " Buffer number
set statusline+=%.30F\             " Full filename truncated to 20 chars
set statusline+=%m                 " Modified
set statusline+=%r                 " Readonly
set statusline+=%=                 " Left/Right seperator
set statusline+=[%{&formatoptions}]\ " Display keyword settings
set statusline+=%{&iskeyword}\     " Display keyword settings
set statusline+=%y\                " Filetype
set statusline+=%l/%L              " Current/Total lines
set statusline+=\:%c               " Cursor position
set statusline+=\ %p%%             " Percent through file
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif
if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif
set term=xterm-256color
set title
set titleold=''
set textwidth=80                 " Max width for text on the screen
set ttimeout                     " Timeout on :mappings and key codes
set ttimeoutlen=300              " Change timeout length
set ttyfast                      " Smoother redraw
set undolevels=5000              " How many undos
set updatetime=1000              " How often to write to the swap file when nothing is pressed
set updatecount=10               " Save every 10 characters typed

"           +--Disable hlsearch while loading viminfo
"           | +--Remember marks for last 500 files
"           | |     +--Enable captial marks
"           | |     |   +--Remember up to 10000 lines in each register
"           | |     |   |      +--Remember up to 1MB in each register
"           | |     |   |      |     +--Remember last 1000 search patterns
"           | |     |   |      |     |     +---Remember last 1000 commands
"           | |     |   |      |     |     |   +--Save/restore buffer list
"           v v     v   v      v     v     v   v  +-- Viminfo file
set viminfo=h,'500,f1,<10000,s1000,/1000,:1000,%,n$HOME/.viminfo
set visualbell                   " stop that ANNOYING beeping
set virtualedit=block            " Allow virtual block to put cursor where there's no actual text

" Keep undo history across sessions by storing in a file
if exists('&undofile')
  silent !mkdir $HOME/.vim/undodir > /dev/null 2>&1
  set undodir=$HOME/.vim/undodir
  set undofile
endif
" The below allows horizontal and vertical splits to be small and out of the way, giving the active
" window as much room as possible
set winheight=10                 " This has to be set to winminheight first in order to work
set winminheight=10              " Then set min height
set winheight=9999               " Then set win height to maximum possible
set winwidth=110                 " Keepjust  current window wide enough to see numbers textwidth=100
set wrapmargin=2                 " Number of chars from the right before wrapping

" == Abbreviations   {{{1
" ==================================================================================================

iabbrev ,, =>
iabbrev @@ lukexor@gmail.com
iabbrev Pelr Perl
iabbrev pelr perl
iabbrev adn and
iabbrev cright Copyright Lucas Petherbridge, All Rights Reserved.
iabbrev liek like
iabbrev liekwise likewise
iabbrev pritn print
iabbrev retrun return
iabbrev teh the
iabbrev tehn then
iabbrev waht what


" == Autocommands   {{{1
" ==================================================================================================

" Custom plugin to fold around searches
runtime custom_plugins/foldsearches.vim

if v:version >= 800
  augroup Undouble_Completions
      autocmd!
      autocmd CompleteDone *  call Undouble_Completions()
  augroup None
endif

augroup Perl_Setup
    autocmd!
    autocmd BufNewFile *.pl :0r $HOME/.vim/templates/perl/pl_script
    autocmd BufNewFile *.pm :0r $HOME/.vim/templates/perl/pm_module
    autocmd BufNewFile *.t :0r $HOME/.vim/templates/perl/test_class
augroup END

augroup filetype_formats
  autocmd!
  " Make sure the syntax is always right, even when in the middle of
  " a huge javascript inside an html file.
  autocmd BufNewFile,BufRead *.conf set filetype=yaml
  autocmd BufNewFile,BufRead *.md   set filetype=markdown.help.text
  autocmd BufNewFile,BufRead *.t    set filetype=perl
  autocmd BufNewFile,BufRead *.tt   set filetype=tt2html.html.javascript.css
  autocmd BufNewFile,BufRead *.txt  set filetype=text
  autocmd BufNewFile,BufRead *      if !&modifiable
  autocmd BufNewFile,BufRead *        setlocal nolist nospell
  autocmd BufNewFile,BufRead *      endif
  if exists("*camelcasemotion#CreateMotionMappings")
    autocmd BufNewFile,BufRead *      :call camelcasemotion#CreateMotionMappings('<localleader>')
  endif
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

" After an alignable, align...
function! AlignOnPat (pat)
    return "\<ESC>:call EQAS_Align('nmap',{'pattern':'" . a:pat . "'})\<CR>A"
endfunction

" }}}
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
    if !empty(b:test_method)
      echom 'Testing ' . filename . '::' . b:test_method
      execute ':' . cmd . ' testm TEST=' . filename . ' METHOD=' . b:test_method
    else
      echom 'Testing ' . filename
      execute ':' . cmd . ' testf TEST=' . filename
    endif
  else
    echom 'Tests not set up for ' . &filetype 'files'
  endif
endfunction

command! RetabIndents call RetabIndents()
func! RetabIndents()
    let saved_view = winsaveview()
    execute '%s@^\(\ \{'.&ts.'\}\)\+@\=repeat("\t", len(submatch(0))/'.&ts.')@e'
    call winrestview(saved_view)
endfunc

function! Undouble_Completions ()
    let col  = getpos('.')[2]
    let line = getline('.')
    call setline('.', substitute(line, '\(\k\+\)\%'.col.'c\zs\1', '', ''))
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

function! ToggleIskeyword(char)
  if !empty(matchstr(&iskeyword, ',\' . a:char))
    echom "Removed " . a:char
    execute "setlocal iskeyword-=" . a:char
  else
    echom "Added " . a:char
    execute "setlocal iskeyword+=" . a:char
  endif
endfunction
function! AskQuit (msg, options, quit_option)
    if confirm(a:msg, a:options) == a:quit_option
        exit
    endif
endfunction

function! EnsureDirExists ()
    let required_dir = expand("%:h")
    if !isdirectory(required_dir)
        call AskQuit("Parent directory '" . required_dir . "' doesn't exist.",
             \       "&Create it\nor &Quit?", 2)

        try
            call mkdir( required_dir, 'p' )
        catch
            call AskQuit("Can't create '" . required_dir . "'",
            \            "&Quit\nor &Continue anyway?", 1)
        endtry
    endif
endfunction

augroup AutoMkdir
    autocmd!
    autocmd  BufNewFile  *  :call EnsureDirExists()
augroup END

" == Plugins    {{{1
" ==================================================================================================

runtime custom_plugins/goto_file.vim
runtime custom_plugins/schlepp.vim
runtime custom_plugins/eqalignsimple.vim

let g:EasyClipShareYanks=1    " Share yanks across all vim sessions
let g:EasyClipAlwaysMoveCursorToEndOfPaste=1    " Affects multi-line pastes
" Override find and use ag instead which will honor .gitignore and only search text files
if executable('ag')
  let $FZF_DEFAULT_COMMAND='ag --hidden -g ""'
endif
let g:fzf_buffers_jump=1          " Jump to existing window if possible
let g:fzf_commits_log_options='--graph --pretty=format:"%C(yellow)%h (%p) %ai%Cred%d %Creset%Cblue[%ae]%Creset %s (%ar). %b %N"'
let g:fzf_source='find * -name .git -prune -o -name AppData -prune -o -type f -print -o -type d -print -o -type l -print'
let g:jsx_ext_required=1
let g:session_autoload='no'       " Loads 'default' session when vim is opened without files
let g:session_autosave='yes'
let g:session_autosave_periodic=3 " Automatically save the current session every 3 minutes
let g:session_autosave_silent=1   " Silence any messages
let g:session_default_to_last=1   " Default opening the last used session
let g:snips_author='Lucas Petherbridge'
let g:SuperTabDefaultCompletionType = "<c-x><c-n>"
let g:SuperTabNoCompleteAfter=['^',',','\s']
let g:SuperTabLongestEnhanced=1
let g:SuperTabCrMapping=1
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=1
let g:syntastic_error_symbol='❌'
let g:syntastic_javascript_checkers=['eslint', 'jshint']
let g:syntastic_loc_list_height=5
let g:syntastic_mode_map={ 'mode': 'passive' }
let g:syntastic_style_error_symbol='[]'
let g:syntastic_style_warning_symbol='??'
let g:syntastic_warning_symbol='^'
let g:tagbar_width=40

" == Mappings   {{{1
" ==================================================================================================

" Custom plugin for documenting mappings
runtime custom_plugins/documap.vim

let g:AutoPairsShortcutToggle='<C-\>'

Doc <C-\> [Toggle AutoPairs]
Doc <localleader>w [{count} CamelCase words forward]
Doc <localleader>b [{count} CamelCase words backward]
Doc <localleader>e [Forward to the end of CamelCase word {count}]

Nmap     <leader>"       [Surround current word with double quotes] ysiw"
Nmap     <leader>'       [Surround current word with single quotes] ysiw'
Nmap     <leader>(       [Surround current word with parentheses with spaces] ysiw(
Nmap     <leader>)       [Surround current word with parentheses] ysiw)
Nmap     <leader><       [Surround current word with an HTML tag] ysiw<
Nmap     <leader>>       [Surround current word with angle brackets] ysiw>
Nmap     <leader>[       [Surround current word with square brackets with spaces] ysiw[
Nmap     <leader>]       [Surround current word with square brackets] ysiw]
Nmap     <leader>`       [Surround current word with tick quotes] ysiw`
Nmap     <leader>{       [Surround current word with curly braces with spaces] ysiw{
Nmap     <leader>}       [Surround current word with curly braces] ysiw}
Nmap     <localleader>H  [Surround current word with {''}] ysiw}lysiw'
Nmap     <localleader>[  [Surround current paragraph with square brackets and indent] ysip[
Nmap     <localleader>]  [Surround current paragraph with square brackets and indent] ysip]
Nmap     <localleader>m  [Remove surrounding {''}] ds'ds}
Nmap     <localleader>{  [Surround current paragraph with curly braces and indent] ysip{
Nmap     <localleader>}  [Surround current paragraph with curly braces and indent] ysip{
Nmap     cP              [Copy line to System clipboard] <Plug>SystemCopyLine
Nmap     cp              [Copy to System clipboard] <Plug>SystemCopy
Nmap     cv              [Paste from System clipbpard] <Plug>SystemPaste
Nnoremap ;               [Faster command mode access] :
Nnoremap <CR>            [Create new empty lines with Enter] o<Esc>
Nnoremap <leader>-       [Maximize current window when in a vertial split] :wincmd _<CR>:wincmd \|<CR>
Nnoremap <leader>=       [Equalize vertical split window widths] :wincmd =<CR>
Nnoremap <leader>B       [Fuzzy search buffer list] :Buffers<CR>
Nnoremap <leader>C       [Regenerate ctags] :Dispatch! ctags -R<CR>:echom "Tags Generated"<CR>
Nnoremap <leader>F       [Fuzzy search files in cwd] :Files<CR>
Nnoremap <leader>H       [Fuzzy search recently opened files] :History<CR>
Nnoremap <leader>ME      [Edit remote copy of a file] :MirrorEdit<space>
Nnoremap <leader>ML      [Pull remote copy and replace local copy of a file] :MirrorPull<space>
Nnoremap <leader>MP      [Push local copy and replace remote copy of a file] :MirrorPush<space>
Nnoremap <leader>P       [Interactively paste by choosing from recent yanks] :IPaste<CR>
Nnoremap <leader>PU      [PlugUpdate and PlugUpgrade] :source $MYVIMRC<CR>:PlugUpdate<CR>:PlugUpgrade<CR>
Nnoremap <leader>Q       [Quit without saving] :q!<CR>
Nnoremap <leader>S       [Shortcut for :%s///g] :%s///g<LEFT><LEFT><LEFT>
Nnoremap <leader>T       [Fuzzy search tags for current file] :BTags<CR>
Nnoremap <leader>cm      [Clear currently set test method] :call ClearTestMethod()<CR>
Nnoremap <leader>ct      [Run code coverage] :call RunCover()<CR>
Nnoremap <leader>cw      [Count number of words in the current file] :!wc -w %<CR>
Nnoremap <leader>d       [Close and delete the current buffer] :bdelete<CR>
Nnoremap <leader>ep      [Edit vim plugins] :vsplit $HOME/.vim/plugins.vim<CR>
Nnoremap <leader>ev      [Edit vimrc in a vertical split] :vsplit $MYVIMRC<CR>
Nnoremap <leader>ga      [Stage Git Hunk] :GitGutterStageHunk<CR>
Nnoremap <leader>gb      [Fugitive git blame] :Gblame<CR>
Nnoremap <leader>gc      [Fugitive git commit] :Gcommit<CR>
Nnoremap <leader>gd      [Fugitive git diff] :Gdiff<CR>
Nnoremap <leader>gg      [Toggle GitGutter] :GitGutterToggle<CR>
Nnoremap <leader>gh      [Toggle GitGutter Line Highlighting] :GitGutterLineHighlightsToggle<CR>
Nnoremap <leader>glg     [Fugitive git log] :Glog<CR>
Nnoremap <leader>gm      [Fugitive git merge] :Gmerge<space>
Nnoremap <leader>gn      [Next Git Hunk] :GitGutterNextHunk<CR>
Nnoremap <leader>gp      [Previous Git Hunk] :GitGutterPrevHunk<CR>
Nnoremap <leader>gpl     [Fugitive git pull] :Gpull<CR>
Nnoremap <leader>gps     [Fugitive git push] :Gpush<CR>
Nnoremap <leader>gst     [Fugitive git status] :Gstatus<CR>
Nnoremap <leader>gu      [Undo Git Hunk] :GitGutterUndoHunk<CR>
Nnoremap <leader>gv      [Preview Git Hunk] :GitGutterPreviewHunk<CR>
Nnoremap <leader>h       [Open previous buffer in the buffer list] :bprevious<CR>
Nnoremap <leader>k       [Open last viewed buffer] :b #<CR>
Nnoremap <leader>l       [Open next buffer in the buffer list] :bnext<CR>
Nnoremap <leader>m       [Run make asynchronously] :Make!<CR>
Nnoremap <leader>n       [Edit a new, unnamed buffer] :enew<CR>
Nnoremap <leader>q       [Quit the current window] :quit<CR>
Nnoremap <leader>ri      [Reindent the entire file] mzgg=G`z
Nnoremap <leader>rs      [Remove trailing spaces in the entire file] mz:silent! %s/\s\+$//<CR>:noh<CR>`z
Nnoremap <leader>rt      [Retab the entire file] :%retab!<CR>
Nnoremap <leader>sc      [Run syntax checker] :SyntasticCheck<CR>
Nnoremap <leader>sm      [Set method under cursor to the current test method] :call SetTestMethod()<CR>
Nnoremap <leader>ss      [Toggle spellcheck] :set spell!<CR>
Nnoremap <leader>sv      [Reload vimrc] :source $MYVIMRC<CR>
Nnoremap <leader>t       [Run unit tests] :call RunTests("")<CR>
Nnoremap <leader>w       [Save file changes] :write<CR>
Nnoremap <leader>x       [Write and quit current window] :x<CR>
Nnoremap <leader>z       [Background vim and return to shell] <C-Z>
Nnoremap <localleader>1  [Toggle NERDTree window] :NERDTreeToggle<CR>
Nnoremap <localleader>2  [Toggle Tagbar window] :TagbarToggle<CR>
Nnoremap <localleader>Q  [Quit all windows without saving] :qall!<CR>
Nnoremap <localleader>ep [Edit snippets in a horizontal split] :SnipMateOpenSnippetFiles<CR>
Nnoremap <localleader>q  [Quit all windows] :qall<CR>
Nnoremap J               [Move current line down one] ddp
Nnoremap K               [Move current line up one] dd<up>P
Nnoremap Q               [Disable EX mode] <NOP>
Nnoremap cd              [Change cwd to current file location] :exe 'lcd ' . fnamemodify(resolve(expand('%')), ':h')<CR>:echo 'cd ' . fnamemodify(resolve(expand('%')), ':h')<CR>
Nnoremap gm              [Add a mark] m
Vmap     <leader>"       [Surround current word with double quotes] gS"
Vmap     <leader>'       [Surround current word with single quotes] gS'
Vmap     <leader>(       [Surround current word with parentheses with spaces] gS(
Vmap     <leader>)       [Surround current word with parentheses] gS)
Vmap     <leader><       [Surround current word with an HTML tag] gS<
Vmap     <leader>>       [Surround current word with angle brackets] gS>
Vmap     <leader>[       [Surround current word with square brackets with spaces] gS[
Vmap     <leader>]       [Surround current word with square brackets] gS]
Vmap     <leader>`       [Surround current word with single quotes] gS'
Vmap     <leader>{       [Surround current word with curly braces with spaces] gS{
Vmap     <leader>}       [Surround current word with curly braces] gS}
Vmap     ga              [Align columns in normal mode with ga{motion}] <Plug>(EasyAlign)
Vmap <C-D>               [Move visual block left] <Plug>SchleppDupLeft
Vmap <down>              [Move visual block down] <Plug>SchleppDown
Vmap <left>              [Move visual block left] <Plug>SchleppLeft
Vmap <right>             [Move visual block right] <Plug>SchleppRight
Vmap <up>                [Move visual block up] <Plug>SchleppUp
Vmap D                   [Move visual block left] <Plug>SchleppDupLeft
Xmap     cp              [Visual copy to System clipboard] <Plug>SystemCopy
Xmap     ga              [Align columns in visual mode with v{motion}ga] <Plug>(EasyAlign)

Nnoremap <silent> <Down>         [Decrease height of current window by 5] :resize -5<CR>
Nnoremap <silent> <Left>         [Decrease width of current window by 5] :vertical resize -5<CR>
Nnoremap <silent> <Right>        [Increase width of current window by 5] :vertical resize +5<CR>
Nnoremap <silent> <Up>           [Increase height of current window by 5] :resize +5<CR>
Nnoremap <silent> <leader><CR>   [Clear search highlighting] :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
Nnoremap <silent> <localleader>- [Toggle - being considered part of a word] :call ToggleIskeyword('-')<CR>
Nnoremap <silent> <localleader>_ [Toggle _ being considered part of a word] :call ToggleIskeyword('_')<CR>
Nnoremap <silent> <localleader>: [Toggle _ being considered part of a word] :call ToggleIskeyword(':')<CR>
Nnoremap <silent> <localleader>$ [Toggle _ being considered part of a word] :call ToggleIskeyword('$')<CR>

" These don't need to be documented
nmap <silent> <expr>  zu  FS_FoldAroundTarget('^\s*use\s\+\S.*;',{'context':1})
nmap <silent> <expr>  zz  FS_ToggleFoldAroundSearch({'context':1})
nnoremap <C-V> v
nnoremap v <C-V>
noremap  j gj
noremap  k gk
vnoremap <C-V> v
vnoremap v <C-V>

" Below is to fix issues with the <CR> mapping to o<Esc> in quickfix window
augroup enter
  autocmd!
  autocmd CmdwinEnter * nnoremap <CR> <CR>
  autocmd BufReadPost quickfix nnoremap <CR> <CR>
augroup END

" -- Syntax Highlighting   {{{1
" --------------------------------------------------------------------------------------------------

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
highlight clear Search
highlight       Search    ctermfg=white


" vim:foldmethod=marker:foldlevel=0
