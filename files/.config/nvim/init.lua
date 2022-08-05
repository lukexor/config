--
--                                    i  t
--                                   LE  ED.
--                                  L#E  E#K:
--                                 G#W.  E##W;
--                                D#K.   E#E##t
--                               E#K.    E#ti##f
--                             .E#E.     E#t ;##D.
--                            .K#E       E#ELLE##K:
--                           .K#D        E#L;;;;;;,
--                          .W#G         E#t
--                         :W##########WtE#t
--                         :,,,,,,,,,,,,,.
--
--
--     Personal vim configuration of Luke Petherbridge <me@lukeworks.tech>

-- =============================================================================
-- General Settings
-- =============================================================================

-- Ensure a vim-compatible shell
vim.env.SHELL = "/bin/bash"
vim.opt.shell = vim.env.SHELL
-- https://neovim.io/doc/user/provider.html
vim.g.python3_host_prog = "python3"

-- Don"t use nvim as a pager within itself
vim.env.PAGER = "less"

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.virtualedit = "block"
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.title = true
vim.opt.incsearch = true
vim.opt.wildmode = "longest:full,full"
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.wrap = false
vim.opt.breakindent = true
vim.opt.list = true
vim.opt.listchars = "tab:\\ ,trail:·,extends:,precedes:,nbsp:‗"
vim.opt.matchpairs:append { "<:>" }
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.cmdheight = 2
vim.opt.confirm = true
vim.opt.updatetime = 300 -- Save more often than 4 seconds.
vim.opt.updatecount = 50 -- Save more often than 200 characters typed.
vim.opt.redrawtime = 10000 -- Allow more time for loading syntax on large files
vim.opt.textwidth = 80
vim.opt.cursorline = true
vim.opt.colorcolumn = "80"
vim.opt.signcolumn = "yes:2"
vim.opt.synmaxcol = 200
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 99
vim.opt.showmatch = true
vim.opt.path:append { "**" }
vim.opt.dictionary = "/usr/share/dict/words"
vim.opt.spellfile = vim.env.HOME .. "/.config/nvim/spell.utf-8.add"

-- Highlight strings and numbers inside comments
vim.g.c_comment_strings = 1

-- Make diffing better: https://vimways.org/2018/the-power-of-diff/
vim.opt.diffopt:append { "iwhite", "algorithm:patience", "indent-heuristic" }

if vim.fn.executable("rg") then
  vim.opt.grepprg = "rg\\ --no-heading\\ --vimgrep\\ --no-ignore-vcs\\ -."
  vim.opt.grepformat = "%f:%l:%c:%m"
end



-- =============================================================================
-- Key Maps
-- =============================================================================

vim.g.mapleader = " "
vim.g.maplocalleader = "-"

function MergeR(t1, t2)
  for k, v in pairs(t2) do
    if type(v) == "table" then
      if type(t1[k] or false) == "table" then
        MergeR(t1[k] or {}, t2[k] or {})
      else
        t1[k] = v
      end
    else
      t1[k] = v
    end
  end
  return t1
end

function Merge(t1, t2)
  return MergeR(MergeR({}, t1 or {}), t2 or {})
end

local silent = { silent = true }
local remap = { remap = true }

local set_keymap = function(...) vim.keymap.set(...) end
local del_keymap = function(...) vim.keymap.del(...) end
local map = function(lhs, rhs, opts) set_keymap("", lhs, rhs, opts) end
local nmap = function(lhs, rhs, opts) set_keymap("n", lhs, rhs, opts) end
local nunmap = function(lhs, opts) del_keymap("n", lhs, opts) end
local vmap = function(lhs, rhs, opts) set_keymap("v", lhs, rhs, opts) end
local xmap = function(lhs, rhs, opts) set_keymap("x", lhs, rhs, opts) end
local imap = function(lhs, rhs, opts) set_keymap("i", lhs, rhs, opts) end
local omap = function(lhs, rhs, opts) set_keymap("o", lhs, rhs, opts) end

-- Quick edit vim files
nmap("<leader>ve", ":edit $MYVIMRC<CR>")
nmap("<leader>vr", ":source $MYVIMRC<CR>:edit<CR>")

-- Quick save
nmap("<leader>w", ":w<CR>")
-- Save but don"t run aus which might format
nmap("<leader>W", ":noa w<CR>")

-- Quick quit
nmap("<leader>q", ":confirm q<CR>")
nmap("<leader>Q", ":confirm qall<CR>")
nmap("<leader>D", ":confirm bufdo bdelete<CR>")
nmap("<leader>o", ":%bd|e#|bd#<CR>")

-- Disable Q for Ex mode since it's accidentally hit often. gQ still works.
nmap("Q", "")

-- Clear search
nmap("<leader><CR>", ":nohlsearch<Bar>diffupdate<CR><C-l>")

-- Allow gf to open non-existent files, doesn"t auto-find like original gf, but
-- can use gF instead.
map("gf", ":edit <cfile><CR>", silent)

-- Switch between windows
map("<C-h>", "<C-w>h", silent)
map("<C-j>", "<C-w>j", silent)
map("<C-k>", "<C-w>k", silent)
map("<C-l>", "<C-w>l", silent)

-- Navigate buffers
nmap("<leader>h", ":bp<CR>")
nmap("<leader>l", ":bn<CR>")
nmap("<leader><leader>", "<C-^>")

-- Navigate to tag
nmap("gt", "gt <C-]>", silent)

-- Show diffs in a modified buffer
vim.cmd("command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis")

-- Reselect visual after indenting
vmap("<", "<gv")
vmap(">", ">gv")

-- Maintain cursor position when yanking visual
vmap("y", "myy`y")
vmap("Y", "myY`y")

-- Paste replace visual selection without copying it
vmap("<leader>p", '"_dP')

-- Deletes the current line and replaces it with the previously yanked value
nmap("+", 'V"_dP')

-- Move selections up/down
-- gv restores visual mode selection, = ensures indent is honored
vmap("J", ":m '>+1<CR>gv=gv")
vmap("K", ":m '<-2<CR>gv=gv")

-- Move line up/down
-- == honors indent
nmap("<leader>j", ":m .+1<CR>==", silent)
nmap("<leader>k", ":m .-2<CR>==", silent)

-- Toggle wrapping text
nmap("<localleader>w", [[ (&fo =~ 't' ? ":set fo-=t<CR>" : ":set fo+=t<CR>") ]], { silent = true, expr = true })

-- Keep cursor centered
nmap("n", "nzzzv")
nmap("N", "Nzzzv")
nmap("J", "mzJ`z")
nmap("*", "*zzzv", silent)
nmap("#", "#zzzv", silent)
nmap("g*", "g*zzzv", silent)
nmap("g#", "g*zzzv", silent)

