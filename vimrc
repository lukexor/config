"=============================================================
" .vimrc
"=============================================================

" Returns operating system
fun! MySys()
  return "$1"
endfun

let vimrc = $HOME . "/.vim-runtime/vimrc"
if filereadable(vimrc)
  set runtimepath=~/.vim-runtime,$VIMRUNTIME,~/.vim-runtime/after
  exec 'source ' . vimrc
else
  set encoding=utf8 " UTF8 encoding is best
  set ff=unix
  set ffs=unix,dos,mac " Default file types
  set number " Line numbers
  set cpoptions+=n
  set t_Co=256 " Force 256 colors
  syntax enable
  highlight  CursorLine ctermbg=017 ctermfg=None
  autocmd InsertEnter * highlight  CursorLine ctermbg=235 ctermfg=None
  autocmd InsertLeave * highlight  CursorLine ctermbg=017 ctermfg=None
  set laststatus=2 " Always show the statusline
  set title
  set statusline=%{HasPaste()} " Whether pastemode is on or not
  set statusline+=%F    " Tail of the filename
  set statusline+=\ [%{strlen(&fenc)?&fenc:'none'}, " File encoding
  set statusline+=%{&ff}] " File format
  set statusline+=%h    " Help file flag
  set statusline+=%m    " Modified flag
  set statusline+=%r    " Read only flag
  set statusline+=%w    " Preview window flag
  set statusline+=%y    " Filetype
  set statusline+=[%{&fo}] " Formatoptions enabled
  set statusline+=\ [%{CurDir()}] " Current directory
  set statusline+=%=    " Left/right separator
  set statusline+=%l/%L " Cursor line/total lines
  set statusline+=\ %P  " Percent through file
  set statusline+=\ c\ %c   " Cursor column
  if v:version > 700
    set statusline+=\ %{exists('g:loaded_fugitive')?fugitive#statusline():''} " Git status
  endif
  set backspace=eol,start,indent " Set backspace config, allowing backspace in insert mode
  set cmdheight=2 " The commandbar height
  set hlsearch " Highlight search things
  set ignorecase " Ignore case when searching
  set incsearch " Make search act like search in modern browsers
  set mat=2 " How many tenths of a second to blink
  set nolazyredraw " Don't redraw while executing macros
  set novisualbell " No visual errors either
  set noerrorbells " No sound on errors
  set ruler " Always show current position
  set showcmd " Display incomplete commands
  set showmatch " Show matching brackets when text indicator is over them
  set showmode " Show current mode
  set smartcase " Ignores the above when searching for UPPERcase
  set so=7 " Set 7 lines to the cusrors - when moving vertical..
  set ttyfast " Smoother changes
  set t_vb= " Unsets the visual bell termcap code
  if exists('&foldenable')
    set foldmethod=expr " Fold based on indent
    set foldexpr=GetFoldLevel(v:lnum)
    set foldnestmax=5 " Deepest fold
    set foldlevel=1 " The default depth to fold
    set foldenable
    set foldminlines=1

    function! NextNonBlankLine(lnum)
      let numlines = line('$')
      let current = a:lnum + 1

      while current <= numlines
        if getline(current) =~? '\v\S'
          return current
        endif

        let current += 1
      endwhile

      let invalid_line = -2
      return invalid_line
    endfunction

    function! IndentLevel(lnum)
      return indent(a:lnum) / &shiftwidth
    endfunction

    function! GetFoldLevel(lnum)
      let undefined_fold_level = '-1'

      if getline(a:lnum) =~? '\v^\s*$'
        return undefined_fold_level
      endif

      let this_indent = IndentLevel(a:lnum)
      let next_indent = IndentLevel(NextNonBlankLine(a:lnum))

      if next_indent == this_indent
        return this_indent
      elseif next_indent < this_indent
        return this_indent
      elseif next_indent > this_indent
        return '>' . next_indent

      return '0'
    endfunction
  endif
  set nobackup
  set noswapfile
  set nowb
  if exists('&undofile')
    silent !mkdir ~/.vim-runtime/undodir > /dev/null 2>&1
    set undodir=~/.vim-runtime/undodir
    set undofile
  endif
  set autoindent
  set expandtab " Always expand tabs into spaces
  set formatoptions=rql " Allow line-width formatting with <leader>gq
  set linebreak " Wrap long lines at a character in breakat
  set list listchars=tab:\|\ ,trail:-,extends:>,precedes:<,nbsp:x " display indentation guides
  highlight SpecialKey ctermfg=darkgrey guifg=darkgrey
  set wrap " wrap default
  set shiftround " Indent/Outdent to nearest tabstop
  set matchpairs+=<:> " Allow % to bounce between angles too
  set smarttab " Tabs according to shiftwidth
  set shiftwidth=2 " Number of spaces used for each indent level
  set softtabstop=2 " Spaces a tab counts for when backspacing or inserting tabs
  set tabstop=2 " The number of spaces a tab counts as
  set textwidth=80
  set wrapmargin=10 " Number of characters from the right where wrapping starts
  if has('spell')
    set spelllang=en
  endif
  filetype plugin indent on " Enable filetype plugin
  set wildmenu " Turn on WiLd menu for name completion
  set wildmode=list:longest " Bash like name-completion
  set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
  set wildignore+=*vim-runtime/undodir*
  set wildignore+=*.gem
  set wildignore+=log/**
  set wildignore+=tmp/**
  set wildignore+=*.png,*.jpg,*.gif
  set wildignore+=*.swp,*.bak,*.pyc,*.class
  set wildignore+=*/build/**
  set scrolloff=8 " Scroll when 8 lines away from margin
  set sidescrolloff=15 " Scroll when 15 lines away from margin
  set sidescroll=1 " Minimum number of columns to scroll horizontally
  let mapleader = "\<Space>" " With a map leader it's possible to do extra key combinations
  nnoremap ; :
  nnoremap j gj
  nnoremap k gk
  vnoremap j gj
  vnoremap k gk
  set mouse=a
  set ttymouse=xterm2
  nnoremap <C-j> 12j
  nnoremap <C-k> 12k
  vnoremap <C-j> 12j
  nnoremap <C-k> 12k
  map 0 ^
  map <F3> <Esc>:set invpaste paste?<CR>
  map! <F3> <Esc>:set invpaste paste?<CR>i
  map <F4> <Esc>:set wrap!<CR>:set list!<CR>
  map! <F4> <Esc>:set wrap!<CR>:set list!<CR>i
  map <F5> <Esc>:set invnu<CR>:set list!<CR>
  map! <F5> <Esc>:set invnu<CR>:set list!<CR>
  vmap <tab> >gv
  vmap <s-tab> <gv
  nmap <tab> >>
  nmap <s-tab> <<
  map <leader>l :rightb vnew<cr>
  cno $c e <C-\>eCurrentFileDir("e")<cr>
  map <leader>tn :tabnew<cr>
  map <leader>te :tabedit
  map <leader>tc :tabclose<cr>
  map <leader>tm :tabmove
  map <leader><up> :tabr<cr>
  map <leader><down> :tabl<cr>
  map <leader>, :tabp<cr>
  map <leader>. :tabn<cr>
  map <leader>w :w!<cr>
  autocmd FileType cpp map <leader>r :w<cr>:!g++ *.cpp *.o -o main.exe && ./main.exe<cr>
  map <leader>q :qall!<cr>
  map <leader>rs :%s/\s\+$//<cr>:noh<cr>
  map <leader><cr> :nohlsearch<cr>
  function! HasPaste()
    if &paste
      return '[PASTE] '
    else
      return ''
    endif
  endfunction
  function! CurDir()
    let curdir = substitute(getcwd(), $HOME, "~", "g")
    if strlen(curdir) > 40
      return "..." . curdir[-40:]
    else
      return curdir
    endif
  endfunction
endif
