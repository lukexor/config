" == Vim Globals {{{1
" ==================================================================================================

" quickfix tips
" :make to check/compile error list
" :vimgrep /{pattern}/ {files} - useful for finding TODOs vimgrep /TODO/ **/
" :copen :cclose - quickfix window

" Global variables
let b:fsize=getfsize(@%)
let mapleader=' '
let maplocalleader=','


" == Plugins   {{{1
" ==================================================================================================

set nocompatible        " Disable VI backwards compatible settings. Must be first

call plug#begin('~/.vim/plugins')

" -- Editing   {{{2
" --------------------------------------------------------------------------------------------------

Plug 'bkad/CamelCaseMotion'          " Text objects for working inside CamelCase words
Plug 'junegunn/vim-easy-align'       " Makes aligning chunks of code super easy
Plug 'kshenoy/vim-signature'         " Adds vim marks to gutter
Plug 'dense-analysis/ale'            " Syntax Linting
Plug 'tmhedberg/matchit'             " Advanced % matching
Plug 'tommcdo/vim-exchange'          " Allows easy exchanging of text
Plug 'tpope/vim-commentary'          " Commenting quality of life improvements
Plug 'tpope/vim-endwise'             " Adds ending structures to blocks e.g. endif
Plug 'tpope/vim-surround'            " Enables surrounding text with quotes or brackets easier
Plug 'tpope/vim-unimpaired'          " Adds a lot of shortcuts complimentary pairs of mappings
" Plug 'jiangmiao/auto-pairs'          " Add/delete quotes, parens, etc, in pairs
Plug 'vim-scripts/YankRing.vim'      " Makes pasting previous yanks easier
Plug 'vim-scripts/argtextobj.vim'    " Select/Modify inner arguments inside parens or quotes
" Snippets engine + ultisnips
if has('python3')
  Plug 'honza/vim-snippets' |
      \ Plug 'SirVer/ultisnips'
endif

" -- File Navigation   {{{2
" --------------------------------------------------------------------------------------------------

Plug 'airblade/vim-rooter'      " Cd's to nearest git root
" Fuzzy-finder written in Go
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-ipmotion'                            " Improves { and } motions
Plug 'majutsushi/tagbar'                                " Displays tags in a sidebar
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }   " FileTree
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-fugitive'                               " Git integration

" -- Formatting/Display   {{{2
" --------------------------------------------------------------------------------------------------

Plug 'morhetz/gruvbox'                  " Colorscheme
Plug 'nelstrom/vim-markdown-folding'    " Folding for markdown by heading
Plug 'ap/vim-css-color'                 " Show Hex colors

" -- Utility/Support   {{{2
" --------------------------------------------------------------------------------------------------

Plug 'tpope/vim-dispatch'   " Allows building/testing to go on in the background
Plug 'tpope/vim-repeat'     " Repeat last command using .

" -- Language Support   {{{2
" --------------------------------------------------------------------------------------------------

Plug 'alvan/vim-closetag'               " Auto close XML/HTML tags
Plug 'rust-lang/rust.vim'               " Rustlang support
Plug 'leafgarland/typescript-vim'       " Typescript support
Plug 'pangloss/vim-javascript'          " Javascript support
Plug 'martinda/Jenkinsfile-vim-syntax'
if v:version >= 800
  Plug 'neoclide/coc.nvim', {'branch': 'release'} " Code completion
endif
Plug 'maxmellon/vim-jsx-pretty'
Plug 'peitalin/vim-jsx-typescript'

" -- Window Navigation   {{{2
" --------------------------------------------------------------------------------------------------

Plug 'christoomey/vim-tmux-navigator' " Easily jump between splits or tmux windows

call plug#end()

" -- Custom plugins   {{{2
" --------------------------------------------------------------------------------------------------

runtime custom_plugins/documap.vim
runtime custom_plugins/eqalignsimple.vim
runtime custom_plugins/foldsearches.vim
runtime custom_plugins/goto_file.vim
runtime custom_plugins/schlepp.vim


" == Vim Settings   {{{1
" ==================================================================================================

set modelines=1                  " Set's the number of lines to read for vim filetype mode formattinm
if exists('+antialias')
    set antialias                " Mac OS X: antialiased fonts
endif
set autoindent                   " Copy indent from current line when adding a new line
set autoread                     " Read file when changed outside vim
set autowriteall                 " Automatically write file changes
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_invert_selection = 0
colorscheme gruvbox
set background=dark
if &term =~ '256color'
    " Disable Background Color Erase (BCE) so that color schemes
    " work properly when Vim is used inside tmux and GNU screen.
    set t_ut=