nmap("<leader>s", ":%s/")
-- Trim blanks
nmap("<leader>R", ":%s/\\s\\+$//<CR>")

-- Open file in default program
nmap("<leader>x", ":!open %<CR><CR>")

-- Escape insert mode
imap("jj", "<Esc>")
imap("<C-c>", "<Esc>")

-- Easy insert trailing punctuation from insert mode
nmap(";;", "A;<Esc>")
nmap(",,", "A,<Esc>")
imap(";;", "<Esc>A;<Esc>")
imap(",,", "<Esc>A,<Esc>")

-- Add breaks in undo chain when typing punctuation
imap(".", ".<C-g>u")
imap(",", ",<C-g>u")
imap("!", "!<C-g>u")
imap("?", "?<C-g>u")

-- Add relative jumps of more than 5 lines to jump list
-- Move by terminal rows, not lines, unless count is provided
nmap("j", [[ (v:count > 0 ? "m'" . v:count . 'j' : "gj") ]], { silent = true, expr = true })
nmap("k", [[ (v:count > 0 ? "m'" . v:count . 'k' : "gk") ]], { silent = true, expr = true })

-- Maximize window
nmap("<leader>-", ":wincmd _<CR>:wincmd \\|<CR>")
-- Equalize window sizes
nmap("<leader>=", ":wincmd =<CR>")

-- Resize windows
nmap("<Down>", ":resize -5<CR>")
nmap("<Left>", ":vertical resize -5<CR>")
nmap("<Right>", ":vertical resize +5<CR>")
nmap("<Up>", ":resize +5<CR>")

-- cd to cwd of current file
nmap("cd", ":exe 'lcd ' fnamemodify(resolve(expand('%')), ':p:h')<CR>"
  .. ":lua vim.notify('lcd ' .. vim.fn.fnamemodify(vim.fn.resolve(vim.fn.expand('%')), ':p:h'))<CR>",
  silent
)

-- Yank/Paste to/from clipboard
nmap("cy", '"*y')
nmap("cY", '"*Y')
nmap("cyy", '"*yy')
vmap("cy", '"*y')
nmap("cp", '"*p')
nmap("cP", '"*P')

-- Next/Last parens text-object
omap("in(", ":<C-u>normal! f(vi(<CR>")
omap("il(", ":<C-u>normal! F)vi(<CR>")
omap("an(", ":<C-u>normal! f(va(<CR>")
omap("al(", ":<C-u>normal! F)va(<CR>")
vmap("in(", ":<C-u>normal! f(vi(<CR><Esc>gv")
vmap("il(", ":<C-u>normal! F)vi(<CR><Esc>gv")
vmap("an(", ":<C-u>normal! f(va(<CR><Esc>gv")
vmap("al(", ":<C-u>normal! F)va(<CR><Esc>gv")

-- Next/Last brace text-object
omap("in{", ":<C-u>normal! f{vi{<CR>")
omap("il{", ":<C-u>normal! F{vi{<CR>")
omap("an{", ":<C-u>normal! f{va{<CR>")
omap("al{", ":<C-u>normal! F{va{<CR>")
vmap("in{", ":<C-u>normal! f{vi{<CR><Esc>gv")
vmap("il{", ":<C-u>normal! F{vi{<CR><Esc>gv")
vmap("an{", ":<C-u>normal! f{va{<CR><Esc>gv")
vmap("al{", ":<C-u>normal! F{va{<CR><Esc>gv")

-- Next/Last bracket text-object
omap("in[", ":<C-u>normal! f[vi[<CR>")
omap("il[", ":<C-u>normal! F[vi[<CR>")
omap("an[", ":<C-u>normal! f[va[<CR>")
omap("al[", ":<C-u>normal! F[va[<CR>")
vmap("in[", ":<C-u>normal! f[vi[<CR><Esc>gv")
vmap("il[", ":<C-u>normal! F[vi[<CR><Esc>gv")
vmap("an[", ":<C-u>normal! f[va[<CR><Esc>gv")
vmap("al[", ":<C-u>normal! F[va[<CR><Esc>gv")

-- Fold text-object
vmap("af", ":<C-u>silent! normal! [zV]z<CR>")
omap("af", ":normal Vaf<CR>")

-- Indent text-object
function IndentTextObj(around)
  local curcol = vim.fn.col(".")
  local curline = vim.fn.line(".")
  local lastline = vim.fn.line("$")
  local blank_line_pat = "^%s*$"

  local i = vim.fn.indent(vim.fn.line(".")) - vim.opt.shiftwidth:get() * (vim.v.count1 - 1)
  if i < 0 then
    i = 0
  end

  local get_pos = function(offset)
    return vim.fn.line(".") + offset
  end

  local get_blank = function(pos)
    return string.match(vim.fn.getline(pos), blank_line_pat)
  end

  if not get_blank(".") then
    local p = get_pos(-1)
    local pp = get_pos(-2)
    local nextblank = get_blank(p)
    local nextnextblank = get_blank(pp)

    while p > 0 and (
        ((not nextblank or (pp > 0 and not nextnextblank))
            and vim.fn.indent(p) >= i
            ) or (not around and nextblank)
        ) do
      vim.cmd("-")
      p = get_pos(-1)
      pp = get_pos(-2)
      nextblank = get_blank(p)
      nextnextblank = get_blank(pp)
    end

    vim.cmd("normal! 0V")
    vim.fn.cursor(curline, curcol)

    p = get_pos(1)
    pp = get_pos(2)
    nextblank = get_blank(p)
    nextnextblank = get_blank(pp)

    while p <= lastline and (
        ((not nextblank or (pp > 0 and not nextnextblank))
            and vim.fn.indent(p) >= i
            ) or (not around and nextblank)
        ) do
      vim.cmd("+")
      p = get_pos(1)
      pp = get_pos(2)
      nextblank = get_blank(p)
      nextnextblank = get_blank(pp)
    end

    vim.cmd("normal! $")
  end
end

omap("ai", ":<C-u>lua IndentTextObj(false)<CR>", silent)
omap("ii", ":<C-u>lua IndentTextObj(true)<CR>", silent)
xmap("ai", ":<C-u>lua IndentTextObj(false)<CR><Esc>gv", silent)
xmap("ii", ":<C-u>lua IndentTextObj(true)<CR><Esc>gv", silent)

-- Identify syntax ID under cursor
nmap("<leader>i", ":echo 'hi<' . synIDattr(synID(line('.'),col('.'),1),'name') . '> trans<'"
  .. " . synIDattr(synID(line('.'),col('.'),0),'name') . '> lo<'"
  .. " . synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name') . '>'<CR>"
)

