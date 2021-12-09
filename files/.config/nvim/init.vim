"
"                                  ________________________
"                                 |#####||#################\
"                                 |#####||##################\
"                                 |#####||#####|      |#####|
"                                 |#####||#####|      |#####|
"                                 |#####||#####|      |#####|
"                                 |#####||#################W
"                                 |#####||################W
"                                 |#####||#####|----------
"                                 |#####||#####|
"                                 |#####||#####|
"                                 |#####||#####|_____
"                                 |##################\
"                                 |###################\
"                                  --------------------
"
"       Personal vim configuration of Luke Petherbridge <me@lukeworks.tech>



" ==================================================================================================
" General Settings   {{{1
" ==================================================================================================

set nocompatible  " Disable VI backwards compatible settings. Must be first

" Ensure a vim-compatible shell
set shell=/bin/bash
let $SHELL="/bin/bash"

let $PAGER='' " Don't use nvim as a pager within itself

set expandtab
set shiftwidth=2
set tabstop=2
set shiftround
set signcolumn=yes:2
set virtualedit=block
set relativenumber
set number
set termguicolors
set undofile
set updatecount=50
set spell
set title
set ignorecase
set smartcase
set wildmode=longest:full,full
set nowrap
set breakindent
set list
set listchars=tab:▸\ ,trail:·
set matchpairs+=<:>
set scrolloff=8
set sidescrolloff=8
set splitright
set splitbelow
set confirm
set backup
set backupdir=~/.local/share/nvim/backup//
set updatetime=300 " You will have bad experience for diagnostic messages when it's default 4000.
set redrawtime=10000 " Allow more time for loading syntax on large files
set textwidth=80
set cursorline
set colorcolumn=80,100
set synmaxcol=200
set foldmethod=indent
set foldlevelstart=99
set showmatch
set path+=**
set dictionary=/usr/share/dict/words
set spellfile=~/.config/nvim/spell.utf-8.add

if &diff
  set diffopt+=iwhite
  " Make diffing better: https://vimways.org/2018/the-power-of-diff/
  set diffopt+=algorithm:patience
  set diffopt+=indent-heuristic
endif

if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep
  set grepformat=%f:%l:%c:%m
endif

" ==================================================================================================
" Key Maps   {{{1
" ==================================================================================================

let mapleader=' '
let maplocalleader=','

nmap <localleader>ve :edit $MYVIMRC<CR>
nmap <localleader>vc :edit ~/.config/nvim/lua/lsp.lua<CR>
nmap <localleader>vr :source $MYVIMRC<CR>:edit<CR>

nnoremap <leader><cr> :nohlsearch<cr>
vnoremap <leader><cr> :nohlsearch<cr>

" Quick save
nmap <leader>w :w<CR>
nmap <leader>W :noa w<CR>

nmap <leader>q :q<CR>
nmap <leader>Q :qall<CR>
nmap <leader>d :bdelete<CR>
nmap <leader>D :bufdo bdelete<CR>

" Allow gf to open non-existent files
map gf :edit <cfile><cr>

" Switch between windows
nmap <silent> <C-h> <C-w>h
nmap <silent> <C-j> <C-w>j
nmap <silent> <C-k> <C-w>k
nmap <silent> <C-l> <C-w>l

" Navigate buffers
nmap <leader>h :bp<CR>
nmap <leader>l :bn<CR>
nmap <leader><leader> <c-^>

" Move by terminal rows, not lines, unless count is provided
nnoremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" Navigate tags
nmap <localleader>tn :tnext<CR>
nmap <localleader>tp :tprevious<CR>

" Make cnext wrap around
command! Cnext try | cnext | catch | cfirst | catch | endtry
command! Cprev try | cprev | catch | clast | catch | endtry
nnoremap [e :Cprev<CR>
nnoremap ]e :Cnext<CR>
" Clear quickfix
nnoremap <leader>cc :cexpr []

" Reselect visual after indenting
vnoremap < <gv
vnoremap > >gv

" Make Y consistent
nnoremap Y y$

" Maintain cursor position when yanking visual
vnoremap y myy`y
vnoremap Y myY`y

" Paste replace visual selection without copying it
vnoremap <leader>p "_dP

" Deletes the current line and replaces it with the previously yanked value
nmap + V"_dP

" Move selections up/down
" gv restores visual mode selection, = ensures indent is honored
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Move line up/down
" == honors indent
nnoremap <leader>j :m .+1<CR>==
nnoremap <leader>k :m .-2<CR>==

" Keep cursor centered
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z
nnoremap <silent> * *zzzv
nnoremap <silent> # #zzzv
nnoremap <silent> g* g*zzzv
nnoremap <silent> g# g*zzzv

nmap <leader>s :%s/

" Open file in default program
nmap <leader>x :!open %<CR><CR>

