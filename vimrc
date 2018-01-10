" == Vim Settings   {{{1
" ==================================================================================================

let b:fsize=getfsize(@%)
let mapleader=' '
let maplocalleader=','

" Load up all of our plugins using vim-plug
if filereadable(expand("$HOME/.vim/plugins.vim"))
    source $HOME/.vim/plugins.vim
endif

" Custom plugins
runtime custom_plugins/documap.vim
runtime custom_plugins/eqalignsimple.vim
runtime custom_plugins/foldsearches.vim
runtime custom_plugins/goto_file.vim
runtime custom_plugins/schlepp.vim

" Any plugins should come after colorscheme if they override highlighting

set nocompatible                 " Disable VI backwards compatible settings. Must be first
set autochdir
set autoindent                   " Copy indent from current line when adding a new line
set autoread
set autowrite
set autowriteall                 " Automatically :write before running commands
set background=dark
colorscheme zhayedan
set backspace=indent,eol,start
" Set directory to store backup files in.
" These are created when saving, and deleted after successfully written

set backupdir=$HOME/.vim/tmp//
set directory=$HOME/.vim/tmp//
set clipboard=unnamed
set complete+=kspell
set completeopt+=longest,menu,preview
set copyindent
if b:fsize <= 1000000
    set cursorline  " Highlight the cursorline - slows redraw
    if v:version >= 704
            call matchadd('ColorColumn', '\%81v', 100)
    endif
endif
set cpoptions+=W                 " Don't overwrite readonly files with :w!
set diffopt+=vertical

" Set directory to store swap files in
set display+=lastline
set encoding=utf-8
set expandtab                  " Replace the tab key with spaces
set fileencoding=utf-8
set fileformat=unix
set fileformats=unix,dos,mac     " Default file types
set nofoldenable
set foldmethod=marker
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
exec "set listchars=tab:\\|\\ ,trail:-,extends:>,precedes:<,nbsp:~"

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
set scrolloff=15                 " Start scrolling when we're # lines away from margins
if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
    set shell=/bin/bash
endif

set shiftround                   " Round to nearest multiple of shiftwidth
set shiftwidth=4                 " The amount of space to shift when using >>, << or <tab>
set showcmd                      " Display incomplete command
set showmatch                    " Blink to a matching bracket if on screen
set showmode                     " Show current mode (INSERT, VISUAL)
set sidescrolloff=15             " Start side-scrolling when # characters away
set sidescroll=5                 " Scroll # column at a time
set smartcase                    " Ignores ignorecase when searching for upercase characters
if !exists("g:syntax_on")
    filetype plugin indent on
    syntax enable
endif
set nosmartindent
set smarttab
" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
if has('spell')
    set dictionary=$HOME/.vim/spell/en-basic.latin1.spl
    set spellfile=$HOME/.vim/spell/vim-spell.utf-8.add
    set spelllang=en
