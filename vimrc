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

" == Plugins   {{{1
" ==================================================================================================

call plug#begin('~/.vim/plugins')

" -- Enhancements   {{{2
" --------------------------------------------------------------------------------------------------

Plug 'ciaranm/securemodelines'                          " Secure version of modelines
Plug 'editorconfig/editorconfig-vim'                    " Loads .editorconfig
Plug 'justinmk/vim-sneak'                               " 's' motion to search, ';' next, ',' prev
Plug 'ludovicchabant/vim-gutentags'                     " Manages updating ctags

" -- Navigation   {{{2
" --------------------------------------------------------------------------------------------------

Plug 'airblade/vim-rooter'                              " Cd's to nearest git root
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'                                " Displays tags in a sidebar
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }   " FileTree
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-fugitive'                               " Git integration
Plug 'christoomey/vim-tmux-navigator'                   " Easily jump between splits or tmux windows
Plug 'kshenoy/vim-signature'                            " Adds vim marks to gutter
Plug 'itchyny/lightline.vim'

" -- Editing   {{{2
" --------------------------------------------------------------------------------------------------

Plug 'neoclide/coc.nvim', {'branch': 'release'}         " Semantic language support
Plug 'dense-analysis/ale'                               " Mostly to allow for custom fixers
if v:version >= 800
  Plug 'SirVer/ultisnips'
endif
Plug 'alvan/vim-closetag'                               " Auto close XML/HTML tags
Plug 'godlygeek/tabular'                                " Align lines
Plug 'tpope/vim-surround'                               " Surround text easier
Plug 'tpope/vim-commentary'                             " Commenting quality of life improvements
Plug 'tpope/vim-endwise'                                " Adds endings to blocks e.g. endif
Plug 'tommcdo/vim-exchange'                             " Allows easy exchanging of text

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

" -- Utility/Support   {{{2
" --------------------------------------------------------------------------------------------------
"
Plug 'tpope/vim-dispatch'                                " Run tasks in the background
Plug 'tpope/vim-repeat'                                  " Repeat last command using '.'

" 2}}}

call plug#end()

" == Plugins Settings   {{{1
" ==================================================================================================

let g:ale_fix_on_save = 1
let b:ale_disable_lsp = 1

let b:local_vimrc = getcwd() . '/.vimrc'
if filereadable(b:local_vimrc)
  exe 'source' b:local_vimrc
endif

let g:fzf_buffers_jump = 1          " Jump to existing window if possible
let g:fzf_commits_log_options = '--graph --pretty=format:"%C(yellow)%h (%p) %ai%Cred%d %Creset%Cblue[%ae]%Creset %s (%ar). %b %N"'

let g:closetag_filetypes = 'xml,xhtml,javascript,javascript.jsx,typescript.tsx'
let g:closetag_xhtml_filetypes = 'xml,xhtml,javascript,javascript.jsx,typescript.tsx'

let g:coc_snippet_next = '<tab>'
let g:coc_snippet_pref = '<s-tab>'
let g:coc_disable_transparent_cursor = 1
let g:coc_global_extensions = [
  \ 'coc-css',
  \ 'coc-eslint',
  \ 'coc-fzf-preview',
  \ 'coc-git',
  \ 'coc-highlight',
  \ 'coc-html',
  \ 'coc-kotlin',
  \ 'coc-java',
  \ 'coc-json',
  \ 'coc-markdownlint',
  \ 'coc-prettier',
  \ 'coc-react-refactor',
  \ 'coc-rust-analyzer',
  \ 'coc-rls',
  \ 'coc-sh',
  \ 'coc-snippets',
  \ 'coc-sql',
  \ 'coc-stylelint',
  \ 'coc-stylelintplus',
  \ 'coc-tag',
  \ 'coc-toml',
  \ 'coc-tsserver',
  \ 'coc-ultisnips',
  \ 'coc-vimlsp',
  \ 'coc-yaml',
  \ 'coc-yank',
\ ]

let g:snips_author = system('git config --get user.name | tr -d "\n"')
let g:snips_author_email = system('git config --get user.email | tr -d "\n"')

let g:UltiSnipsExpandTrigger = '<c-l>'

