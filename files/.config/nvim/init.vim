" == Quick Reference   {{{1
" ==================================================================================================

" -- Quickfix   {{{2
" --------------------------------------------------------------------------------------------------

" :make - to check/compile error list
" :vimgrep /{pattern}/ {files} - useful for finding TODOs vimgrep /TODO/ **/
" :copen :cclose - quickfix window

" == Globals   {{{1
" ==================================================================================================

let $PAGER=''
let mapleader=' '
let maplocalleader=','

let g:show_gutter = 1  " Used by ToggleGutter

set nocompatible  " Disable VI backwards compatible settings. Must be first
set shell=/bin/bash
let $SHELL="/bin/bash"

" == Plugins   {{{1
" ==================================================================================================

call plug#begin('~/.config/nvim/plugins')

" -- Enhancements   {{{2
" --------------------------------------------------------------------------------------------------

Plug 'ciaranm/securemodelines'                          " Secure version of modelines
Plug 'editorconfig/editorconfig-vim'                    " Loads .editorconfig
Plug 'justinmk/vim-sneak'                               " 's' motion to search, ';' next, ',' prev

" -- Navigation   {{{2
" --------------------------------------------------------------------------------------------------

Plug 'airblade/vim-rooter'                              " Cd's to nearest git root
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'                               " FileTree
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-fugitive'                               " Git integration
Plug 'christoomey/vim-tmux-navigator'                   " Easily jump between splits or tmux windows
Plug 'kshenoy/vim-signature'                            " Adds vim marks to gutter
Plug 'itchyny/lightline.vim'

" -- Editing   {{{2
" --------------------------------------------------------------------------------------------------

if v:version >= 800
  Plug 'SirVer/ultisnips'
endif
Plug 'alvan/vim-closetag'                               " Auto close XML/HTML tags
Plug 'godlygeek/tabular'                                " Align lines
Plug 'tpope/vim-surround'                               " Surround text easier
Plug 'tpope/vim-commentary'                             " Commenting quality of life improvements
Plug 'tpope/vim-endwise'                                " Adds endings to blocks e.g. endif
Plug 'tommcdo/vim-exchange'                             " Allows easy exchanging of text
Plug 'hrsh7th/nvim-compe'
Plug 'kosayoda/nvim-lightbulb'

" -- Language Syntax   {[{2
" --------------------------------------------------------------------------------------------------

Plug 'plasticboy/vim-markdown'
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'rust-lang/rust.vim'
Plug 'rhysd/vim-clang-format'
Plug 'leafgarland/typescript-vim'
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'peitalin/vim-jsx-typescript'
Plug 'udalov/kotlin-vim'
Plug 'gerw/vim-HiLinkTrace'
Plug 'neovim/nvim-lspconfig'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'sainnhe/gruvbox-material'
Plug 'nvim-lua/lsp_extensions.nvim'

" -- Utility/Support   {{{2
" --------------------------------------------------------------------------------------------------

Plug 'tpope/vim-dispatch'                                " Run tasks in the background
Plug 'tpope/vim-repeat'                                  " Repeat last command using '.'
Plug 'puremourning/vimspector'                           " Graphical debugger
Plug 'vim-test/vim-test'
Plug 'liuchengxu/vim-which-key'

" 2}}}

call plug#end()

" -- Lua   {{{2
" --------------------------------------------------------------------------------------------------

lua require("lsp")

" == Plugins Settings   {{{1
" ==================================================================================================

let g:fzf_buffers_jump = 1          " Jump to existing window if possible
let g:fzf_commits_log_options = '--graph --pretty=format:"%C(yellow)%h (%p) %ai%Cred%d %Creset%Cblue[%ae]%Creset %s (%ar). %b %N"'

let g:closetag_filetypes = 'xml,xhtml,javascript,javascript.jsx,typescript.tsx'
let g:closetag_xhtml_filetypes = 'xml,xhtml,javascript,javascript.jsx,typescript.tsx'

