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

-- Don"t use nvim as a pager within itself
vim.env.PAGER = "less"
-- Ensure a vim-compatible shell
vim.env.SHELL = "/bin/bash"
vim.o.shell = vim.env.SHELL
-- https://neovim.io/doc/user/provider.html
vim.g.python3_host_prog = "python3"
-- Highlight strings and numbers inside comments
vim.g.c_comment_strings = 1

vim.o.breakindent = true
vim.o.cmdheight = 2
vim.o.completeopt = "menu,menuone,noselect"
vim.o.confirm = true
vim.o.cursorline = true
vim.o.dictionary = "/usr/share/dict/words"
-- Make diffing better: https://vimways.org/2018/the-power-of-diff/
vim.opt.diffopt:append { "iwhite", "algorithm:patience", "indent-heuristic" }
vim.o.expandtab = true
vim.o.foldlevelstart = 99
vim.o.foldmethod = "indent"
vim.o.incsearch = true
vim.o.list = true
vim.o.listchars = "tab:│ ,trail:+,extends:,precedes:,nbsp:‗"
vim.opt.matchpairs:append { "<:>" }
vim.o.mouse = ""
vim.o.number = true
vim.opt.path:append { "**" }
vim.o.redrawtime = 10000 -- Allow more time for loading syntax on large files
vim.o.relativenumber = true
vim.o.scrolloff = 8
vim.o.shiftround = true
vim.o.shiftwidth = 2
vim.o.showmatch = true
vim.o.sidescrolloff = 8
vim.o.signcolumn = "yes:2"
vim.o.spellfile = vim.env.HOME .. "/.config/nvim/spell.utf-8.add"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.synmaxcol = 200
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.textwidth = 80
vim.o.title = true
vim.o.undofile = true
vim.o.updatecount = 50 -- Save more often than 200 characters typed.
vim.o.updatetime = 300 -- Save more often than 4 seconds.
vim.o.virtualedit = "block"
vim.o.wildmode = "longest:full,full"
vim.o.wrap = false

if vim.fn.executable("rg") then
  vim.o.grepprg = "rg --no-heading --vimgrep"
  vim.o.grepformat = "%f:%l:%c:%m"
else
  vim.notify_once("rg is not installed", vim.log.levels.ERROR)
end



-- =============================================================================
-- Key Maps
-- =============================================================================

vim.g.mapleader = " "
vim.g.maplocalleader = ","

function Merge(a, b)
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

  return MergeR(MergeR({}, a or {}), b or {})
end

local set_keymap = function(...) vim.keymap.set(...) end
local nmap = function(lhs, rhs, opts) set_keymap("n", lhs, rhs, opts) end
local vmap = function(lhs, rhs, opts) set_keymap("v", lhs, rhs, opts) end
local imap = function(lhs, rhs, opts) set_keymap("i", lhs, rhs, opts) end
local omap = function(lhs, rhs, opts) set_keymap("o", lhs, rhs, opts) end

nmap("<leader>ve", ":edit $MYVIMRC<CR>", { desc = "edit init.lua" })
nmap("<leader>vr", ":source $MYVIMRC<CR>:edit<CR>", { desc = "reload init.lua" })

nmap("<leader>w", ":w<CR>", { desc = "write buffer" })
nmap("<leader>W", ":noa w<CR>", { desc = "write without autocommands" })

nmap("<leader>q", ":confirm q<CR>", { desc = "close window/exit vim" })
nmap("<leader>Q", ":confirm qall<CR>", { desc = "exit vim" })
nmap("<leader>O", ":%bd|e#|bd#<CR>", { desc = "close all but current" })

nmap("x", '"_x', { desc = "del character(s) under/after cursor into blackhole" })
nmap("X", '"_X', { desc = "del character(s) before cursor into blackhole" })

nmap("Q", "<nop>", { desc = "disable Q for ExMode, use gQ instead" })

nmap("<leader><CR>", ":nohlsearch|diffupdate|normal !<C-l><CR>", { desc = "clear search highlighting" })

nmap("<leader>ef", ":edit <cfile><CR>", { desc = "edit file" })
nmap("gt", "<C-]>", { desc = "go to tag" })

nmap("<C-h>", "<C-w>h", { desc = "go to Nth left window" })
nmap("<C-j>", "<C-w>j", { desc = "go to Nth below window" })
nmap("<C-k>", "<C-w>k", { desc = "go to Nth above window" })
nmap("<C-l>", "<C-w>l", { desc = "go to Nth right window" })

nmap("<leader>-", "<C-w>_<C-w>|", { desc = "maximize window" })
nmap("<leader>=", "<C-w>=", { desc = "make all windows equal size" })

nmap("<leader>h", ":bp<CR>", { silent = true, desc = "go to previous buffer" })
nmap("<leader>l", ":bn<CR>", { silent = true, desc = "go to next buffer" })
nmap("<leader><leader>", "<C-^>", { desc = "alternate buffer" })

-- Show diffs in a modified buffer
vim.api.nvim_create_user_command("DiffOrig",
  "vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis", {})

-- Reselect visual after indenting
vmap("<", "<gv", { desc = "shift {motion} lines leftwards" })
vmap(">", ">gv", { desc = "shift {motion} lines rightwards" })

vmap("p", '"_dP', { desc = "replace selection without yanking" })
nmap("+", 'V"_dP', { desc = "replace current line with yank" })

-- "==" honors indent
nmap("<leader>j", ":m .+1<CR>==", { silent = true, desc = "move line upwards" })
nmap("<leader>k", ":m .-2<CR>==", { silent = true, desc = "move line downwards" })

nmap("<localleader>w", [[&fo =~ 't' ? ":set fo-=t<CR>" : ":set fo+=t<CR>"]],
  { expr = true, desc = "toggle text auto-wrap" })

-- Keep cursor centered
nmap("n", "nzzzv", { desc = "repeat latest / or ?" })
nmap("N", "Nzzzv", { desc = "repeat latest / or ? in reverse" })
nmap("J", "mzJ`z", { desc = "join lines" })
nmap("*", "*zzzv", { desc = "search forward" })
nmap("#", "#zzzv", { desc = "search backwards" })
nmap("g*", "g*zzzv", { desc = "search forwards without word boundary" })
nmap("g#", "g*zzzv", { desc = "search backwards without word boundary" })