" Escape insert mode
imap jj <Esc>
inoremap <C-c> <Esc>

" Easy insert trailing punctuation from insert mode
imap ;; <Esc>A;<Esc>
imap ,, <Esc>A,<Esc>

" Add breaks in undo chain when typing punctuation
inoremap . .<C-g>u
inoremap , ,<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u

" Add relative jumps of more than 5 lines to jump list
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'

" Maximize window
nmap <leader>- :wincmd _<CR>:wincmd \|<CR>
" Equalize window sizes
nmap <leader>= :wincmd =<CR>

" Resize windows
nnoremap <silent> <Down> :resize -5<CR>
nnoremap <silent> <Left> :vertical resize -5<CR>
nnoremap <silent> <Right> :vertical resize +5<CR>
nnoremap <silent> <Up> :resize +5<CR>

" cd to cwd of current file
nnoremap cd :execute 'lcd ' fnamemodify(resolve(expand('%')), ':h')<CR>
  \ :echo 'cd ' . fnamemodify(resolve(expand('%')), ':h')<CR>

" Clipboard
nnoremap cY "*Y
nnoremap cyy "*yy
nnoremap cp "*p
nnoremap cP "*P
vnoremap cy "*y

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

nnoremap <F7> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
  \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
  \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>


fun! ToggleQuickFix()
  if exists("w:quickfix_title")
    cclose
  else
    try
      copen
    catch
      echo "No Errors found!"
    endtry
  endif
endfun
nnoremap <localleader>1 :call ToggleQuickFix()<CR>

let b:show_gutter = 1
fun! ToggleGutter()
  if b:show_gutter
    execute "set nornu nonu nolist signcolumn=no"
    let b:show_gutter = 0
  else
    execute "set rnu nu list signcolumn=yes:2"
    let b:show_gutter = 1
  endif
endfun
nnoremap <localleader>2 :call ToggleGutter()<CR>

" ==================================================================================================
" Plugins   {{{1
" ==================================================================================================

" Auto-install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo ' . data_dir . '/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(data_dir . '/plugins')

source ~/.config/nvim/plugins/closetag.vim
source ~/.config/nvim/plugins/commentary.vim
source ~/.config/nvim/plugins/dispatch.vim
source ~/.config/nvim/plugins/editorconfig.vim
source ~/.config/nvim/plugins/endwise.vim
source ~/.config/nvim/plugins/floatterm.vim
source ~/.config/nvim/plugins/fugitive.vim
source ~/.config/nvim/plugins/fzf.vim
source ~/.config/nvim/plugins/gruvbox.vim
source ~/.config/nvim/plugins/kotlin.vim
source ~/.config/nvim/plugins/lightline.vim
source ~/.config/nvim/plugins/lsp.vim
source ~/.config/nvim/plugins/markdown-preview.vim
source ~/.config/nvim/plugins/nerdtree.vim
source ~/.config/nvim/plugins/projectionist.vim
source ~/.config/nvim/plugins/polyglot.vim
source ~/.config/nvim/plugins/repeat.vim
source ~/.config/nvim/plugins/rooter.vim
source ~/.config/nvim/plugins/rust.vim
source ~/.config/nvim/plugins/signature.vim
source ~/.config/nvim/plugins/smooth-scroll.vim
source ~/.config/nvim/plugins/snippets.vim
source ~/.config/nvim/plugins/surround.vim
source ~/.config/nvim/plugins/test.vim
source ~/.config/nvim/plugins/unimpaired.vim
source ~/.config/nvim/plugins/vimspector.vim
source ~/.config/nvim/plugins/which-key.vim

call plug#end()
doautocmd User PlugLoaded

lua require("lsp")

" Abbreviations   {{{1
" ==================================================================================================

iabbrev .. =>
iabbrev adn and
iabbrev liek like
iabbrev liekwise likewise
iabbrev pritn print
iabbrev retrun return
iabbrev teh the
iabbrev tehn then
iabbrev waht what

" ==================================================================================================
" Misc   {{{1
" ==================================================================================================

hi SpecialComment ctermfg=108 guifg=#89b482 guisp=#89b482

augroup FileTypeOverrides
  autocmd TermOpen * setlocal nospell
  autocmd!
  autocmd BufRead,BufNewFile *.nu set filetype=sh
  autocmd Filetype * set formatoptions=croqnjp
augroup END

augroup Init
  autocmd!
  " Jump to the last known cursor position.
  autocmd BufReadPost * if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

  autocmd InsertLeave * set nopaste
  autocmd InsertEnter * hi CursorLine ctermbg=237 guibg=#3c3836
  autocmd InsertLeave * hi CursorLine ctermbg=235 guibg=#282828
augroup END


" vim: foldmethod=marker foldlevel=0