function ToggleGutter()
  if vim.opt.nu:get() or vim.opt.rnu:get() or vim.opt.list:get() then
    vim.cmd("set nornu nonu nolist signcolumn=no")
  else
    vim.cmd("set rnu nu list signcolumn=yes:2")
  end
end

-- Toggle gutter and signs
nmap("<leader>\\", ":lua ToggleGutter()<CR>")

--- Ascii Art
nmap("<leader>tb", ":.!toilet -w 200 -f term -F border<CR>")
nmap("<leader>ts", ":.!figlet -w 200 -f standard<CR>")
nmap("<leader>tS", ":.!figlet -w 200 -f small<CR>")


-- =============================================================================
-- Plugins
-- =============================================================================

-- Auto-install vim-plug
local data_dir = vim.fn.stdpath('data') .. "/site"
if vim.fn.empty(vim.fn.glob(data_dir .. "/autoload/plug.vim")) then
  local install_cmd = "silent exe '!curl -fLo %s/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'"
  vim.cmd(install_cmd:format(data_dir))
end

-- Run PlugInstall if there are missing plugins
vim.cmd([[
  au VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \| PlugInstall --sync | source $MYVIMRC
    \| endif
]])

local Plug = require("vimplug")

Plug.begin(data_dir .. "/plugged")

-- -----------------------------------------------------------------------------
-- VIM Enhancements
-- -----------------------------------------------------------------------------

-- Keep window layout when deleting buffers
Plug("famiu/bufdelete.nvim", {
  config = function()
    nmap("<leader>d", ":confirm Bdelete<CR>")
  end
})
-- Better buffer management
Plug("ap/vim-buftabline", {
  except = { "vpm" },
  config = function()
    vim.g.buftabline_show = 2 -- always
    vim.g.buftabline_numbers = 2 -- ordinal numbers
    vim.g.buftabline_indicators = 1
    vim.g.buftabline_separators = 1

    nmap("<leader>1", "<Plug>BufTabLine.Go(1)")
    nmap("<leader>2", "<Plug>BufTabLine.Go(2)")
    nmap("<leader>3", "<Plug>BufTabLine.Go(3)")
    nmap("<leader>4", "<Plug>BufTabLine.Go(4)")
    nmap("<leader>5", "<Plug>BufTabLine.Go(5)")
    nmap("<leader>6", "<Plug>BufTabLine.Go(6)")
    nmap("<leader>7", "<Plug>BufTabLine.Go(7)")
    nmap("<leader>8", "<Plug>BufTabLine.Go(8)")
    nmap("<leader>9", "<Plug>BufTabLine.Go(9)")
    nmap("<leader>0", "<Plug>BufTabLine.Go(-1)")
  end
})
-- Easier vim session management
Plug("tpope/vim-obsession", {
  on = { "Obsession" },
  preload = function()
    nmap("<leader>O", ":Obsession<CR>")
  end,
  config = function()
  end
})
Plug("tpope/vim-repeat") -- Repeat with "."
Plug("tpope/vim-sleuth") -- Smart buffer options based on contents
Plug("tpope/vim-unimpaired") -- Bracket motions
-- Better searching
Plug("justinmk/vim-sneak", {
  config = function()
    vim.g["sneak#s_next"] = 1
    omap("z", "<Plug>Sneak_s")
    omap("Z", "<Plug>Sneak_S")
  end
})
Plug("ypcrts/securemodelines") -- Safe modelines
Plug("editorconfig/editorconfig-vim") -- Parses .editorconfig
Plug("kshenoy/vim-signature") -- Show marks in gutter
-- Less jarring scroll
Plug("terryma/vim-smooth-scroll", {
  config = function()
    nmap("<C-u>", ":call smooth_scroll#up(&scroll, 10, 1)<CR>", silent)
    nmap("<C-d>", ":call smooth_scroll#down(&scroll, 10, 1)<CR>", silent)
    nmap("<C-b>", ":call smooth_scroll#up(&scroll*2, 10, 3)<CR>", silent)
    nmap("<C-f>", ":call smooth_scroll#down(&scroll*2, 10, 3)<CR>", silent)
  end
})

-- -----------------------------------------------------------------------------
-- Documentation
-- -----------------------------------------------------------------------------

Plug("sudormrfbin/cheatsheet.nvim") -- Cheatsheet Search
-- Online Cheat.sh lookup
Plug("dbeniamine/cheat.sh-vim", {
  config = function()
    vim.g.CheatSheetStayInOrigBuf = 0
    vim.g.CheatSheetDoNotMap = 1
    vim.g.CheatDoNotReplaceKeywordPrg = 1
    nmap("<leader>cs", ":Cheat ")
  end
})
-- File symbol outline to TagBar
Plug("simrat39/symbols-outline.nvim", {
  on = { "SymbolsOutline" },
  preload = function()
    nmap("<leader>to", ":SymbolsOutline<CR>")
  end,
  config = function()
    vim.g.symbols_outline = {
      width = 40,
      highlight_hovered_item = false,
    }
  end
})
Plug("folke/which-key.nvim", {
  config = function()
    require("which-key").setup {
      plugins = {
        spelling = {
          enabled = true,
        }
      },
    }
  end
})

-- -----------------------------------------------------------------------------
-- Code Assists
-- -----------------------------------------------------------------------------