nmap("<leader>G", ":silent lgrep ", { desc = "grep" })
nmap("<localleader>S", ":%s//g<left><left>", { desc = "global search and replace" })
nmap("<localleader>Tb", ":%s/\\s\\+$//<CR>", { desc = "trim trailing blanks" })
vmap("<C-r>", '"hy:%s/<C-r>h//g<left><left>', { desc = "search and replace selection" });

nmap("<localleader>x", function()
  if vim.fn.has("linux") == 1 then
    vim.cmd("!xdg-open %")
  elseif vim.fn.has("mac") == 1 then
    vim.cmd("!open %")
  else
    vim.notify("unable to open file", vim.log.levels.ERROR, { title = "open external file" })
  end
end, { expr = true, desc = "open external file" })

imap("jj", "<Esc>", { desc = "escape" })
imap("<C-c>", "<Esc>", { desc = "escape" })

nmap(";;", "A;<Esc>", { desc = "append ;" })
nmap(",,", "A,<Esc>", { desc = "append ," })
imap(";;", "<Esc>A;<Esc>", { desc = "append ;" })
imap(",,", "<Esc>A,<Esc>", { desc = "append ," })

-- Add breaks in undo chain when typing punctuation
imap(".", ".<C-g>u", { desc = "." })
imap(",", ",<C-g>u", { desc = "," })
imap("!", "!<C-g>u", { desc = "!" })
imap("?", "?<C-g>u", { desc = "?" })

-- Add relative jumps of more than 5 lines to jump list
-- Move by terminal rows, not lines, unless count is provided
nmap("j", [[v:count > 0 ? "m'" . v:count . 'j' : "gj"]], { expr = true, desc = "go down a line" })
nmap("k", [[v:count > 0 ? "m'" . v:count . 'k' : "gk"]], { expr = true, desc = "go up a line" })

nmap("<S-Down>", ":resize -5<CR>", { desc = "shrink window height" })
nmap("<S-Up>", ":resize +5<CR>", { desc = "increase window height" })
nmap("<S-Left>", ":vertical resize +5<CR>", { desc = "shrink window width" })
nmap("<S-Right>", ":vertical resize -5<CR>", { desc = "increase window width" })

nmap("cd",
  function()
    local pathname = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
    vim.cmd(("lcd %s"):format(pathname))
    vim.notify(("lcd %s"):format(pathname))
  end,
  { desc = "cd to current file path" }
)

nmap("cy", '"*y', { desc = "yank to clipboard" })
nmap("cY", '"*Y', { desc = "yank line to clipboard" })
nmap("cyy", '"*yy', { desc = "yank line to clipbard" })
vmap("cy", '"*y', { desc = "yank selection to clipboard" })
nmap("cp", '"*p', { desc = "paste from clipboard after cursor" })
nmap("cP", '"*P', { desc = "paste from clipboard before cursor" })

omap("in(", ":<C-u>normal! f(vi(<CR>", { silent = true, desc = "inner next () block" })
omap("il(", ":<C-u>normal! F)vi(<CR>", { silent = true, desc = "inner last () block" })
omap("an(", ":<C-u>normal! f(va(<CR>", { silent = true, desc = "around next () block" })
omap("al(", ":<C-u>normal! F)va(<CR>", { silent = true, desc = "around last () block" })
vmap("in(", ":<C-u>normal! f(vi(<CR><Esc>gv", { silent = true, desc = "inner next () block" })
vmap("il(", ":<C-u>normal! F)vi(<CR><Esc>gv", { silent = true, desc = "inner last () block" })
vmap("an(", ":<C-u>normal! f(va(<CR><Esc>gv", { silent = true, desc = "around next () block" })
vmap("al(", ":<C-u>normal! F)va(<CR><Esc>gv", { silent = true, desc = "around last () block" })

omap("in{", ":<C-u>normal! f{vi{<CR>", { silent = true, desc = "inner next {} block" })
omap("il{", ":<C-u>normal! F{vi{<CR>", { silent = true, desc = "inner last {} block" })
omap("an{", ":<C-u>normal! f{va{<CR>", { silent = true, desc = "around next {} block" })
omap("al{", ":<C-u>normal! F{va{<CR>", { silent = true, desc = "around last {} block" })
vmap("in{", ":<C-u>normal! f{vi{<CR><Esc>gv", { silent = true, desc = "inner next {} block" })
vmap("il{", ":<C-u>normal! F{vi{<CR><Esc>gv", { silent = true, desc = "inner last {} block" })
vmap("an{", ":<C-u>normal! f{va{<CR><Esc>gv", { silent = true, desc = "around next {} block" })
vmap("al{", ":<C-u>normal! F{va{<CR><Esc>gv", { silent = true, desc = "around last {} block" })

omap("in[", ":<C-u>normal! f[vi[<CR>", { silent = true, desc = "inner next [] block" })
omap("il[", ":<C-u>normal! F[vi[<CR>", { silent = true, desc = "inner last [] block" })
omap("an[", ":<C-u>normal! f[va[<CR>", { silent = true, desc = "around next [] block" })
omap("al[", ":<C-u>normal! F[va[<CR>", { silent = true, desc = "around last [] block" })
vmap("in[", ":<C-u>normal! f[vi[<CR><Esc>gv", { silent = true, desc = "inner next [] block" })
vmap("il[", ":<C-u>normal! F[vi[<CR><Esc>gv", { silent = true, desc = "inner last [] block" })
vmap("an[", ":<C-u>normal! f[va[<CR><Esc>gv", { silent = true, desc = "around next [] block" })
vmap("al[", ":<C-u>normal! F[va[<CR><Esc>gv", { silent = true, desc = "around last [] block" })

vmap("af", ":<C-u>silent! normal! [zV]z<CR>", { silent = true, desc = "around fold" })
omap("af", ":normal Vaf<CR>", { silent = true, desc = "around fold" })

function IndentTextObj(around)
  local curcol = vim.fn.col(".")
  local curline = vim.fn.line(".")
  local lastline = vim.fn.line("$")
  local blank_line_pat = "^%s*$"

  local i = vim.fn.indent(vim.fn.line(".")) - vim.o.shiftwidth * (vim.v.count1 - 1)
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

