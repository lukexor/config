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
vim.env.PAGER = "bat"
-- Ensure a vim-compatible shell
vim.env.SHELL = "/bin/bash"
vim.o.shell = vim.env.SHELL
-- https://neovim.io/doc/user/provider.html
vim.g.python3_host_prog = "python3"
-- Highlight strings and numbers inside comments
vim.g.c_comment_strings = 1

vim.o.breakindent = true
vim.o.cmdheight = 1
vim.o.completeopt = "menu,menuone,noselect"
vim.o.confirm = true
vim.o.cursorline = true
vim.o.dictionary = "/usr/share/dict/words"
-- Make diffing better: https://vimways.org/2018/the-power-of-diff/
vim.opt.diffopt:append { "iwhite", "algorithm:patience", "indent-heuristic" }
vim.o.expandtab = true
vim.o.incsearch = true
vim.o.laststatus = 2
vim.o.list = true
vim.o.listchars = "tab:│ ,trail:+,extends:,precedes:,nbsp:‗"
vim.opt.matchpairs:append { "<:>" }
vim.o.mouse = ""
vim.o.number = true
vim.opt.path:append { "**" }
vim.o.redrawtime = 10000 -- Allow more time for loading syntax on large files
vim.o.relativenumber = true
vim.o.scrolloff = 8
vim.o.shortmess = ""
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

local map = function(lhs, rhs, options)
  local opts = vim.deepcopy(options)
  local mode = opts.mode or "n"
  opts.mode = nil
  vim.keymap.set(mode, lhs, rhs, opts)
end

local function system_open(path)
  local cmd
  if vim.fn.has "win32" == 1 and vim.fn.executable "explorer" == 1 then
    cmd = { "cmd.exe", "/K", "explorer" }
  elseif vim.fn.has "unix" == 1 and vim.fn.executable "xdg-open" == 1 then
    cmd = { "xdg-open" }
  elseif (vim.fn.has "mac" == 1 or vim.fn.has "unix" == 1) and vim.fn.executable "open" == 1 then
    cmd = { "open" }
  end
  if not cmd then vim.notify("Available system opening command not found!", "error") end
  vim.fn.jobstart(vim.fn.extend(cmd, { path or vim.fn.expand "<cfile>" }), { detach = true })
end

local function bool2str(bool) return bool and "on" or "off" end

-- -----------------------------------------------------------------------------
-- Settings
-- -----------------------------------------------------------------------------

map("<localleader>w", [[&fo =~ 't' ? "<cmd>set fo-=t<CR>" : "<cmd>set fo+=t<CR>"]],
  { expr = true, desc = "Toggle Text Auto-wrap" })

vim.g.gutter_enabled = true
map("<leader>ug", function()
  vim.g.gutter_enabled = not vim.g.gutter_enabled
  vim.notify(string.format("gutter %s", bool2str(vim.g.cmp_enabled)))
  if vim.g.gutter_enabled then
    vim.cmd("set rnu nu list signcolumn=yes:2 foldcolumn=1")
  else
    vim.cmd("set nornu nonu nolist signcolumn=no foldcolumn=0")
  end
end, { desc = "Toggle Gutter" })

map("<leader>us", function()
  vim.o.spell = not vim.o.spell
  vim.notify(string.format("spell %s", bool2str(vim.o.spell)))
end, { desc = "Toggle Spellcheck" })

map("<leader>uS", function()
  vim.opt.conceallevel = vim.opt.conceallevel:get() == 0 and 2 or 0
  vim.notify(string.format("conceal %s", bool2str(vim.opt.conceallevel:get() == 2)))
end, { desc = "Toggle Conceal" })

map("<leader>uw", function()
  vim.o.wrap = not vim.o.wrap -- local to window
  vim.notify(string.format("wrap %s", bool2str(vim.o.wrap)))
end, { desc = "Toggle Wrap" })

map("<leader>uc", function()
  vim.g.cmp_enabled = not vim.g.cmp_enabled
  vim.notify(string.format("completion %s", bool2str(vim.g.cmp_enabled)))
end, { desc = "Toggle Auto-completion" })

-- -----------------------------------------------------------------------------
-- Plugin Manager
-- -----------------------------------------------------------------------------

map("<leader>pi", "<cmd>Lazy install<CR>", { desc = "Install Plugins" })
map("<leader>ps", "<cmd>Lazy<CR>", { desc = "Plugin Status" })
map("<leader>pu", "<cmd>Lazy check<CR>", { desc = "Check Plugin Updates" })
map("<leader>pU", "<cmd>Lazy sync<CR>", { desc = "Update Plugins" })

-- -----------------------------------------------------------------------------
-- Manage Buffers
-- -----------------------------------------------------------------------------

map("<leader>w", "<cmd>w<CR>", { desc = "Save" })
map("<leader>W", "<cmd>noa w<CR>", { desc = "Save/No Formatting" })
map("<leader>q", "<cmd>confirm q<CR>", { desc = "Quit" })
map("<leader>Q", "<cmd>confirm qall<CR>", { desc = "Quit All" })
map("<leader>O", "<cmd>%bd|e#|bd#<CR>", { desc = "Quit all but current" })
map("<leader>n", "<cmd>enew<CR>", { desc = "New Buffer" })