-- Auto-close HTML/JSX tags
Plug("windwp/nvim-ts-autotag", {
  config = function()
    require("nvim-treesitter.configs").setup {
      autotag = {
        enable = true,
      }
    }
  end
})
Plug("tpope/vim-endwise") -- Auto-add endings for control structures: if, for, etc
Plug("tpope/vim-commentary") -- Commenting motion commands gc*
Plug("tpope/vim-surround", {
  config = function()
    -- Surround text with punctuation easier 'you surround' + motion
    nmap('<leader>"', 'ysiw"', remap)
    nmap("<leader>'", "ysiw'", remap)
    nmap("<leader>(", "ysiw(", remap)
    nmap("<leader>)", "ysiw)", remap)
    nmap("<leader>>", "ysiw>", remap)
    nmap("<leader>[", "ysiw[", remap)
    nmap("<leader>]", "ysiw]", remap)
    nmap("<leader>`", "ysiw`", remap)
    nmap("<leader>{", "ysiw{", remap)
    nmap("<leader>}", "ysiw}", remap)
    nmap("<leader><Bar>", "ysiw|", remap)

    -- Same mappers for visual mode
    vmap('<leader>"', 'gS"', remap)
    vmap("<leader>'", "gS'", remap)
    vmap("<leader>(", "gS(", remap)
    vmap("<leader>)", "gS)", remap)
    vmap("<leader><", "gS<", remap)
    vmap("<leader>>", "gS>", remap)
    vmap("<leader>[", "gS[", remap)
    vmap("<leader>]", "gS]", remap)
    vmap("<leader>`", "gS`", remap)
    vmap("<leader>{", "gS{", remap)
    vmap("<leader>}", "gS}", remap)
    vmap("<leader><Bar>", "gS|", remap)

    nmap("<localleader>[", "ysip[", remap)
    nmap("<localleader>]", "ysip]", remap)
    nmap("<localleader>rh", "ds'ds}", remap)
    nmap("<localleader>sh", "ysiw}lysiw'", remap)
    nmap("<localleader>{", "ysip{", remap)
    nmap("<localleader>}", "ysip{", remap)
  end
})
-- Make aligning rows easier
Plug("junegunn/vim-easy-align", {
  config = function()
    xmap("<leader>a", "<Plug>(EasyAlign)")
    nmap("<leader>a", "<Plug>(EasyAlign)")
  end
})
Plug("glts/vim-magnum") -- Dependency for glts/vim-radical
-- Number conversions
Plug("glts/vim-radical", {
  config = function()
    nmap("gA", "<Plug>RadicalView")
    xmap("gA", "<Plug>RadicalView")
    nmap("crd", "<Plug>RadicalCoerceToDecimal")
    nmap("crx", "<Plug>RadicalCoerceToHex")
    nmap("cro", "<Plug>RadicalCoerceToOctal")
    nmap("crb", "<Plug>RadicalCoerceToBinary")
  end
})
Plug("zirrostig/vim-schlepp", {
  config = function()
    vmap("K", "<Plug>SchleppUp")
    vmap("J", "<Plug>SchleppDown")
    vmap("H", "<Plug>SchleppLeft")
    vmap("L", "<Plug>SchleppRight")
  end
})

-- -----------------------------------------------------------------------------
-- System Integration
-- -----------------------------------------------------------------------------

Plug("tpope/vim-dadbod") -- Database access
Plug("tpope/vim-dispatch") -- Async builder/dispatcher
Plug("tpope/vim-eunuch", {
  on = { "Remove", "Delete", "Move", "Rename", "Copy", "Mkdir", "Wall", "SudoWrite", "SudoEdit" }
})
Plug("tpope/vim-fugitive", {
  on = { "Git", "Gdiffsplit", "Gvdiffsplit", "GMove", "GBrowse", "GDelete" }
})
Plug("tpope/vim-rhubarb", { on = { "GBrowse" } }) -- Browse github urls
Plug("voldikss/vim-floaterm", {
  config = function()
    vim.g.floaterm_shell = "nu"
    vim.g.floaterm_title = "nvim $1/$2"
    vim.g.floaterm_keymap_new = "<C-y>"
    vim.g.floaterm_keymap_toggle = "<C-t>"
    vim.g.floaterm_keymap_prev = "<C-p>"
    vim.g.floaterm_keymap_next = "<C-n>"
    vim.g.floaterm_gitcommit = "floaterm"
    vim.g.floaterm_autoinsert = 1
    vim.g.floaterm_width = 0.8
    vim.g.floaterm_height = 0.8
    vim.g.floaterm_wintitle = 0
    vim.g.floaterm_autoclose = 1
  end
})
Plug("iamcco/markdown-preview.nvim", {
  run = vim.fn["mkdp#util#install"],
  ft = { "markdown", "vim-plug" },
  config = function()
    vim.g.mkdp_echo_preview_url = 1
  end
})
local nerdtree_opts = { on = { "NERDTree", "NERDTreeFind", "NERDTreeToggle" } }
Plug("preservim/nerdtree", {
  on = nerdtree_opts.on,
  preload = function()
    nmap(
      "<leader>n",
      "exists('g:NERDTree') && g:NERDTree.IsOpen() ? ':NERDTreeClose<CR>' : @% == ''"
      .. " ? ':NERDTree<CR>' : ':NERDTreeFind<CR>'",
      { expr = true }
    )
    nmap("<leader>N", ":NERDTreeFind<CR>")

    -- Function to open the file or NERDTree or netrw.
    --   Returns: 1 if either file explorer was opened; otherwise, 0.
    vim.cmd([[
      fun! s:OpenFileOrExplorer(...)
        if a:0 == 0
          exe 'edit'
          return 0
        elseif a:1 =~? '^\(scp\|ftp\)://' " Add other protocols as needed.
          exe 'Vexplore '.a:1
        elseif isdirectory(a:1)
          exe 'NERDTree '.a:1
        else
          exe 'edit '.a:1
          return 0
        endif
        return 1
      endfun

      command! -n=? -complete=file -bar Edit :call <SID>OpenFileOrExplorer('<args>')
      cnoreabbrev e Edit
    ]])

    vim.cmd([[
      aug NERDTree
        au!
        " Start NERDTree when Vim starts with a directory argument.
        au StdinReadPre * let s:std_in=1
        au VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
          \ if <SID>OpenFileOrExplorer(argv()[0]) | wincmd p | enew | bd 1 | exe 'lcd '.argv()[0] | wincmd p | endif | endif

        " Closes if NERDTree is the only open window
        au BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
        " If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
        au BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
          \ let buf=bufnr() | buffer# | exe "normal! \<C-W>w" | exe 'buffer'.buf | endif
      aug END
    ]])
  end,
  config = function()
    vim.g.NERDTreeShowHidden = 1
    vim.g.NERDTreeMinimalUI = 1
    vim.g.NERDTreeWinSize = 35
    vim.g.NERDTreeDirArrowExpandable = '▹'
    vim.g.NERDTreeDirArrowCollapsible = '▿'
    -- avoid crashes when calling vim-plug functions while the cursor is on the NERDTree window
    vim.g.plug_window = 'noau vertical topleft new'
  end
})
Plug("Xuyuanp/nerdtree-git-plugin", nerdtree_opts)
Plug("tiagofumo/vim-nerdtree-syntax-highlight", nerdtree_opts)

-- -----------------------------------------------------------------------------
-- Project Management
-- -----------------------------------------------------------------------------

