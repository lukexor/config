"
"                                    i  t
"                                   LE  ED.
"                                  L#E  E#K:
"                                 G#W.  E##W;
"                                D#K.   E#E##t
"                               E#K.    E#ti##f
"                             .E#E.     E#t ;##D.
"                            .K#E       E#ELLE##K:
"                           .K#D        E#L;;;;;;,
"                          .W#G         E#t
"                         :W##########WtE#t
"                         :,,,,,,,,,,,,,.
"
"
"     Personal vim configuration of Luke Petherbridge <me@lukeworks.tech>



" =============================================================================
" General Settings   {{{1
" =============================================================================

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
if &compatible
  set nocompatible
endif

" Ensure a vim-compatible shell
set shell=/bin/bash
let $SHELL="/bin/bash"
let g:python3_host_prog = 'python3'

" Don't use nvim as a pager within itself
let $PAGER='less'

set expandtab
set shiftwidth=2
set tabstop=2
set shiftround
set virtualedit=block
set relativenumber
set number
set termguicolors
set undofile
set spell
set title
set incsearch
set wildmode=longest:full,full
set completeopt=menu,menuone,noselect
set nowrap
set breakindent
set list
set listchars=tab:\ ,trail:·,extends:,precedes:,nbsp:‗
set matchpairs+=<:>
set scrolloff=8
set sidescrolloff=8
set splitright
set splitbelow
set cmdheight=2
set confirm
set updatetime=300 " Save more often than 4 seconds.
set updatecount=50 " Save more often than 200 characters typed.
set redrawtime=10000 " Allow more time for loading syntax on large files
set textwidth=80
set cursorline
set colorcolumn=80
set signcolumn=yes:2
set synmaxcol=200
set foldmethod=indent
set foldlevelstart=99
set showmatch
set path+=**
set dictionary=/usr/share/dict/words
set spellfile=~/.config/nvim/spell.utf-8.add

" Highlight strings and numbers inside comments
let c_comment_strings=1

if &diff
  set diffopt+=iwhite
  " Make diffing better: https://vimways.org/2018/the-power-of-diff/
  set diffopt+=algorithm:patience
  set diffopt+=indent-heuristic
endif

if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep\ -.\ --ignore-file\ .git/
  set grepformat=%f:%l:%c:%m
endif


" =============================================================================
" Key Maps   {{{1
" =============================================================================

let mapleader=' '
let maplocalleader='-'

" Quick edit vim files
nmap <leader>ve :edit $MYVIMRC<CR>
nmap <leader>vc :edit ~/.config/nvim/lua/lsp-setup.lua<CR>
nmap <leader>vr :source $MYVIMRC<CR>:edit<CR>

" Quick save
nmap <leader>w :w<CR>
" Save but don't run autocmds which might format
nmap <leader>W :noa w<CR>

" Quick quit
nmap <leader>q :q<CR>
nmap <leader>Q :qall<CR>
nmap <leader>d :Bdelete<CR>
nmap <leader>D :bufdo bdelete<CR>

" Disable Q for Ex mode since it's accidentally hit. gQ still works.
" Instead use it for formatting.
nmap Q gq

" Clear search
nnoremap <leader><CR> :nohlsearch<Bar>diffupdate<CR><C-l>

" Allow gf to open non-existent files, doesn't auto-find like original gf, but
" can use gF instead.
map <silent> gf :edit <cfile><CR>

" Switch between windows
nmap <silent> <C-h> <C-w>h
nmap <silent> <C-j> <C-w>j
nmap <silent> <C-k> <C-w>k
nmap <silent> <C-l> <C-w>l

" Navigate buffers
nmap <leader>h :bp<CR>
nmap <leader>l :bn<CR>
nmap <leader><leader> <C-^>

" Navigate to tag
nnoremap <silent> gt <C-]>

" Show diffs in a modified buffer
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
    \ | wincmd p | diffthis
endif

" Reselect visual after indenting
vnoremap < <gv
vnoremap > >gv

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
nnoremap <silent> <leader>j :m .+1<CR>==
nnoremap <silent> <leader>k :m .-2<CR>==

" Keep cursor centered
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z
nnoremap <silent> * *zzzv
nnoremap <silent> # #zzzv
nnoremap <silent> g* g*zzzv
nnoremap <silent> g# g*zzzv

nmap <leader>s :%s/
" Trim blanks
nmap <leader>R :%s/\s\+%//

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
" Move by terminal rows, not lines, unless count is provided
nnoremap <silent> <expr> j (v:count > 0 ? "m'" . v:count . 'j' : "gj")
nnoremap <silent> <expr> k (v:count > 0 ? "m'" . v:count . 'k' : "gk")