let g:snips_author = system('git config --get user.name | tr -d "\n"')
let g:snips_author_email = system('git config --get user.email | tr -d "\n"')

let g:lightline = {
  \ 'colorscheme': 'gruvbox_material',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'readonly', 'filename', 'modified', 'function' ] ],
  \   'right': [ [ 'lineinfo' ],
  \              [ 'percent' ],
  \              [ 'gitstatus', 'filetype' ],
  \              [ 'charvaluehex' ] ],
  \ },
  \ 'component_function': {
  \   'function': 'CurrentFunction',
  \   'filename': 'LightlineFilename',
  \   'gitstatus': 'FugitiveHead',
  \ },
\ }

let g:plug_window = 'noautocmd vertical topleft new'

let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0
let g:rustfmt_command = 'rustup run stable rustfmt'

let g:sneak#s_next = 1

let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_frontmatter = 1

let g:NERDTreeWinSize = 35

nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey ','<CR>

" -- Vimspector   {{{2
" --------------------------------------------------------------------------------------------------

let g:vimspector_enable_mappings = 'HUMAN'
let g:vimspector_install_gadgets = [ 'CodeLLDB', 'debugger-for-chrome', 'vscode-bash-debug' ]

" mnemonic 'di' = 'debug inspect'
nmap <leader>dd <Plug>VimspectorLaunch
nmap <leader>db <Plug>VimspectorToggleBreakpoint
nmap <leader>dc <Plug>VimspectorContinue
nmap <leader>dq <Plug>VimspectorStop
nmap <leader>dO <Plug>VimspectorStepOver
nmap <leader>dI <Plug>VimspectorStepInto
nmap <leader>dE <Plug>VimspectorStepOut
nmap <leader>dr <Plug>VimspectorRunToCursor
nmap <leader>dx :VimspectorReset<CR>
nmap <leader>de :VimspectorEval
nmap <leader>dw :VimspectorWatch
nmap <leader>do :VimspectorShowOutput
nmap <leader>di <Plug>VimspectorBalloonEval
xmap <leader>di <Plug>VimspectorBalloonEval

" == Mappings   {{{1
" ==================================================================================================

" -- Commands   {{{2
" --------------------------------------------------------------------------------------------------

" Make commands easier
nnoremap ; :

" -- Files   {{{2
" --------------------------------------------------------------------------------------------------

" FZF
map <C-p> :Files<CR>
map <C-g> :GFiles<CR>
nmap <leader>R :History<CR>

" Quick save
nmap <leader>w :w<CR>
nmap <leader>W :noa w<CR>
nmap <leader>x :x<CR>

" Config/Snippets
nmap <localleader>ev :vsplit $MYVIMRC<CR>
nmap <localleader>gc :Commits<CR>

" Fixes Ctrl-X Ctrl-K
" https://github.com/SirVer/ultisnips/blob/master/doc/UltiSnips.txt
inoremap <c-x><c-k> <c-x><c-k>

" New file
nmap <leader>n :enew<CR>
nmap <leader>q :q<CR>

nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <localleader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

" -- Navigation   {{{2
" --------------------------------------------------------------------------------------------------

" Jump to start and end of line using the home row keys
map H ^
map L $

nmap <localleader>M :Marks<CR>
nmap <localleader>T :Tags<CR>

" Move by line
nnoremap j gj
nnoremap k gk

" Toggles between buffers
nnoremap <leader><leader> <c-^>

" cd to cwd of current file
nnoremap cd :execute 'lcd ' fnamemodify(resolve(expand('%')), ':h')<CR>
  \ :echo 'cd ' . fnamemodify(resolve(expand('%')), ':h')<CR>

" Navigate buffers
nmap <leader>h :bp<CR>
nmap <leader>l :bn<CR>

" Navigate tags
nmap <localleader>tn :tnext<CR>
nmap <localleader>tp :tprevious<CR>

