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
vim.env.SHELL = "bash"

--- Highlight strings and numbers inside comments
vim.g.c_comment_strings = 1

-- Disable <C-c> completions in sql
vim.g.omni_sql_no_default_maps = 1

vim.o.breakindent = true
vim.o.cmdheight = 1
vim.o.completeopt = "menu,menuone,noselect"
vim.o.confirm = true
vim.o.cursorline = true
vim.o.dictionary = "/usr/share/dict/words"
-- Make diffing better: https://vimways.org/2018/the-power-of-diff/
vim.opt.diffopt:append("iwhite,algorithm:patience,indent-heuristic")
vim.o.expandtab = true
vim.o.incsearch = true
vim.o.jumpoptions = "stack,view"
vim.o.laststatus = 3
vim.o.list = true
vim.o.listchars = "tab:│ ,trail:+,extends:,precedes:,nbsp:‗"
vim.opt.matchpairs:append("<:>")
vim.o.mouse = ""
vim.o.number = true
vim.opt.path:append("**")
vim.o.redrawtime = 10000 -- Allow more time for loading syntax on large files
vim.o.relativenumber = true
vim.o.scrolloff = 8
vim.o.shell = vim.env.SHELL
vim.o.shiftround = true
vim.o.shiftwidth = 2
vim.o.showmatch = true
vim.o.sidescrolloff = 8
vim.o.signcolumn = "yes:2"
vim.o.spellfile = vim.env.HOME .. "/config/.config/nvim/spell.utf-8.add"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.synmaxcol = 500
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.textwidth = 80
vim.o.title = true
vim.o.undofile = true
vim.o.updatecount = 50 -- Save more often than 200 characters typed.
vim.o.updatetime = 250 -- Save more often than 4 seconds.
vim.o.timeoutlen = 300
vim.o.virtualedit = "block"
vim.o.wildmode = "longest:full,full"
vim.o.wrap = false

if vim.fn.executable("rg") then
  vim.o.grepprg = "rg --no-heading --vimgrep"
  vim.o.grepformat = "%f:%l:%c:%m"
else
  vim.notify_once("rg is not installed", vim.log.levels.ERROR)
end

local codelldb_ext_path = vim.env.HOME .. "/.local/share/nvim/mason/packages/codelldb/extension"
local codelldb_path = codelldb_ext_path .. "/adapter/codelldb"
local liblldb_path = codelldb_ext_path .. "/lldb/lib/liblldb"
local os = vim.loop.os_uname().sysname
-- The path is different on Windows
if os:find("Windows") then
  codelldb_path = codelldb_ext_path .. "/adapter/codelldb.exe"
  liblldb_path = codelldb_ext_path .. "/lldb/bin/liblldb.dll"
else
  -- The liblldb extension is .so for Linux and .dylib for MacOS
  liblldb_path = liblldb_path .. (os == "Linux" and ".so" or ".dylib")
end

local codellb_adaptor = function(cb)
  cb({
    executable = {
      args = {
        "--liblldb",
        liblldb_path,
        "--port",
        "${port}",
      },
      command = codelldb_path,
    },
    host = "127.0.0.1",
    port = "${port}",
    type = "server",
  })
end

-- Dynamic mapping to go to a given buffer by its ordinal index
local function create_buffer_keymap(index)
  return {
    "<leader>" .. index,
    function()
      local buffers = vim.fn.getbufinfo({ buflisted = 1 })
      local buf = buffers[index]
      if buf then
        vim.api.nvim_set_current_buf(buf.bufnr)
      end
    end,
    desc = "Go to buffer " .. index,
  }
end

-- =============================================================================
-- Key Maps
-- =============================================================================

vim.g.mapleader = " "
vim.g.maplocalleader = ","

local map = function(lhs, rhs, options)
  local opts = vim.deepcopy(options or {})
  local mode = opts.mode or "n"
  opts.mode = nil
  vim.keymap.set(mode, lhs, rhs, opts)
end
local del_map = function(lhs, options)
  local opts = vim.deepcopy(options or {})
  local mode = opts.mode or "n"
  opts.mode = nil
  if vim.fn.maparg(lhs, mode) ~= "" then
    vim.keymap.del(mode, lhs, options)
  end
end

local function system_open(path)
  local cmd
  if vim.fn.has("win32") == 1 and vim.fn.executable("explorer") == 1 then
    cmd = { "cmd.exe", "/K", "explorer" }
  elseif vim.fn.has("unix") == 1 and vim.fn.executable("xdg-open") == 1 then
    cmd = { "xdg-open" }
  elseif (vim.fn.has("mac") == 1 or vim.fn.has("unix") == 1) and vim.fn.executable("open") == 1 then
    cmd = { "open" }
  end
  if not cmd then
    vim.notify("Available system opening command not found!", vim.log.levels.ERROR)
  end
  vim.fn.jobstart(vim.fn.extend(cmd, { path or vim.fn.expand("<cfile>") }), { detach = true })
end

local function bool2str(bool)
  return bool and "on" or "off"
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local lsp_on_attach = function(client, bufnr)
  require("lsp-status").on_attach(client, bufnr)

  vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "LspDiagnosticsSignError" })
  vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "LspDiagnosticsSignWarning" })
  vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "LspDiagnosticsSignHint" })
  vim.fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "LspDiagnosticsSignInformation" })

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  map("gd", "m'<cmd>Telescope lsp_definitions<CR>", { desc = "Go to Definition", buffer = bufnr })
  map("gD", "m'<cmd>Telescope lsp_type_definitions<CR>", { desc = "Go to Type Definition", buffer = bufnr })
  map("gh", vim.lsp.buf.hover, { desc = "Symbol Information", buffer = bufnr })
  map("gH", vim.lsp.buf.signature_help, { desc = "Signature Information", buffer = bufnr })
  map("gi", "m'<cmd>Telescope lsp_implementations<CR>", { desc = "Go to Implementation", buffer = bufnr })
  map("gr", "m'<cmd>Telescope lsp_references<CR>", { desc = "References", buffer = bufnr })
  map("gR", vim.lsp.buf.rename, { desc = "Rename References", buffer = bufnr })
  map("ga", vim.lsp.buf.code_action, { desc = "Code Action", buffer = bufnr })
  map("ge", vim.diagnostic.open_float, { desc = "Diagnostics", buffer = bufnr })
  map("<leader>S", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "LSP Symbols", buffer = bufnr })

  client.server_capabilities.semanticTokensProvider = nil -- don't need treesitter semantic higlighting
end

local lsp_capabilities = function()
  local client_capabilities = vim.lsp.protocol.make_client_capabilities()
  local capabilities = require("cmp_nvim_lsp").default_capabilities(client_capabilities)
  return vim.tbl_extend("keep", capabilities, require("lsp-status").capabilities)
end

-- -----------------------------------------------------------------------------
-- Settings
-- -----------------------------------------------------------------------------

map(
  "<localleader>w",
  [[&fo =~ 't' ? "<cmd>set fo-=t<CR>" : "<cmd>set fo+=t<CR>"]],
  { expr = true, desc = "Toggle Text Auto-wrap" }
)

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
  vim.opt.conceallevel = vim.opt.conceallevel == 0 and 2 or 0
  vim.notify(string.format("conceal %s", bool2str(vim.opt.conceallevel == 2)))
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
map("<leader>pp", "<cmd>Lazy profile<CR>", { desc = "Plugin Profile" })
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
map("<leader>n", "<cmd>new<CR>", { desc = "New Buffer" })