" Maximize window
nmap <leader>- :wincmd _<CR>:wincmd \|<CR>
" Equalize window sizes
nmap <leader>= :wincmd =<CR>

" Resize windows
nnoremap <Down> :resize -5<CR>
nnoremap <Left> :vertical resize -5<CR>
nnoremap <Right> :vertical resize +5<CR>
nnoremap <Up> :resize +5<CR>

" cd to cwd of current file
nnoremap <silent> cd :execute 'lcd ' fnamemodify(resolve(expand('%')), ':p:h')<CR>
  \ :lua vim.notify('lcd ' .. vim.fn.fnamemodify(vim.fn.resolve(vim.fn.expand('%')), ':p:h'))<CR>

" Yank/Paste to/from clipboard
nnoremap cy "*y
nnoremap cY "*Y
nnoremap cyy "*yy
vnoremap cy "*y
nnoremap cp "*p
nnoremap cP "*P

" Next/Last parens text-object
onoremap in( :<C-u>normal! f(vi(<CR>
onoremap il( :<C-u>normal! F)vi(<CR>
onoremap an( :<C-u>normal! f(va(<CR>
onoremap al( :<C-u>normal! F)va(<CR>
vnoremap in( :<C-u>normal! f(vi(<CR><Esc>gv
vnoremap il( :<C-u>normal! F)vi(<CR><Esc>gv
vnoremap an( :<C-u>normal! f(va(<CR><Esc>gv
vnoremap al( :<C-u>normal! F)va(<CR><Esc>gv

" Next/Last brace text-object
onoremap in{ :<C-u>normal! f{vi{<CR>
onoremap il{ :<C-u>normal! F{vi{<CR>
onoremap an{ :<C-u>normal! f{va{<CR>
onoremap al{ :<C-u>normal! F{va{<CR>
vnoremap in{ :<C-u>normal! f{vi{<CR><Esc>gv
vnoremap il{ :<C-u>normal! F{vi{<CR><Esc>gv
vnoremap an{ :<C-u>normal! f{va{<CR><Esc>gv
vnoremap al{ :<C-u>normal! F{va{<CR><Esc>gv

" Next/Last bracket text-object
onoremap in[ :<C-u>normal! f[vi[<CR>
onoremap il[ :<C-u>normal! F[vi[<CR>
onoremap an[ :<C-u>normal! f[va[<CR>
onoremap al[ :<C-u>normal! F[va[<CR>
vnoremap in[ :<C-u>normal! f[vi[<CR><Esc>gv
vnoremap il[ :<C-u>normal! F[vi[<CR><Esc>gv
vnoremap an[ :<C-u>normal! f[va[<CR><Esc>gv
vnoremap al[ :<C-u>normal! F[va[<CR><Esc>gv

" Fold text-object
vnoremap af :<C-u>silent! normal! [zV]z<CR>
omap af :normal Vaf<CR>

" Indent text-object
onoremap ai :<C-u>call <SID>IndTxtObj(0)<CR>
onoremap ii :<C-u>call <SID>IndTxtObj(1)<CR>
vnoremap ai :<C-u>call <SID>IndTxtObj(0)<CR><Esc>gv
vnoremap ii :<C-u>call <SID>IndTxtObj(1)<CR><Esc>gv

fun! s:IndTxtObj(inner)
  let curcol = col(".")
  let curline = line(".")
  let lastline = line("$")
  let i = indent(line(".")) - &shiftwidth * (v:count1 - 1)
  let i = i < 0 ? 0 : i
  if getline(".") !~ "^\\s*$"
    let p = line(".") - 1
    let pp = line(".") - 2
    let nextblank = getline(p) =~ "^\\s*$"
    let nextnextblank = getline(pp) =~ "^\\s*$"
    while p > 0 && (((!nextblank || (pp > 0 && !nextnextblank)) && indent(p) >= i) || (!a:inner && nextblank))
      -
      let p = line(".") - 1
      let pp = line(".") - 2
      let nextblank = getline(p) =~ "^\\s*$"
      let nextnextblank = getline(pp) =~ "^\\s*$"
    endwhile
    normal! 0V
    call cursor(curline, curcol)
    let p = line(".") + 1
    let pp = line(".") + 2
    let nextblank = getline(p) =~ "^\\s*$"
    let nextnextblank = getline(pp) =~ "^\\s*$"
    while p <= lastline && (((!nextblank || (pp > 0 && !nextnextblank)) && indent(p) >= i) || (!a:inner && nextblank))
      +
      let p = line(".") + 1
      let pp = line(".") + 2

      let nextblank = getline(p) =~ "^\\s*$"
      let nextnextblank = getline(pp) =~ "^\\s*$"
    endwhile
    normal! $
  endif
endfun

" Identify syntax ID under cursor
nnoremap <leader>i :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
  \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
  \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Toggle gutter and signs
nnoremap <leader>\ :call <SID>ToggleGutter()<CR>

fun! s:ToggleGutter()
  if &nu || &rnu || &list || &signcolumn
    execute "set nornu nonu nolist signcolumn=no"
  else
    execute "set rnu nu list signcolumn=yes:2"
  endif
endfun


" =============================================================================
" Plugins   {{{1
" =============================================================================

" Auto-install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo ' . data_dir . '/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
  \| endif

call plug#begin(data_dir . '/plugged')

source ~/.config/nvim/plugins/bufdelete.vim
source ~/.config/nvim/plugins/buftabline.vim
source ~/.config/nvim/plugins/cheatsh.vim
source ~/.config/nvim/plugins/closetag.vim
source ~/.config/nvim/plugins/commentary.vim
source ~/.config/nvim/plugins/cmp.vim
source ~/.config/nvim/plugins/dadbod.vim
source ~/.config/nvim/plugins/digraphs.vim
source ~/.config/nvim/plugins/dispatch.vim
source ~/.config/nvim/plugins/dressing.vim
source ~/.config/nvim/plugins/easy-align.vim
source ~/.config/nvim/plugins/editorconfig.vim
source ~/.config/nvim/plugins/endwise.vim
source ~/.config/nvim/plugins/eunuch.vim
source ~/.config/nvim/plugins/floatterm.vim
source ~/.config/nvim/plugins/fugitive.vim
source ~/.config/nvim/plugins/fzf.vim
source ~/.config/nvim/plugins/gruvbox.vim
source ~/.config/nvim/plugins/highlightedyank.vim
source ~/.config/nvim/plugins/illuminate.vim
source ~/.config/nvim/plugins/lsp.vim
source ~/.config/nvim/plugins/lualine.vim
source ~/.config/nvim/plugins/markdown-preview.vim
source ~/.config/nvim/plugins/nerdtree.vim
source ~/.config/nvim/plugins/notify.vim
source ~/.config/nvim/plugins/obsession.vim
source ~/.config/nvim/plugins/polyglot.vim
source ~/.config/nvim/plugins/projectionist.vim
source ~/.config/nvim/plugins/quickfix.vim
source ~/.config/nvim/plugins/radical.vim
source ~/.config/nvim/plugins/repeat.vim
source ~/.config/nvim/plugins/rooter.vim
source ~/.config/nvim/plugins/securemodelines.vim
source ~/.config/nvim/plugins/signature.vim
source ~/.config/nvim/plugins/sleuth.vim
source ~/.config/nvim/plugins/symbols-outline.vim
source ~/.config/nvim/plugins/smooth-scroll.vim
source ~/.config/nvim/plugins/sneak.vim
source ~/.config/nvim/plugins/surround.vim
source ~/.config/nvim/plugins/test.vim
source ~/.config/nvim/plugins/todo-lists.vim
source ~/.config/nvim/plugins/unimpaired.vim
source ~/.config/nvim/plugins/vimspector.vim
source ~/.config/nvim/plugins/which-key.vim

call plug#end()
doautocmd User PlugLoaded


" =============================================================================
" Abbreviations   {{{1
" =============================================================================

iabbrev .. =>
iabbrev adn and
iabbrev liek like
iabbrev liekwise likewise
iabbrev pritn print
iabbrev retrun return
iabbrev teh the
iabbrev tehn then
iabbrev tihs this
iabbrev waht what


" =============================================================================
" Misc   {{{1
" =============================================================================

augroup FileTypeOverrides
  autocmd!
  autocmd TermOpen * setlocal nospell nonu nornu | startinsert
  autocmd BufRead,BufNewFile *.nu set ft=nu
  autocmd Filetype help set nu rnu
  autocmd Filetype * set formatoptions=croqnjp
augroup END

augroup Init
  autocmd!
  " Jump to the last known cursor position. See |last-position-jump|.
  autocmd BufReadPost *
    \ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe 'normal! g`"' |
    \ endif
  autocmd VimEnter * helptags ~/.config/nvim/doc
  autocmd CmdwinEnter *
      \ echohl Todo |
      \ echo 'You discovered the command-line window! You can close it with ":q".' |
      \ echohl None
augroup END


" vim: foldmethod=marker foldlevel=0