-- Add project commands
Plug("tpope/vim-projectionist", {
  config = function()
    vim.g.projectionist_heuristics = {
      ["package.json"] = {
        ["*"] = {
          start = "npm start",
          make = "npm run lint",
        },
        ["*.ts"] = {
          type = "source",
          alternate = "{}.test.ts",
        },
        ["*.tsx"] = {
          type = "source",
          alternate = "{}.test.tsx",
        }
      },
      ["Cargo.toml"] = {
        ["*"] = {
          start = "cargo run",
          make = "cargo clippy --all-targets",
          console = "nu -c 'start https://play.rust-lang.org/' > /dev/null 2>&1; exit",
        },
      },
    }
  end
})
-- Find the root project folder
Plug("airblade/vim-rooter", {
  config = function()
    vim.g.rooter_cd_cmd = "lcd"
    vim.g.rooter_resolve_links = 1
  end
})
Plug("aserebryakov/vim-todo-lists", {
  config = function()
    -- This plugin is great but takes too many liberties with mappings
    vim.g.vimtodolists_plugin = 1

    -- TODO: Convert to lua
    vim.cmd([[
      fun! TodoListsSetNormalMode()
        setlocal indentexpr=b:pindentexpr
        setlocal formatoptions=b:pformatoptions
        nunmap <buffer> o
        nunmap <buffer> O
        iunmap <buffer> <CR>
        noremap <buffer> <leader>te :silent call TodoListsSetItemMode()<CR>
      endfun
    ]])

    vim.cmd([[
      fun! TodoListsSetItemMode()
        let b:pindentexpr=&indentexpr
        let b:pformatoptions=&formatoptions
        setlocal indentexpr=
        setlocal formatoptions-=ro
        nnoremap <buffer><silent> o :silent call VimTodoListsCreateNewItemBelow()<CR>
        nnoremap <buffer><silent> O :silent call VimTodoListsCreateNewItemAbove()<CR>
        inoremap <buffer><silent> <CR> <ESC>:silent call VimTodoListsCreateNewItemBelow()<CR>
        noremap <buffer><silent> <leader>te :silent call TodoListsSetNormalMode()<CR>
      endfun
    ]])

    vim.cmd([[
      fun! TodoListsInit()
        let g:VimTodoListsKeepSameIndent = 0
        let g:VimTodoListsUndoneItem = '- [ ]'
        let g:VimTodoListsDoneItem = '- [x]'
        let g:VimTodoListsMoveItems = 0

        call VimTodoListsInitializeTokens()
        call VimTodoListsInitializeSyntax()

        nnoremap <buffer> <leader>tt :silent call VimTodoListsToggleItem()<CR>
        nnoremap <buffer> <leader>tn :silent call VimTodoListsCreateNewItem()<CR>
        nnoremap <buffer> <leader>tO :silent call VimTodoListsCreateNewItemAbove()<CR>
        nnoremap <buffer> <leader>to :silent call VimTodoListsCreateNewItemBelow()<CR>
        noremap <buffer> <leader>te :silent call TodoListsSetItemMode()<CR>
      endfun
    ]])

    vim.cmd([[
      aug TodoLists
        au!
        au BufRead,BufNewFile *.todo.md call TodoListsInit()
      aug end
    ]])
  end
})
-- Javascrpt import sizes
Plug("yardnsm/vim-import-cost", {
  run = "npm install --production",
  config = function()
    vim.g.import_cost_virtualtext_prefix = " ▸ "
    nmap("<localleader>C", ":ImportCost<CR>");
    vim.cmd([[
      aug ImportCost
        au!
        au ColorScheme gruvbox-material hi! link ImportCostVirtualText VirtualTextInfo
      aug END
    ]])
  end
})

-- -----------------------------------------------------------------------------
-- Windowing/Theme
-- -----------------------------------------------------------------------------

Plug("ryanoasis/vim-devicons")
Plug("stevearc/dressing.nvim") -- Window UI enhancements
Plug("sainnhe/gruvbox-material", {
  config = function()
    vim.g.gruvbox_material_transparent_background = 1
    vim.g.gruvbox_material_background = "hard"
    vim.g.gruvbox_material_enable_italic = 1
    vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
    vim.g.gruvbox_material_better_performance = 1
    vim.g.gruvbox_material_visual = "reverse"
    vim.g.gruvbox_material_menu_selection_background = "green"
    vim.g.gruvbox_material_ui_contrast = "high"

    vim.cmd([[
      aug ColorOverrides
        au!
        au ColorScheme gruvbox-material hi! Comment ctermfg=208 guifg=#e78a4e
        au ColorScheme gruvbox-material hi! SpecialComment ctermfg=108 guifg=#89b482 guisp=#89b482
        au ColorScheme gruvbox-material hi! ColorColumn ctermbg=237 guibg=#333333
        au ColorScheme gruvbox-material hi! FloatermBorder ctermbg=none guibg=none
        au ColorScheme gruvbox-material hi! link Whitespace DiffDelete
        au InsertEnter * hi! CursorLine ctermbg=237 guibg=#333e34
        au InsertLeave * hi! CursorLine ctermbg=235 guibg=#282828
      aug END
    ]])

    vim.opt.background = "dark"
    vim.cmd("colorscheme gruvbox-material")
  end
})
Plug("nvim-lualine/lualine.nvim", {
  config = function()
    require("lualine").setup {
      options = {
        icons_enabled = true,
        theme = "gruvbox",
        component_separators = { left = " ", right = " " },
        section_separators = { left = " ", right = " " },
        disabled_filetypes = {},
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "SleuthIndicator", "ObsessionStatus", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      }
    }
  end
})
Plug("junegunn/goyo.vim") -- Distraction free writing
Plug("junegunn/limelight.vim") -- Dim non-active paragraphs

-- -----------------------------------------------------------------------------
-- LSP
-- -----------------------------------------------------------------------------