map("<leader>h", "<cmd>bp<CR>", { silent = true, desc = "Go to Previous Buffer" })
map("<leader>l", "<cmd>bn<CR>", { silent = true, desc = "Go to Next Buffer" })
map("<leader><leader>", "<C-^>", { desc = "Alternate Buffer" })

map("|", "<cmd>vsplit<CR>", { desc = "Vertical Split" })
map("\\", "<cmd>split<CR>", { desc = "Horizontal Split" })

-- -----------------------------------------------------------------------------
-- Navigation
-- -----------------------------------------------------------------------------

-- Add relative jumps of more than 1 line to jump list
-- Move by terminal rows, not lines, unless count is provided
map("j", [[ v:count > 0 ? "m'" . v:count . 'j' : "gj" ]], { mode = { "n", "v" }, expr = true, desc = "Down N lines" })
map("k", [[ v:count > 0 ? "m'" . v:count . 'k' : "gk" ]], { mode = { "n", "v" }, expr = true, desc = "Up N lines" })

map("<leader>-", "<C-w>_<C-w>|", { desc = "Maximize window" })
map("<leader>=", "<C-w>=", { desc = "Equal Window Sizes" })

map("<S-Down>", "<cmd>resize -5<CR>", { desc = "Reduce Height" })
map("<S-Up>", "<cmd>resize +5<CR>", { desc = "Increase Height" })
map("<S-Left>", "<cmd>vertical resize +5<CR>", { desc = "Reduce Width" })
map("<S-Right>", "<cmd>vertical resize -5<CR>", { desc = "Increase Width" })

map("<C-h>", "<C-w>h", { desc = "Go to Nth left window" })
map("<C-j>", "<C-w>j", { desc = "Go to Nth below window" })
map("<C-k>", "<C-w>k", { desc = "Go to Nth above window" })
map("<C-l>", "<C-w>l", { desc = "Go to Nth right window" })

map("gt", "<C-]>", { desc = "Go to Tag" })

map("cd",
  function()
    local pathname = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
    vim.cmd(("lcd %s"):format(pathname))
    vim.notify(("lcd %s"):format(pathname))
  end,
  { desc = "cd to current file path" }
)

-- -----------------------------------------------------------------------------
-- Editing
-- -----------------------------------------------------------------------------

map("<leader>Ef", "<cmd>edit <cfile><CR>", { desc = "Edit File" })
map("gx", system_open, { desc = "Open File Externally" })

map("<leader>ve", "<cmd>edit $MYVIMRC<CR>", { desc = "Edit Nvim Config" })
map("<leader>vr", "<cmd>source $MYVIMRC<CR>:edit<CR>", { desc = "Reload Nvim Config" })

map("x", '"_x', { desc = "Delete Under" })
map("X", '"_X', { desc = "Delete Before" })

-- "==" honors indent
map("<leader>j", "<cmd>m .+1<CR>==", { silent = true, desc = "Move Line Up" })
map("<leader>k", "<cmd>m .-2<CR>==", { silent = true, desc = "Move Line Down" })

-- Keep cursor centered
map("n", "nzzzv", { desc = "repeat latest / or ?" })
map("N", "Nzzzv", { desc = "repeat latest / or ? in reverse" })
map("J", "mzJ`z", { desc = "join lines" })
map("*", "*zzzv", { desc = "search forward" })
map("#", "#zzzv", { desc = "search backwards" })
map("g*", "g*zzzv", { desc = "search forwards without word boundary" })
map("g#", "g*zzzv", { desc = "search backwards without word boundary" })

-- Reselect visual after indenting
map("<", "<gv", { mode = "v", desc = "Shift {motion} Lines Left" })
map(">", ">gv", { mode = "v", desc = "Shift {motion} Lines Right" })
map("<S-Tab>", "<gv", { mode = "v", desc = "Shift {motion} Lines Left" })
map("<Tab>", ">gv", { mode = "v", desc = "Shift {motion} Lines Right" })

map("p", '"_dP', { mode = "v", desc = "Replace selection without yanking" })
map("+", 'V"_dP', { desc = "Replace current line with yank" })

-- Show diffs in a modified buffer
vim.api.nvim_create_user_command("DiffOrig",
  "vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis", {})

map("<localleader>Tb", "<cmd>%s/\\s\\+$//<CR>", { desc = "Trim Trailing Blanks" })

map("jj", "<Esc>", { mode = "i", remap = true, desc = "Escape" })
map("<C-c>", "<Esc>", { mode = "i", remap = true, desc = "Escape" })

-- Case statements in bash use `;;`
if vim.bo.filetype ~= "sh" then
  map(";;", "A;<Esc>", { desc = "Append ;" })
  map(";;", "<Esc>A;<Esc>", { mode = "i", desc = "Append ;" })
end
map(",,", "A,<Esc>", { desc = "Append ," })
map(",,", "<Esc>A,<Esc>", { mode = "i", desc = "Append ," })

-- Add breaks in undo chain when typing punctuation
map(".", ".<C-g>u", { mode = "i", desc = "." })
map(",", ",<C-g>u", { mode = "i", desc = "," })
map("!", "!<C-g>u", { mode = "i", desc = "!" })
map("?", "?<C-g>u", { mode = "i", desc = "?" })