map("<leader><leader>", "<C-^>", { desc = "Alternate Buffer" })

-- Skip split macros in temporary files like editing fish command line in
-- $EDITOR to avoid causing unnecessary split on startup due to errant "|"
if not string.find(vim.fn.expand("%:h"), "/tmp") then
  map("|", "<cmd>vsplit<CR>", { desc = "Vertical Split" })
  map("\\", "<cmd>split<CR>", { desc = "Horizontal Split" })
end

-- -----------------------------------------------------------------------------
-- Navigation
-- -----------------------------------------------------------------------------

-- Add relative jumps of more than 1 line to jump list
-- Move by terminal rows, not lines, unless count is provided
map("j", [[ v:count > 0 ? "m'" . v:count . 'j' : "gj" ]], { mode = { "n", "v" }, expr = true, desc = "Down N lines" })
map("k", [[ v:count > 0 ? "m'" . v:count . 'k' : "gk" ]], { mode = { "n", "v" }, expr = true, desc = "Up N lines" })

map("<leader>-", "<C-w>_<C-w>|", { desc = "Maximize window" })
map("<leader>=", "<C-w>=", { desc = "Equal Window Sizes" })

map("<A-S-Down>", "<cmd>resize -5<CR>", { desc = "Reduce Height" })
map("<A-S-Up>", "<cmd>resize +5<CR>", { desc = "Increase Height" })
map("<A-S-Right>", "<cmd>vertical resize +5<CR>", { desc = "Reduce Width" })
map("<A-S-Left>", "<cmd>vertical resize -5<CR>", { desc = "Increase Width" })

-- TODO: phase out hjkl bindings
map("<C-h>", "<C-w>h", { desc = "Go to Nth left window" })
map("<C-j>", "<C-w>j", { desc = "Go to Nth below window" })
map("<C-k>", "<C-w>k", { desc = "Go to Nth above window" })
map("<C-l>", "<C-w>l", { desc = "Go to Nth right window" })

map("gt", "<C-]>", { desc = "Go to Tag" })

map("<C-a>", "<Home>", { mode = "c", desc = "Go to start of line" })
map("<C-b>", "<Left>", { mode = "c", desc = "Go back one character" })
map("<C-d>", "<Del>", { mode = "c", desc = "Delete one character under cursor" })
map("<C-e>", "<End>", { mode = "c", desc = "Go to the end of line" })
map("<C-f>", "<Right>", { mode = "c", desc = "Go forward one character" })
map("<C-n>", "<Down>", { mode = "c", desc = "Recall newer command-line" })
map("<C-p>", "<Up>", { mode = "c", desc = "Recall previous command-line" })
map("<M-b>", "<S-Left>", { mode = "c", desc = "Go back one word" })
map("<M-f>", "<S-Right>", { mode = "c", desc = "Go forward one word" })

map("<C-bs>", "<C-w>", { mode = "i", desc = "delete previous word" })

map("cd", function()
  local pathname = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
  vim.cmd(("lcd %s"):format(pathname))
  vim.notify(("lcd %s"):format(pathname))
end, { desc = "cd to current file path" })

-- -----------------------------------------------------------------------------
-- Editing
-- -----------------------------------------------------------------------------

map("<leader>Ef", "<cmd>edit <cfile><CR>", { desc = "Edit File" })
map("gx", system_open, { desc = "Open File Externally" })

map("<leader>ve", "<cmd>edit $MYVIMRC<CR>", { desc = "Edit Nvim Config" })
map("<leader>vr", "<cmd>source $MYVIMRC<CR>:edit<CR>", { desc = "Reload Nvim Config" })

map("<leader>B", '"_', { desc = "Use the blackhole register" })
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
vim.api.nvim_create_user_command(
  "DiffOrig",
  "vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis",
  {}
)

map("<localleader>Tb", "<cmd>%s/\\s\\+$//<CR>", { desc = "Trim Trailing Blanks" })

map("<C-c>", "<Esc>", { mode = "i", remap = true, desc = "Escape" })

-- Case statements in bash use `;;`
map("<leader>;", "A;<Esc>", { desc = "Append ;" })
map("<leader>,", "A,<Esc>", { desc = "Append ," })

-- Add breaks in undo chain when typing punctuation
map(".", ".<C-g>u", { mode = "i", desc = "." })
map(",", ",<C-g>u", { mode = "i", desc = "," })
map("!", "!<C-g>u", { mode = "i", desc = "!" })
map("?", "?<C-g>u", { mode = "i", desc = "?" })

map("<localleader>ab", "<cmd>.!toilet -w 200 -f term -F border<CR>", { desc = "ASCII Border" })
map("<localleader>aS", "<cmd>.!figlet -w 200 -f small<CR>", { desc = "ASCII Small" })
map("<localleader>as", "<cmd>.!figlet -w 200 -f standard<CR>", { desc = "ASCII Standard" })

map("<leader>s", ":'<,'>!sort<CR>", { mode = "x", silent = true, desc = "Sort selection" })

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

map("<leader>G", ":silent lgrep ", { desc = "Grep" })
map("<leader>R", ":%s/\\<<C-r><C-w>\\>//g<left><left>", { desc = "Search and Replace word under cursor" })
map("<localleader>R", ":%s//g<left><left>", { desc = "Global Search and Replace" })
map("<C-r>", '"hy:%s/<C-r>h//g<left><left>', { mode = "v", desc = "Search and Replace Selection" })

-- -----------------------------------------------------------------------------
-- Clipboard
-- -----------------------------------------------------------------------------

map("cy", '"+y', { mode = { "n", "v" }, desc = "Yank to clipboard" })
map("cY", '"+Y', { desc = "Yank line to clipboard" })
map("cyy", '"+yy', { desc = "Yank line to clipbard" })
map("cp", '"+p', { mode = { "n", "v" }, desc = "Paste from clipboard after cursor" })
map("cP", '"+P', { mode = { "n", "v" }, desc = "Paste from clipboard before cursor" })

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

    while
      p > 0
      and (((not nextblank or (pp > 0 and not nextnextblank)) and vim.fn.indent(p) >= i) or (not around and nextblank))
    do
      vim.cmd("-")
      p = get_pos(-1)
      pp = get_pos(-2)
      nextblank = get_blank(p)
      nextnextblank = get_blank(pp)
    end

    vim.cmd("normal! 0V")
    vim.fn.cursor({ curline, curcol })

    p = get_pos(1)
    pp = get_pos(2)
    nextblank = get_blank(p)
    nextnextblank = get_blank(pp)

    while
      p <= lastline
      and (((not nextblank or (pp > 0 and not nextnextblank)) and vim.fn.indent(p) >= i) or (not around and nextblank))
    do
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
  "gzip",
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
  vim.notify(
    "No LSP client attached for filetype: `" .. vim.bo.filetype .. "`.",
    vim.log.levels.WARN,
    { title = "lsp" }
  )
end

-- TODO: finish migrating to vim.lsp.config
vim.lsp.config["luals"] = {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        checkThirdParty = false,
      },
    },
  },
}
vim.lsp.enable("luals")