Plug("RRethy/vim-illuminate") -- Highlights nearby uses of words on hover
Plug("ray-x/lsp_signature.nvim") -- Shows function signatures as you type
Plug("williamboman/nvim-lsp-installer")
Plug("antoinemadec/FixCursorHold.nvim") -- Dependency for nvim-lightbulb
-- Lightbulb next to code actions
Plug("kosayoda/nvim-lightbulb", {
  config = function()
    vim.fn.sign_define("LightBulbSign", { text = "", texthl = "", linehl = "", numhl = "" })
    require("nvim-lightbulb").setup { au = { enabled = true } }
  end
})
Plug("simrat39/rust-tools.nvim") -- Rust LSP library
Plug("jose-elias-alvarez/null-ls.nvim")
Plug("neovim/nvim-lspconfig", {
  config = function()
    -- Default LSP shortcuts to no-ops for non-supported file types to avoid
    -- confusion with default vim shortcuts.
    function NoLspClient()
      vim.notify("No LSP client attached for filetype: `" .. vim.bo.filetype .. "`.", 3)
    end

    local buf_nmap = function(bufnr, lhs, rhs, opts) set_keymap("n", lhs, rhs,
        Merge({ buffer = bufnr }, opts))
    end
    local buf_xmap = function(bufnr, lhs, rhs, opts) set_keymap("x", lhs, rhs,
        Merge({ buffer = bufnr }, opts))
    end
    local buf_set_option = function(bufnr, ...) vim.api.nvim_buf_set_option(bufnr, ...) end

    nmap("<leader>Li", ":LspInfo<CR>", silent)
    nmap("<leader>Ls", ":LspStart<CR>", silent)
    nmap("<leader>LS", ":LspStop<CR>", silent)
    nmap("<leader>Lr", ":LspRestart<CR>", silent)
    nmap("gd", NoLspClient, silent)
    nmap("gD", NoLspClient, silent)
    nmap("gh", NoLspClient, silent)
    nmap("gH", NoLspClient, silent)
    nmap("gi", NoLspClient, silent)
    nmap("gr", NoLspClient, silent)
    nmap("gR", NoLspClient, silent)
    nmap("ga", NoLspClient, silent)
    nmap("gO", NoLspClient, silent)
    nmap("ge", vim.diagnostic.open_float, silent)
    nmap("gp", vim.diagnostic.goto_prev, silent)
    nmap("gn", vim.diagnostic.goto_next, silent)
    nmap("<localleader>f", NoLspClient, silent)

    vim.cmd("au! DiagnosticChanged * lua vim.diagnostic.setqflist({ open = false })")

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
      if bufnr == nil then
        vim.notify("Buffer error")
      else
        -- Used for debugging
        -- vim.notify("Attached " .. client.config.name)
      end
      -- Enable completion triggered by <C-x><C-o>
      buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

      vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "LspDiagnosticsSignError" })
      vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "LspDiagnosticsSignWarning" })
      vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "LspDiagnosticsSignHint" })
      vim.fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "LspDiagnosticsSignInformation" })

      -- See `:help vim.lsp.*` for documentation on any of the below functions
      buf_nmap(bufnr, "gd", ":Telescope lsp_definitions<CR>", silent)
      buf_nmap(bufnr, "gD", ":Telescope lsp_type_definitions<CR>", silent)
      buf_nmap(bufnr, "gh", vim.lsp.buf.hover, silent)
      buf_nmap(bufnr, "gH", vim.lsp.buf.signature_help, silent)
      buf_nmap(bufnr, "gi", ":Telescope lsp_implementations<CR>", silent)
      buf_nmap(bufnr, "gr", ":Telescope lsp_references<CR>", silent)
      buf_nmap(bufnr, "gR", vim.lsp.buf.rename, silent)
      buf_nmap(bufnr, "ga", vim.lsp.buf.code_action, silent)
      buf_nmap(bufnr, "ge", vim.diagnostic.open_float, silent)

      if client.resolved_capabilities.document_formatting then
        buf_nmap(bufnr, "<localleader>f", function() vim.lsp.buf.formatting_sync(nil, 4000) end, silent)
        buf_xmap(bufnr, "<localleader>f", function() vim.lsp.buf.range_formatting(nil, 4000) end, silent)
        vim.cmd([[
          aug LspFormat
            au! * <buffer>
            au BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)
          aug END
        ]])
      end

      require("illuminate").on_attach(client)
      require("lsp_signature").on_attach({
        bind = true,
        doc_lines = 10,
        floating_window_above_cur_line = false,
        handler_opts = {
          border = "rounded"
        },
      })
    end
    local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

    local null_ls = require("null-ls")
    null_ls.setup {
      on_attach = on_attach,
      sources = {
        null_ls.builtins.code_actions.eslint_d,
        null_ls.builtins.code_actions.shellcheck,
        null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.diagnostics.jsonlint,
        null_ls.builtins.diagnostics.markdownlint,
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.diagnostics.stylelint,
        null_ls.builtins.diagnostics.tidy,
        null_ls.builtins.diagnostics.yamllint,
        null_ls.builtins.formatting.prettierd,
      }
    }

    local disable_formatting = function(opts)
      local orig_on_attach = opts.on_attach
      opts.on_attach = function(client, ...)
        client.resolved_capabilities.document_formatting = false
        orig_on_attach(client, ...)
      end
      return opts
    end

    local get_options = function(enhance)
      local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
      }
      if type(enhance) == "function" then
        enhance(opts)
      end
      return opts
    end

    local server_opts = {
      bashls = get_options(),
      cssls = get_options(disable_formatting),
      html = get_options(disable_formatting),
      jsonls = get_options(function(opts)
        disable_formatting(opts)
        -- Range formatting for entire document
        opts.commands = {
          Format = {
            function()
              vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
            end
          }
        }
      end),
      kotlin_language_server = get_options(function(opts)
        opts.settings = {
          ["kotlin-language-server"] = {
            cmd_env = {
              PATH = vim.env.JAVA_HOME .. "/bin:" .. vim.env.PATH,
              JAVA_HOME = vim.env.JAVA_HOME,
            }
          }
        }
      end),
      rust_analyzer = get_options(function(opts)
        opts.settings = {
          ["rust-analyzer"] = {
            assist = {
              importgroup = false,
              importprefix = "by_crate",
            },
            cargo = {},
            checkonsave = { command = "clippy" },
          }
        }
      end),
      sumneko_lua = get_options(function(opts)
        opts.settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" }
            },
            runtime = {
              version = "LuaJIT",
            },
            workspace = {
              checkThirdParty = false,
            }
          }
        }
      end),
      tsserver = get_options(disable_formatting),
      vimls = get_options(),
      yamlls = get_options(),
    }

    require("nvim-lsp-installer").setup {
      automatic_installation = true,
      ui = {
        check_outdated_servers_on_open = true,
      }
    }

    local lspconfig = require("lspconfig")
    for server, opts in pairs(server_opts) do
      local load_config = loadfile(vim.fn.getcwd() .. "/.lspconfig.lua")
      if load_config ~= nil then
        local enhance_opts = load_config()
        if enhance_opts ~= nil and enhance_opts[server] then
          enhance_opts[server](opts)
        end
      end
      if server == "rust_analyzer" then
        require("rust-tools").setup {
          -- We don't want to call lspconfig.rust_analyzer.setup() when using
          -- rust-tools. See
          -- * https://github.com/simrat39/rust-tools.nvim/issues/89
          server = opts,
          tools = {
            inlay_hints = {
              only_current_line_au = "CursorHold,CursorHoldI",
              show_parameter_hints = false,
              highlight = "VirtualTextInfo",
              parameter_hints_prefix = " ← ",
              other_hints_prefix = " ▸ ",
            },
          },
        }
      else
        lspconfig[server].setup(opts)
      end
    end
  end
})

-- -----------------------------------------------------------------------------
-- Auto-Completion
-- -----------------------------------------------------------------------------