map("<localleader>ab", "<cmd>.!toilet -w 200 -f term -F border<CR>", { desc = "ASCII Border" })
map("<localleader>as", "<cmd>.!figlet -w 200 -f standard<CR>", { desc = "ASCII Standard" })
map("<localleader>aS", "<cmd>.!figlet -w 200 -f small<CR>", { desc = "ASCII Small" })

-- -----------------------------------------------------------------------------
-- Git
-- -----------------------------------------------------------------------------

map("<leader>gS", "<cmd>Git<CR>", { desc = "Git Status" })
map("<leader>gB", "<cmd>Git blame<CR>", { desc = "Git Blame" })

-- -----------------------------------------------------------------------------
-- Disabled mappings
-- -----------------------------------------------------------------------------

map("Q", "<nop>", { desc = "Disable ExMode" })
map("gQ", "<nop>", { desc = "Disable ExMode" })

-- -----------------------------------------------------------------------------
-- Search
-- -----------------------------------------------------------------------------

map("<leader><CR>", "<cmd>nohlsearch|diffupdate|normal !<C-l><CR>", { desc = "Clear Highlighting" })

map("<leader>G", "<cmd>silent lgrep ", { desc = "Grep" })
map("<localleader>S", "<cmd>%s//g<left><left>", { desc = "Global Search and Replace" })
map("<C-r>", '"hy:%s/<C-r>h//g<left><left>', { mode = "v", desc = "Search and Replace Selection" });

-- -----------------------------------------------------------------------------
-- Clipboard
-- -----------------------------------------------------------------------------

map("cy", '"*y', { desc = "Yank to clipboard" })
map("cY", '"*Y', { desc = "Yank line to clipboard" })
map("cyy", '"*yy', { desc = "Yank line to clipbard" })
map("cy", '"*y', { mode = "v", desc = "Yank selection to clipboard" })
map("cp", '"*p', { desc = "Paste from clipboard after cursor" })
map("cP", '"*P', { desc = "Paste from clipboard before cursor" })

-- -----------------------------------------------------------------------------
-- Text Objects
-- -----------------------------------------------------------------------------

map("in(", ":<C-u>normal! f(vi(<CR>", { mode = "o", silent = true, desc = "inner next () block" })
map("il(", ":<C-u>normal! F)vi(<CR>", { mode = "o", silent = true, desc = "inner last () block" })
map("an(", ":<C-u>normal! f(va(<CR>", { mode = "o", silent = true, desc = "around next () block" })
map("al(", ":<C-u>normal! F)va(<CR>", { mode = "o", silent = true, desc = "around last () block" })
map("in(", ":<C-u>normal! f(vi(<CR><Esc>gv", { mode = "v", silent = true, desc = "inner next () block" })
map("il(", ":<C-u>normal! F)vi(<CR><Esc>gv", { mode = "v", silent = true, desc = "inner last () block" })
map("an(", ":<C-u>normal! f(va(<CR><Esc>gv", { mode = "v", silent = true, desc = "around next () block" })
map("al(", ":<C-u>normal! F)va(<CR><Esc>gv", { mode = "v", silent = true, desc = "around last () block" })

map("in{", ":<C-u>normal! f{vi{<CR>", { mode = "o", silent = true, desc = "inner next {} block" })
map("il{", ":<C-u>normal! F{vi{<CR>", { mode = "o", silent = true, desc = "inner last {} block" })
map("an{", ":<C-u>normal! f{va{<CR>", { mode = "o", silent = true, desc = "around next {} block" })
map("al{", ":<C-u>normal! F{va{<CR>", { mode = "o", silent = true, desc = "around last {} block" })
map("in{", ":<C-u>normal! f{vi{<CR><Esc>gv", { mode = "v", silent = true, desc = "inner next {} block" })
map("il{", ":<C-u>normal! F{vi{<CR><Esc>gv", { mode = "v", silent = true, desc = "inner last {} block" })
map("an{", ":<C-u>normal! f{va{<CR><Esc>gv", { mode = "v", silent = true, desc = "around next {} block" })
map("al{", ":<C-u>normal! F{va{<CR><Esc>gv", { mode = "v", silent = true, desc = "around last {} block" })

map("in[", ":<C-u>normal! f[vi[<CR>", { mode = "o", silent = true, desc = "inner next [] block" })
map("il[", ":<C-u>normal! F[vi[<CR>", { mode = "o", silent = true, desc = "inner last [] block" })
map("an[", ":<C-u>normal! f[va[<CR>", { mode = "o", silent = true, desc = "around next [] block" })
map("al[", ":<C-u>normal! F[va[<CR>", { mode = "o", silent = true, desc = "around last [] block" })
map("in[", ":<C-u>normal! f[vi[<CR><Esc>gv", { mode = "v", silent = true, desc = "inner next [] block" })
map("il[", ":<C-u>normal! F[vi[<CR><Esc>gv", { mode = "v", silent = true, desc = "inner last [] block" })
map("an[", ":<C-u>normal! f[va[<CR><Esc>gv", { mode = "v", silent = true, desc = "around next [] block" })
map("al[", ":<C-u>normal! F[va[<CR><Esc>gv", { mode = "v", silent = true, desc = "around last [] block" })