vim.g.lazyvim_check_order = false
require("lazy").setup({
  spec = {
    { import = "plugins" },
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
          desc = "Dismiss Notifications",
        },
      },
      opts = {
        timeout = 3000,
        background_colour = "#111111",
        render = "minimal",
        stages = "static",
        max_height = function()
          return math.floor(vim.o.lines * 0.50)
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.50)
        end,
      },
    },
    -- -----------------------------------------------------------------------------
    -- VIM Enhancements
    -- -----------------------------------------------------------------------------
    {
      "dag/vim-fish", -- fish shell support
      ft = "fish",
    },
    {
      "dcharbon/vim-flatbuffers", -- Flatbuffer file support
      ft = "fbs",
    },
    {
      "famiu/bufdelete.nvim", -- Keep window layout when deleting buffers
      keys = {
        { "<leader>D", "<cmd>confirm Bdelete<CR>", desc = "Delete Buffer" },
      },
    },
    {
      "tpope/vim-repeat", -- Repeat with "."
      event = "VeryLazy",
    },
    "tpope/vim-sleuth", -- Smart buffer options based on contents
    {
      "ggandor/leap.nvim", -- Better movement with s/S, x/X, and gS
      event = "InsertEnter",
      init = function()
        require("leap").add_default_mappings()
      end,
    },
    "ypcrts/securemodelines", -- Safe modelines
    {
      "kshenoy/vim-signature", -- Show marks in gutter
      event = "VeryLazy",
    },
    {
      "mbbill/undotree",
      event = "VeryLazy",
      keys = {
        {
          "<leader>U",
          "<cmd>UndotreeToggle<CR>",
          desc = "Toggle Undo Tree",
          silent = true,
        },
      },
      init = function()
        vim.g.undotree_WindowLayout = 2
        vim.g.undotree_ShortIndicators = 1
        vim.g.undotree_SplitWidth = 40
      end,
    },
    {
      "kevinhwang91/nvim-ufo", -- improved vim folds
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
        {
          "zr",
          function()
            require("ufo").openFoldsExceptKinds()
          end,
          desc = "Fold Less",
        },
        {
          "zR",
          function()
            require("ufo").openAllFolds()
          end,
          desc = "Open All Folds",
        },
        {
          "zm",
          function()
            require("ufo").closeFoldsWith()
          end,
          desc = "Fold More",
        },
        {
          "zM",
          function()
            require("ufo").closeAllFolds()
          end,
          desc = "Close All Folds",
        },
        {
          "zp",
          function()
            require("ufo").peekFoldedLinesUnderCursor()
          end,
          desc = "Peek Fold",
        },
      },
      opts = {
        provider_selector = function()
          return { "treesitter", "indent" }
        end,
      },
      init = function()
        vim.o.foldcolumn = "1"
        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
        vim.o.foldmethod = "indent"
      end,
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
      opts = {},
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
        { "<leader>to", "<cmd>AerialToggle<CR>", desc = "toggle symbol outline" },
      },
      opts = {
        layout = {
          min_width = 35,
          default_direction = "prefer_right",
        },
      },
    },
    {
      "folke/which-key.nvim", -- Show mappings as you type
      event = "VeryLazy",
      opts = {},
      keys = {
        {
          "<leader>?",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "Buffer Local Keymaps (which-key)",
        },
        create_buffer_keymap(1),
        create_buffer_keymap(2),
        create_buffer_keymap(3),
        create_buffer_keymap(4),
        create_buffer_keymap(5),
        create_buffer_keymap(6),
        create_buffer_keymap(7),
        create_buffer_keymap(8),
        create_buffer_keymap(9),
      },
    },
    -- -----------------------------------------------------------------------------
    -- Code Assists
    -- -----------------------------------------------------------------------------
    {
      "mfussenegger/nvim-lint",
      config = function()
        local lint = require("lint")
        -- Copied from nvim-lint/lua/lint/linters/tidy.lua
        lint.linters.tidyxml = {
          cmd = "tidy",
          stdin = true,
          stream = "stderr",
          ignore_exitcode = true,
          args = {
            "-quiet",
            "-errors",
            "-language",
            "en",
            "--gnu-emacs",
            "yes",
            "-xml",
          },
          parser = require("lint.parser").from_pattern(pattern, groups, severities, { ["source"] = "tidy" }),
        }
        lint.linters_by_ft = {
          bash = { "shellcheck" },
          css = { "stylelint" },
          -- So pedantic...
          cpp = { "clangtidy" },
          glslc = { "glslc" },
          html = { "tidy" },
          xml = { "tidyxml" },
          javascript = { "eslint_d" },
          javascriptreact = { "eslint_d" },
          json = { "jsonlint" },
          markdown = { "markdownlint" },
          proto = { "protolint" },
          typescript = { "eslint_d" },
          typescriptreact = { "eslint_d" },
          yaml = { "yamllint" },
        }

        local lint_augroup = vim.api.nvim_create_augroup("Lint", {})
        vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI" }, {
          group = lint_augroup,
          desc = "Lint file",
          callback = function()
            lint.try_lint()
          end,
        })
      end,
    },
    {
      "windwp/nvim-ts-autotag", -- Auto-close HTML/JSX tags
      event = "InsertEnter",
      -- opts required otherwise it doesn't load correctly
      opts = {},
    },
    {
      -- Can't be lazy or it won't load correctly
      "tpope/vim-endwise", -- Auto-add endings for control structures: if, for, etc
    },
    {
      "tpope/vim-commentary", -- Commenting motion commands gc*
      event = "VeryLazy",
    },
    {
      "NoahTheDuke/vim-just", -- justfile support
      event = { "BufReadPre", "BufNewFile" },
      ft = { "\\cjustfile", "*.just", ".justfile" },
    },
    {
      "nastevens/vim-cargo-make", -- cargo make support
    },
    {
      "cespare/vim-toml", -- TOML support
    },
    {
      "tpope/vim-surround", -- Easy changes of surrounding quotes & brackets
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
        vim.keymap.set("n", "cs", "<Plug>Csurround")
        vim.keymap.set("n", "cS", "<Plug>CSurround")
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
      end,
    },
    {
      "junegunn/vim-easy-align", -- Make aligning rows easier
      cmd = "EasyAlign",
      keys = {
        { "gA", "<Plug>(EasyAlign)", desc = "align text" },
        { "=", "<Plug>(EasyAlign)", mode = "v", desc = "align selection" },
        -- e.g. Comments
        { "<leader>#", "gAii#", remap = true, desc = "align indent level to #" },
        { "<leader>/", "gAii/", remap = true, desc = "align indent level to /" },
        -- e.g. JSON or YAML
        { "<leader>:", "gAii:", remap = true, desc = "align indent level to :" },
        -- e.g. assignments, ==, !=, +=, etc
        { "<leader>+", "gAii=", remap = true, desc = "align indent level to =" },
      },
      init = function()
        vim.g.easy_align_delimiters = {
          [">"] = { pattern = ">>\\|=>\\|>" },
          ["/"] = {
            pattern = "//\\+\\|/\\*\\|\\*/",
            delimiter_align = "l",
            ignore_groups = { "!Comment" },
          },
        }
      end,
    },
    {
      "glts/vim-radical", -- Number conversions
      dependencies = {
        "glts/vim-magnum",
      },
      lazy = true,
      cmd = { "RadicalView", "RadicalCoerceToDecimal", "RadicalCoerceToHex", "RadicalCoerceToBinary" },
      keys = {
        { "gC", "<Plug>RadicalView", desc = "show number conversions under cursor" },
        { "gC", "<Plug>RadicalView", mode = "v", desc = "show number conversions under selection" },
        { "crd", "<Plug>RadicalCoerceToDecimal", desc = "convert number to decimal" },
        { "crx", "<Plug>RadicalCoerceToHex", desc = "convert number to hex" },
        { "crb", "<Plug>RadicalCoerceToBinary", desc = "convert number to binary" },
      },
    },
    {
      "brenoprata10/nvim-highlight-colors",
      opts = {
        enable_tailwind = true,
      },
    },
    -- -----------------------------------------------------------------------------
    -- System Integration
    -- -----------------------------------------------------------------------------
    {
      "iamcco/markdown-preview.nvim", -- markdown browser viewer
      ft = { "markdown" },
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      build = "cd app && npm install && git restore .",
      init = function()
        vim.g.mkdp_filetypes = { "markdown" }
        vim.g.mkdp_echo_preview_url = 1
      end,
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
              vim.cmd.wincmd("p")
            else
              vim.cmd.Neotree("focus")
            end
          end,
          desc = "Toggle Explorer Focus",
        },
      },
      opts = {
        close_if_last_window = true,
        filesystem = {
          bind_to_cwd = false,
          follow_current_file = true,
        },
        window = {
          width = 30,
          mappings = {
            ["<space>"] = "none",
          },
        },
        default_component_configs = {
          name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName",
          },
          git_status = {
            symbols = {
              -- Change type
              added = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
              modified = "", -- or "", but this is redundant info if you use git_status_colors on the name
              deleted = "✖", -- this can only be used in the git_status source
              renamed = "󰁕", -- this can only be used in the git_status source
              -- Status type
              untracked = "",
              ignored = "",
              unstaged = "󰄱",
              staged = "",
              conflict = "",
            },
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
        vim.g.rooter_patterns = { ".git" }
      end,
    },
    -- TODO: Create TODO list shortcuts
    -- -----------------------------------------------------------------------------
    -- Windowing / Theme
    -- -----------------------------------------------------------------------------
    {
      "stevearc/dressing.nvim", -- Window UI enhancements, popups, input, etc
      event = "VeryLazy",
      opts = {
        select = {
          -- Fixes small width on vim.ui.select
          telescope = {},
        },
      },
    },
    {
      "folke/noice.nvim", -- UI improvements
      dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
      },
      opts = {
        lsp = {
          message = {
            view = "popup",
          },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          hover = {
            enabled = false,
          },
          progress = {
            enabled = false,
          },
          signature = {
            enabled = true,
            auto_open = {
              enabled = false,
            },
          },
        },
        presets = {
          long_message_to_split = true,
        },
        views = {
          mini = {
            size = {
              width = "auto",
              height = "auto",
              max_height = 20,
              max_width = 100,
            },
            win_options = {
              winhighlight = { Normal = "NormalFloat" },
              winblend = 0,
            },
            border = {
              padding = { 0, 1 },
            },
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
                  },
                },
              },
            },
            opts = { skip = true },
          },
        },
      },
    },
    {
      "nvim-lualine/lualine.nvim", -- statusline
      event = "VeryLazy",
      opts = function()
        local function fg(name)
          return function()
            local hl = vim.api.nvim_get_hl(0, { name = name })
            return hl and hl.fg and { fg = string.format("#%06x", hl.fg) }
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
          },
          sections = {
            lualine_a = {
              {
                "buffers",
                mode = 2,
                symbols = { modified = " ", alternate_file = " " },
                use_mode_colors = true,
              },
            },
            lualine_b = {
              { "branch", color = fg("SpecialComment") },
              { "filename", path = 4 },
            },
            lualine_c = {
              { macro_recording, color = fg("Special") },
              {
                "diagnostics",
                sources = { "vim_lsp" },
              },
              {
                function()
                  return require("lsp-status").status()
                end,
              },
            },
            lualine_x = {
              { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = fg("Special") },
              { "SleuthIndicator", color = fg("Comment") },
            },
            lualine_y = { "progress", "location", "selectioncount" },
            lualine_z = {
              {
                "os.date('%Y-%m-%d %R')",
                fmt = function(date)
                  return " " .. date
                end,
              },
            },
          },
          extensions = { "aerial", "fugitive", "lazy", "neo-tree", "quickfix", "trouble" },
        }
      end,
    },
    -- -----------------------------------------------------------------------------
    -- LSP
    -- -----------------------------------------------------------------------------
    -- Disabled for now, trying to rely less on AI
    -- {
    --   "Exafunction/codeium.nvim",
    --   dependencies = {
    --     "nvim-lua/plenary.nvim",
    --     "hrsh7th/nvim-cmp",
    --   },
    --   config = function()
    --     local opts = {}
    --     local handle = io.popen("grep -c ID=nixos /etc/os-release")
    --     if handle ~= nil then
    --       local is_nix = handle:read("*a")
    --       handle:close()
    --       if is_nix:match("1") == "1" then
    --         opts.wrapper = "steam-run"
    --       end
    --     end
    --     require("codeium").setup(opts)
    --   end,
    -- },
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      dependencies = {
        {
          "williamboman/mason.nvim",
          cmd = { "Mason", "MasonUpdate" },
          build = ":MasonUpdate",
          keys = {
            { "<leader>pm", "<cmd>MasonUpdate<CR>:Mason<CR>", desc = "Update LSP Servers" },
          },
          opts = {
            ui = {
              check_outdated_servers_on_open = true,
            },
          },
        },
      },
      opts = {
        ensure_installed = {
          "bash-language-server",
          "clang-format",
          "clangd",
          "cpplint",
          "css-lsp",
          "eslint_d",
          "html-lsp",
          "json-lsp",
          "jsonlint",
          "lua-language-server",
          "markdownlint",
          "prettierd",
          "protolint",
          "pyright",
          "rust_analyzer",
          "shellcheck",
          "stylelint",
          "stylelint-lsp",
          "stylua",
          "tailwindcss-language-server",
          "taplo",
          "typescript-language-server",
          "vim-language-server",
          "yamllint",
          "yaml-language-server",
        },
      },
    },
    {
      "jay-babu/mason-nvim-dap.nvim",
      cmd = { "DapInstall" },
      opts = {
        ensure_installed = { "codelldb", "debugpy", "node-debug2-adapter" },
      },
    },
    {
      "mrcjkb/rustaceanvim",
      ft = { "rust" },
      version = "^6",
      init = function()
        vim.g.rustaceanvim = function()
          local cfg = require("rustaceanvim.config")
          local capabilities = lsp_capabilities()
          return {
            tools = {
              float_win_config = {
                width = 0.8,
              },
            },
            -- LSP config
            server = {
              on_attach = function(client, bufnr)
                lsp_on_attach(client, bufnr)
                vim.cmd("compiler cargo")
                -- TODO: Not a fan of the dialog not being centered like vim.lsp.buf.code_action
                -- map("ga", function()
                --   vim.cmd.RustLsp("codeAction")
                -- end, { silent = true, desc = "Code Action", buffer = bufnr })
                map("gh", function()
                  vim.cmd.RustLsp({ "hover", "actions" })
                end, { silent = true, desc = "Hover", buffer = bufnr })
                map("<leader>cr", "<cmd>Make run<CR>", { desc = "cargo run", buffer = bufnr })
                map("<leader>cb", "<cmd>Make build<CR>", { desc = "cargo build", buffer = bufnr })
                map("<leader>cc", "<cmd>Make clippy<CR>", { desc = "cargo clippy", buffer = bufnr })
              end,
              capabilities = capabilities,
              default_settings = {
                ["rust-analyzer"] = {
                  assist = {
                    -- insert #[must_use] when generating as_ methods for enum variants.
                    emitMustUse = true,
                  },
                  cachePriming = {
                    -- Don't prime on start up, esp for quick edits
                    enable = false,
                    -- How many worker threads to handle priming caches.
                    numThreads = 8,
                  },
                  cargo = {
                    -- pass --all-features to cargo
                    features = "all",
                    -- Avoid locking CARGO_TARGET_DIR by using a sub-directory
                    targetDir = true,
                    -- target triple override
                    -- target = "wasm32-unknown-unknown",
                  },
                  runnables = {
                    extraTestBinaryArgs = { "--nocapture" },
                  },
                  check = {
                    -- Run `cargo clippy` instead of `cargo check`
                    command = "clippy",
                  },
                  completion = {
                    -- Limit completions returned
                    limit = 25,
                  },
                  diagnostics = {
                    -- Additional style lints
                    styleLints = { enable = true },
                  },
                  files = {
                    exclude = {
                      (vim.env.CARGO_TARGET_DIR or "target"),
                      "_",
                      "data",
                      "docs",
                      "dist",
                      "node_modules",
                      ".git",
                    },
                  },
                  hover = {
                    actions = {
                      -- Whether to show References action.
                      references = { enable = true },
                    },
                    show = {
                      -- How many variants of an enum to display when hovering on.
                      enumVariants = 10,
                      -- How many fields of a struct, variant or union to display
                      -- when hovering on.
                      fields = 10,
                    },
                  },
                  imports = {
                    -- Whether to enforce the import granularity setting for all files.
                    granularity = { enforce = true },
                    -- Don't group imports
                    group = { enable = false },
                  },
                  -- Disable inlay hints
                  inlayHints = {
                    bindingModeHints = { enable = false },
                    chainingHints = { enable = false },
                    closingBraceHints = { enable = false },
                    closureCaptureHints = { enable = false },
                    closureReturnTypeHints = { enable = false },
                    discriminantHints = { enable = false },
                    expressionAdjustmentHints = { enable = false },
                    genericParameterHints = {
                      const = { enable = false },
                      lifetime = { enable = false },
                      type = { enable = false },
                    },
                    implicitDrops = { enable = false },
                    lifetimeElisionHints = { enable = false },
                    parameterHints = { enable = false },
                    rangeExclusiveHints = { enable = false },
                    reborrowHints = { enable = false },
                    typeHints = { enable = false },
                  },
                  -- Intepret tests
                  interpret = { tests = true },
                  -- Increased syntax tree LRU
                  lru = { capacity = 256 },
                  -- How many worker threads in the main loop.
                  numThreads = 8,
                  procMacro = {
                    ignored = {
                      thiserror = {
                        "Error",
                      },
                      serde = {
                        "Serialize",
                        "Deserialize",
                      },
                    },
                  },
                  workspace = {
                    symbol = {
                      -- Limits the number of items returned from a workspace symbol search
                      search = { limit = 512 },
                    },
                  },
                  -- trace = {
                  --   server = "verbose",
                  -- },
                },
              },
            },
            dap = { adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path) },
          }
        end
      end,
    },
    {
      "neovim/nvim-lspconfig", -- language server
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "williamboman/mason-lspconfig.nvim",
        {
          "kosayoda/nvim-lightbulb", -- Lightbulb next to code actions
          opts = {
            autocmd = { enabled = true },
            sign = {
              text = "",
            },
          },
        },
        {
          "nvim-lua/lsp-status.nvim",
          config = function()
            local lsp_status = require("lsp-status")
            lsp_status.register_progress()
            lsp_status.config({
              status_symbol = "",
            })
          end,
        },
      },
      keys = {
        { "<leader>Li", "<cmd>LspInfo<CR>", desc = "LSP Info" },
        { "<leader>LI", "<cmd>LspInfo<CR>", desc = "LSP Install Info" },
        { "<leader>Ls", "<cmd>LspStart<CR>", desc = "Start LSP Server" },
        { "<leader>LS", "<cmd>LspStop<CR>", desc = "Stop LSP Server" },
        { "<leader>Lr", "<cmd>LspRestart<CR>", desc = "Restart LSP Server" },
        { "gd", NoLspClient, desc = "Go to Definition" },
        { "gD", NoLspClient, desc = "Go to Type Definition" },
        { "gh", NoLspClient, desc = "Symbol Information" },
        { "gH", NoLspClient, desc = "Signature Information" },
        { "gi", NoLspClient, desc = "Go to Implementation" },
        { "gr", NoLspClient, desc = "References" },
        { "gR", NoLspClient, desc = "Rename References" },
        { "ga", NoLspClient, desc = "Code Action" },
        { "ge", vim.diagnostic.open_float, desc = "Diagnostics" },
        {
          "gp",
          function()
            vim.diagnostic.jump({ count = -1, float = true })
          end,
          desc = "Previous Diagnostic",
        },
        {
          "gn",
          function()
            vim.diagnostic.jump({ count = 1, float = true })
          end,
          desc = "Next Diagnostic",
        },
        { "<leader>S", NoLspClient, desc = "LSP Symbols" },
        { "<localleader>f", "gq", desc = "Format" },
      },
      config = function()
        local capabilities = lsp_capabilities()
        local get_options = function(enhance)
          local opts = {
            on_attach = lsp_on_attach,
            capabilities = capabilities,
            flags = {
              debounce_text_changes = 200,
            },
          }
          if type(enhance) == "function" then
            enhance(opts)
          end
          return opts
        end

        local servers = {
          bashls = get_options(),
          cssls = get_options(function(opts)
            opts.settings = {
              css = {
                lint = {
                  unknownAtRules = "ignore",
                },
              },
            }
          end),
          html = get_options(),
          jsonls = get_options(function(opts)
            opts.cmd = { "vscode-json-languageserver", "--stdio" }
          end),
          pyright = get_options(function(opts)
            opts.settings = {
              python = {
                -- just in case
                -- analysis = { typeCheckingMode = "off" },
              },
            }
          end),
          clangd = get_options(function(opts)
            opts.cmd = { "clangd", "--background-index", "--clang-tidy" }
            opts.init_options = {
              fallbackFlags = { "-std=c++17" },
            }
          end),
          tailwindcss = get_options(function(opts)
            opts.filetypes = {
              "css",
              "html",
              "javascript",
              "javascriptreact",
              "markdown",
              "mdx",
              "rust",
              "typescript",
              "typescriptreact",
            }
            opts.init_options = {
              classAttributes = { "class", "className" },
              userLanguages = {
                rust = "html",
              },
            }
          end),
          ts_ls = get_options(function(opts)
            opts.filetypes = {
              "javascript",
              "javascriptreact",
              "typescript",
              "typescriptreact",
            }
          end),
          vimls = get_options(),
          wgsl_analyzer = get_options(),
          yamlls = get_options(function(opts)
            opts.settings = {
              yaml = {
                keyOrdering = false,
              },
            }
          end),
        }

        local lspconfig = require("lspconfig")
        for server, opts in pairs(servers) do
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
      end,
    },
    {
      "stevearc/conform.nvim",
      event = { "BufWritePost" },
      cmd = { "ConformInfo" },
      keys = {
        {
          "<leader>F",
          function()
            require("conform").format({ async = true, lsp_fallback = true })
          end,
          desc = "Format buffer",
        },
      },
      opts = {
        format_on_save = {
          lsp_format = "fallback",
        },
        formatters = {
          leptosfmt = {
            command = "leptosfmt",
            args = { "--stdin", "-e" },
          },
          rustfmt = {
            command = "rustfmt",
            args = { "--edition", "2024", "--emit=stdout" },
          },
        },
        formatters_by_ft = {
          c = { "clang_format" },
          cpp = { "clang_format" },
          css = { "prettierd" },
          fish = { "fish_indent" },
          graphql = { "prettierd" },
          html = { "rustywind", "prettierd" },
          javascript = { "eslint_d", "rustywind", "prettierd" },
          javascriptreact = { "eslint_d", "rustywind", "prettierd" },
          python = { "darker" }, -- black format only changed lines
          json = { "prettierd" },
          jsonc = { "prettierd" },
          lua = { "stylua" },
          -- FIXME: file truncaction
          -- markdown = { "prettierd" },
          rust = { "leptosfmt", "rustfmt" },
          toml = { "taplo" },
          typescript = { "eslint_d", "rustywind", "prettierd" },
          typescriptreact = { "eslint_d", "rustywind", "prettierd" },
          xml = { "xmlformat" },
          yaml = { "prettierd" },
          ["*"] = { "trim_whitespace" },
        },
      },
    },
    {
      "folke/trouble.nvim", -- quickfix LSP issues
      cmd = "Trouble",
      opts = {}, -- required empty opts to initialize
      keys = {
        { "<leader>tt", "<cmd>Trouble diagnostics toggle<CR>", desc = "toggle diagnostics" },
        { "<leader>tq", "<cmd>Trouble qflist toggle<CR>", desc = "toggle quickfix list" },
        { "<leader>tl", "<cmd>Trouble loclist toggle<CR>", desc = "toggle location list" },
      },
    },
    -- -----------------------------------------------------------------------------
    -- Auto-Completion
    -- -----------------------------------------------------------------------------
    {
      "hrsh7th/nvim-cmp", -- Auto-completion library
      cmd = "CmpStatus",
      event = "InsertEnter",
      dependencies = {
        "chrisgrieser/cmp-nerdfont",
        "dmitmel/cmp-digraphs",
        "f3fora/cmp-spell",
        "FelipeLema/cmp-async-path",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        "max397574/cmp-greek",
        "onsails/lspkind.nvim",
        "saadparwaiz1/cmp_luasnip",
        "uga-rosa/cmp-dictionary",
        {
          "L3MON4D3/LuaSnip", -- Snippets
          dependencies = {
            "honza/vim-snippets",
          },
          keys = {
            { "<leader>Es", "<cmd>lua require('luasnip.loaders').edit_snippet_files()<CR>", desc = "Edit Snippets" },
          },
          build = "make install_jsregexp",
          cond = function()
            return vim.fn.executable("make") == 1
          end,
          config = function()
            vim.g.snips_author = vim.fn.system("git config --get user.name | tr -d '\n'")
            vim.g.snips_email = vim.fn.system("git config --get user.email | tr -d '\n'")
            vim.g.snips_github = "https://github.com/lukexor"
            require("luasnip.loaders.from_snipmate").lazy_load({ paths = "./snippets" })
            require("luasnip.loaders.from_lua").lazy_load({ paths = "./snippets" })
          end,
        },
      },
      init = function()
        vim.g.cmp_enabled = true
      end,
      config = function()
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")
        local cmp = require("cmp")

        local has_words_before = function()
          unpack = unpack or table.unpack
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        cmp.setup({
          enabled = function()
            if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
              return false
            end
            return vim.g.cmp_enabled
          end,
          -- See: https://github.com/hrsh7th/nvim-cmp/issues/1565
          preselect = cmp.PreselectMode.None,
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function()
              if luasnip.jumpable(-1) then
                luasnip.jump(-1)
              end
            end, { "i", "s" }),
            ["<C-n>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<C-p>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<C-j>"] = cmp.mapping(function(fallback)
              if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<C-k>"] = cmp.mapping(function(fallback)
              if luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
            ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
            ["<C-e>"] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() }),
          }),
          formatting = {
            format = lspkind.cmp_format({
              mode = "symbol",
              menu = {
                luasnip = "[Snippet]",
                nvim_lsp = "[LSP]",
                buffer = "[Buffer]",
                digraphs = "[Digraphs]",
                nerdfont = "[NerdFont]",
                greek = "[Greek]",
                async_path = "[Path]",
              },
              symbol_map = {
                Class = "",
                Color = "",
                Copilot = "",
                Codeium = "",
                Constant = "π",
                Constructor = "",
                Enum = "",
                EnumMember = "",
                Event = "",
                Field = "",
                File = "",
                Folder = "",
                Function = "",
                Interface = "",
                Keyword = "",
                Method = "λ",
                Module = "",
                Operator = "",
                Property = "",
                Reference = "",
                Snippet = "",
                Struct = "",
                Text = "",
                TypeParameter = "",
                Unit = "",
                Value = "",
                Variable = "",
              },
            }),
          },
          sources = cmp.config.sources({
            { name = "luasnip" },
            { name = "nvim_lsp", keyword_length = 3 },
            { name = "codeium", keyword_length = 4 },
            { name = "buffer", keyword_length = 4 },
            { name = "spell", keyword_length = 3, keyword_pattern = [[\w\+]] },
            { name = "dictionary", keyword_length = 3, keyword_pattern = [[\w\+]] },
            { name = "digraphs" },
            { name = "nerdfont" },
            { name = "greek" },
            { name = "async_path" },
          }),
          sorting = {
            priority_weight = 1.0,
            comparators = {
              cmp.config.compare.exact,
              cmp.config.compare.locality,
              cmp.config.compare.recently_used,
              cmp.config.compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
              cmp.config.compare.offset,
              cmp.config.compare.kind,
              cmp.config.compare.sort_text,
              cmp.config.compare.length,
              cmp.config.compare.order,
            },
          },
          cmdline = {
            ["/"] = {
              mapping = cmp.mapping.preset.cmdline(),
              sources = {
                { name = "buffer" },
              },
            },
            [":"] = {
              mapping = cmp.mapping.preset.cmdline(),
              sources = cmp.config.sources({
                { name = "async_path" },
              }, {
                {
                  name = "cmdline",
                  option = {
                    ignore_cmds = { "Man", "!" },
                  },
                },
              }),
            },
          },
          experimental = {
            ghost_text = { enabled = true },
          },
        })
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter", -- AST Parser and highlighter
      build = ":TSUpdate",
      event = { "VeryLazy" },
      cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
      dependencies = {
        {
          "nvim-treesitter/nvim-treesitter-context",
          opts = {
            max_lines = 5,
            multiline_threshold = 2,
            trim_scope = "inner",
            min_window_height = 30,
          },
          build = function()
            -- Resolves compatibility issue with rayliwell/tree-sitter-rstml
            local context_queries = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter-context/queries"
            local rust_query = context_queries .. "/rust"
            local rstml_query = context_queries .. "/rust_with_rstml"

            -- Check if rust query exists and rstml symlink doesn't
            if vim.fn.isdirectory(rust_query) == 1 and vim.fn.isdirectory(rstml_query) == 0 then
              vim.fn.system("ln -s " .. rust_query .. " " .. rstml_query)
            end
          end,
        },
        "nvim-treesitter/nvim-treesitter-textobjects",
      },
      init = function(plugin)
        -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
        -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
        -- no longer trigger the **nvim-treesitter** module to be loaded in time.
        -- Luckily, the only things that those plugins need are the custom queries, which we make available
        -- during startup.
        require("lazy.core.loader").add_to_rtp(plugin)
        require("nvim-treesitter.query_predicates")
      end,
      keys = {
        { "<c-space>", desc = "Increment Selection" },
        { "<c-m-space>", desc = "Decrement Selection", mode = "x" },
      },
      opts = {
        ensure_installed = {
          "bash",
          "c",
          "cpp",
          "css",
          "dockerfile",
          "fish",
          "glsl",
          "graphql",
          "html",
          "javascript",
          "json",
          "lua",
          "make",
          "markdown",
          "markdown_inline",
          "proto",
          "python",
          "query",
          "regex",
          "rust",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
        },
        highlight = {
          enable = false,
        },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            scope_incremental = "<c-s>",
            node_decremental = "<c-m-space>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },
      },
      config = function(_, opts)
        -- Defer configs setup to improve initial startup time
        vim.defer_fn(function()
          require("nvim-treesitter.configs").setup(opts)

          -- Disable treesitter indentexpr for Python since it's wonky atm
          if vim.bo.filetype == "python" then
            vim.cmd([[set indentexpr=]])
          end
        end, 10)
      end,
    },
    {
      "rayliwell/tree-sitter-rstml",
      dependencies = { "nvim-treesitter/nvim-treesitter" },
      build = ":TSInstall rust_with_rstml",
      config = function()
        require("tree-sitter-rstml").setup()
      end,
    },
    {
      "nvim-lua/plenary.nvim", -- Async library
      lazy = true,
    },
    {
      "nvim-lua/popup.nvim", -- UI popup library
      lazy = true,
    },
    {
      cmd = "Telescope",
      "nvim-telescope/telescope.nvim", -- Fuzzy finder
      dependencies = {
        {
          "benfowler/telescope-luasnip.nvim",
          lazy = true,
          config = function()
            require("telescope").load_extension("luasnip")
          end,
        },
        "nvim-telescope/telescope-symbols.nvim",
        {
          "nvim-telescope/telescope-dap.nvim",
          lazy = true,
          config = function()
            require("telescope").load_extension("dap")
          end,
        },
        {
          "folke/noice.nvim",
          lazy = true,
          config = function()
            require("telescope").load_extension("noice")
          end,
        },
      },
      opts = {
        defaults = {
          preview = {
            filesize_limit = 100,
            timeout = 1000,
          },
        },
      },
      keys = {
        { "<leader>f", "<cmd>Telescope fd find_command=fd,-tfile,-H,-L,-E.git,-X,grep,-lI,.<CR>", desc = "Find File" },
        { "<leader>b", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
        { "<leader>C", "<cmd>Telescope commands<CR>", desc = "Commands" },
        { "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Git Branches" },
        { "<leader>gc", "<cmd>Telescope git_bcommits<CR>", desc = "Buffer Git Commits" },
        { "<leader>gC", "<cmd>Telescope git_commits<CR>", desc = "Git Commits" },
        { "<leader>gf", "<cmd>Telescope git_files<CR>", desc = "Git Files" },
        { "<leader>gt", "<cmd>Telescope git_status<CR>", desc = "Git Status" },
        { "<leader>I", "<cmd>Telescope oldfiles<CR>", desc = "Recent Files" },
        { "<leader>K", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
        { "<leader>m", "<cmd>Telescope marks<CR>", desc = "Marks" },
        { "<leader>M", "<cmd>Telescope notify<CR>", desc = "Notify Messages" },
        { "<leader>r", "<cmd>Telescope live_grep<CR>", desc = "Live Grep" },
        { "<leader>gs", "<cmd>Telescope grep_string<CR>", desc = "Grep String" },
        { "<leader>s", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Buffer Search" },
        { "<leader>dD", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
        { "<leader>Th", "<cmd>Telescope help_tags<CR>", desc = "Help" },
        { "<leader>N", "<cmd>Telescope luasnip<CR>", desc = "Snippets" },
        { "<c-u>", "<cmd>Telescope luasnip<CR>", mode = "i", desc = "Snippets" },
        { "<c-s>", "<cmd>Telescope symbols<CR>", mode = { "n", "i" }, desc = "Symbols" },
      },
      config = function()
        require("telescope").load_extension("notify")
      end,
    },
    -- -----------------------------------------------------------------------------
    -- Testing / Debugging
    -- -----------------------------------------------------------------------------
    {
      "romainl/vim-qf", -- Tame the quickfix window
      event = "VeryLazy",
      keys = {
        { "[q", "<Plug>(qf_qf_previous)", desc = "previous quickfix" },
        { "]q", "<Plug>(qf_qf_next)", desc = "next quickfix" },
        { "[l", "<Plug>(qf_loc_previous)", desc = "previous location" },
        { "]l", "<Plug>(qf_loc_next)", desc = "next location" },
        { "<leader>gq", "<Plug>(qf_qf_toggle)", desc = "toggle quickfix list" },
        { "<leader>gQ", "<cmd>cexpr []<CR>", desc = "clears quickfix list" },
      },
    },
    {
      "nvim-neotest/neotest",
      dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
      keys = {
        {
          "<leader>Tn",
          function()
            require("neotest").run.run()
          end,
          desc = "Run Nearest Test",
        },
        {
          "<leader>Ts",
          function()
            require("neotest").run.stop()
          end,
          desc = "Stop Nearest Test",
        },
        {
          "<leader>Td",
          function()
            require("neotest").run.run({ strategy = "dap" })
          end,
          desc = "Debug Nearest Test",
        },
        {
          "<leader>Tf",
          function()
            require("neotest").run.run(vim.fn.expand("%"))
          end,
          desc = "Run Tests in File",
        },
        {
          "<leader>TN",
          function()
            require("neotest").run.run_last()
          end,
          desc = "Run Last Test",
        },
        {
          "<leader>TD",
          function()
            require("neotest").run.run_last({ strategy = "dap" })
          end,
          desc = "Debug Last Test",
        },
      },
      config = function()
        require("neotest").setup({
          adapters = {
            require("rustaceanvim.neotest"),
          },
        })
      end,
    },
    {
      "rcarriga/nvim-dap-ui",
      dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
      },
      keys = {
        {
          "<leader>du",
          function()
            require("dapui").toggle()
          end,
          desc = "Toggle Dap UI",
        },
      },
    },
    {
      "mfussenegger/nvim-dap",
      keys = {
        {
          "<leader>db",
          function()
            require("dap").toggle_breakpoint()
          end,
          desc = "Toggle breakpoint",
        },
        {
          "<leader>dc",
          function()
            require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
          end,
          desc = "Set conditional breakpoint",
        },
        {
          "<leader>dC",
          function()
            require("dap").clear_breakpoints()
          end,
          desc = "Clear breakpoints",
        },
        {
          "<leader>dlp",
          function()
            require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
          end,
          desc = "Set logpoint",
        },
        {
          "<c-/>",
          function()
            require("dap").continue()
          end,
          desc = "Debug/Continue",
        },
        {
          "<leader>dl",
          function()
            require("dap").run_last()
          end,
          desc = "Run Last Debugger",
        },
        {
          "<c-\\>",
          function()
            require("dap").pause()
          end,
          desc = "Pause Debugger",
        },
        {
          "<leader>ds",
          function()
            require("dap").terminate()
          end,
          desc = "Stop debugger",
        },
        {
          "<leader>dr",
          function()
            require("dap").run_to_cursor()
          end,
          desc = "Run until cursor",
        },
        {
          "<leader>dR",
          function()
            require("dap").restart()
          end,
          desc = "Restart debugger",
        },
        {
          "<c-'>",
          function()
            require("dap").step_over()
          end,
          desc = "Step over",
        },
        {
          "<c-;>",
          function()
            require("dap").step_into()
          end,
          desc = "Step into",
        },
        {
          "<c-:>",
          function()
            require("dap").step_out()
          end,
          desc = "Step out",
        },
        {
          "<c-k>",
          function()
            require("dapui").eval()
          end,
          desc = "Evaluate expression",
        },
        {
          "<leader>dL",
          "<cmd>Telescope dap list_breakpoints<CR>",
          desc = "List breakpoints",
        },
      },
      config = function()
        vim.fn.sign_define("DapBreakpoint", { text = "🔴" })
        vim.fn.sign_define("DapBreakpointCondition", { text = "🟡" })
        vim.fn.sign_define("DapLogPoint", { text = "📕" })
        vim.fn.sign_define("DapStopped", { text = "⏸️" })
        vim.fn.sign_define("DapBreakpointRejected", { text = "❌" })
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "dap-repl",
          desc = "Set up DAP autocomplete",
          callback = function()
            require("dap.ext.autocompl").attach()
          end,
        })

        local dap = require("dap")
        dap.defaults.fallback.exception_breakpoints = { "uncaught" }
        dap.adapters.codelldb = codellb_adaptor
        dap.adapters.python = function(cb, config)
          if config.request == "attach" then
            local port = (config.connect or config).port
            local host = (config.connect or config).host or "127.0.0.1"
            cb({
              type = "server",
              port = assert(port, "`connect.port` is required for a python `attach` configuration"),
              host = host,
              options = {
                source_filetype = "python",
              },
            })
          else
            cb({
              type = "executable",
              command = vim.env.HOME .. "/.virtualenvs/debugpy/bin/python3",
              args = { "-m", "debugpy.adapter" },
              options = {
                source_filetype = "python",
              },
            })
          end
        end
        -- Find Rust types
        local initCommands = function()
          -- Find out where to look for the pretty printer Python module
          local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))

          local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
          local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

          local commands = {}
          local file = io.open(commands_file, "r")
          if file then
            for line in file:lines() do
              table.insert(commands, line)
            end
            file:close()
          end
          table.insert(commands, 1, script_import)

          return commands
        end
        local promptArgs = function()
          DapArgs = vim.fn.expand(vim.fn.input({ prompt = "Arguments: ", default = DapArgs, completion = "file" }))
          if DapArgs == "" then
            return nil
          end
          return { DapArgs }
        end
        local findRustTarget = function(flags)
          local pickers = require("telescope.pickers")
          local finders = require("telescope.finders")
          local conf = require("telescope.config").values
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")

          vim.cmd.write()
          local cmd = "cargo build " .. vim.fn.expand((flags or ""))
          vim.notify("Building `" .. cmd .. "`...")
          vim.fn.jobstart(cmd)
          assert(vim.v.shell_error == 0, "Build failed...")

          local profile = (flags:find("%-%-release") and "release") or flags:match("%-%-profile%s+(%S+)") or "debug"
          local cargo_dir = (vim.env.CARGO_TARGET_DIR or vim.fn.getcwd()) .. "/" .. profile

          return coroutine.create(function(co)
            local opts = {}
            pickers
              .new(opts, {
                prompt_title = "Executable",
                finder = finders.new_oneshot_job({
                  "fd",
                  "-E",
                  "*.dylib",
                  "-E",
                  "*.so",
                  "-t",
                  "x",
                  "-d",
                  "1",
                  ".",
                  cargo_dir,
                }, {}),
                sorter = conf.generic_sorter(opts),
                attach_mappings = function(buffer_number)
                  actions.select_default:replace(function()
                    actions.close(buffer_number)
                    coroutine.resume(co, action_state.get_selected_entry()[1])
                  end)
                  return true
                end,
              })
              :find()
          end)
        end
        dap.configurations.rust = {
          {
            name = "Launch",
            type = "codelldb",
            request = "launch",
            cwd = "${workspaceFolder}",
            initCommands = initCommands,
            program = findRustTarget,
          },
          {
            name = "Launch w/ Args",
            type = "codelldb",
            request = "launch",
            cwd = "${workspaceFolder}",
            initCommands = initCommands,
            args = promptArgs,
            program = findRustTarget,
          },
          {
            name = "Launch w/ Args & Build Flags",
            type = "codelldb",
            request = "launch",
            cwd = "${workspaceFolder}",
            initCommands = initCommands,
            args = promptArgs,
            program = function()
              DapFlags = vim.fn.input({ prompt = "Build Flags: ", default = DapFlags })
              return findRustTarget(DapFlags)
            end,
          },
          {
            name = "Attach",
            type = "codelldb",
            request = "attach",
            cwd = "${workspaceFolder}",
            pid = "${command:pickProcess}",
            initCommands = initCommands,
          },
        }
        dap.configurations.python = {
          {
            name = "Launch",
            type = "python",
            request = "launch",
            cwd = "${workspaceFolder}",
            program = "${file}",
            pythonPath = function()
              local cwd = vim.fn.getcwd()
              if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
                return cwd .. "/venv/bin/python"
              elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
                return cwd .. "/.venv/bin/python"
              else
                return vim.g.python3_host_prog
              end
            end,
          },
          {
            name = "Attach",
            type = "python",
            request = "attach",
            cwd = "${workspaceFolder}",
            pid = "${command:pickProcess}",
          },
        }

        local dapui = require("dapui")
        dapui.setup()
        dap.listeners.before.attach.dapui_config = dapui.open
        dap.listeners.before.launch.dapui_config = dapui.open
        dap.listeners.after.event_terminated.dapui_config = dapui.close
        dap.listeners.after.event_exited.dapui_config = dapui.close
      end,
    },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
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
    au TermOpen * setlocal nospell nonu nornu
    au BufRead,BufNewFile *.nu set ft=nu
    au BufRead,BufNewFile *.mdx set ft=markdown
    au BufRead,BufNewFile *.wgsl set ft=wgsl
    au BufRead,BufNewFile Vagrantfile set filetype=ruby
    au BufRead,BufNewFile *.vert,*.frag set ft=glsl
    au BufRead,BufNewFile Makefile.toml set ft=cargo-make
    au Filetype help set nu rnu
    au Filetype * set formatoptions=croqnjp
    au Filetype markdown set comments=
    au FileType c,cpp setlocal commentstring=//\ %s
    " Don't use rustfmt for formatting, it's already handled on file save
    " I just want the default gq behavior for line wrapping comments
    au Filetype rust setlocal formatprg=
  aug END
]])

vim.cmd([[
  aug Init
    au!
    au DiagnosticChanged * lua vim.diagnostic.setqflist({ open = false })
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
    au VimEnter * hi! link TreesitterContext FloatFooter
    " Make comments stand out, they're important!
    au VimEnter * hi! link rustCommentLineDoc FloatTitle
    au VimEnter * hi! link SpecialComment FloatTitle
    au VimEnter * hi! link Comment Question
    au VimEnter * hi! link WinSeparator CursorLineNr
  aug END
]])