endif
set backspace=indent,eol,start
" Set directory to store backup files in.
" These are created when saving, and deleted after successfully written
set backupdir=/tmp//
if v:version >= 704
    set breakindent                  " Wrapped line repeats indent
endif
set directory=/tmp//
set complete+=kspell             " Use the active spell checking
set complete+=k                  " Add dictionary to ins-complete
set shortmess+=c                 " Don't pass messages to |ins-completion-menu|.
set completeopt+=longest,menu,preview
set confirm                      " Ask about unsaved/read-only files
set copyindent
" Disable vertical color column for large files
if b:fsize <= 1000000
    set cursorline  " Highlight the cursorline - slows redraw
    if exists('+signcolumn')
        set signcolumn=yes
    endif
    if exists('+colorcolumn')
        set colorcolumn=80,100
    endif
endif
set cpoptions+=W                 " Don't overwrite readonly files with :w!
set cpoptions-=aA                " Don't set alternate file # on :read or :write
set display+=lastline
set encoding=utf-8
set expandtab                    " Replace the tab key with spaces
set fileencoding=utf-8
set fileformat=unix
set fileformats=unix,dos,mac     " Default file types
set nofoldenable
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
if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep " Set grep to always print filename headers
  set grepformat=%f:%l:%c:%m
endif
set hidden                       " Hide buffers instead of closing them
set history=1000                 " Save the last # commands
set hlsearch                     " Highlight all search matches
set incsearch                    " Highlight incrementally
set ignorecase                   " Case insensitive searching (unless specified)
set infercase
set laststatus=1
set lazyredraw                   " Don't redraw screen during macros or commands
set linebreak                    " Wrap long lines at a character in breakat
set list                         " Enable visibility of unprintable chars
exec "set listchars=tab:\\|\\ ,trail:-,extends:»,precedes:«,nbsp:~"

" Set < and > as brackets for jumping with %
set matchpairs+=<:>
set noerrorbells                 " No sound on errors
set noequalalways                " Don't make windows equal size
set nowrap                       " Default line wrap
set number
if exists('+relativenumber')
    set relativenumber           " Toggle relative line numbering
endif

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
set ruler
set sessionoptions-=help,options " Don't save help windows
set scrolloff=15                 " Start scrolling when we're # lines away from margins
if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
    set shell=/bin/bash
endif