" Navigate errors
nnoremap <localleader>en :cnext<CR>
nnoremap <localleader>ep :cprevious<CR>

" -- Windows/Buffers   {{{2
" --------------------------------------------------------------------------------------------------

" Maximze window
nmap <leader>- :wincmd _<CR>:wincmd \|<CR>
" Equalize window sizes
nmap <leader>= :wincmd =<CR>

" Resize windows
nnoremap <silent> <Down> :resize -5<CR>
nnoremap <silent> <Left> :vertical resize -5<CR>
nnoremap <silent> <Right> :vertical resize +5<CR>
nnoremap <silent> <Up> :resize +5<CR>

nmap <leader>; :Buffers<CR>
nmap <leader>D :call CloseBuffer()<CR>
nmap <localleader>D :call CloseAllBuffersButCurrent()<CR>
nmap <leader>q :q<CR>
nmap <leader>Q :qall!<CR>

" -- Editing   {{{2
" --------------------------------------------------------------------------------------------------

" Deletes the current line and replaces it with the previously yanked value
nmap + V"0p

" Make Y act like D and C
nnoremap Y y$

" Join lines, but keep cursor position
nnoremap J mzJ`z

" Move selections up/down
" gv restores visual mode selection, = enures indent is honored
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Move line up/down
" == honors indent
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==

" Add breaks in undo chain when typing punctuation
inoremap . .<C-g>u
inoremap , ,<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u

" Add relative jumps of more than 5 lines to jump list
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'

vnoremap <C-j> <Esc>
snoremap <C-j> <Esc>
inoremap <C-j> <Esc>
xnoremap <C-j> <Esc>
cnoremap <C-j> <Esc>
onoremap <C-j> <Esc>
lnoremap <C-j> <Esc>
tnoremap <C-j> <Esc>

inoremap <C-c> <Esc>

" Blackhole replacements for x and d
nnoremap <silent> <localleader>d "_d
xnoremap <silent> <localleader>d "_d
nnoremap <silent> <localleader>dd "_dd
nnoremap <silent> <localleader>dD 0"_d$
nnoremap <silent> <localleader>D "_D
xnoremap <silent> <localleader>D "_D
nnoremap <silent> x "_x
xnoremap <silent> x "_x

" Swap visual and visual linewise shortcuts
vnoremap <C-V> v
vnoremap v <C-V>

" Paste from CLIPBOARD
inoremap <C-v> <c-r>+

" Surround text with punctuation easier 'you surround' + motion
nmap <leader>" ysiw"
nmap <leader>' ysiw'
nmap <leader>( ysiw(
nmap <leader>) ysiw)
nmap <leader>> ysiw>
nmap <leader>[ ysiw[
nmap <leader>] ysiw]
nmap <leader>` ysiw`
nmap <leader>{ ysiw{
nmap <leader>} ysiw}

" Same mappers for visual mode
vmap <leader>" gS"
vmap <leader>' gS'
vmap <leader>( gS(
vmap <leader>) gS)
vmap <leader>< gS<
vmap <leader>> gS>
vmap <leader>[ gS[
vmap <leader>] gS]
vmap <leader>` gS`
vmap <leader>{ gS{
vmap <leader>} gS}

nmap <localleader>[ ysip[
nmap <localleader>] ysip]
nmap <localleader>rh ds'ds}
nmap <localleader>sh ysiw}lysiw'
nmap <localleader>{ ysip{
nmap <localleader>} ysip{

" Clipboard
nnoremap cY "*yy
nnoremap cP "*p

" Disable EX mode
nnoremap Q <NOP>

" Close quickfix
nmap <leader>cc :ccl<CR>

" Reload Config
nmap <localleader>sv :source $MYVIMRC<CR>:e<CR>

" Change up to the next return
onoremap r /return<CR>
" Change inside next parens
onoremap in( :<c-u>normal! f(vi(<cr>
" Change inside last parens
onoremap il( :<c-u>normal! F)vi(<cr>
" Change inside next brace
onoremap in{ :<c-u>normal! f{vi{<cr>
" Change inside last brace
onoremap il{ :<c-u>normal! F{vi{<cr>
" Change inside next bracket
onoremap in[ :<c-u>normal! f[vi[<cr>
" Change inside last bracket
onoremap il[ :<c-u>normal! F[vi[<cr>

" Completion
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

" -- Status   {{{2
" --------------------------------------------------------------------------------------------------

" Toggle hidden characters
nmap <leader>, :set list<cr>

" Shows stats
nnoremap <localleader>q g<c-g>

nnoremap <F7> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
  \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
  \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

nnoremap <localleader>1 :call OpenNERDTree()<CR>
nnoremap <localleader>2 :TagbarToggle<CR>
nnoremap <localleader>3 :call ToggleGutter()<CR>
nnoremap <localleader>4 :set paste!<CR>
nnoremap <localleader>5 :set rnu!<CR>

" -- Search   {{{2
" --------------------------------------------------------------------------------------------------

" Keep cursor in the center when cycling through search
" zz centers curor, zv opens any folds
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <silent> * *zzzv
nnoremap <silent> # #zzzv
nnoremap <silent> g* g*zzzv
nnoremap <silent> g# g*zzzv

" Very magic by default
nnoremap ? ?\v
nnoremap / /\v
cnoremap %s/ %sm/

nmap <leader>s :Rg<cr>
nmap <leader>S :%s/

let g:endwise_no_mappings = v:true
let g:AutoPairsMapCR = v:false

" Clear search highlighting
nnoremap <leader><cr> :nohlsearch<cr>
vnoremap <leader><cr> :nohlsearch<cr>

" == Settings   {{{1
" ==================================================================================================

" -- Syntax/Highlighting   {{{2
" --------------------------------------------------------------------------------------------------

filetype plugin indent on       " Load plugins according to detected filetype
syntax on                       " Enable syntax highlighting

if has('termguicolors')
  set termguicolors
endif

set background=dark
let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_diagnostic_virtual_text = 'colored'
let g:gruvbox_material_better_performance = 1
colorscheme gruvbox-material

hi SpecialComment ctermfg=108 guifg=#89b482 guisp=#89b482

if &modifiable
  set fileformat=unix
endif
set breakindent                 " Wrapped lines indent are indented

set cursorline                  " Highlight the cursorline
set colorcolumn=80,100          " Highlight columns at 80 and 100
set synmaxcol=200               " Only highlight the first 200 columns

set list                        " Enable visibility of unprintable chars
if has('multi_byte') && &encoding ==# 'utf-8'
  exec "set listchars=tab:▸\\ ,extends:❯,precedes:❮,nbsp:±,trail:±"
else
  exec "set listchars=tab:>\\ ,extends:>,precedes:<,nbsp:.,trail:."
endif

" -- Editing   {{{2
" --------------------------------------------------------------------------------------------------

set autoindent                  " Copy indent from current line when starting a new line
set backspace=indent,eol,start  " Backspace over things
set textwidth=80                " Max width for text on the screen
set expandtab                   " Replace the tab key with spaces
set softtabstop=2               " Tab key indents by 4 spaces.
set shiftround                  " Round to nearest multiple of shiftwidth
set shiftwidth=2                " The amount of space to shift when using >>, << or <tab>
set smarttab                    " Tabs using shiftwidth
set nostartofline               " Keep same column for navigation

set autoread                    " Read file when changed outside vim
set foldmethod=indent           " Default folds to indent level
set foldlevelstart=99           " Default no closed

if &diff
  set diffopt+=iwhite             " No whitespace in vimdiff
  " Make diffing better: https://vimways.org/2018/the-power-of-diff/
  set diffopt+=algorithm:patience
  set diffopt+=indent-heuristic
endif

" Set < and > as brackets for jumping with %
set matchpairs+=<:>
if has('noesckeys')
  set noesckeys                   " Disable <Esc> keys in Insert mode
endif

set updatecount=50              " Save every # characters typed
set virtualedit=block           " Allow virtual block to put cursor where there's no actual text

nmap gT :call RunTest()<CR>

" formatoptions set as autocmd

" -- Status   {{{2
" --------------------------------------------------------------------------------------------------

set laststatus=2                " Always show statusline
set display=lastline            " Show as much as possible of the last line

set noshowmode                  " Disable INSERT display since lightline shows it
set showcmd                     " Show already typed keys when more are expected
set cmdheight=2                 " Set two lines for better messaging
set report=0                    " Always report changed lines

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=500

set nowrap                      " Don't wrap
set number                      " Display line numbers
set ruler                       " Show line/column number of cursor
set relativenumber              " Toggle relative line numbering
set signcolumn=yes

" -- Search/Completion   {{{2
" --------------------------------------------------------------------------------------------------

set hlsearch                    " Highlight all search matches
set incsearch                   " Highlight incrementally
" Search recursively when using gf, f, or find
set path+=**

set ignorecase                  " Case insensitive searching (unless specified)
set infercase                   " Infer case matching based on typed text
set smartcase                   " Ignores ignorecase when searching for upercase characters

set showmatch                   " Blink to a matching bracket if on screen

if executable('rg')
  " Set grep to always print filename headers
  set grepprg=rg\ --no-heading\ --vimgrep
  set grepformat=%f:%l:%c:%m
endif

set completeopt=menuone,noselect
set shortmess+=c                " Don't show |ins-completion-menu| messages
set wildmenu                    " Completion mode - match longest then next full match
set wildmode=list:longest,full

" -- Window   {{{2
" --------------------------------------------------------------------------------------------------

set title                       " Set window title to value of titlestring or filename
set noequalalways               " Don't make windows equal size automatically
set hidden                      " Keep open buffers

set scrolloff=15                " Start scrolling when we're # lines away from margins
set sidescrolloff=15            " Start side-scrolling when # characters away
set sidescroll=5                " Scroll # column at a time
set wrapmargin=2                " Number of chars from the right before wrapping

set splitbelow                  " New horizontal splits should be below
set splitright                  " New vertical splits should be to the right

set errorbells                  " Bell for error messages
set visualbell                  " Stop that ANNOYING beeping

set ttyfast
" https://github.com/vim/vim/issues/1735#issuecomment-383353563
set lazyredraw

" -- Files   {{{2
" --------------------------------------------------------------------------------------------------

" Store swp in global /tmp for easier cleanup
if !isdirectory("/tmp/vim/files")
  call mkdir("/tmp/vim/files/swap", "p")
  call mkdir("/tmp/vim/files/undo", "p")
  call mkdir("/tmp/vim/files/info", "p")
  call mkdir("/tmp/vim/files/spell", "p")
endif
set directory=/tmp/vim/files/swap//
set undolevels=5000
set undodir=/tmp/vim/files/undo/
set undofile
set nobackup
set nowritebackup

"           +--Disable hlsearch while loading viminfo
"           | +--Remember marks for last # files
"           | |     +--Enable captial marks
"           | |     |   +--Remember up to # lines in each register
"           | |     |   |      +--Remember up to #KB in each register
"           | |     |   |      |     +--Remember last # search patterns
"           | |     |   |      |     |     +---Remember last # commands
"           | |     |   |      |     |     |   +--Save/restore buffer list
"           v v     v   v      v     v     v   v  +-- Viminfo file
if !has('nvim')
  set viminfo=h,'100,f1,<10000,s1000,/1000,:1000,%,n/tmp/vim/files/info/viminfo
else
  set viminfo+=n/tmp/vim/files/info/viminfo
endif

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set dictionary=/tmp/vim/files/spell/en-basic.latin1.spl
set spellfile=/tmp/vim/files/spell/vim-spell.utf-8.add
set spelllang=en

" == Functions   {{{1
" ==================================================================================================

" returns true iff is NERDTree open/active
fun! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfun

fun! OpenNERDTree()
  if IsNERDTreeOpen()
    NERDTreeClose
  elseif filereadable(expand('%'))
      NERDTreeFind
  else
      NERDTree
  endif
endfun

" calls NERDTreeFind iff NERDTree is active, current window contains a modifiable file, and we're not in vimdiff
fun! NERDTreeSync()
  let filename = expand('%')
  if matchstr(filename, "node_modules") == "" && filereadable(filename) && &modifiable && IsNERDTreeOpen() && !&diff
    NERDTreeFind
    wincmd p
  endif
endfun


func! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfun

fun! CloseBuffer()
    if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1
        execute ':bn|bd #'
    else
        execute ':e ' . getcwd() . '|bd #'
    endif
endfun

fun! CloseAllBuffersButCurrent()
  let curr = bufnr("%")
  let last = bufnr("$")

  if curr > 1    | silent! execute "1,".(curr-1)."bd"     | endif
  if curr < last | silent! execute (curr+1).",".last."bd" | endif
endfun

fun! RunTest()
  let in_test = match(expand("%"), '\(.test.ts\)$') != -1
  if in_test
    if expand("%") != ""
      :w
    end
    let filename = substitute(expand("%"), '\(.test.ts\)$', '.ts', "")
    exec ":!npm run test " . @% . " -- --coverage --collectCoverageOnlyFrom " . filename
  end
endfun

fun! ToggleGutter()
  if g:show_gutter
    execute "set nornu nonu nolist signcolumn=no"
    let g:show_gutter = 0
  else
    execute "set rnu nu list signcolumn=yes"
    let g:show_gutter = 1
  endif
endfun

" == Autocommands   {{{1
" ==================================================================================================

augroup Filetypes
  autocmd!

  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile *.nu set filetype=sh
  autocmd Filetype kotlin setlocal softtabstop=4 shiftwidth=4
  autocmd Filetype man setlocal nolist
  " c: Wrap comments using textwidth
  " r: Continue comments when pressing ENTER in I mode
  " q: Enable formatting of comments with gq
  " n: Detect lists for formatting
  " j: Remove comment leader when joining lines if possible
  " p: Don't break following periods for single spaces
  autocmd Filetype * set formatoptions=croqnjp
augroup END

augroup NERDTree
  autocmd!

  autocmd BufEnter * call NERDTreeSync()

  " Opens NERDTree when no files specified
  autocmd StdinReadPre * let s:std_in=1

  " Closes if NERDTree is the only open window
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

  " If more than one window and previous buffer was NERDTree, go back to it.
  autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
augroup END

augroup Init
  autocmd!

  " Automatically rebalance windows on vim resize
  autocmd VimResized * :wincmd =

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  autocmd BufReadPost * if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

  " Leave paste mode when leaving insert mode
  autocmd InsertLeave * set nopaste

  " Color Insert mode differently
  autocmd InsertEnter * hi CursorLine ctermbg=237 guibg=#3c3836
  autocmd InsertLeave * hi CursorLine ctermbg=235 guibg=#282828
augroup END

" == Abbreviations   {{{1
" ==================================================================================================

iabbrev ,, =>
iabbrev eml lukexor@gmail.com
iabbrev eml2 me@lukeworks.tech
iabbrev adn and
iabbrev cpy Copyright Lucas Petherbridge. All Rights Reserved.
iabbrev liek like
iabbrev liekwise likewise
iabbrev pritn print
iabbrev retrun return
iabbrev teh the
iabbrev tehn then
iabbrev waht what

" 1}}}

" vim: foldmethod=marker foldlevel=0