let g:lightline = {
  \ 'colorscheme': 'seoul256',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'cocstatus', 'tagstatus', 'readonly', 'filename', 'modified', 'function' ] ],
  \   'right': [ [ 'lineinfo' ],
  \              [ 'percent' ],
  \              [ 'gitstatus', 'gitbranch', 'filetype' ] ],
  \ },
  \ 'component_function': {
  \   'function': 'CurrentFunction',
  \   'filename': 'LightlineFilename',
  \   'tagstatus': 'gutentags#statusline',
  \   'cocstatus': 'coc#status',
  \   'gitstatus': 'GitStatus',
  \   'gitbranch': 'FugitiveHead'
  \ },
\ }

let g:plug_window = 'noautocmd vertical topleft new'

let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0
let g:rustfmt_command = 'rustup run stable rustfmt'
let g:rust_use_custom_ctags_defs = 1

let g:sneak#s_next = 1

let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_frontmatter = 1

let g:NERDTreeWinSize = 35

" -- Gutentags   {{{2
" --------------------------------------------------------------------------------------------------

let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['package.json', '.git', 'cargo.toml']
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0

" -- Tagbar   {{{2
" --------------------------------------------------------------------------------------------------

let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1
let g:tagbar_autoshowtag = 1
let g:tagbar_compact = 1
let g:tagbar_width = 35
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
let g:tagbar_type_javascript = {
  \ 'ctagstype': 'javascript',
  \ 'kinds': [
    \ 'A:arrays',
    \ 'P:properties',
    \ 'T:tags',
    \ 'O:objects',
    \ 'G:generator functions',
    \ 'F:functions',
    \ 'C:constructors/classes',
    \ 'M:methods',
    \ 'V:variables',
    \ 'I:imports',
    \ 'E:exports',
    \ 'S:styled components'
  \ ]
\ }
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
let g:tagbar_type_rust = {
  \ 'ctagstype' : 'rust',
  \ 'kinds' : [
    \ 'T:types,type definitions',
    \ 'f:functions,function definitions',
    \ 'g:enum,enumeration names',
    \ 's:structure names',
    \ 'm:modules,module names',
    \ 'c:consts,static constants',
    \ 't:traits',
    \ 'i:impls,trait implementations',
  \ ]
\ }
let g:tagbar_type_typescript = {
  \ 'ctagstype': 'typescript',
  \ 'kinds': [
    \ 'A:arrays',
    \ 'P:properties',
    \ 't:types',
    \ 'T:tags',
    \ 'O:objects',
    \ 'G:generator functions',
    \ 'F:functions',
    \ 'C:constructors/classes',
    \ 'M:methods',
    \ 'V:variables',
    \ 'i:interfaces',
    \ 'I:imports',
    \ 'e:enums',
    \ 'E:exports',
    \ 'S:styled components'
  \ ]
\ }

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
nmap <leader>x :x<CR>

" Vimrc/Snippets
nmap <localleader>ev :vsplit $MYVIMRC<CR>
nmap <localleader>es :CocCommand snippets.editSnippets<CR>
nmap <localleader>ls :CocList snippets<CR>
nmap <localleader>gc :Commits<CR>

" Fixes Ctrl-X Ctrl-K
" https://github.com/SirVer/ultisnips/blob/master/doc/UltiSnips.txt
inoremap <c-x><c-k> <c-x><c-k>

" New file
nmap <leader>n :enew<CR>
nmap <leader>q :q<CR>

" -- Navigation   {{{2
" --------------------------------------------------------------------------------------------------

" Jump to start and end of line using the home row keys
map H ^
map L $

" No arrow keys --- force yourself to use the home row
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

nmap <leader>M :Marks<CR>
nmap <leader>T :Tags<CR>

" Move by line
nnoremap j gj
nnoremap k gk

" Toggles between buffers
nnoremap <leader><leader> <c-^>

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" cd to cwd of current file
nnoremap cd :execute 'lcd' fnamemodify(resolve(expand('%')), ':h')<CR>
  \ :echo 'cd ' . fnamemodify(resolve(expand('%')), ':h')<CR>

" Navigate buffers
nmap <leader>h :bp<CR>
nmap <leader>l :bn<CR>

" Navigate tags
nmap <leader>tn :tnext<CR>
nmap <leader>tp :tprevious<CR>

" Navigate errors
nnoremap <leader>en :cnext<CR>
nnoremap <leader>ep :cprevious<CR>

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
nmap <leader>D :call CloseAllBuffersButCurrent()<CR>
nmap <leader>d :call CloseBuffer()<CR>
nmap <leader>q :q<CR>
nmap <leader>Q :qall!<CR>