endif
set splitbelow                 " New horizontal splits should be below
set splitright                 " New vertical splits should be to the right
set statusline=%n:\            " Buffer number
set statusline+=%.40F\         " Full filename truncated
set statusline+=%m             " Modified
set statusline+=%r             " Readonly
set statusline+=%{tagbar#currenttag('[%s]\ ','','')}
set statusline+=%=             " Left/Right seperator
set statusline+=%y\            " Filetype
set statusline+=%l/%L          " Current/Total lines
set statusline+=\:%c           " Cursor position
set statusline+=\ %p%%         " Percent through file
set tags=./tags,tags,$HOME/lib/tags
if v:version > 704
    set tagcase=match
endif
set nocst  " Disable cscope - it messes with local tag lookups, might be useful
           " if I ever do a lot of C programming
set term=xterm-256color
set title
set titleold=''
set textwidth=80                 " Max width for text on the screen
set ttimeout                     " Timeout on :mappings and key codes
set ttimeoutlen=300              " Change timeout length
set ttyfast                      " Smoother redraw
if has('persistent_undo')
    set undolevels=5000              " How many undos
    set undodir=$HOME/.vim/undodir
    set undofile
endif
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

if v:version >= 800
    augroup Undouble_Completions
        autocmd!
        autocmd CompleteDone *  call Undouble_Completions()
    augroup None
endif
" augroup NoSimultaneousEdits
"     autocmd!
"     autocmd SwapExists * let v:swapchoice = 'o'
"     autocmd SwapExists * echom 'Duplicate edit session (readonly)'
"     autocmd SwapExists * sleep 2
" augroup END
augroup filetype_formats
    autocmd!
    " Make sure the syntax is always right, even when in the middle of
    " a huge javascript inside an html file.
    autocmd BufNewFile,BufRead *.conf set filetype=yaml
    autocmd BufNewFile,BufRead *.md   set filetype=markdown.help.text
    autocmd BufNewFile,BufRead *.t    set filetype=perl
    autocmd BufNewFile,BufRead *.tt   set filetype=tt2html.html.javascript.css
    autocmd BufNewFile,BufRead *.txt  set filetype=text
    autocmd BufNewFile,BufRead * if !&modifiable | setlocal nolist nospell | endif
    autocmd BufNewFile,BufRead * call camelcasemotion#CreateMotionMappings('<localleader>')
augroup END
augroup vimrcEx
    autocmd!

    " Automatically rebalance windows on vim resize
    autocmd VimResized * :wincmd =

    " Don't do it for commit messages, when the position is invalid, or when
    " When editing a file, always jump to the last known cursor position.
    " inside an event handler (happens when dropping a file on gvim).
    autocmd BufReadPost * if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

    " Closes if NERDTree is the only open window
    autocmd BufEnter * if winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary" | qall! | endif

    " Save whenever switching windows or leaving vim. This is useful when running
    " the tests inside vim without having to save all files first.
    autocmd FocusLost,WinLeave * :silent! wa

    " Change Color when entering Insert Mode
    autocmd InsertEnter * highlight CursorLine ctermfg=035

    " Revert Color to default when leaving Insert Mode
    autocmd InsertLeave * highlight CursorLine ctermbg=234
augroup END

" }}}
" == Functions   {{{1
" ==================================================================================================

let b:test_method=""
function! RunTests(...)
    if &filetype == 'perl'
        let filename = expand('%:p:s?.*lib/??:r:gs?/?::?')
        let cmd = 'Make'
        if !empty(a:1) && a:1 == 'background'
            let cmd = 'Make!'
        endif
        let test_method = get(b:, 'test_method', "")
        if !empty(test_method)
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

function! EnsureDirExists(dir, prompt)
    let required_dir = a:dir
    if !isdirectory(required_dir)
        if a:prompt
            call AskQuit("Parent directory '" . required_dir . "' doesn't exist.",
            \            "&Create it\nor &Quit?", 2)
        endif

        try
            call mkdir( required_dir, 'p' )
        catch
            call AskQuit("Can't create '" . required_dir . "'",
            \            "&Quit\nor &Continue anyway?", 1)
        endtry
    endif
endfunction

" After an alignable, align...
function! AlignOnPat(pat)
    return "\<ESC>:call EQAS_Align('nmap',{'pattern':'" . a:pat . "'})\<CR>A"
endfunction

function! GenerateCtags()
    let path = expand('%:p:h')
    execute ":Dispatch! cd " . expand('%:p:h') . "; ctags *"
endfunction

nnoremap <silent> n n:call HLNext(0.3)<CR>
nnoremap <silent> N N:call HLNext(0.3)<CR>

highlight! WhiteOnRed ctermbg=red ctermfg=white
function! HLNext(blinktime)
    let [bufname, lnum, col, off] = getpos('.')
    let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
    let target_pat = '\c\%#'.@/
    let blinks = 2
    for n in range(1,blinks)
        let red = matchadd('WhiteOnRed', target_pat, 101)
        redraw
        exec 'sleep ' . float2nr(a:blinktime / (2*blinks) * 1000) . 'm'
        call matchdelete(red)
        redraw
        exec 'sleep ' . float2nr(a:blinktime / (2*blinks) * 1000) . 'm'
    endfor
endfunction

augroup AutoMkdir
    autocmd!
    autocmd BufNewFile * :call EnsureDirExists(expand("%:h"), 1)
    if has('persistent_undo')
        call EnsureDirExists(&undodir, 0)
        call EnsureDirExists(&backupdir, 0)
    endif
augroup END

" == Plugins    {{{1
" ==================================================================================================

let g:EasyClipUseCutDefaults=0  " Don't add move shortcuts - conflicts with marks and vim-signature
let g:EasyClipEnableBlackHoleRedirectForDeleteOperator=0  " Keep delete functionality unchanged
let g:fzf_buffers_jump=1          " Jump to existing window if possible
let g:fzf_commits_log_options='--graph --pretty=format:"%C(yellow)%h (%p) %ai%Cred%d %Creset%Cblue[%ae]%Creset %s (%ar). %b %N"'
let g:gitgutter_sign_column_always=1
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
let g:tagbar_autoclose=1
let g:tagbar_autofocus=1
let g:tagbar_autoshowtag=1
let g:tagbar_compact=1
let g:tagbar_hide_nonpublic=1
let g:tagbar_width=40
let g:tagbar_type_perl = {
    \ 'kinds' : [
        \ 'i:includes:1:0',
        \ 'c:constants:0:0',
        \ 'o:ours:0:0',
        \ 'R:readonly:0:0',
        \ 'f:formats:0:0',
        \ 'a:attributes:0:1',
        \ 'x:attribute modifiers:0:1',
        \ 's:subroutines:0:1',
        \ 'p:packages:0:0',
    \ ],
\ }
" TODO: extend if needed
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds' : [
        \ 'p:package:0:1',
        \ 'f:function:0:1',
        \ 'v:variable:0:1',
        \ 'c:constant:0:0',
        \ 't:type:0:1',
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 'p' : 'package',
        \ 'f' : 'function',
        \ 'v' : 'variable',
        \ 'c' : 'constant',
        \ 't' : 'type',
    \ },
    \ 'scope2kind' : {
        \ 'package' : 'p',
        \ 'function' : 'f',
        \ 'variable' : 'v',
        \ 'constant' : 'c',
        \ 'type' : 't',
    \ },