map("af", ":<C-u>silent! normal! [zV]z<CR>", { mode = "v", silent = true, desc = "around fold" })
map("af", ":normal Vaf<CR>", { mode = "o", silent = true, desc = "around fold" })

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

map("ii", ":<C-u>lua IndentTextObj(true)<CR>", { mode = "o", silent = true, desc = "inner indent" })
map("ai", ":<C-u>lua IndentTextObj(false)<CR>", { mode = "o", silent = true, desc = "around indent" })
map("ii", ":<C-u>lua IndentTextObj(true)<CR><Esc>gv", { mode = "v", silent = true, desc = "inner indent" })
map("ai", ":<C-u>lua IndentTextObj(false)<CR><Esc>gv", { mode = "v", silent = true, desc = "around indent" })

-- -----------------------------------------------------------------------------
-- Debug
-- -----------------------------------------------------------------------------

map("<localleader>i", function()
  local line = vim.fn.line(".")
  local col = vim.fn.col(".")
  local hi = vim.fn.synIDattr(vim.fn.synID(line, col, 1), "name")
  local trans = vim.fn.synIDattr(vim.fn.synID(line, col, 0), "name")
  local lo = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.synID(line, col, 0)), "name")
  vim.cmd(("echo 'hi<%s> trans<%s> lo<%s>'"):format(hi, trans, lo))
end, { desc = "show syntax ID under cursor" })

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
  "logipat",
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
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

-- Default LSP shortcuts to no-ops for non-supported file types to avoid
-- confusion with default vim shortcuts.
function NoLspClient()
  vim.notify("No LSP client attached for filetype: `" .. vim.bo.filetype .. "`.", vim.log.levels.WARN,
    { title = "lsp" })
end