omap("ii", ":<C-u>lua IndentTextObj(true)<CR>", { silent = true, desc = "inner indent" })
omap("ai", ":<C-u>lua IndentTextObj(false)<CR>", { silent = true, desc = "around indent" })
vmap("ii", ":<C-u>lua IndentTextObj(true)<CR><Esc>gv", { silent = true, desc = "inner indent" })
vmap("ai", ":<C-u>lua IndentTextObj(false)<CR><Esc>gv", { silent = true, desc = "around indent" })

nmap("<localleader>i", function()
  local line = vim.fn.line(".")
  local col = vim.fn.col(".")
  local hi = vim.fn.synIDattr(vim.fn.synID(line, col, 1), "name")
  local trans = vim.fn.synIDattr(vim.fn.synID(line, col, 0), "name")
  local lo = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.synID(line, col, 0)), "name")
  vim.cmd(("echo 'hi<%s> trans<%s> lo<%s>'"):format(hi, trans, lo))
end, { desc = "show syntax ID under cursor" })

nmap("<leader>\\", function()
  if vim.o.nu or vim.o.rnu or vim.o.list then
    vim.cmd("set nornu nonu nolist signcolumn=no")
  else
    vim.cmd("set rnu nu list signcolumn=yes:2")
  end
end, { desc = "toggle gutter and signs" })

nmap("<localleader>ab", ":.!toilet -w 200 -f term -F border<CR>", { desc = "ascii art border" })
nmap("<localleader>as", ":.!figlet -w 200 -f standard<CR>", { desc = "ascii art standard" })
nmap("<localleader>aS", ":.!figlet -w 200 -f small<CR>", { desc = "ascii art small" })


-- =============================================================================
-- Plugins
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Disable built-in plugins
-- -----------------------------------------------------------------------------