\ }
let g:UltiSnipsEnableSnipMate = 0
let g:UltiSnipsSnippetsDir = '~/.vim/UltiSnips'


" == Mappings   {{{1
" ==================================================================================================

let g:AutoPairsShortcutToggle='<C-\>'

Doc <C-\> [Toggle AutoPairs]
Doc <localleader>w [{count} CamelCase words forward]
Doc <localleader>b [{count} CamelCase words backward]
Doc <localleader>e [Forward to the end of CamelCase word {count}]

Nmap      <leader>"             [Surround current word with double quotes] ysiw"
Nmap      <leader>'             [Surround current word with single quotes] ysiw'
Nmap      <leader>(             [Surround current word with parentheses with spaces] ysiw(
Nmap      <leader>)             [Surround current word with parentheses] ysiw)
Nmap      <leader><             [Surround current word with an HTML tag] ysiw<
Nmap      <leader>>             [Surround current word with angle brackets] ysiw>
Nmap      <leader>[             [Surround current word with square brackets with spaces] ysiw[
Nmap      <leader>]             [Surround current word with square brackets] ysiw]
Nmap      <leader>`             [Surround current word with tick quotes] ysiw`
Nmap      <leader>{             [Surround current word with curly braces with spaces] ysiw{
Nmap      <leader>}             [Surround current word with curly braces] ysiw}
Nmap      <localleader>=        [Align paragraph with = sign] gaip=
Nmap      <localleader>H        [Surround current word with {''}] ysiw}lysiw'
Nmap      <localleader>[        [Surround current paragraph with square brackets and indent] ysip[
Nmap      <localleader>]        [Surround current paragraph with square brackets and indent] ysip]
Nmap      <localleader>h        [Remove surrounding {''}] ds'ds}
Nmap      <localleader>{        [Surround current paragraph with curly braces and indent] ysip{
Nmap      <localleader>}        [Surround current paragraph with curly braces and indent] ysip{
Nmap      cP                    [Copy line to System clipboard] <Plug>SystemCopyLine
Nmap      ga                    [Align columns in normal mode with ga{motion}] <Plug>(EasyAlign)
Nnoremap  <CR>                  [Create new empty lines with Enter] o<Esc>
Nnoremap  <leader>-             [Maximize current window when in a vertial split] :wincmd _<CR>:wincmd \|<CR>
Nnoremap  <leader>=             [Equalize vertical split window widths] :wincmd =<CR>
Nnoremap  <leader>H             [Open previous tab] :tabp<CR>
Nnoremap  <leader>L             [Open next tab] :tabn<CR>
Nnoremap  <leader>M             [Fuzzy search vim Marks] :History<CR>
Nnoremap  <leader>P             [Interactively paste by choosing from recent yanks] :IPaste<CR>
Nnoremap  <leader>Q             [Quit without saving] :confirm qall<CR>
Nnoremap  <leader>R             [Fuzzy search Recent files] :History<CR>
Nnoremap  <leader>S             [Shortcut for :%s///g] :%s///g<LEFT><LEFT><LEFT>
Nnoremap  <leader>W             [Fuzzy search vim windows] :Windows<CR>
Nnoremap  <leader>b             [Fuzzy search buffer list] :Buffers<CR>
Nnoremap  <leader>C             [Regenerate ctags] :call GenerateCtags()<CR>:echom "Tags Generated"<CR>
Nnoremap  <leader>cm            [Clear currently set test method] :call ClearTestMethod()<CR>
Nnoremap  <leader>cw            [Count number of words in the current file] :!wc -w %<CR>
Nnoremap  <leader>d             [Close and delete the current buffer] :bd<CR>
Nnoremap  <leader>ep            [Edit vim plugins] :vsplit $HOME/.vim/plugins.vim<CR>
Nnoremap  <leader>ev            [Edit vimrc in a vertical split] :vsplit $MYVIMRC<CR>
Nnoremap  <leader>f             [Fuzzy search files in cwd] :Files<CR>
Nnoremap  <leader>ga            [Stage Git Hunk] :GitGutterStageHunk<CR>
Nnoremap  <leader>gb            [Fugitive git blame] :Gblame<CR>
Nnoremap  <leader>gc            [Fugitive git commit] :Gcommit<CR>
Nnoremap  <leader>gd            [Fugitive git diff] :Gdiff<CR>
Nnoremap  <leader>gg            [Toggle GitGutter] :GitGutterToggle<CR>
Nnoremap  <leader>gh            [Toggle GitGutter Line Highlighting] :GitGutterLineHighlightsToggle<CR>
Nnoremap  <leader>glg           [Fugitive git log] :Glog<CR>
Nnoremap  <leader>gm            [Fugitive git merge] :Gmerge<space>
Nnoremap  <leader>gn            [Next Git Hunk] :GitGutterNextHunk<CR>
Nnoremap  <leader>gp            [Previous Git Hunk] :GitGutterPrevHunk<CR>
Nnoremap  <leader>gpl           [Fugitive git pull] :Gpull<CR>
Nnoremap  <leader>gps           [Fugitive git push] :Gpush<CR>
Nnoremap  <leader>gst           [Fugitive git status] :Gstatus<CR>
Nnoremap  <leader>gu            [Undo Git Hunk] :GitGutterUndoHunk<CR>
Nnoremap  <leader>gv            [Preview Git Hunk] :GitGutterPreviewHunk<CR>
Nnoremap  <leader>h             [Open previous buffer] :bprevious<CR>
Nnoremap  <leader>k             [Open last viewed buffer] :b #<CR>
Nnoremap  <leader>l             [Open next buffer] :bnext<CR>
Nnoremap  <leader>m             [Fuzy search marks] :Marks<CR>
Nnoremap  <localleader>m        [Run make asynchronously] :Make!<CR>
Nnoremap  <leader>n             [Edit a new, unnamed buffer] :enew<CR>
Nnoremap  <leader>g             [Fuzzy search git files] :GFiles<CR>
Nnoremap  <leader>q             [Close the current window] :close<CR>
Nnoremap  ZZ                    [Close the current window] :close<CR>
Nnoremap  <leader>rc            [Run code coverage] :call RunCover()<CR>
Nnoremap  <leader>ri            [Reindent the entire file] mzgg=G`z
Nnoremap  <leader>rs            [Remove trailing spaces in the entire file] mz:silent! %s/\s\+$//<CR>:noh<CR>`z
Nnoremap  <leader>rt            [Run unit tests] :call RunTests("")<CR>
Nnoremap  <leader>rT            [Retab the entire file] :call RetabIndents()<CR>
Nnoremap  <leader>sc            [Run syntax checker] :SyntasticCheck<CR>
Nnoremap  <leader>sm            [Set method under cursor to the current test method] :call SetTestMethod()<CR>
Nnoremap  <leader>ss            [Toggle spellcheck] :set spell!<CR>
Nnoremap  <leader>sv            [Reload vimrc] :source $MYVIMRC<CR>
Nnoremap  <leader>t             [Fuzzy search tags] :Tags<CR>
Nnoremap  <leader>tn            [Next Tag] :tnext<CR>
Nnoremap  <leader>tp            [Previous Tag] :tprevious<CR>
Nnoremap  <leader>w             [Save file changes] :write<CR>
Nnoremap  <leader>x             [Write and quit current window] :x<CR>
Nnoremap  <leader>z             [Background vim and return to shell] <C-Z>
Nnoremap  <localleader>1        [Toggle NERDTree window] :NERDTreeToggle<CR>
Nnoremap  <localleader>2        [Toggle Tagbar window] :TagbarToggle<CR>
Nnoremap  <localleader>3        [Toggle Line Numbers] :set rnu! nu! list!<CR>
Nnoremap  <localleader>Q        [Quit all windows without qall!<CR>
Nnoremap  <localleader>ep       [Edit snippets in a horizontal split] :UltiSnipsEdit<CR>
Nnoremap  <localleader>q        [Quit all windows] :qall<CR>
Nnoremap  J                     [Move current line down one] ddp
Nnoremap  K                     [Move current line up one] dd<up>P
Nnoremap  Q                     [Disable EX mode] <NOP>
Nnoremap  cd                    [Change local cwd to current file location] :exe 'lcd ' . fnamemodify(resolve(expand('%')), ':h')<CR>:echo 'cd ' . fnamemodify(resolve(expand('%')), ':h')<CR>
Vmap      <C-D>                 [Move visual block left] <Plug>SchleppDupLeft
Vmap      <down>                [Move visual block down] <Plug>SchleppDown
Vmap      <leader>"             [Surround current word with double quotes] gS"
Vmap      <leader>'             [Surround current word with single quotes] gS'
Vmap      <leader>(             [Surround current word with parentheses with spaces] gS(
Vmap      <leader>)             [Surround current word with parentheses] gS)
Vmap      <leader><             [Surround current word with an HTML tag] gS<
Vmap      <leader>>             [Surround current word with angle brackets] gS>
Vmap      <leader>[             [Surround current word with square brackets with spaces] gS[
Vmap      <leader>]             [Surround current word with square brackets] gS]
Vmap      <leader>`             [Surround current word with single quotes] gS'
Vmap      <leader>{             [Surround current word with curly braces with spaces] gS{
Vmap      <leader>}             [Surround current word with curly braces] gS}
Vmap      <left>                [Move visual block left] <Plug>SchleppLeft
Vmap      <right>               [Move visual block right] <Plug>SchleppRight
Vmap      <up>                  [Move visual block up] <Plug>SchleppUp
Vmap      D                     [Move visual block left] <Plug>SchleppDupLeft
Vmap      ga                    [Align columns in normal mode with ga{motion}] <Plug>(EasyAlign)
Xmap      cp                    [Visual copy to System clipboard] <Plug>SystemCopy
Xmap      ga                    [Align columns in visual mode with v{motion}ga] <Plug>(EasyAlign)

Nnoremap <silent> <Down>         [Decrease height of current window by 5] :resize -5<CR>
Nnoremap <silent> <Left>         [Decrease width of current window by 5] :vertical resize -5<CR>
Nnoremap <silent> <Right>        [Increase width of current window by 5] :vertical resize +5<CR>
Nnoremap <silent> <Up>           [Increase height of current window by 5] :resize +5<CR>
Nnoremap <silent> <leader><CR>   [Clear search highlighting] :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
Nnoremap <silent> <localleader>- [Toggle - being considered part of a word] :call ToggleIskeyword('-')<CR>
Nnoremap <silent> <localleader>. [Toggle . being considered part of a word] :call ToggleIskeyword('.')<CR>
Nnoremap <silent> <localleader>_ [Toggle _ being considered part of a word] :call ToggleIskeyword('_')<CR>
Nnoremap <silent> <localleader>: [Toggle : being considered part of a word] :call ToggleIskeyword(':')<CR>
Nnoremap <silent> <localleader>$ [Toggle $ being considered part of a word] :call ToggleIskeyword('$')<CR>

" These don't need to be documented
nmap <silent> <expr>  zu  FS_FoldAroundTarget('^\s*use\s\+\S.*;',{'context':1})
nmap <silent> <expr>  zz  FS_ToggleFoldAroundSearch({'context':1})
noremap  j gj
noremap  k gk
vnoremap <C-V> v
vnoremap v <C-V>

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Advanced customization using autoload functions
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

nnoremap <silent> <localleader>d "_d
xnoremap <silent> <localleader>d "_d
nnoremap <silent> <localleader>dd "_dd
nnoremap <silent> <localleader>dD 0"_d$
nnoremap <silent> <localleader>D "_D
xnoremap <silent> <localleader>D "_D
nnoremap <silent> x "_x
xnoremap <silent> x "_x

" Below is to fix issues with the <CR> mapping to o<Esc> in quickfix window
augroup enter
    autocmd!
    autocmd CmdwinEnter * nnoremap <CR> <CR>
    autocmd BufReadPost quickfix nnoremap <CR> <CR>
augroup END

" -- Syntax Highlighting   {{{1
" --------------------------------------------------------------------------------------------------

highlight link SyntasticErrorSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn
highlight link SyntasticWarningSign SignColumn
" vim:foldmethod=marker:foldlevel=0