set shiftround                   " Round to nearest multiple of shiftwidth
set shiftwidth=2                 " The amount of space to shift when using >>, << or <tab>
set showcmd                      " Display incomplete command
set cmdheight=2
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
set statusline=%n:\            " uffer number
set statusline+=%.40F\         " Full filename truncated
set statusline+=%m             " Modified
set statusline+=%r             " Readonly
set statusline+=%{tagbar#currenttag('[%s]\ ','','')}
set statusline+=%=             " Left/Right seperator
set statusline+=%y\            " Filetype
set statusline+=%l/%L          " Current/Total lines
set statusline+=\:%c           " Cursor position
set statusline+=\ %p%%         " Percent through file
set tags=./tags,tags
set nocst                      " Disable cscope - it messes with local tag lookups, might be useful
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
set updatetime=300               " How often to write to the swap file when nothing is pressed
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
set wrapmargin=2                 " Number of chars from the right before wrapping
set diffopt=filler,iblank,iwhiteall,vertical
if v:version >= 802
  set diffopt+=algorithm:patience,indent-heuristic
endif


" == Abbreviations   {{{1
" ==================================================================================================

iabbrev ,, =>
iabbrev eml lukexor@gmail.com
iabbrev Pelr Perl
iabbrev pelr perl
iabbrev adn and
iabbrev cpy Copyright Lucas Petherbridge, All Rights Reserved.
iabbrev liek like
iabbrev liekwise likewise
iabbrev pritn print
iabbrev retrun return
iabbrev teh the
iabbrev tehn then
iabbrev waht what


" == Functions   {{{1
" ==================================================================================================

" returns true iff is NERDTree open/active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

function! OpenNERDTree()
    let file_count = len(split(globpath('.', '*'), '\n'))
    let node = expand('%:p') =~ 'node_modules'
    if file_count < 50 && !node
      execute ':NERDTree | setlocal nornu nonu nolist signcolumn=no | wincmd p | call NERDTreeSync()'
    endif
endfunction

" calls NERDTreeFind iff NERDTree is active, current window contains a modifiable file, and we're not in vimdiff
function! NERDTreeSync()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

function! CloseBuffer()
    if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1
        execute ':bn|bd #'
    else
        execute ':e ' . getcwd() . '|bd #'
    endif
endfunction
function! CloseAllBuffersButCurrent()
  let curr = bufnr("%")
  let last = bufnr("$")

  if curr > 1    | silent! execute "1,".(curr-1)."bd"     | endif
  if curr < last | silent! execute (curr+1).",".last."bd" | endif
endfunction

" Sets g:pUnable to determine the projectroject_dir to the cwd on vim startup. The function will only set it
" if not already defined and then changes the local cwd to the current file
" location
function! SetProjectDir()
    if empty("g:project_dir")
        let g:project_dir = getcwd()
    endif
    exe 'lcd ' . fnamemodify(resolve(expand('%')), ':h')
endfunction

" Not the same as :retab
" This replaces spaces for the current tabstop with literal tabs
command! RetabIndents call RetabIndents()
func! RetabIndents()
    " let saved_view = winsaveview()
    " execute '%s@^\(\ \{'.&ts.'\}\)\+@\=repeat("\t", len(submatch(0))/'.&ts.')@e'
    " call winrestview(saved_view)
    :set ts=8 noet | retab! | set et ts=4 | retab
endfunc

" When autocompleting within an identifier, prevent duplications...
" Only available in vim >= 800
function! Undouble_Completions()
    let col  = getpos('.')[2]
    let line = getline('.')
    call setline('.', substitute(line, '\(\k\+\)\%'.col.'c\zs\1', '', ''))
endfunction

" Ability to toggle certain characters as keywords for operations like
" ciw, diw, etc
function! ToggleIskeyword(char)
    if !empty(matchstr(&iskeyword, ',\' . a:char))
    echom "Removed " . a:char
    execute "setlocal iskeyword-=" . a:char
    else
    echom "Added " . a:char
    execute "setlocal iskeyword+=" . a:char
    endif
endfunction

function! ToggleGutter()
  if g:show_gutter
    execute "set nornu nonu nolist signcolumn=no"
    let g:show_gutter = 0
  else
    execute "set rnu nu list signcolumn=yes"
    let g:show_gutter = 1
  endif
endfunction

" Simple confirmation helper
function! AskQuit (msg, options, quit_option)
    if confirm(a:msg, a:options) == a:quit_option
        exit
    endif
endfunction

" Used by the AutoMkdir autocmd when creating a new file to prompt to
" auto-create recursive directories as needed
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

" Helper to generate tag files in the background
function! GenerateCtags()
    execute ":Dispatch! ctags -I ~/.ctags --file-scope=no -R"
endfunction

" Highlights search matches and flashes
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

function! ClosePair()
    let line = getline('.')
    let col = col('.')
    let nextc3 = line[col+1]
    let nextc2 = line[col]
    let nextc1 = line[col-1]
    let prevc1 = line[col-2]
    let prevc2 = line[col-3]
    let prevc3 = line[col-4]
    let match = { '(':')', '{':'}', '[':']', '<':'>', '`':'`' }
    let str = ""
    let mov = ""
    if has_key(match, prevc1) && nextc1 == match[prevc1]
        return "  \<left>"
    endif
    if has_key(match, prevc2) && nextc2 == match[prevc2] && prevc1 == " "
        if has_key(match, prevc3) && nextc3 == match[prevc3]
            return "\<backspace>\<CR>\<Esc>0dt" . nextc2 . "i\<CR>\<Esc>0dt" . nextc2 . "i\<up>\<tab>"
        else
            return "\<backspace>\<CR>\<CR>\<up>\<tab>"
        endif
    endif
    if prevc1 =~ "[({\[<`]" && has_key(match, prevc1) && nextc1 != match[prevc1]
        let str = str . match[prevc1]
        let mov = mov . "\<left>"
    endif
    if prevc2 =~ "[({\[<`]" && has_key(match, prevc2) && nextc2 != match[prevc2]
        if prevc1 == " "
            let str = str . " "
            let mov = mov . "\<left>"
        endif
        if prevc3 =~ "[({\[<`]"
            let str = str . match[prevc2] . match[prevc3]
            let mov = mov . "\<left>\<left>"
        else
            let str = str . match[prevc2]
            let mov = mov . "\<left>"
        endif
    endif
    if !empty(str)
        return str . mov
    else
        return <tab>
    endif
endfunction


" == Autocommands   {{{1
" ==================================================================================================

if v:version >= 800
    augroup UndoubleCompletions
        autocmd!
        autocmd CompleteDone *  call Undouble_Completions()
    augroup END
endif

" augroup NoSimultaneousEdits
"     autocmd!
"     autocmd SwapExists * let v:swapchoice = 'o'
"     autocmd SwapExists * echom 'Duplicate edit session (readonly)'
"     autocmd SwapExists * sleep 1
" augroup END

augroup FiletypeFormats
    autocmd!
    autocmd BufRead            *.orig, *.bak setlocal readonly
    autocmd BufNewFile,BufRead *.apxc setlocal filetype=java
    autocmd BufNewFile,BufRead *.conf setlocal filetype=yaml formatprg=prettier\ --parser\ yaml
    autocmd BufNewFile,BufRead *.md   setlocal filetype=markdown.help.text formatprg=prettier\ --parser\ markdown
    autocmd BufNewFile,BufRead *.t    setlocal filetype=perl
    autocmd BufNewFile,BufRead *.tsx  setlocal filetype=typescript.tsx.html formatprg=prettier\ --parser\ typescript
    autocmd BufNewFile,BufRead *.jsx  setlocal filetype=javascript.jsx.html formatprg=prettier\ --parser\ babel
    autocmd BufNewFile,BufRead *.js   setlocal filetype=javascript.html formatprg=prettier\ --parser\ babel
    " Default headers to C files since it's more likely
    autocmd BufNewFile,BufRead *.h    setlocal filetype=c
    autocmd BufNewFile,BufRead *.txt  setlocal filetype=text
    autocmd BufNewFile,BufRead * if !&modifiable | setlocal nolist nospell | endif
    autocmd BufNewFile,BufRead * call camelcasemotion#CreateMotionMappings('<localleader>')

    autocmd FileType javascript setlocal foldmethod=syntax
    autocmd FileType html setlocal foldmethod=indent
augroup END

augroup FiletypeShortcuts
    autocmd!

    autocmd FileType *                     Nnoremap <leader>F [Prettify File] mzgggqG`z
    " Formatting
    autocmd FileType rust                  Nnoremap <leader>F [RustFmt] :RustFmt<CR>
    autocmd FileType rust                  Vnoremap <leader>F [RustFmtRange] :RustFmtRange<CR>
    autocmd FileType rust                  Nnoremap <leader>rf [Toggle RustFmt on save] :let g:rustfmt_autosave = !g:rustfmt_autosave<CR>:echo "Set RustFmt to " . g:rustfmt_autosave<CR>
    autocmd FileType javascript            setlocal formatprg=prettier\ --parser\ babel
    autocmd FileType typescript            setlocal formatprg=prettier\ --parser\ typescript
    autocmd FileType html                  setlocal formatprg=prettier\ --parser\ html
    autocmd FileType css,scss              setlocal formatprg=prettier\ --parser\ css
    autocmd FileType json                  setlocal formatprg=prettier\ --parser\ json
    autocmd FileType gql                   setlocal formatprg=prettier\ --parser\ graphql
    autocmd FileType md                    setlocal formatprg=prettier\ --parser\ markdown
    autocmd FileType yaml,yml              setlocal formatprg=prettier\ --parser\ yaml

    " Compiling
    if filereadable("./makefile")
        autocmd FileType *                 Nnoremap <leader>m [Run Make] :Make<CR>
    elseif filereadable("./package.json")
        autocmd FileType typescript        Nnoremap <leader>m [Yarn Build] :Start yarn build<CR>
    endif
    autocmd FileType rust                  Nnoremap <leader>m [Cargo Build] :Start cargo build<CR>
    autocmd FileType kotlin                Nnoremap <leader>m [Kotlin Build] :echo 'Unimplemented Kotlin build'<CR>

    " Testing
    autocmd FileType rust                  Nnoremap <leader>t [Cargo Test] :Start cargo test<CR>
    if filereadable("./package.json")
      if filereadable("./yarn.lock")
        autocmd FileType typescript        Nnoremap <leader>t [Yarn Test] :Start yarn test -- --browsers ChromeHeadless --watch=false<CR>
      else
        autocmd FileType typescript        Nnoremap <leader>t [Npm Lint] :Start npm run test<CR>
      endif
    endif

    " Linting
    autocmd FileType rust                  Nnoremap <leader>L [Cargo Check] :Start cargo check<CR>
    if filereadable("./package.json")
      if filereadable("./yarn.lock")
        autocmd FileType typescript        Nnoremap <leader>L [Yarn Lint] :Start yarn lint<CR>
      else
        autocmd FileType typescript        Nnoremap <leader>L [Npm Lint] :Start npm run lint<CR>
      endif
    endif
augroup END

augroup VimrcEx
    autocmd!

    " Automatically rebalance windows on vim resize
    autocmd VimResized * :wincmd =

    " Open NERDTree when starting up
    autocmd VimEnter * call OpenNERDTree()
    autocmd BufEnter * call NERDTreeSync()

    " Opens NERDTree when no files specified
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | setlocal nornu nonu nolist signcolumn=no | endif

    " Open NERDTree in a directory
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | setlocal nornu nonu nolist signcolumn=no | wincmd p | ene | exe 'cd '.argv()[0] | endif

    " Closes if NERDTree is the only open window
    autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

    " If more than one window and previous buffer was NERDTree, go back to it.
    autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
    let g:plug_window = 'noautocmd vertical topleft new'

    " Don't do it for commit messages, when the position is invalid, or when
    " When editing a file, always jump to the last known cursor position.
    " inside an event handler (happens when dropping a file on gvim).
    autocmd BufReadPost * if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

    " Save whenever switching windows or leaving vim. This is useful when running
    " the tests inside vim without having to save all files first.
    autocmd FocusLost,WinLeave * :silent! wa

    " Leave paste mode when leaving insert mode
    autocmd InsertLeave * set nopaste
augroup END

augroup AutoMkdir
    autocmd!
    autocmd BufNewFile * :call EnsureDirExists(expand("%:h"), 1)
    if has('persistent_undo')
        call EnsureDirExists(&undodir, 0)
        call EnsureDirExists(&backupdir, 0)
    endif
augroup END

" Below is to fix issues with the <CR> mapping to o<Esc> in quickfix window
augroup Enter
    autocmd!
    autocmd CmdwinEnter * nnoremap <CR> <CR>
    autocmd BufReadPost quickfix nnoremap <CR> <CR>
augroup END


" == Plugins   {{{1
" ==================================================================================================

let g:ale_linters = {
  \ 'go': ['gopls'],
  \ 'html': ['prettier'],
  \ 'javascript': ['prettier', 'eslint'],
  \ 'json': ['prettier'],
  \ 'typescript': ['prettier', 'tslint'],
  \ 'css': ['prettier'],
  \ 'scss': ['prettier'],
  \ 'rust': ['rls'],
  \ }
let g:ale_fixers = {
  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
  \ 'html': ['prettier'],
  \ 'javascript': ['prettier'],
  \ 'json': ['prettier'],
  \ 'typescript': ['prettier'],
  \ 'css': ['prettier'],
  \ 'scss': ['prettier'],
  \ }
let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 1
let g:ale_rust_rls_toolchain = 'stable'

let g:closetag_filetypes='xml,xhtml,javascript,javascript.jsx,typescript.tsx'
let g:closetag_xhtml_filetypes='xml,xhtml,javascript,javascript.jsx,typescript.tsx'

" C/C++/Objective-C - use https://clangd.github.io/
" Go - use https://github.com/golang/tools/tree/master/gopls
" Python - use https://github.com/pappasam/jedi-language-server
" Rust - use https://github.com/rust-lang/rls
" Vue - use https://github.com/vuejs/vetur
" \ 'coc-python',         " Python - use https://github.com/Microsoft/vscode-python
" \ 'coc-rust-analyzer',  " Rust - use https://github.com/rust-analyzer/rust-analyzer
let g:coc_global_extensions = [
  \ 'coc-angular',
  \ 'coc-clangd',
  \ 'coc-css',
  \ 'coc-eslint',
  \ 'coc-git',
  \ 'coc-go',
  \ 'coc-highlight',
  \ 'coc-html',
  \ 'coc-java',
  \ 'coc-jedi',
  \ 'coc-json',
  \ 'coc-lists',
  \ 'coc-markdownlint',
  \ 'coc-rls',
  \ 'coc-snippets',
  \ 'coc-sql',
  \ 'coc-tsserver',
  \ 'coc-vetur',
  \ 'coc-yaml',
  \ 'coc-yank'
  \ ]
let g:fzf_buffers_jump=1          " Jump to existing window if possible
let g:fzf_commits_log_options='--graph --pretty=format:"%C(yellow)%h (%p) %ai%Cred%d %Creset%Cblue[%ae]%Creset %s (%ar). %b %N"'
let g:fzf_layout = { 'down': '~20%' }
let g:NERDTreeWinSize = 35
let g:rustfmt_autosave = 1
let g:rustfmt_command = 'rustup run stable rustfmt'
let g:rust_use_custom_ctags_defs = 1
let g:snips_author = 'Lucas Petherbridge'
let g:show_gutter = 1
let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1
let g:tagbar_autoshowtag = 1
let g:tagbar_compact = 1
let g:tagbar_hide_nonpublic = 1
let g:tagbar_width = 35
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
let g:UltiSnipsExpandTrigger="<c-tab>"


" == Mappings   {{{1
" ==================================================================================================

" -- Undocumented   {{{2
" --------------------------------------------------------------------------------------------------

" Move up and down within wrapped paragraphs
nnoremap  j gj
nnoremap  k gk

" Highlight search matches forward and backward
nnoremap <silent> n n:call HLNext(0.3)<CR>
nnoremap <silent> N N:call HLNext(0.3)<CR>

" Swap visual and visual linewise shortcuts
vnoremap <C-V> v
vnoremap v <C-V>

" Blackhole replacements for x and d
nnoremap <silent> <localleader>d "_d
xnoremap <silent> <localleader>d "_d
nnoremap <silent> <localleader>dd "_dd
nnoremap <silent> <localleader>dD 0"_d$
nnoremap <silent> <localleader>D "_D
xnoremap <silent> <localleader>D "_D
nnoremap <silent> x "_x
xnoremap <silent> x "_x

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" This could be remapped by other vim plugin, try `:verbose imap <CR>`.
let g:endwise_no_mappings = v:true
let g:AutoPairsMapCR = v:false
if exists('*complete_info')
  inoremap <expr> <Plug>CustomCocCR complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <Plug>CustomCocCR pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif
imap <CR> <Plug>CustomCocCR<Plug>DiscretionaryEnd
" <Plug>AutoPairsReturn

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
nnoremap <leader>prn :CocSearch <C-R>=expand("<cword>")<CR><CR>

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

Doc <C-^> [Go to alternate file]

imap <C-j> <C-[>
imap <C-k> <C-[>
imap <C-c> <C-[>

" Helpful vim shortcuts
Doc <C-X><C-N> [Complete Word in File]

" -- Plugin Provided   {{{2
" --------------------------------------------------------------------------------------------------

Doc <localleader>w [{count} CamelCase words forward]
Doc <localleader>b [{count} CamelCase words backward]
Doc <localleader>e [Forward to the end of CamelCase word {count}]

" Search mappings
Nmap <leader><tab> [Search Normal Mappings] <Plug>(fzf-maps-n)
Xmap <leader><tab> [Search Visual Mappings] <Plug>(fzf-maps-x)
Omap <leader><tab> <Plug>(fzf-maps-o)

" Insert mode completion
Imap <c-x><c-k> [FZF Complete Word] <Plug>(fzf-complete-word)
Imap <c-x><c-f> [FZF Complete Path] <Plug>(fzf-complete-file-ag)
Imap <c-x><c-l> [FZF Complete Line] <Plug>(fzf-complete-line)

" -- Normal Mode   {{{2
" --------------------------------------------------------------------------------------------------

" These mappings need to be recursively defined
Nmap gA                          [Align with gA{motion}] <Plug>(EasyAlign)
Nmap <leader>"                   [Surround current word with double quotes] ysiw"
Nmap <leader>'                   [Surround current word with single quotes] ysiw'
Nmap <leader>(                   [Surround current word with parentheses with spaces] ysiw(
Nmap <leader>)                   [Surround current word with parentheses] ysiw)
Nmap <leader>>                   [Surround current word with angle brackets] ysiw>
Nmap <leader>[                   [Surround current word with square brackets with spaces] ysiw[
Nmap <leader>]                   [Surround current word with square brackets] ysiw]
Nmap <leader>`                   [Surround current word with tick quotes] ysiw`
Nmap <leader>{                   [Surround current word with curly braces with spaces] ysiw{
Nmap <leader>}                   [Surround current word with curly braces] ysiw}
Nmap <localleader>=              [Align paragraph with = sign] gaip=
Nmap <localleader>[              [Surround current paragraph with square brackets and indent] ysip[
Nmap <localleader>]              [Surround current paragraph with square brackets and indent] ysip]
Nmap <localleader>rh             [Remove surrounding {''}] ds'ds}
Nmap <localleader>sh             [Surround current word with {''}] ysiw}lysiw'
Nmap <localleader>{              [Surround current paragraph with curly braces and indent] ysip{
Nmap <localleader>}              [Surround current paragraph with curly braces and indent] ysip{
" Fix for syntax highlighting from above line }}

Nnoremap ]r                      [Go to next ALE warning] :ALENextWrap<CR>
Nnoremap [r                      [Go to prev ALE warning] :ALEPreviousWrap<CR>
Nnoremap H                       [Go to start of line] ^
Nnoremap L                       [Go to end of line] $
Nnoremap cY                      [Copy line to clipboard] "*yy
Nnoremap cP                      [Paste from clipboard] "*p
Nnoremap <F10>                   [Syntax ID Debug] :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
    \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
    \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
Nnoremap <CR>                    [Create new empty lines with Enter] o<Esc>
Nnoremap J                       [Move current line down one] ddp
Nnoremap K                       [Move current line up one] dd<up>P
Nnoremap Q                       [Disable EX mode] <NOP>
Nnoremap cdP                     [Change project directory to current file] :let g:project_dir = fnamemodify(resolve(expand('%')), ':h')<CR>:echo 'project_dir=' . fnamemodify(resolve(expand('%')), ':h')<CR>
Nnoremap cd                      [Change cwd to current file] :execute 'lcd' fnamemodify(resolve(expand('%')), ':h')<CR>:echo 'cd ' . fnamemodify(resolve(expand('%')), ':h')<CR>
Nnoremap <leader>-               [Maximize current window when in a vertial split] :wincmd _<CR>:wincmd \|<CR>
Nnoremap <leader>=               [Equalize vertical split window widths] :wincmd =<CR> Nnoremap <leader>C               [Regenerate ctags] :call GenerateCtags()<CR>:echom "Tags Generated"<CR>
Nnoremap <leader>D               [Close and delete the all but the current buffer] :call CloseAllBuffersButCurrent()<CR>
Nnoremap <leader>h               [Open previous buffer] :bprevious<CR>
Nnoremap <leader>l               [Open next buffer] :bnext<CR>
Nnoremap <leader>M               [Fuzy search marks] :Marks<CR>
Nnoremap <leader>Q               [Quit without saving] :qall!<CR>
Nnoremap <leader>R               [Fuzzy search Recent files] :History<CR>
Nnoremap <leader>S               [Shortcut for :%s///g] :%s///g<LEFT><LEFT><LEFT>
Nnoremap <leader>T               [Fuzzy search tags] :Tags<CR>
Nnoremap <leader>W               [Fuzzy search vim windows] :Windows<CR>
Nnoremap <leader>b               [Fuzzy search buffer list] :Buffers<CR>
Nnoremap <leader>cc              [Close Quickfix] :ccl<CR>
Nnoremap <leader>cm              [Clear currently set test method] :call ClearTestMethod()<CR>
Nnoremap <leader>cw              [Count number of words in the current file] :!wc -w %<CR>
Nnoremap <leader>d               [Close and delete the current buffer] :call CloseBuffer()<CR>
Nnoremap <leader>ev              [Edit vimrc in a vertical split] :vsplit $MYVIMRC<CR>
Nnoremap <leader>ep              [Edit Snippets] :UltiSnipsEdit<CR>
Nnoremap <leader>f               [Fuzzy search files in cwd] :FZF<CR>
Nnoremap <leader>g               [Fuzzy search git files] :GFiles<CR>
Nnoremap <leader>k               [Open last viewed buffer] <C-^>
Nnoremap <leader>n               [Edit a new, unnamed buffer] :enew<CR>
Nnoremap <leader>q               [Close the current window] :q<CR>
Nnoremap <leader>nr              [Reveal in NERDTree] :NERDTreeFind<CR>:wincmd p<CR>
Nnoremap <leader>rT              [Retab the entire file] :call RetabIndents()<CR>
Nnoremap <leader>rc              [Run code coverage] :call RunCover()<CR>
Nnoremap <leader>rg              [Search with Rg] :Rg<CR>
Nnoremap <leader>ri              [Reindent the entire file] mzgg=G`z
Nnoremap <leader>rs              [Remove trailing spaces in the entire file] mz:silent! %s/\s\+$//<CR>:noh<CR>`z
Nnoremap <leader>sm              [Set method under cursor to the current test method] :call SetTestMethod()<CR>
Nnoremap <leader>ss              [Toggle spellcheck] :set spell!<CR>
Nnoremap <leader>sv              [Reload vimrc] :source $MYVIMRC<CR>
Nnoremap <leader>tn              [Next Tag] :tnext<CR>
Nnoremap <leader>tp              [Previous Tag] :tprevious<CR>
Nnoremap <leader>w               [Save file changes] :write<CR>
Nnoremap <leader>x               [Write and quit current window] :x<CR>
Nnoremap <leader>z               [Background vim and return to shell] <C-Z>
Nnoremap <silent> <leader><CR>   [Clear search highlighting] :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
Nnoremap <localleader>1          [Toggle NERDTree Window] :NERDTreeToggle<CR>
Nnoremap <localleader>2          [Toggle Tagbar Window] :TagbarToggle<CR>
Nnoremap <localleader>3          [Toggle Gutter Columns] :call ToggleGutter()<CR>
Nnoremap <localleader>4          [Toggle Paste] :set paste!<CR>
Nnoremap <localleader>5          [Toggle Relative Lines] :set rnu!<CR>
Nnoremap <localleader>H          [Fuzzy search vim History] :History<CR>
Nnoremap <localleader>P          [Interactively paste by choosing from recent yanks] :IPaste<CR>
Nnoremap <localleader>Q          [Quit all windows without qall!<CR>
Nnoremap <localleader>n          [Go to next error]:cn<CR>
Nnoremap <localleader>p          [Go to previous error]:cp<CR>
Nnoremap <localleader>q          [Quit all windows] :qall<CR>
Nnoremap <silent> <expr> zu      [Fold Target] FS_FoldAroundTarget('^\s*use\s\+\S.*;',{'context':1})
Nnoremap <silent> <expr> zz      [Fold Search] FS_ToggleFoldAroundSearch({'context':1})
Nnoremap <silent> <Down>         [Decrease height of current window by 5] :resize -5<CR>
Nnoremap <silent> <Left>         [Decrease width of current window by 5] :vertical resize -5<CR>
Nnoremap <silent> <Right>        [Increase width of current window by 5] :vertical resize +5<CR>
Nnoremap <silent> <Up>           [Increase height of current window by 5] :resize +5<CR>
Nnoremap <silent> <localleader>$ [Toggle $ being considered part of a word] :call ToggleIskeyword('$')<CR>
Nnoremap <silent> <localleader>- [Toggle - being considered part of a word] :call ToggleIskeyword('-')<CR>
Nnoremap <silent> <localleader>. [Toggle . being considered part of a word] :call ToggleIskeyword('.')<CR>
Nnoremap <silent> <localleader>: [Toggle : being considered part of a word] :call ToggleIskeyword(':')<CR>
Nnoremap <silent> <localleader>_ [Toggle _ being considered part of a word] :call ToggleIskeyword('_')<CR>

" -- Visual & Select Mode   {{{2
" --------------------------------------------------------------------------------------------------

" These mappings need to be recursively defined
Vmap ga                      [Align columns in normal mode with ga{motion}] <Plug>(EasyAlign)
Vmap <C-D>                   [Duplicate block down] <Plug>SchleppDupDown
Vmap <C-L>                   [Duplicate block left] <Plug>SchleppDupLeft
Vmap <C-R>                   [Duplicate block right] <Plug>SchleppDupRight
Vmap <C-U>                   [Duplicate block up] <Plug>SchleppDupUp
Vmap <down>                  [Move block down] <Plug>SchleppDown
Vmap <left>                  [Move block left] <Plug>SchleppLeft
Vmap <right>                 [Move block right] <Plug>SchleppRight
Vmap <up>                    [Move block up] <Plug>SchleppUp
Vmap <leader>"               [Surround current word with double quotes] gS"
Vmap <leader>'               [Surround current word with single quotes] gS'
Vmap <leader>(               [Surround current word with parentheses with spaces] gS(
Vmap <leader>)               [Surround current word with parentheses] gS)
Vmap <leader><               [Surround current word with an HTML tag] gS<
Vmap <leader>>               [Surround current word with angle brackets] gS>
Vmap <leader>[               [Surround current word with square brackets with spaces] gS[
Vmap <leader>]               [Surround current word with square brackets] gS]
Vmap <leader>`               [Surround current word with single quotes] gS`
Vmap <leader>{               [Surround current word with curly braces with spaces] gS{
Vmap <leader>}               [Surround current word with curly braces] gS}

" -- Visual Mode   {{{2
" --------------------------------------------------------------------------------------------------

" These mappings need to be recursively defined
Xmap ga                      [Align columns in visual mode with v{motion}ga] <Plug>(EasyAlign)

" -- Operating-Pending Mode   {{{2
" --------------------------------------------------------------------------------------------------

" Shortcuts for ci, di, etc
onoremap ( i(
onoremap [ i[
onoremap { i{
onoremap ' i'
onoremap " i"

" Change up to the next return
onoremap r /return<CR>
" Change inside next parens
onoremap in( :<c-u>normal! f(vi(<cr>
" Change inside last parens
" onoremap il( :<c-u>normal! F)vi(<cr>
onoremap il( :<c-u>normal! F)vi(<cr>


" == Syntax Highlighting   {{{1
" ==================================================================================================

" Define a highlight for use in HLNext
hi! WhiteOnRed cterm=NONE ctermbg=red ctermfg=white
hi! Error cterm=NONE ctermbg=darkred ctermfg=white
hi! ErrorMsg cterm=NONE ctermbg=darkred ctermfg=white

" vim: foldmethod=marker foldlevel=0