" -- Editing   {{{2
" --------------------------------------------------------------------------------------------------

" Deletes the current line and replaces it with the previously yanked value
nmap + V"0p

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>prn :CocSearch <C-R>=expand("<cword>")<CR><CR>

" Remap keys for applying codeAction to the current buffer.
xmap <leader>ac  <Plug>(coc-codeaction)
nmap <leader>ac  <Plug>(coc-codeaction)
xmap <leader>as  <Plug>(coc-codeaction-selected)
nmap <leader>as  <Plug>(coc-codeaction-selected)
nmap <leader>f  :CocFix<CR>
nmap <leader>F  <Plug>(coc-fix-current)
nmap <leader>o  :OR<CR>
nmap <localleader>F  <Plug>(coc-fix-fixAll)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocActionAsync('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :call CocActionAsync('runCommand', 'editor.action.organizeImport')

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <leader>A  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <leader>E  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <leader>C  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <leader>O  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <leader>S  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <leader>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <leader>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <localleader>r  :<C-u>CocListResume<CR>

inoremap <C-j> <Esc>
vnoremap <C-j> <Esc>
snoremap <C-j> <Esc>
xnoremap <C-j> <Esc>
cnoremap <C-j> <Esc>
onoremap <C-j> <Esc>
lnoremap <C-j> <Esc>
tnoremap <C-j> <Esc>

" Disable using C-C to exit insert mode - Use <C-j> or <C-[> in paste mode
inoremap <C-c> <NOP>

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

" Newline upon enter
nnoremap <CR> o<Esc>

" Move lines up or down
nnoremap J ddp
nnoremap K dd<up>P

" Disable EX mode
nnoremap Q <NOP>

" Close quickfix
nmap <leader>cc :ccl<CR>

" Reload vimrc
nmap <localleader>sv :source $MYVIMRC<CR>:e<CR>

" Change up to the next return
onoremap r /return<CR>
" Change inside next parens
onoremap in( :<c-u>normal! f(vi(<cr>
" Change inside last parens
onoremap il( :<c-u>normal! F)vi(<cr>

" -- Status   {{{2
" --------------------------------------------------------------------------------------------------

" Toggle hidden characters
nmap <leader>, :set list<cr>

" Display help
nnoremap <silent> <leader>H :call CocActionAsync('doHover')<cr>

" Shows stats
nnoremap <localleader>q g<c-g>

nnoremap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
  \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
  \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

nnoremap <localleader>1 :call OpenNERDTree()<CR>
nnoremap <localleader>2 :TagbarToggle<CR>
nnoremap <localleader>3 :call ToggleGutter()<CR>
nnoremap <localleader>4 :call TogglePaste()<CR>
nnoremap <localleader>5 :set rnu!<CR>

" -- Search   {{{2
" --------------------------------------------------------------------------------------------------

" Search results centered please
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" Very magic by default
nnoremap ? ?\v
nnoremap / /\v
cnoremap %s/ %sm/

" Clear search highlighting
vnoremap <leader><cr> :nohlsearch<cr>:call coc#float#close_all()<CR>
nnoremap <leader><cr> :nohlsearch<cr>:call coc#float#close_all()<CR>
nnoremap <silent> <leader><CR> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>:call clearmatches()<CR>:call coc#float#close_all()<CR>

nmap <leader>s :Rg<cr>

" Use K to show documentation in preview window.
nmap <silent> <leader>D :call <SID>show_documentation()<CR>

fun! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfun

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" -- Completion   {{{2
" --------------------------------------------------------------------------------------------------

" 'Smart' nevigation
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_previous_space() ? "\<TAB>" :
      \ coc#refresh()

fun! s:check_previous_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~# '\s'
endfun

" Use <c-.> to trigger completion.
inoremap <silent><expr> <c-.> coc#refresh()

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
let g:endwise_no_mappings = v:true
let g:AutoPairsMapCR = v:false
if exists('*complete_info')
  inoremap <expr> <Plug>CustomCocCR complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <Plug>CustomCocCR pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif
imap <CR> <Plug>CustomCocCR<Plug>DiscretionaryEnd

" == Settings   {{{1
" ==================================================================================================

" -- Syntax/Highlighting   {{{2
" --------------------------------------------------------------------------------------------------

filetype plugin indent on       " Load plugins according to detected filetype
syntax on                       " Enable syntax highlighting

colorscheme mustang
set background=dark

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
set formatexpr=CocActionAsync('formatSelected')

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
set updatetime=300

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

set completeopt+=longest,menu,menuone,preview
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
if !isdirectory($HOME."/.vim/files")
  call mkdir($HOME."/.vim/files/swap", "p")
  call mkdir($HOME."/.vim/files/undo", "p")
  call mkdir($HOME."/.vim/files/info", "p")
  call mkdir($HOME."/.vim/files/spell", "p")
endif
set directory=$HOME/.vim/files/swap//
set undolevels=5000
set undodir=$HOME/.vim/files/undo/
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
set viminfo=h,'100,f1,<10000,s1000,/1000,:1000,%,n$HOME/.vim/files/info/viminfo

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set dictionary=$HOME/.vim/files/spell/en-basic.latin1.spl
set spellfile=$HOME/.vim/files/spell/vim-spell.utf-8.add
set spelllang=en

" == Functions   {{{1
" ==================================================================================================

" returns true iff is NERDTree open/active
fun! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfun

fun! OpenNERDTree()
  let arg_count = argc()
  let file_count = len(split(globpath('.', '*'), '\n'))
  let is_node_module = expand('%:p') =~ 'node_modules'
  if arg_count < 1 || file_count > 50 || is_node_module || exists("s:std_in")
    return
  endif

  let file = argv()[0]
  if isdirectory(file)
    execute 'NERDTree ' . file
    setlocal nolist signcolumn=no
    wincmd p
    ene
    execute 'cd' . file
  else
    NERDTree
    setlocal nolist signcolumn=no
    wincmd p
    call NERDTreeSync()
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

fun CurrentFunction()
  return tagbar#currenttag('[%s]','','')
endf

func! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfun

func! GitStatus()
  return get(b:, 'coc_git_status', '') . get(b:, 'coc_git_blame', '')
endfun

fun! TogglePaste()
  set paste!
  if &paste
    hi StatusLine ctermbg=253 ctermfg=52
  else
    hi StatusLine ctermbg=238 ctermfg=253
  endif
endfun

fun! FormatKotlin()
  exec 'Dispatch! ktlint -F ' . expand('%')
endf

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

  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile *.js,*.jsx nmap <leader>F :call CocActionAsync('runCommand', 'eslint.executeAutofix')<CR>
  autocmd BufRead,BufNewFile *.ts,*.tsx nmap <leader>F :call CocActionAsync('runCommand', 'tsserver.executeAutofix')<CR>:call CocActionAsync('runCommand', 'eslint.executeAutofix')<CR>
  autocmd Filetype kotlin setlocal softtabstop=4 shiftwidth=4
  autocmd Filetype man setlocal nolist
  autocmd BufWritePost *.kt,*.kts call FormatKotlin()

  " c: Wrap comments using textwidth
  " r: Continue comments when pressing ENTER in I mode
  " q: Enable formatting of comments with gq
  " n: Detect lists for formatting
  " j: Remove comment leader when joining lines if possible
  " p: Don't break following periods for single spaces
  autocmd Filetype * set formatoptions=crqnjp
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

augroup VimrcEx
  autocmd!

  " Automatically rebalance windows on vim resize
  autocmd VimResized * :wincmd =

  " Don't do it for commit messages, when the position is invalid, or when
  " When editing a file, always jump to the last known cursor position.
  autocmd BufReadPost * if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

  " Leave paste mode when leaving insert mode
  autocmd InsertLeave * set nopaste

  " Color Insert mode differently
  autocmd InsertEnter * hi CursorLine ctermbg=23
  autocmd InsertLeave * hi CursorLine ctermbg=236
augroup END

" == Abbreviations   {{{1
" ==================================================================================================

iabbrev ,, =>
iabbrev eml lukexor@gmail.com
iabbrev eml2 me@lukeworks.tech
iabbrev adn and
iabbrev cpy Copyright Lucas Petherbridge. All Rights Reserved.
iabbrev copy Copyright Lucas Petherbridge. All Rights Reserved.
iabbrev liek like
iabbrev liekwise likewise
iabbrev pritn print
iabbrev retrun return
iabbrev teh the
iabbrev tehn then
iabbrev waht what

" 1}}}

" vim: foldmethod=marker foldlevel=0