require("lazy").setup({
  -- -----------------------------------------------------------------------------
  -- Global Dependencies
  -- -----------------------------------------------------------------------------
  {
    "rcarriga/nvim-notify", -- Prettier notifications
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Delete all Notifications",
      },
    },
    opts = {
      timeout = 500,
      background_colour = "#000000",
      render = "minimal",
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
  },
  -- -----------------------------------------------------------------------------
  -- VIM Enhancements
  -- -----------------------------------------------------------------------------
  "nathom/filetype.nvim", -- lua replacement of filetype.vim
  {
    "dag/vim-fish",       -- fish shell support
    ft = "fish",
  },
  {
    "famiu/bufdelete.nvim", -- Keep window layout when deleting buffers
    keys = {
      { "<leader>D", "<cmd>confirm Bdelete<CR>", desc = "Delete Buffer" }
    }
  },
  {
    "ap/vim-buftabline", -- Better buffer management
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
      vim.g.buftabline_show = 0 -- never
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
    keys = {
      { "s", "<Plug>(leap-forward-to)", mode = { "n", "x", "o" }, desc = "leap forward to" },
      { "S", "<Plug>(leap-backward-to)", mode = { "n", "x", "o" }, desc = "leap backward to" },
      { "z", "<Plug>(leap-forward-till)", mode = { "v", "o" }, desc = "leap forward till" },
      { "Z", "<Plug>(leap-backward-till)", mode = { "v", "o" }, desc = "leap backward till" },
      { "gs", "<Plug>(leap-from-window)", mode = { "n", "o" }, desc = "leap from window" },
    },
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
        "<cmd>call smooth_scroll#up(&scroll, 5, 1)<CR>",
        desc = "small scroll up",
        silent = true,
      },
      {
        "<C-d>",
        "<cmd>call smooth_scroll#down(&scroll, 5, 1)<CR>",
        desc = "small scroll down",
        silent = true,
      },
      {
        "<C-b>",
        "<cmd>call smooth_scroll#up(&scroll*2, 10, 3)<CR>",
        desc = "large scroll up",
        silent = true,
      },
      {
        "<C-f>",
        "<cmd>call smooth_scroll#down(&scroll*2, 10, 3)<CR>",
        desc = "large scroll down",
        silent = true,
      },
    },
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    keys = {
      { "zo", nil },
      { "zO", nil },
      { "zc", nil },
      { "zC", nil },
      { "za", nil },
      { "zA", nil },
      { "zv", nil },
      { "zn", nil },
      { "zN", nil },
      { "zi", nil },
      { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Fold Less" },
      { "zR", function() require("ufo").openAllFolds() end, desc = "Open All Folds" },
      { "zm", function() require("ufo").closeFoldsWith() end, desc = "Fold More" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Close All Folds" },
      { "zp", function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "Peek Fold" },
    },
    opts = {
      provider_selector = function()
        return { 'treesitter', 'indent' }
      end
    },
    init = function()
      vim.o.foldcolumn = 'auto'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.foldmethod = 'indent'
    end
  },
  -- -----------------------------------------------------------------------------
  -- Documentation
  -- -----------------------------------------------------------------------------
  {
    "sudormrfbin/cheatsheet.nvim", -- Cheatsheet Search
    cmd = { "Cheatsheet", "CheatsheetEdit" },
    keys = {
      { "<localleader>C", "<cmd>Cheatsheet<CR>", desc = "cheatsheet" },
      { "<localleader>E", "<cmd>CheatsheetEdit<CR>", desc = "edit cheatsheet" },
    },
  },
  {
    "dbeniamine/cheat.sh-vim", -- Online Cheat.sh lookup
    cmd = { "Cheat" },
    keys = {
      { "<leader>cs", "<cmd>Cheat ", desc = "search cheat.sh" },
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
      { "<leader>to", "<cmd>AerialToggle<CR>", desc = "toggle symbol outline" },
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
      plugins = { spelling = true }
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
    event = "VeryLazy",
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
    },
    init = function()
      vim.g.surround_no_mappings = 1
    end,
    config = function()
      -- Just the defaults copied here.
      vim.keymap.set("n", "ds", "<Plug>Dsurround")
      vim.keymap.set("n", "cS", "<Plug>Csurround")
      vim.keymap.set("n", "ys", "<Plug>Ysurround")
      vim.keymap.set("n", "yS", "<Plug>YSurround")
      vim.keymap.set("n", "yss", "<Plug>Yssurround")
      vim.keymap.set("n", "ySs", "<Plug>YSsurround")
      vim.keymap.set("n", "ySS", "<Plug>YSsurround")

      -- The conflicting ones. Note that `<Plug>(leap-cross-window)`
      -- _does_ work in Visual mode, if jumping to the same buffer,
      -- so in theory, `gs` could be useful for Leap too...
      vim.keymap.set("x", "gs", "<Plug>VSurround")
      vim.keymap.set("x", "gS", "<Plug>VgSurround")
    end
  },
  {
    "junegunn/vim-easy-align", -- Make aligning rows easier
    cmd = "EasyAlign",
    keys = {
      { "gA", "<Plug>(EasyAlign)", desc = "align text" },
      { "<CR>", "<Plug>(EasyAlign)", mode = "v", desc = "align selection" },
      { "<leader>a/", "gAii/", remap = true, desc = "align indent level to /" },
      { "<leader>a:", "gAii:", remap = true, desc = "align indent level to :" },
      { "<leader>a=", "gAii:", remap = true, desc = "align indent level to =" },
    },
    init = function()
      vim.g.easy_align_delimiters = {
        [">"] = { pattern = ">>\\|=>\\|>" },
        ["/"] = {
          pattern = "//\\+\\|/\\*\\|\\*/",
          delimiter_align = "l",
          ignore_groups = { "!Comment" }
        },
      }
    end
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
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function()
        local gs = package.loaded.gitsigns

        map("]h", gs.next_hunk, { desc = "Next Hunk" })
        map("[h", gs.prev_hunk, { desc = "Prev Hunk" })
        map("<leader>ghp", gs.preview_hunk, { desc = "Preview Hunk" })
        map("<leader>ghb", function() gs.blame_line({ full = true }) end, { desc = "Blame Line" })
        map("<leader>ghd", gs.diffthis, { desc = "Diff This" })
        map("<leader>ghD", function() gs.diffthis("~") end, { desc = "Diff This ~" })
        map("ih", "<cmd><C-U>Gitsigns select_hunk<CR>", { mode = { "o", "x" }, desc = "GitSigns Select Hunk" })
      end,
    },
  },
  {
    "iamcco/markdown-preview.nvim", -- markdown browser viewer
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
      vim.g.mkdp_echo_preview_url = 1
    end
  },
  {
    "nvim-neo-tree/neo-tree.nvim", -- file explorer
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
      { "<leader>e", "<cmd>Neotree toggle reveal reveal_force_cwd<CR>", desc = "Toggle Explorer" },
      {
        "<leader>o",
        function()
          if vim.bo.filetype == "neo-tree" then
            vim.cmd.wincmd "p"
          else
            vim.cmd.Neotree "focus"
          end
        end,
        desc = "Toggle Explorer Focus"
      },
    },
    opts = {
      close_if_last_window = true,
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = true,
      },
      window = {
        mappings = {
          ["<space>"] = "none",
        },
      },
    },
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
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
      { "<localleader>I", "<cmd>ImportCost<CR>", desc = "calculate import sizes" },
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
  {
    "stevearc/dressing.nvim", -- Window UI enhancements, popups, input, etc
    lazy = true,
    init = function()
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },
  {
    "folke/noice.nvim", -- UI improvements
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        signature = {
          view = "mini",
        },
        message = {
          view = "popup",
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        command_palette = true,
        long_message_to_split = true,
      },
      views = {
        mini = {
          position = { row = -3 },
          size = {
            width = "auto",
            height = "auto",
            max_height = 20,
          },
          win_options = {
            winhighlight = { Normal = "NormalFloat" },
            winblend = 0,
          },
          border = { style = "rounded" },
        },
        cmdline_popup = {
          position = { row = -5, col = "50%" },
        },
        popupmenu = {
          position = { row = -8, col = "50%" },
        },
      },
      routes = {
        {
          filter = {
            any = {
              { event = "msg_show", kind = "", find = "written" },
              {
                event = "lsp",
                kind = "progress",
                any = {
                  { find = "code_action" },
                  { find = "cargo clippy" },
                  { find = "formatting" },
                  { find = "diagnostics" },
                }
              },
            },
          },
          opts = { skip = true },
        },
      },
    },
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
          VirtualTextInfo = { fg = colors.special },
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
    opts = function()
      local function fg(name)
        return function()
          local hl = vim.api.nvim_get_hl_by_name(name, true)
          return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
        end
      end
      local function macro_recording()
        local mode = require("noice").api.statusline.mode.get()
        if mode then
          return string.match(mode, "^recording @.*") or ""
        end
        return ""
      end
      return {
        options = {
          disabled_filetypes = { statusline = { "dashboard", "lazy" } },
          globalstatus = true,
          icons_enabled = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          theme = "ayu_dark",
        },
        sections = {
          lualine_a = {
            {
              "buffers",
              mode = 2,
              symbols = { modified = " ", alternate_file = "濫" },
              use_mode_colors = true,
            },
          },
          lualine_b = {
            { "branch", color = { fg = "#c2d94c" } },
          },
          lualine_c = {
            { macro_recording, color = fg("Special") },
            {
              "diagnostics",
              sources = { "vim_lsp" },
            },
          },
          lualine_x = {
            { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = fg("Special") },
            { "SleuthIndicator", color = fg("Comment") },
            { "diff" },
          },
          lualine_y = { "progress", "location" },
          lualine_z = {
            function()
              return " " .. os.date("%m-%d %R")
            end,
          },
        },
        extensions = { "aerial", "fugitive", "lazy", "neo-tree", "quickfix", "trouble" },
      }
    end,
  },
  -- -----------------------------------------------------------------------------
  -- LSP
  -- -----------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonUpdate" },
        keys = {
          { "<leader>pm", "<cmd>Mason<CR>", desc = "LSP Plugins" },
          { "<leader>pM", "<cmd>MasonUpdate<CR>:Mason<CR>", desc = "Update LSP Servers" },
        },
      },
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason-lspconfig.nvim",
      "kosayoda/nvim-lightbulb", -- Lightbulb next to code actions
      "simrat39/rust-tools.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    lazy = false,
    keys = {
      { "<leader>Li", "<cmd>LspInfo<CR>", desc = "lsp info" },
      { "<leader>LI", "<cmd>LspInfo<CR>", desc = "lsp install info" },
      { "<leader>Ls", "<cmd>LspStart<CR>", desc = "start lsp server" },
      { "<leader>LS", "<cmd>LspStop<CR>", desc = "stop lsp server" },
      { "<leader>Lr", "<cmd>LspRestart<CR>", desc = "restart lsp server" },
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
      { "<leader>S", NoLspClient, desc = "LSP Symbols" },
      { "<localleader>f", "gq", desc = "format buffer" },
    },
    config = function()
      vim.fn.sign_define("LightBulbSign", { text = "", texthl = "", linehl = "", numhl = "" })
      require("nvim-lightbulb").setup { autocmd = { enabled = true } }

      vim.cmd("au! DiagnosticChanged * lua vim.diagnostic.setqflist({ open = false })")

      local lsp_format_augroup = vim.api.nvim_create_augroup("LspFormat", {})
      local lsp_format = function(bufnr)
        vim.lsp.buf.format({
          bufnr = bufnr,
          filter = function(client)
            return client.name ~= "html" and
                client.name ~= "jsonls" and
                client.name ~= "tsserver"
          end,
        })
      end

      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      local on_attach = function(client, bufnr)
        vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "LspDiagnosticsSignError" })
        vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "LspDiagnosticsSignWarning" })
        vim.fn.sign_define("DiagnosticSignHint", { text = "ﳵ", texthl = "LspDiagnosticsSignHint" })
        vim.fn.sign_define("DiagnosticSignInformation", { text = "ℹ", texthl = "LspDiagnosticsSignInformation" })

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        map("gd", "<cmd>Telescope lsp_definitions<CR>", { desc = "Go To Definition", buffer = bufnr })
        map("gD", "<cmd>Telescope lsp_type_definitions<CR>", { desc = "Go To Type Definition", buffer = bufnr })
        map("gh", vim.lsp.buf.hover, { desc = "Symbol Information", buffer = bufnr })
        map("gH", vim.lsp.buf.signature_help, { desc = "Signature Information", buffer = bufnr })
        map("gi", "<cmd>Telescope lsp_implementations<CR>", { desc = "Go To Implementation", buffer = bufnr })
        map("gr", "<cmd>Telescope lsp_references<CR>", { desc = "References", buffer = bufnr })
        map("gR", vim.lsp.buf.rename, { desc = "Rename References", buffer = bufnr })
        map("ga", vim.lsp.buf.code_action, { desc = "Code Action", buffer = bufnr })
        map("ge", vim.diagnostic.open_float, { desc = "Diagnostics", buffer = bufnr })
        map("<leader>S", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "LSP Symbols", buffer = bufnr })

        if client.supports_method("textDocument/formatting") then
          map("<localleader>f", function() lsp_format(bufnr) end, { desc = "Format", buffer = bufnr })

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

        client.server_capabilities.semanticTokensProvider = false -- TODO: Fix. Highlighting is garbage right now
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
        if vim.bo.filetype == "markdown" or vim.bo.filetype == "proto" then
          vim.o.formatexpr = ""
        end
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
          null_ls.builtins.diagnostics.protolint,
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
        clangd = get_options(function(opts)
          opts.filetypes = { "c", "cpp" }
        end),
        rust_analyzer = get_options(function(opts)
          opts.settings = {
            ["rust-analyzer"] = {
              assist = { emitMustUse = true },
              cargo = {
                features = "all",
                -- target = "x86_64-pc-windows-msvc",
                -- target = "x86_64-unknown-linux-musl",
                buildScripts = { enable = true },
              },
              checkOnSave = {
                command = "clippy",
                features = "all",
                allTargets = true,
                extraEnv = { RUSTUP_TOOLCHAIN = "nightly" },
              },
              imports = {
                group = { enable = false },
              },
              procMacro = { enable = true },
              -- Uncomment for debugging
              -- trace = {
              --   server = "verbose",
              -- },
            },
          }
          opts.setup = function(server_opts)
            if vim.bo.filetype == "rust" then
              map("<leader>R", "<cmd>Make run<CR>", { desc = "cargo run" });
              map("<leader>M", "<cmd>Make build<CR>", { desc = "cargo build" });
              map("<leader>C", "<cmd>Make clippy<CR>", { desc = "cargo clippy" });
            end
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
        ensure_installed = {
          "bashls", "cssls", "gopls", "html", "jsonls", "pylsp", "clangd", "rust_analyzer", "lua_ls",
          "tsserver", "vimls", "yamlls"
        },
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
      { "<leader>tt", "<cmd>TroubleToggle<CR>", desc = "toggle diagnostics" },
      {
        "<leader>tw",
        "<cmd>TroubleToggle workspace_diagnostics<CR>",
        desc = "toggle workspace diagnostics"
      },
      { "<leader>td", "<cmd>TroubleToggle document_diagnostics<CR>", desc = "toggle document diagnostics" },
      { "<leader>tq", "<cmd>TroubleToggle quickfix<CR>", desc = "toggle quickfix list" },
      { "<leader>tl", "<cmd>TroubleToggle loclist<CR>", desc = "toggle location list" },
    },
  },
  -- -----------------------------------------------------------------------------
  -- Auto-Completion
  -- -----------------------------------------------------------------------------
  {
    "zbirenbaum/copilot-cmp", -- Copilot auto-complete. Must load after nvim-cmp.
    dependencies =
    {
      "hrsh7th/nvim-cmp",
      {
        "zbirenbaum/copilot.lua", -- AI auto-complete
        build = ":Copilot auth",
        cmd = "Copilot",
        opts = {
          suggestion = { enabled = false, auto_trigger = true },
          panel = { enabled = false, auto_refresh = true },
        }
      },
    },
    config = function()
      require("copilot_cmp").setup()
    end
  },
  {
    "hrsh7th/nvim-cmp", -- Auto-completion library
    cmd = "CmpStatus",
    event = "InsertEnter",
    dependencies = {
      "dmitmel/cmp-digraphs",
      "f3fora/cmp-spell",
      "FelipeLema/cmp-async-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "onsails/lspkind.nvim",
      "saadparwaiz1/cmp_luasnip",
      "uga-rosa/cmp-dictionary",
    },
    init = function()
      vim.g.cmp_enabled = true
    end,
    config = function()
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      local cmp = require("cmp")
      cmp.setup {
        enabled = function()
          if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then return false end
          return vim.g.cmp_enabled
        end,
        preselect = cmp.PreselectMode.None,
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
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
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol",
            menu = ({
              luasnip = "[Snippet]",
              nvim_lsp = "[LSP]",
              copilot = "[Copilot]",
              buffer = "[Buffer]",
              digraphs = "[Digraphs]",
              async_path = "[Path]",
            })
          }),
        },
        sources = cmp.config.sources({
          { name = 'luasnip', priority = 8 },
          { name = "nvim_lsp", priority = 7 },
          { name = "copilot", priority = 7 },
          { name = "buffer", priority = 6 },
          { name = "spell", keyword_length = 3, priority = 5, keyword_pattern = [[\w\+]] },
          { name = "dictionary", keyword_length = 3, priority = 5, keyword_pattern = [[\w\+]] },
          { name = "digraphs", priority = 4 },
          { name = "async_path", priority = 3 },
        }),
        sorting = {
          priority_weight = 1.0,
          comparators = {
            cmp.config.compare.locality,
            cmp.config.compare.recently_used,
            cmp.config.compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
            cmp.config.compare.offset,
            cmp.config.compare.order,
          },
        },
        cmdline = {
          ["/"] = {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
              { name = "buffer" }
            }
          },
          [":"] = {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
              { name = "async_path" }
            }, {
              {
                name = "cmdline",
                option = {
                  ignore_cmds = { 'Man', '!' }
                }
              }
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
      { "<leader>Es", "<cmd>lua require('luasnip.loaders').edit_snippet_files()<CR>", desc = "Edit Snippets" },
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
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          -- PERF: no need to load the plugin, if we only need its queries for mini.ai
          local plugin = require("lazy.core.config").spec.plugins["nvim-treesitter"]
          local opts = require("lazy.core.plugin").values(plugin, "opts", false)
          local enabled = false
          if opts.textobjects then
            for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
              if opts.textobjects[mod] and opts.textobjects[mod].enable then
                enabled = true
                break
              end
            end
          end
          if not enabled then
            require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
          end
        end,
      },
    },
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "help",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "rust",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
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
    "nvim-telescope/telescope.nvim", -- Fuzzy finder
    cmd = "Telescope",
    version = false,
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim", -- Search dependency of telescope
        build = "make",
        lazy = true,
      },
      "benfowler/telescope-luasnip.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      "folke/noice.nvim",
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
      { "<leader>f", "<cmd>Telescope fd<CR>", desc = "Find File" },
      {
        "<leader>A",
        "<cmd>Telescope fd find_command=rg,--files,--hidden,--no-ignore,--glob,!.git<CR>",
        desc = "Find Hidden File"
      },
      { "<leader>B", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>cc", "<cmd>Telescope commands<CR>", desc = "Commands" },
      { "<leader>F", "<cmd>Telescope resume<CR>", desc = "Resume Search" },
      { "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Git Branches" },
      { "<leader>gc", "<cmd>Telescope git_bcommits<CR>", desc = "Buffer Git Commits" },
      { "<leader>gC", "<cmd>Telescope git_commits<CR>", desc = "Git Commits" },
      { "<leader>gf", "<cmd>Telescope git_files<CR>", desc = "Git Files" },
      { "<leader>gt", "<cmd>Telescope git_status<CR>", desc = "Git Status" },
      { "<leader>H", "<cmd>Telescope oldfiles<CR>", desc = "Recent Files" },
      { "<leader>K", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
      { "<leader>m", "<cmd>Telescope marks<CR>", desc = "Marks" },
      { "<leader>M", "<cmd>Telescope notify<CR>", desc = "Notify Messages" },
      { "<leader>r", "<cmd>Telescope live_grep<CR>", desc = "Live Grep" },
      { "<leader>gs", "<cmd>Telescope grep_string<CR>", desc = "Grep String" },
      { "<leader>s", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Buffer Search" },
      { "<leader>dD", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
      { "<leader>Th", "<cmd>Telescope help_tags<CR>", desc = "Help Tags" },
      { "<leader>U", "<cmd>Telescope luasnip<CR>", desc = "Snippets" },
      { "<c-s>", "<Esc>h:Telescope symbols<CR>", mode = "i", desc = "Symbols" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.load_extension("notify")
      telescope.load_extension('luasnip')
      telescope.load_extension("fzf")
      telescope.load_extension("noice")
    end
  },
  -- -----------------------------------------------------------------------------
  -- Testing / Debugging
  -- -----------------------------------------------------------------------------
  {
    "romainl/vim-qf", -- Tame the quickfix window
    keys = {
      { "[q", "<Plug>(qf_qf_previous)", desc = "previous quickfix" },
      { "]q", "<Plug>(qf_qf_next)", desc = "next quickfix" },
      { "<leader>cq", "<cmd>cexpr []<CR>", desc = "clears quickfix list" },
    }
  },
  {
    "vim-test/vim-test", -- run unit tests
    cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast", "TestVisit" },
    keys = {
      { "<leader>Tn", "<cmd>TestNearest<CR>", desc = "run nearest test" },
      { "<leader>Tf", "<cmd>TestFile<CR>", desc = "run test file" },
      { "<leader>Ts", "<cmd>TestSuite<CR>", desc = "run test suite" },
      { "<leader>Tl", "<cmd>TestLast<CR>", desc = "run last test" },
      { "<leader>Tv", "<cmd>TestVisit<CR>", desc = "open last test file" },
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
      "VimspectorUpdate",
    },
    keys = {
      { "<leader>dd", "<Plug>VimspectorLaunch", desc = "launch debugger" },
      { "<leader>db", "<Plug>VimspectorToggleBreakpoint", desc = "toggle breakpoint" },
      { "<leader>dc", "<Plug>VimspectorToggleConditionalBreakpoint", desc = "toggle conditional breakpoint" },
      -- TODO: Make shortcuts easier to use when debugging
      { "<leader>dl", "<Plug>VimspectorBreakpoints", desc = "list breakpoints" },
      { "<leader>dC", "<cmd>call vimspector#ClearBreakpoints()<CR>", desc = "clear breakpoints" },
      { "<leader>/", "<Plug>VimspectorContinue", desc = "continue execution" },
      { "<leader>!", "<Plug>VimspectorPause", desc = "pause debugger" },
      { "<leader>ds", "<cmd>VimspectorReset<CR>", desc = "reset debugger" },
      { "<leader>dS", "<Plug>VimspectorStop", desc = "stop debugger" },
      { "<leader>'", "<Plug>VimspectorStepOver", desc = "step over" },
      { "<leader>;", "<Plug>VimspectorStepInto", desc = "step into" },
      { "<leader>:", "<Plug>VimspectorStepOut", desc = "step out" },
      { "<leader>dr", "<Plug>VimspectorRunToCursor", desc = "run until cursor" },
      { "<leader>dR", "<Plug>VimspectorRestart", desc = "restart debugger" },
      { "<leader>de", "<Plug>VimspectorBalloonEval", desc = "evaluate value" },
      { "<leader>de", "<Plug>VimspectorBalloonEval", mode = "v", desc = "evaluate selection" },
      { "<leader>dw", "<cmd>VimspectorWatch ", mode = "v", desc = "watch expression" },
      { "<leader>dE", "<cmd>VimspectorEval ", mode = "v", desc = "evaluate expression" },
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
}, {
  checker = {
    enabled = true,
    notify = false,
  },
})

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