Plug("hrsh7th/cmp-nvim-lsp") -- LSP completion source
Plug("hrsh7th/cmp-buffer") -- Buffer completion source
Plug("hrsh7th/cmp-path") -- Path completion source
Plug("hrsh7th/cmp-cmdline") -- Command completion source
Plug("quangnguyen30192/cmp-nvim-ultisnips") -- Ultisnips completion source
-- Auto-completion library
Plug("hrsh7th/nvim-cmp", {
  config = function()
    local cmp = require("cmp")
    local next_item = function(fallback)
      if cmp.visible() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end
    local prev_item = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end

    cmp.setup {
      preselect = cmp.PreselectMode.None,
      snippet = {
        expand = function(args) vim.fn["UltiSnips#Anon"](args.body) end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = {
        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        ["<C-n>"] = cmp.mapping({
          c = next_item,
          i = next_item,
        }),
        ["<C-p>"] = cmp.mapping({
          c = prev_item,
          i = prev_item,
        }),
      },
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "ultisnips" },
      }, {
        { name = "path" },
      }, {
        { name = "buffer" },
      }),
      cmdline = {
        ["/"] = {
          sources = {
            { name = "buffer" }
          }
        },
        [":"] = {
          sources = cmp.config.sources({
            { name = "path" }
          }, {
            { name = "cmdline" }
          })
        },
      },
      experimental = {
        ghost_text = true,
      },
    }
  end
})
Plug("SirVer/ultisnips", {
  config = function()
    -- Fixes Ctrl-X Ctrl-K https://github.com/SirVer/ultisnips/blob/master/doc/UltiSnips.txt#L263
    imap("<C-x><C-k>", "<C-x><C-k>")
    nmap("<leader>es", ":UltiSnipsEdit<CR>")
    vim.g.UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
    vim.g.UltiSnipsListSnippets = "<c-x><c-s>"
    vim.g.UltiSnipsRemoveSelectModeMappings = 0
    vim.g.UltiSnipsEnableSnipMate = 0
  end
})
Plug("honza/vim-snippets", {
  config = function()
    vim.g.snips_author = vim.fn.system("git config --get user.name | tr -d '\n'")
    vim.g.snips_author_email = vim.fn.system("git config --get user.email | tr -d '\n'")
    vim.g.snips_github = "https://github.com/lukexor"
  end
})
Plug("nvim-treesitter/nvim-treesitter", { -- AST Parser and highlighter
  run = vim.fn[":TSUpdate"],
  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = { "javascript", "lua", "rust" },
      sync_install = false,
      auto_install = true,
    }
  end
})
Plug("nvim-lua/plenary.nvim") -- Async library for other plugins
Plug("nvim-lua/popup.nvim")
Plug("nvim-telescope/telescope-fzf-native.nvim", { run = "make" }) -- Search dependency of telescope
Plug("fhill2/telescope-ultisnips.nvim")
Plug("rcarriga/nvim-notify", { -- Prettier notifications
  config = function()
    require("notify").setup({ background_colour = "#000000" })
    vim.notify = require("notify")
  end
})
Plug("nvim-telescope/telescope.nvim", { -- Fuzzy finder
  config = function()
    local telescope = require("telescope")
    telescope.setup {}
    telescope.load_extension("notify")
    telescope.load_extension("ultisnips")
    telescope.load_extension("fzf")

    nmap("<leader>f", ":Telescope fd<CR>")
    nmap("<leader>A", ":Telescope fd find_command=rg,--files,--hidden,--no-ignore,--glob,!.git<CR>")
    nmap("<leader>b", ":Telescope buffers<CR>")
    nmap("<leader>B", ":Telescope current_buffer_fuzzy_find<CR>")
    nmap("<leader>C", ":Telescope commands<CR>")
    nmap("<leader>H", ":Telescope oldfiles<CR>")
    nmap("<leader>T", ":Telescope help_tags<CR>")
    nmap("<leader>S", ":Telescope lsp_document_symbols<CR>")
    nmap("<leader>U", ":Telescope ultisnips<CR>")
    nmap("<leader>M", ":Telescope marks<CR>")
    nmap("<leader>K", ":Telescope keymaps<CR>")
    nmap("<leader>r", ":Telescope live_grep<CR>")
    nmap("<leader>F", ":Telescope git_files<CR>")
    nmap("<leader>gb", ":Telescope git_branches<CR>")
    nmap("<leader>gc", ":Telescope git_commits<CR>")
    nmap("<leader>gC", ":Telescope git_bcommits<CR>")
  end
})

-- -----------------------------------------------------------------------------
-- Language Support
-- -----------------------------------------------------------------------------

Plug("sheerun/vim-polyglot", {
  preload = function()
    vim.g.polyglot_disabled = { "autoindent" } -- Let vim-sleuth do it
  end,
  config = function()
    -- HTML:       othree/html5.vim
    -- Javascript: pangloss/vim-javascript
    -- JSON:       elzr/vim-json
    -- JSX:        MaxMEllon/vim-jsx-pretty
    -- Kotlin:     udalov/kotlin-vim
    -- Lua:        tbastos/vim-lua
    -- Markdown:   plasticboy/vim-markdown
    -- Python:     vim-python/python-syntax
    -- Rust:       rust-lang/rust.vim
    -- Swift:      keith/swift.vim
    -- TOML:       cespare/vim-toml
    -- Typescript: HerringtonDarkholme/yats.vim
    vim.g.rustfmt_autosave = 1
    vim.g.rust_clip_command = "pbcopy"
    -- Lua GetLuaIndent is not accurate
    vim.cmd("au BufEnter *.lua set indentexpr= smartindent")
  end
})
Plug("stephpy/vim-yaml") -- Not provided by vim-polyglot

-- -----------------------------------------------------------------------------
-- Testing/Debugging
-- -----------------------------------------------------------------------------

-- Tame the quickfix window
Plug("romainl/vim-qf", {
  config = function()
    nmap("[q", "<Plug>(qf_qf_previous)")
    nmap("]q", "<Plug>(qf_qf_next)")
    nmap("<leader>ct", "<Plug>(qf_qf_toggle)")
    -- Clear quickfix
    nmap("<leader>cc", ":cexpr []")
  end
})
Plug("vim-test/vim-test", {
  config = function()
    nmap("<leader>Tn", ":TestNearest<CR>")
    nmap("<leader>Tf", ":TestFile<CR>")
    nmap("<leader>Ts", ":TestSuite<CR>")
    nmap("<leader>Tl", ":TestLast<CR>")
    nmap("<leader>Tv", ":TestVisit<CR>")
  end
})
-- Debugger
Plug("puremourning/vimspector", {
  on = {
    "<Plug>VimspectorLaunch",
    "<Plug>VimspectorToggleBreakpoint",
    "<Plug>VimspectorToggleConditionalBreakpoint"
  },
  preload = function()
    nmap("<localleader>dd", "<Plug>VimspectorLaunch")
    nmap("<localleader>db", "<Plug>VimspectorToggleBreakpoint")
    nmap("<localleader>dB", "<Plug>VimspectorToggleConditionalBreakpoint")
  end,
  config = function()
    vim.g.vimspector_install_gadgets = {
      "CodeLLDB",
      "debugger-for-chrome",
      "vscode-bash-debug",
    }

    -- mnemonic di = debug inspect
    nmap("<localleader>dc", "<Plug>VimspectorContinue")
    nmap("<localleader>dp", "<Plug>VimspectorPause")
    nmap("<localleader>dq", "<Plug>VimspectorStop")
    nmap("<localleader>do", "<Plug>VimspectorStepOver")
    nmap("<localleader>di", "<Plug>VimspectorStepInto")
    nmap("<localleader>dO", "<Plug>VimspectorStepOut")
    nmap("<localleader>dr", "<Plug>VimspectorRunToCursor")
    nmap("<localleader>dR", "<Plug>VimspectorRestart")
    nmap("<localleader>de", "<Plug>VimspectorBalloonEval")
    xmap("<localleader>de", "<Plug>VimspectorBalloonEval")
  end
})