local disabled_built_ins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "tar",
  "tarPlugin",
  "tutor",
  "rplugin",
  "rrhelper",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- -----------------------------------------------------------------------------
  -- Global Dependencies
  -- -----------------------------------------------------------------------------
  {
    "rcarriga/nvim-notify", -- Prettier notifications
    lazy = false,
    priority = 1000,
  },
  -- -----------------------------------------------------------------------------
  -- VIM Enhancements
  -- -----------------------------------------------------------------------------
  "nathom/filetype.nvim", -- lua replacement of filetype.vim
  {
    "nickeb96/fish.vim",  -- fish shell support
    ft = "fish",
  },
  {
    "famiu/bufdelete.nvim", -- Keep window layout when deleting buffers
    keys = {
      { "<leader>D", ":confirm Bdelete<CR>", desc = "delete buffer" }
    }
  },
  {
    "ap/vim-buftabline", -- Better buffer management
    enabled = function()
      return vim.bo.filetype ~= "vpm"
    end,
    event = "BufAdd",
    keys = {
      { "<leader>1", "<Plug>BufTabLine.Go(1)", desc = "go to buffer tab 1" },
      { "<leader>2", "<Plug>BufTabLine.Go(2)", desc = "go to buffer tab 2" },
      { "<leader>3", "<Plug>BufTabLine.Go(3)", desc = "go to buffer tab 3" },
      { "<leader>4", "<Plug>BufTabLine.Go(4)", desc = "go to buffer tab 4" },
      { "<leader>5", "<Plug>BufTabLine.Go(5)", desc = "go to buffer tab 5" },
      { "<leader>6", "<Plug>BufTabLine.Go(6)", desc = "go to buffer tab 6" },
      { "<leader>7", "<Plug>BufTabLine.Go(7)", desc = "go to buffer tab 7" },
      { "<leader>8", "<Plug>BufTabLine.Go(8)", desc = "go to buffer tab 8" },
      { "<leader>9", "<Plug>BufTabLine.Go(9)", desc = "go to buffer tab 9" },
      { "<leader>0", "<Plug>BufTabLine.Go(-1)", desc = "go to last buffer tab" },
    },
    init = function()
      vim.g.buftabline_show = 2    -- always
      vim.g.buftabline_numbers = 2 -- ordinal numbers
      vim.g.buftabline_indicators = 1
    end,
  },
  {
    "tpope/vim-repeat", -- Repeat with "."
    event = "VeryLazy",
  },
  "tpope/vim-sleuth",    -- Smart buffer options based on contents
  {
    "ggandor/leap.nvim", -- Better movement with s/S, x/X, and gS
    event = "InsertEnter",
    config = function()
      require("leap").add_default_mappings()
    end
  },
  "ypcrts/securemodelines",        -- Safe modelines
  "editorconfig/editorconfig-vim", -- Parses .editorconfig
  {
    "kshenoy/vim-signature",       -- Show marks in gutter
    event = "VeryLazy"
  },
  {
    "terryma/vim-smooth-scroll", -- Less jarring scroll
    keys = {
      {
        "<C-u>",
        ":call smooth_scroll#up(&scroll, 5, 1)<CR>",
        desc = "small scroll up",
        silent = true,
      },
      {
        "<C-d>",
        ":call smooth_scroll#down(&scroll, 5, 1)<CR>",
        desc = "small scroll down",
        silent = true,
      },
      {
        "<C-b>",
        ":call smooth_scroll#up(&scroll*2, 10, 3)<CR>",
        desc = "large scroll up",
        silent = true,
      },
      {
        "<C-f>",
        ":call smooth_scroll#down(&scroll*2, 10, 3)<CR>",
        desc = "large scroll down",
        silent = true,
      },
    },
  },
  -- -----------------------------------------------------------------------------
  -- Documentation
  -- -----------------------------------------------------------------------------
  {
    "sudormrfbin/cheatsheet.nvim", -- Cheatsheet Search
    cmd = { "Cheatsheet", "CheatsheetEdit" },
    keys = {
      { "<localleader>C", ":Cheatsheet<CR>", desc = "cheatsheet" },
      { "<localleader>E", ":CheatsheetEdit<CR>", desc = "edit cheatsheet" },
    },
  },
  {
    "dbeniamine/cheat.sh-vim", -- Online Cheat.sh lookup
    cmd = { "Cheat" },
    keys = {
      { "<leader>cs", ":Cheat ", desc = "search cheat.sh" },
    },
    init = function()
      vim.g.CheatSheetStayInOrigBuf = 0
      vim.g.CheatSheetDoNotMap = 1
      vim.g.CheatDoNotReplaceKeywordPrg = 1
    end,
  },
  {
    "stevearc/aerial.nvim", -- File symbol outline to TagBar
    cmd = "AerialToggle",
    keys = {
      { "<leader>to", ":AerialToggle<CR>", desc = "toggle symbol outline" },
    },
    opts = {
      layout = {
        min_width = 40,
        default_direction = "prefer_right"
      },
    },
  },
  {
    "folke/which-key.nvim", -- Show mappings as you type
    event = "VeryLazy",
    opts = {
      plugins = {
        spelling = {
          enabled = true,
        },
      },
    },
  },
  -- -----------------------------------------------------------------------------
  -- Code Assists
  -- -----------------------------------------------------------------------------
  {
    "windwp/nvim-ts-autotag", -- Auto-close HTML/JSX tags
    ft = {
      "html",
      "typescriptreact",
    },
    opts = {
      autotag = {
        enable = true,
      }
    }
  },
  {
    "tpope/vim-endwise", -- Auto-add endings for control structures: if, for, etc
    event = "InsertEnter",
  },
  {
    "tpope/vim-commentary", -- Commenting motion commands gc*
    event = "VeryLazy",
  },
  {
    "tpope/vim-surround",
    keys = {
      -- Surround text with punctuation easier 'you surround' + motion
      { '<leader>"', 'ysiw"', remap = true, desc = 'surround text with ""' },
      { "<leader>'", "ysiw'", remap = true, desc = "surround text with ''" },
      { "<leader>(", "ysiw(", remap = true, desc = "surround text with ( )" },
      { "<leader>)", "ysiw)", remap = true, desc = "surround text with ()" },
      { "<leader><", "ysiw>", remap = true, desc = "surround text with <>" },
      { "<leader>>", "ysiw>", remap = true, desc = "surround text with <>" },
      { "<leader>[", "ysiw[", remap = true, desc = "surround text with [ ]" },
      { "<leader>]", "ysiw]", remap = true, desc = "surround text with []" },
      { "<leader>`", "ysiw`", remap = true, desc = "surround text with ``" },
      { "<leader>{", "ysiw{", remap = true, desc = "surround text with { }" },
      { "<leader>}", "ysiw}", remap = true, desc = "surround text with {}" },
      { "<leader>|", "ysiw|", remap = true, desc = "surround text with ||" },
      { "<localleader>rh", "ds'ds}", remap = true, desc = "remove surrounding {''}" },
      { "<localleader>sh", "ysiw}lysiw'", remap = true, desc = "surround text with {''}" },

      -- Same mappers for visual mode
      { '<leader>"', 'gS"', remap = true, mode = "v", desc = 'surround text with ""' },
      { "<leader>'", "gS'", remap = true, mode = "v", desc = "surround text with ''" },
      { "<leader>(", "gS(", remap = true, mode = "v", desc = "surround text with ( )" },
      { "<leader>)", "gS)", remap = true, mode = "v", desc = "surround text with ()" },
      { "<leader><", "gS>", remap = true, mode = "v", desc = "surround text with <>" },
      { "<leader>>", "gS>", remap = true, mode = "v", desc = "surround text with <>" },
      { "<leader>[", "gS[", remap = true, mode = "v", desc = "surround text with [ ]" },
      { "<leader>]", "gS]", remap = true, mode = "v", desc = "surround text with []" },
      { "<leader>`", "gS`", remap = true, mode = "v", desc = "surround text with ``" },
      { "<leader>{", "gS{", remap = true, mode = "v", desc = "surround text with { }" },
      { "<leader>}", "gS}", remap = true, mode = "v", desc = "surround text with {}" },
      { "<leader>|", "gS|", remap = true, mode = "v", desc = "surround text with |" },

      -- Surround paragraphs
      { "<localleader>[", "ysip[", remap = true, desc = "surround paragraph with []" },
      { "<localleader>]", "ysip]", remap = true, desc = "surround paragraph with []" },
      { "<localleader>{", "ysip{", remap = true, desc = "surround paragraph with {}" },
      { "<localleader>}", "ysip{", remap = true, desc = "surround paragraph with {}" },
    }
  },
  {
    "junegunn/vim-easy-align", -- Make aligning rows easier
    keys = {
      { "gA", "<Plug>(EasyAlign)", desc = "align text" },
      { "gA", "<Plug>(EasyAlign) ", mode = "v", desc = "align selection" },
    }
  },
  {
    "glts/vim-radical", -- Number conversions
    dependencies = {
      "glts/vim-magnum",
    },
    lazy = true,
    keys = {
      { "gC", "<Plug>RadicalView", desc = "show number conversions under cursor" },
      { "gC", "<Plug>RadicalView", mode = "v", desc = "show number conversions under selection" },
      { "crd", "<Plug>RadicalCoerceToDecimal", desc = "convert number to decimal" },
      { "crx", "<Plug>RadicalCoerceToHex", desc = "convert number to hex" },
      { "cro", "<Plug>RadicalCoerceToOctal", desc = "convert number to octal" },
      { "crb", "<Plug>RadicalCoerceToBinary", desc = "convert number to binary" },
    }
  },
  {
    "zirrostig/vim-schlepp", -- visually move blocks
    lazy = true,
    keys = {
      { "<S-Up>", "<Plug>SchleppUp", mode = "v", desc = "move selection up" },
      { "<S-Down>", "<Plug>SchleppDown", mode = "v", desc = "move selection down" },
      { "<S-Left>", "<Plug>SchleppLeft", mode = "v", desc = "move selection left" },
      { "<S-Right>", "<Plug>SchleppRight", mode = "v", desc = "move selection right" },
    }
  },
  -- -----------------------------------------------------------------------------
  -- System Integration
  -- -----------------------------------------------------------------------------
  {
    "tpope/vim-eunuch", -- unix commands
    cmd = { "Remove", "Delete", "Move", "Rename", "Copy", "Mkdir", "Wall", "SudoWrite", "SudoEdit" }
  },
  {
    "tpope/vim-fugitive", -- git integration
    cmd = { "Git", "Gdiffsplit", "Gvdiffsplit", "GMove", "GBrowse", "GDelete" }
  },
  {
    "iamcco/markdown-preview.nvim", -- markdown browser viewer
    ft = { "markdown" },
    build = vim.fn["mkdp#util#install()"],
    init = function()
      vim.g.mkdp_echo_preview_url = 1
    end
  },
  {
    "preservim/nerdtree", -- file browser
    cmd = { "NERDTree", "NERDTreeFind", "NERDTreeToggle" },
    dependencies = {
      "Xuyuanp/nerdtree-git-plugin",
      "tiagofumo/vim-nerdtree-syntax-highlight",
    },
    keys = {
      {
        "<leader>n",
        "exists('g:NERDTree') && g:NERDTree.IsOpen() ? ':NERDTreeClose<CR>' : @% == ''"
        .. " ? ':NERDTree<CR>' : ':NERDTreeFind<CR>'",
        expr = true,
        desc = "toggle NERDTree"
      },
      { "<leader>N", ":NERDTreeFind<CR>", desc = "find file in NERDTree" },
    },
    init = function()
      vim.g.NERDTreeShowHidden = 1
      vim.g.NERDTreeMinimalUI = 1
      vim.g.NERDTreeWinSize = 35
      vim.g.NERDTreeDirArrowExpandable = '▹'
      vim.g.NERDTreeDirArrowCollapsible = '▿'
      -- Fixes issue with visual select being cancelled when NERDTree is open
      vim.g.NERDTreeGitStatusUpdateOnCursorHold = 0
      vim.g.NERDTreeLimitedSyntax = 1
    end,
    config = function()
      -- Closes if NERDTree is the only open window
      vim.cmd([[au! BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif]])
    end,
  },
  -- -----------------------------------------------------------------------------
  -- Project Management
  -- -----------------------------------------------------------------------------
  {
    "airblade/vim-rooter", -- Find the root project folder
    init = function()
      vim.g.rooter_cd_cmd = "lcd"
      vim.g.rooter_resolve_links = 1
    end
  },
  -- TODO: Create TODO list shortcuts
  {
    "yardnsm/vim-import-cost", -- Javascrpt import sizes
    build = "npm install --production",
    cmd = { "ImportCost" },
    ft = { "typescript", "typescriptreact" },
    keys = {
      { "<localleader>I", ":ImportCost<CR>", desc = "calculate import sizes" },
    },
    init = function()
      vim.g.import_cost_virtualtext_prefix = " ▸ "
    end,
    config = function()
      vim.cmd([[
        aug ImportCost
          au!
          au ColorScheme * hi! link ImportCostVirtualText VirtualTextInfo
        aug END
      ]])
    end
  },
  -- -----------------------------------------------------------------------------
  -- Windowing / Theme
  -- -----------------------------------------------------------------------------
  { "ryanoasis/vim-devicons", lazy = true },
  { "kyazdani42/nvim-web-devicons", lazy = true },
  {
    "stevearc/dressing.nvim", -- Window UI enhancements, popups, input, etc
    lazy = true
  },
  {
    "Shatur/neovim-ayu",
    init = function()
      vim.o.background = "dark"
    end,
    priority = 1000,
    config = function()
      local colors = require('ayu.colors')
      colors.generate()

      vim.cmd(([[
      aug CursorLine
        au!
        au InsertEnter * hi! CursorLine guibg=%s
        au InsertLeave * hi! CursorLine guibg=%s
      aug END
    ]]):format(colors.selection_inactive, colors.panel_bg))

      local ayu = require('ayu')
      ayu.setup {
        overrides = {
          BufTabLineActive = { bg = "none" },
          BufTabLineModifiedActive = { bg = "none" },
          CursorLine = { bg = colors.panel_bg },
          LineNr = { fg = colors.gutter_active },
          Comment = { fg = colors.vcs_modified },
          SpecialComment = { fg = colors.vcs_added },
          Normal = { bg = "none" },
          FloatermBorder = { bg = "none" },
          SignColumn = { bg = "none" },
          TabLine = { bg = "none" },
          TabLineFill = { bg = "none" },
          TabLineSel = { fg = colors.tag, bg = "none" },
          VirtualTextInfo = { fg = colors.selection_bg },
          Visual = { bg = colors.selection_bg },
          DiffAdd = { bg = "none", fg = colors.vcs_added },
          DiffDelete = { bg = "none", fg = colors.vcs_removed },
          DiffChange = { bg = "none", fg = colors.vcs_modified },
          DiffText = { bg = "none", fg = colors.special },
        }
      }
      ayu.colorscheme()
    end
  },
  {
    "nvim-lualine/lualine.nvim", -- statusline
    event = "VeryLazy",
    opts = {
      options = {
        icons_enabled = true,
        theme = "ayu",
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
  },
  -- -----------------------------------------------------------------------------
  -- LSP
  -- -----------------------------------------------------------------------------
  {
    "williamboman/mason.nvim",
    build = function() vim.cmd(":MasonUpdate") end,
    lazy = true,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "rcarriga/nvim-notify",
      "kosayoda/nvim-lightbulb",  -- Lightbulb next to code actions
      "ray-x/lsp_signature.nvim", -- Shows function signatures as you type
      "simrat39/rust-tools.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    keys = {
      { "<leader>Li", ":LspInfo<CR>", desc = "lsp info" },
      { "<leader>LI", ":LspInfo<CR>", desc = "lsp install info" },
      { "<leader>Ls", ":LspStart<CR>", desc = "start lsp server" },
      { "<leader>LS", ":LspStop<CR>", desc = "stop lsp server" },
      { "<leader>Lr", ":LspRestart<CR>", desc = "restart lsp server" },
      { "gd", NoLspClient, desc = "go to definition" },
      { "gD", NoLspClient, desc = "go to type definition" },
      { "gh", NoLspClient, desc = "display symbol information" },
      { "gH", NoLspClient, desc = "display signature information" },
      { "gi", NoLspClient, desc = "go to implementation" },
      { "gr", NoLspClient, desc = "list references" },
      { "gR", NoLspClient, desc = "rename all references to symbol" },
      { "ga", NoLspClient, desc = "select code action" },
      { "ge", vim.diagnostic.open_float, desc = "show diagnostics" },
      { "gp", vim.diagnostic.goto_prev, desc = "go to previous diagnostic" },
      { "gn", vim.diagnostic.goto_next, desc = "go to next diagnostic" },
      { "<localleader>f", "gq", desc = "format buffer" },
    },
    config = function()
      -- Default LSP shortcuts to no-ops for non-supported file types to avoid
      -- confusion with default vim shortcuts.
      function NoLspClient()
        vim.notify("No LSP client attached for filetype: `" .. vim.bo.filetype .. "`.", vim.log.levels.WARN,
          { title = "lsp" })
      end

      vim.fn.sign_define("LightBulbSign", { text = "", texthl = "", linehl = "", numhl = "" })
      require("nvim-lightbulb").setup { autocmd = { enabled = true } }

      local buf_nmap = function(bufnr, lhs, rhs, opts)
        set_keymap("n", lhs, rhs,
          Merge({ buffer = bufnr }, opts))
      end

      vim.cmd("au! DiagnosticChanged * lua vim.diagnostic.setqflist({ open = false })")

      local lsp_format_augroup = vim.api.nvim_create_augroup("LspFormat", {})
      local lsp_format = function(bufnr)
        vim.lsp.buf.format({
          bufnr = bufnr,
          filter = function(client)
            return client.name ~= "ccls" and
                client.name ~= "html" and
                client.name ~= "jsonls" and
                client.name ~= "tsserver"
          end,
        })
      end

      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      local on_attach = function(client, bufnr)
        if bufnr == nil then
          vim.notify_once("on_attach buffer error for " .. client.config.name, vim.log.levels.ERROR, { title = "lsp" })
        else
          vim.notify_once("attached " .. client.config.name, vim.log.levels.INFO, { title = "lsp" })
        end

        vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "LspDiagnosticsSignError" })
        vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "LspDiagnosticsSignWarning" })
        vim.fn.sign_define("DiagnosticSignHint", { text = "ﳵ", texthl = "LspDiagnosticsSignHint" })
        vim.fn.sign_define("DiagnosticSignInformation", { text = "ℹ", texthl = "LspDiagnosticsSignInformation" })

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        buf_nmap(bufnr, "gd", ":Telescope lsp_definitions<CR>", { desc = "go to definition" })
        buf_nmap(bufnr, "gD", ":Telescope lsp_type_definitions<CR>", { desc = "go to type definition" })
        buf_nmap(bufnr, "gh", vim.lsp.buf.hover, { desc = "display symbol information" })
        buf_nmap(bufnr, "gH", vim.lsp.buf.signature_help, { desc = "display signature information" })
        buf_nmap(bufnr, "gi", ":Telescope lsp_implementations<CR>", { desc = "go to implementation" })
        buf_nmap(bufnr, "gr", ":Telescope lsp_references<CR>", { desc = "list references" })
        buf_nmap(bufnr, "gR", vim.lsp.buf.rename, { desc = "rename all references to symbol" })
        buf_nmap(bufnr, "ga", vim.lsp.buf.code_action, { desc = "select code action" })
        buf_nmap(bufnr, "ge", vim.diagnostic.open_float, { desc = "show diagnostics" })

        if client.supports_method("textDocument/formatting") then
          buf_nmap(bufnr, "<localleader>f", function() lsp_format(bufnr) end, { desc = "format buffer" })

          vim.api.nvim_clear_autocmds({ group = lsp_format_augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = lsp_format_augroup,
            buffer = bufnr,
            callback = function() lsp_format(bufnr) end,
          })
        end

        local filtered_diagnostics = {
          [80001] = true -- File is a CommonJS module; it may be converted to an ES module.
        }

        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
          function(err, result, ctx, config)
            for i, diagnostic in pairs(result.diagnostics) do
              if filtered_diagnostics[diagnostic.code] ~= nil then
                table.remove(result.diagnostics, i)
              end
            end
            vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
          end, { update_in_insert = false }
        )

        -- vim.lsp.formatexpr() seems broken with markdownlint/prettier
        if vim.bo.filetype == "markdown" then
          vim.o.formatexpr = ""
        end

        require("lsp_signature").on_attach({
          bind = true,
          doc_lines = 5,
          handler_opts = {
            border = "rounded"
          },
          toggle_key = "<C-p>",
        })
      end
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local null_ls = require("null-ls")
      null_ls.setup {
        on_attach = on_attach,
        sources = {
          null_ls.builtins.code_actions.eslint_d,
          null_ls.builtins.code_actions.shellcheck,
          null_ls.builtins.diagnostics.eslint_d,
          null_ls.builtins.diagnostics.jsonlint,
          null_ls.builtins.diagnostics.markdownlint,
          null_ls.builtins.diagnostics.pylint,
          null_ls.builtins.diagnostics.shellcheck,
          null_ls.builtins.diagnostics.stylelint,
          null_ls.builtins.diagnostics.tidy,
          null_ls.builtins.diagnostics.yamllint,
          null_ls.builtins.formatting.prettierd,
        }
      }

      local get_options = function(enhance)
        local opts = {
          on_attach = on_attach,
          capabilities = capabilities,
          flags = {
            debounce_text_changes = 200,
          }
        }
        if type(enhance) == "function" then
          enhance(opts)
        end
        return opts
      end

      local server_opts = {
        bashls = get_options(),
        cssls = get_options(),
        gopls = get_options(),
        html = get_options(),
        jsonls = get_options(function(opts)
          -- Range formatting for entire document
          opts.commands = {
            Format = {
              function()
                vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
              end
            }
          }
        end),
        pylsp = get_options(),
        ccls = get_options(),
        rust_analyzer = get_options(function(opts)
          opts.settings = {
            ["rust-analyzer"] = {
              assist = {
                emitMustUse = true,
              },
              cargo = {
                features = "all",
                -- target = "x86_64-pc-windows-msvc",
                -- target = "x86_64-unknown-linux-musl",
                buildScripts = {
                  enable = true,
                },
              },
              checkOnSave = {
                command = "clippy",
                features = "all",
                allTargets = true,
                extraEnv = { RUSTUP_TOOLCHAIN = "nightly" },
              },
              imports = {
                group = {
                  enable = false,
                },
              },
              procMacro = {
                enable = true,
              },
              -- Uncomment for debugging
              -- trace = {
              --   server = "verbose",
              -- },
            },
          }
          opts.setup = function(server_opts)
            nmap("<leader>R", ":Make run<CR>", { desc = "cargo run" });
            nmap("<leader>M", ":Make build<CR>", { desc = "cargo build" });
            nmap("<leader>C", ":Make clippy<CR>", { desc = "cargo clippy" });
            require("rust-tools").setup {
              -- We don't want to call lspconfig.rust_analyzer.setup() when using
              -- rust-tools. See https://github.com/simrat39/rust-tools.nvim/issues/89
              server = server_opts,
              tools = {
                inlay_hints = {
                  parameter_hints_prefix = " ← ",
                  other_hints_prefix = " ▸ ",
                  highlight = "VirtualTextInfo",
                },
              },
            }
          end
        end),
        lua_ls = get_options(function(opts)
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
        tsserver = get_options(),
        vimls = get_options(),
        yamlls = get_options(function(opts)
          opts.settings = {
            yaml = {
              keyOrdering = false
            }
          }
        end),
      }

      require("mason").setup({
        ui = {
          check_outdated_servers_on_open = true,
        }
      })
      require("mason-lspconfig").setup({
        automatic_installation = true,
      })

      local lspconfig = require("lspconfig")
      for server, opts in pairs(server_opts) do
        -- Custom config overrides per-project
        -- e.g.
        -- return {
        --   rust_analyzer = function(opts)
        --     -- customize opts
        --   end
        -- }
        local load_config = loadfile(vim.fn.getcwd() .. "/.lspconfig.lua")
        if load_config ~= nil then
          local enhance_opts = load_config()
          if enhance_opts ~= nil and enhance_opts[server] then
            enhance_opts[server](opts)
          end
        end

        if opts.setup ~= nil then
          opts.setup(opts)
        else
          lspconfig[server].setup(opts)
        end
      end
    end
  },
  {
    "folke/trouble.nvim", -- quickfix LSP issues
    cmd = { "TroubleToggle" },
    keys = {
      { "<leader>tt", ":TroubleToggle<CR>", desc = "toggle diagnostics" },
      {
        "<leader>tw",
        ":TroubleToggle workspace_diagnostics<CR>",
        desc = "toggle workspace diagnostics"
      },
      { "<leader>td", ":TroubleToggle document_diagnostics<CR>", desc = "toggle document diagnostics" },
      { "<leader>tq", ":TroubleToggle quickfix<CR>", desc = "toggle quickfix list" },
      { "<leader>tl", ":TroubleToggle loclist<CR>", desc = "toggle location list" },
    },
  },
  -- -----------------------------------------------------------------------------
  -- Auto-Completion
  -- -----------------------------------------------------------------------------
  {
    "zbirenbaum/copilot.lua", -- AI auto-complete
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    }
  },
  {
    "hrsh7th/nvim-cmp", -- Auto-completion library
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "dmitmel/cmp-digraphs",
      "zbirenbaum/copilot-cmp",
    },
    config = function()
      local luasnip = require("luasnip")
      local cmp = require("cmp")
      cmp.setup {
        preselect = cmp.PreselectMode.None,
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping({
            i = function(fallback)
              if cmp.visible() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
              else
                fallback()
              end
            end,
            s = function(fallback)
              if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end,
          }),
          ["<S-Tab>"] = cmp.mapping({
            s = function(fallback)
              if luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end,
          }),
          ["<C-n>"] = cmp.mapping({
            i = function(fallback)
              if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              else
                fallback()
              end
            end,
            s = function(fallback)
              if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end
          }),
          ["<C-p>"] = cmp.mapping({
            i = function(fallback)
              if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
              else
                fallback()
              end
            end,
            s = function(fallback)
              if luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end
          }),
          ["<C-j>"] = cmp.mapping({
            i = function(fallback)
              if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end,
            s = function(fallback)
              if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end
          }),
          ["<C-k>"] = cmp.mapping({
            i = function(fallback)
              if luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end,
            s = function(fallback)
              if luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end
          }),
          ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
          ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
          ['<C-e>'] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() }),
        }),
        sources = cmp.config.sources({
        }, {
          { name = "copilot" },
          { name = 'luasnip' },
          { name = "nvim_lsp" },
        }, {
          { name = "path" },
          { name = "cmdline" },
        }, {
          { name = "buffer" },
        }, {
          { name = "digraphs" },
        }),
        view = {
          entries = {
            name = "custom",
          },
        },
        cmdline = {
          ["/"] = {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
              { name = "buffer", opts = { keyword_pattern = [=[[^[:blank:]].*]=] } }
            }
          },
          [":"] = {
            mapping = cmp.mapping.preset.cmdline(),
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
  },
  {
    "L3MON4D3/LuaSnip", -- Snippets
    event = "InsertEnter",
    dependencies = {
      "honza/vim-snippets",
    },
    keys = {
      { "<leader>es", ":lua require('luasnip.loaders').edit_snippet_files()<CR>", desc = "edit snippets" },
    },
    init = function()
      vim.g.snips_author = vim.fn.system("git config --get user.name | tr -d '\n'")
      vim.g.snips_author_email = vim.fn.system("git config --get user.email | tr -d '\n'")
      vim.g.snips_github = "https://github.com/lukexor"
    end,
    config = function()
      require("luasnip.loaders.from_snipmate").lazy_load()
      require("luasnip.loaders.from_lua").lazy_load({ paths = "./snippets" })
    end
  },
  {
    "nvim-treesitter/nvim-treesitter", -- AST Parser and highlighter
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
    },
    build = function() vim.cmd(":TSUpdate") end,
    opts = {
      ensure_installed = { "javascript", "lua", "rust" },
      sync_install = false,
      auto_install = true,
    }
  },
  {
    "nvim-lua/plenary.nvim", -- Async library for other plugins
    lazy = true,
  },
  {
    "nvim-lua/popup.nvim",
    lazy = true,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim", -- Search dependency of telescope
    build = "make",
    lazy = true,
  },
  {
    "nvim-telescope/telescope.nvim", -- Fuzzy finder
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      "benfowler/telescope-luasnip.nvim",
      "nvim-telescope/telescope-symbols.nvim",
    },
    opts = {
      defaults = {
        preview = {
          filesize_limit = 40,
          timeout = 500,
        }
      }
    },
    keys = {
      { "<leader>f", ":Telescope fd<CR>", desc = "find file" },
      {
        "<leader>A",
        ":Telescope fd find_command=rg,--files,--hidden,--no-ignore,--glob,!.git<CR>",
        desc = "find hidden files"
      },
      { "<leader>b", ":Telescope buffers<CR>", desc = "list buffers" },
      { "<leader>H", ":Telescope oldfiles<CR>", desc = "list recent files" },
      { "<leader>Th", ":Telescope help_tags<CR>", desc = "list help tags" },
      { "<leader>S", ":Telescope lsp_document_symbols<CR>", desc = "list symbols" },
      { "<leader>U", ":Telescope luasnip<CR>", desc = "list snippets" },
      { "<leader>K", ":Telescope keymaps<CR>", desc = "list keymaps" },
      { "<leader>r", ":Telescope live_grep<CR>", desc = "live grep" },
      { "<leader>s", ":Telescope current_buffer_fuzzy_find<CR>", desc = "search in buffer" },
      { "<leader>gf", ":Telescope git_files<CR>", desc = "open git file" },
      { "<leader>gb", ":Telescope git_branches<CR>", desc = "list git branches" },
      { "<leader>gc", ":Telescope git_bcommits<CR>", desc = "list buffer git commits" },
      { "<leader>gC", ":Telescope git_commits<CR>", desc = "list all git commits" },
      { "<c-s>", "<Esc>h:Telescope symbols<CR>", mode = "i", desc = "find a symbol to insert to insert" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.load_extension("notify")
      telescope.load_extension('luasnip')
      telescope.load_extension("fzf")
    end
  },
  -- -----------------------------------------------------------------------------
  -- Testing / Debugging
  -- -----------------------------------------------------------------------------
  {
    "romainl/vim-qf", -- Tame the quickfix window
    lazy = true,
    -- cmd = { ":<Plug>(qf_qf_toggle)", ":<Plug>(qf_qf_next)", ":<Plug>(qf_qf_previous)" },
    keys = {
      { "[q", "<Plug>(qf_qf_previous)", desc = "previous quickfix" },
      { "]q", "<Plug>(qf_qf_next)", desc = "next quickfix" },
      { "<leader>cc", ":cexpr []<CR>", desc = "clears quickfix list" },
    }
  },
  {
    "vim-test/vim-test", -- run unit tests
    cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast", "TestVisit" },
    keys = {
      { "<leader>Tn", ":TestNearest<CR>", desc = "run nearest test" },
      { "<leader>Tf", ":TestFile<CR>", desc = "run test file" },
      { "<leader>Ts", ":TestSuite<CR>", desc = "run test suite" },
      { "<leader>Tl", ":TestLast<CR>", desc = "run last test" },
      { "<leader>Tv", ":TestVisit<CR>", desc = "open last test file" },
    }
  },
  {
    "tpope/vim-dispatch",
    cmd = { "Make", "Dispatch" }
  },
  {
    "radenling/vim-dispatch-neovim",
    cmd = { "Make", "Dispatch" }
  },
  {
    "puremourning/vimspector", -- Debugger
    cmd = {
      -- ":<Plug>VimspectorLaunch",
      -- ":<Plug>VimspectorToggleBreakpoint",
      -- ":<Plug>VimspectorToggleConditionalBreakpoint",
      "VimspectorUpdate",
    },
    keys = {
      { "<leader>dd", "<Plug>VimspectorLaunch", desc = "launch debugger" },
      { "<leader>db", "<Plug>VimspectorToggleBreakpoint", desc = "toggle breakpoint" },
      { "<leader>dc", "<Plug>VimspectorToggleConditionalBreakpoint", desc = "toggle conditional breakpoint" },
      -- TODO: Make shortcuts easier to use when debugging
      { "<leader>dl", "<Plug>VimspectorBreakpoints", desc = "list breakpoints" },
      { "<leader>dC", ":call vimspector#ClearBreakpoints()<CR>", desc = "clear breakpoints" },
      { "<leader>/", "<Plug>VimspectorContinue", desc = "continue execution" },
      { "<leader>!", "<Plug>VimspectorPause", desc = "pause debugger" },
      { "<leader>ds", ":VimspectorReset<CR>", desc = "reset debugger" },
      { "<leader>dS", "<Plug>VimspectorStop", desc = "stop debugger" },
      { "<leader>'", "<Plug>VimspectorStepOver", desc = "step over" },
      { "<leader>;", "<Plug>VimspectorStepInto", desc = "step into" },
      { "<leader>:", "<Plug>VimspectorStepOut", desc = "step out" },
      { "<leader>dr", "<Plug>VimspectorRunToCursor", desc = "run until cursor" },
      { "<leader>dR", "<Plug>VimspectorRestart", desc = "restart debugger" },
      { "<leader>de", "<Plug>VimspectorBalloonEval", desc = "evaluate value" },
      { "<leader>de", "<Plug>VimspectorBalloonEval", mode = "v", desc = "evaluate selection" },
      { "<leader>dw", ":VimspectorWatch ", mode = "v", desc = "watch expression" },
      { "<leader>dE", ":VimspectorEval ", mode = "v", desc = "evaluate expression" },
    },
    init = function()
      vim.g.vimspector_install_gadgets = {
        "CodeLLDB", -- C/C++/Rust
        "vscode-bash-debug",
        "vscode-node-debug2",
        "local-lua-debugger-vscode",
        "debugger-for-chrome",
        "debugpy",
        "delve", -- For Golang
      }
    end
  },
}, {})

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

-- =============================================================================
-- Autocommands
-- =============================================================================

vim.cmd([[
  aug FiletypeOverrides
    au!
    au TermOpen * setlocal nospell nonu nornu | startinsert
    au BufRead,BufNewFile *.nu set ft=nu
    au BufRead,BufNewFile Vagrantfile set filetype=ruby
    au BufRead,BufNewFile *.vert,*.frag set ft=glsl
    au Filetype help set nu rnu
    au Filetype * set formatoptions=croqnjp
    au Filetype markdown set comments=
    au FileType c,cpp setlocal commentstring=//\ %s
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
    au CmdwinEnter *
        \ echohl Todo |
        \ echo 'You discovered the command-line window! You can close it with ":q".' |
        \ echohl None
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup="Search", timeout=300, on_visual=false }
    au VimEnter * if isdirectory(expand('%')) | bd | exe 'Telescope fd' | endif
  aug END
]])