Plug.ends();

-- =============================================================================
-- Abbreviations
-- =============================================================================

vim.cmd("iabbrev .. =>")
vim.cmd("iabbrev adn and")
vim.cmd("iabbrev liek like")
vim.cmd("iabbrev liekwise likewise")
vim.cmd("iabbrev pritn print")
vim.cmd("iabbrev retrun return")
vim.cmd("iabbrev teh the")
vim.cmd("iabbrev tehn then")
vim.cmd("iabbrev tihs this")
vim.cmd("iabbrev waht what")

function ToggleDigraphs()
  local digraphs = {
    copyright = "©",
    registered = "®",
    degrees = "°",
    ["+-"] = "±",
    ["1S"] = "¹",
    ["2S"] = "²",
    ["3S"] = "³",
    ["14F"] = "¼",
    ["12F"] = "½",
    ["34F"] = "¾",
    multiply = "×",
    divide = "÷",
    alpha = "α",
    beta = "β",
    delta = "δ",
    epsilon = "ε",
    theta = "θ",
    lambda = "λ",
    mu = "μ",
    pi = "π",
    rho = "ρ",
    sigma = "σ",
    tau = "τ",
    phi = "φ",
    omega = "ω",
    ["<-"] = "←",
    ["-^"] = "↑",
    ["->"] = "→",
    ["-v"] = "↓",
    ["<->"] = "↔",
    ["^-v"] = "↕",
    ["<="] = "⇐",
    ["=>"] = "⇒",
    ["<=>"] = "⇔",
    sqrt = "√",
    inf = "∞",
    ["!="] = "≠",
    ["=<"] = "≤",
    [">="] = "≥",
  }

  if vim.g.digraphs_enabled == 1 then
    local cmd = 'exe ":iunabbrev %s"'
    for abbr, _ in pairs(digraphs) do
      vim.cmd(cmd:format(abbr))
    end
    vim.g.digraphs_enabled = 0
    vim.notify("Digraphs Disabled")
  else
    local cmd = 'exe ":iabbrev %s %s"'
    for abbr, symbol in pairs(digraphs) do
      vim.cmd(cmd:format(abbr, symbol))
    end
    vim.g.digraphs_enabled = 1
    vim.notify("Digraphs Enabled")
  end
end

nmap("<leader>I", ":lua ToggleDigraphs()<CR>", silent)

-- =============================================================================
-- Autocommands
-- =============================================================================

vim.cmd([[
  aug FileTypeOverrides
    au!
    au TermOpen * setlocal nospell nonu nornu | startinsert
    au BufRead,BufNewFile *.nu set ft=nu
    au Filetype help set nu rnu
    au Filetype * set formatoptions=croqnjp
    au Filetype markdown set comments=
  aug END
]])

function GoyoEnter()
  vim.fn.system("tmux set status off")

  vim.opt.showmode = false
  vim.opt.showcmd = false
  vim.opt.list = false
  vim.opt.scrolloff = 999
  vim.opt.showtabline = 0

  vim.g.gruvbox_material_show_eob = 0
  vim.cmd("colorscheme gruvbox-material")
  vim.cmd("SignatureToggleSigns")
end

function GoyoLeave()
  vim.fn.system("tmux set status on")

  vim.opt.showmode = true
  vim.opt.showcmd = true
  vim.opt.list = true
  vim.opt.scrolloff = 8
  vim.opt.showtabline = 1

  vim.g.gruvbox_material_show_eob = 1
  vim.cmd("colorscheme gruvbox-material")
  vim.cmd("SignatureToggleSigns")
end

vim.cmd([[
  aug Goyo
    au!
    au User GoyoEnter nested lua GoyoEnter()
    au User GoyoLeave nested lua GoyoLeave()
  aug END
]])

function FindExecCmd()
  local line = vim.fn.search("^!!:.*")
  if line > 0 then
    local command = vim.fn.substitute(vim.fn.getline(line), "^!!:", "", "")
    vim.cmd(("silent !%s"):format(command))
    vim.cmd("normal gg0")
    vim.cmd("redraw!")
  end
end

function TogglePresentMode()
  if vim.fn.exists("#goyo") ~= 0 then
    PresentLeave()
  else
    PresentEnter()
  end
end

function PresentEnter()
  nmap("l", ":n<CR>gg0", { silent = true })
  nmap("h", ":N<CR>gg0", { silent = true })
  nmap("<leader>E", ":lua FindExecCmd()<CR>")
  nmap("<leader>P", ":lua TogglePresentMode()<CR>")

  vim.opt.textwidth = 140
  vim.opt.colorcolumn = "138"
  vim.opt.splitbelow = false
  vim.opt.splitright = false
  vim.cmd("Goyo 145x40")
  vim.cmd("normal gg0")
end

function PresentLeave()
  nunmap("l")
  nunmap("h")

  vim.cmd("Goyo!")
  vim.cmd("hi! ColorColumn ctermbg=238 guibg=#333333")
  vim.opt.splitbelow = true
  vim.opt.splitright = true
end

vim.cmd([[
  aug PresentationMode
    au!
    au BufRead,BufNewFile *.vpm set ft=vpm
    au BufRead *.vpm lua FindExecCmd()
    au BufRead *.vpm if filereadable('syntax.vim') | source syntax.vim | endif
    au VimEnter *.vpm lua PresentEnter()
  aug END
]])

vim.cmd([[
  aug Init
    au!
    " Jump to the last known cursor position. See |last-position-jump|.
    au BufReadPost *
      \ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe 'normal! g`"' |
      \ endif
    au VimEnter * helptags ~/.config/nvim/doc
    au CmdwinEnter *
        \ echohl Todo |
        \ echo 'You discovered the command-line window! You can close it with ":q".' |
        \ echohl None
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup="Search", timeout=300, on_visual=false }
  aug END
]])
