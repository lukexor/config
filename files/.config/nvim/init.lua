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

-- Require latest binaries for neovim, even if individual projects might use
-- older/outdated versions.
-- https://neovim.io/doc/user/provider.html
vim.g.python3_host_prog = vim.env.HOME .. "/.local/bin/python3"
vim.g.node_host_prog = vim.env.HOME .. "/.local/bin/node"
--- Highlight strings and numbers inside comments
vim.g.c_comment_strings = 1

vim.o.breakindent = true
vim.o.cmdheight = 1
vim.o.completeopt = "menu,menuone,noselect"
vim.o.confirm = true
vim.o.cursorline = true
vim.o.dictionary = "/usr/share/dict/words"
-- Make diffing better: https://vimways.org/2018/the-power-of-diff/
vim.opt.diffopt:append({ "iwhite", "algorithm:patience", "indent-heuristic" })
vim.o.expandtab = true
vim.o.incsearch = true
vim.o.jumpoptions = "stack,view"
vim.o.laststatus = 2
vim.o.list = true
vim.o.listchars = "tab:│ ,trail:+,extends:,precedes:,nbsp:‗"
vim.opt.matchpairs:append({ "<:>" })
vim.o.mouse = ""
vim.o.number = true
vim.opt.path:append({ "**" })
vim.o.redrawtime = 10000 -- Allow more time for loading syntax on large files
vim.o.relativenumber = true
vim.o.scrolloff = 8
vim.o.shell = vim.env.SHELL
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
      command = codelldb_ext_path .. "/adapter/codelldb",
    },
    host = "127.0.0.1",
    port = "${port}",
    type = "server",
  })
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
  local opts = vim.deepcopy(options or {})
  local mode = opts.mode or "n"
  opts.mode = nil
  vim.keymap.set(mode, lhs, rhs, opts)
end
local del_map = function(lhs, options)
  local opts = vim.deepcopy(options or {})
  local mode = opts.mode or "n"
  opts.mode = nil
  vim.keymap.del(mode, lhs, options)
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
  vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "LspDiagnosticsSignError" })
  vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "LspDiagnosticsSignWarning" })
  vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "LspDiagnosticsSignHint" })
  vim.fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "LspDiagnosticsSignInformation" })

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  map("gd", "m'<cmd>Telescope lsp_definitions<CR>", { desc = "Go To Definition", buffer = bufnr })
  map("gD", "m'<cmd>Telescope lsp_type_definitions<CR>", { desc = "Go To Type Definition", buffer = bufnr })
  map("gh", vim.lsp.buf.hover, { desc = "Symbol Information", buffer = bufnr })
  map("gH", vim.lsp.buf.signature_help, { desc = "Signature Information", buffer = bufnr })
  map("gi", "m'<cmd>Telescope lsp_implementations<CR>", { desc = "Go To Implementation", buffer = bufnr })
  map("gr", "m'<cmd>Telescope lsp_references<CR>", { desc = "References", buffer = bufnr })
  map("gR", vim.lsp.buf.rename, { desc = "Rename References", buffer = bufnr })
  map("ga", vim.lsp.buf.code_action, { desc = "Code Action", buffer = bufnr })
  map("ge", vim.diagnostic.open_float, { desc = "Diagnostics", buffer = bufnr })
  map("<leader>S", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "LSP Symbols", buffer = bufnr })

  -- Filter out diagnostics that are not useful
  local filtered_diagnostics = {
    [80001] = true, -- File is a CommonJS module; it may be converted to an ES module.
  }
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(function(err, result, ctx, config)
    for i, diagnostic in pairs(result.diagnostics) do
      if filtered_diagnostics[diagnostic.code] ~= nil then
        table.remove(result.diagnostics, i)
      end
    end
    vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
  end, { update_in_insert = true })
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

map("<leader>h", "<cmd>bp<CR>", { silent = true, desc = "Go to Previous Buffer" })
map("<leader>l", "<cmd>bn<CR>", { silent = true, desc = "Go to Next Buffer" })
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

map("<S-Down>", "<cmd>resize -5<CR>", { desc = "Reduce Height" })
map("<S-Up>", "<cmd>resize +5<CR>", { desc = "Increase Height" })
map("<S-Left>", "<cmd>vertical resize +5<CR>", { desc = "Reduce Width" })
map("<S-Right>", "<cmd>vertical resize -5<CR>", { desc = "Increase Width" })

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
  "mustache/vim-mustache-handlebars", -- Template parsing
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
        min_width = 40,
        default_direction = "prefer_right",
      },
    },
  },
  {
    "folke/which-key.nvim", -- Show mappings as you type
    event = "VeryLazy",
    opts = {},
  },
  -- -----------------------------------------------------------------------------
  -- Code Assists
  -- -----------------------------------------------------------------------------
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require("lint")
      -- TODO: test protolint
      lint.linters.protolint = {
        cmd = "protolint",
      }
      lint.linters.tidy_xml = {
        cmd = "tidy",
        stdin = true,
        stream = "stderr",
        args = {
          "-quiet",
          "-errors",
          "-language",
          "en",
          "-xml",
        },
      }
      lint.linters_by_ft = {
        bash = { "shellcheck" },
        css = { "stylelint" },
        cpp = { "cpplint" },
        glslc = { "glslc" },
        html = { "tidy_xml" },
        xml = { "tidy_xml" },
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
      vim.api.nvim_create_autocmd({ "InsertChange", "TextChanged", "TextChangedI" }, {
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
    ft = {
      "html",
      "javascript",
      "javascriptreact",
      "rust",
      "typescript",
      "typescriptreact",
      "xml",
    },
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
      { "<leader>=/", "gAii/", remap = true, desc = "align indent level to /" },
      { "<leader>=:", "gAii:", remap = true, desc = "align indent level to :" },
      { "<leader>==", "gAii=", remap = true, desc = "align indent level to =" },
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
    keys = {
      { "gC", "<Plug>RadicalView", desc = "show number conversions under cursor" },
      { "gC", "<Plug>RadicalView", mode = "v", desc = "show number conversions under selection" },
      { "crd", "<Plug>RadicalCoerceToDecimal", desc = "convert number to decimal" },
      { "crx", "<Plug>RadicalCoerceToHex", desc = "convert number to hex" },
      { "cro", "<Plug>RadicalCoerceToOctal", desc = "convert number to octal" },
      { "crb", "<Plug>RadicalCoerceToBinary", desc = "convert number to binary" },
    },
  },
  {
    "zirrostig/vim-schlepp", -- visually move blocks
    lazy = true,
    keys = {
      { "<S-Up>", "<Plug>SchleppUp", mode = "v", desc = "move selection up" },
      { "<S-Down>", "<Plug>SchleppDown", mode = "v", desc = "move selection down" },
      { "<S-Left>", "<Plug>SchleppLeft", mode = "v", desc = "move selection left" },
      { "<S-Right>", "<Plug>SchleppRight", mode = "v", desc = "move selection right" },
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
    "tpope/vim-eunuch", -- unix commands
    cmd = { "Remove", "Delete", "Move", "Rename", "Copy", "Mkdir", "Wall", "SudoWrite", "SudoEdit" },
  },
  {
    "tpope/vim-fugitive", -- git integration
    cmd = { "Git", "Gdiffsplit", "Gvdiffsplit", "GMove", "GBrowse", "GDelete" },
  },
  {
    "iamcco/markdown-preview.nvim", -- markdown browser viewer
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
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
    end,
  },
  -- TODO: Create TODO list shortcuts
  {
    "yardnsm/vim-import-cost", -- Javascript import sizes
    build = "npm install --production",
    cond = function()
      return vim.fn.executable("npm") == 1
    end,
    cmd = { "ImportCost" },
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
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
    end,
  },
  -- -----------------------------------------------------------------------------
  -- Windowing / Theme
  -- -----------------------------------------------------------------------------
  {
    "stevearc/dressing.nvim", -- Window UI enhancements, popups, input, etc
    event = "VeryLazy",
    opts = {},
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
    "Shatur/neovim-ayu", -- colorscheme
    init = function()
      vim.o.background = "dark"
    end,
    priority = 1000,
    config = function()
      local colors = require("ayu.colors")
      colors.generate()

      vim.cmd(([[
        aug CursorLine
          au!
          au InsertEnter * hi! CursorLine guibg=%s
          au InsertLeave * hi! CursorLine guibg=%s
        aug END
      ]]):format(colors.selection_inactive, colors.panel_bg))

      local ayu = require("ayu")
      ayu.setup({
        overrides = {
          BufTabLineActive = { bg = "none" },
          BufTabLineModifiedActive = { bg = "none" },
          CursorLine = { bg = colors.panel_bg },
          LineNr = { fg = colors.fg },
          Comment = { fg = colors.vcs_modified, italic = true },
          SpecialComment = { fg = colors.vcs_added, italic = true },
          Normal = { bg = "none" },
          FloatermBorder = { bg = "none" },
          SignColumn = { bg = "none" },
          TabLine = { bg = "none" },
          TabLineFill = { bg = "none" },
          TabLineSel = { fg = colors.tag, bg = "none" },
          VirtualTextInfo = { fg = colors.comment },
          Visual = { bg = colors.selection_bg },
          DiffAdd = { bg = "none", fg = colors.vcs_added },
          DiffDelete = { bg = "none", fg = colors.vcs_removed },
          DiffChange = { bg = "none", fg = colors.vcs_modified },
          DiffText = { bg = "none", fg = colors.special },
        },
      })
      ayu.colorscheme()
      vim.api.nvim_set_hl(0, "@lsp.type.comment.rust", {})
    end,
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
          theme = "ayu_dark",
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
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonUpdate" },
    keys = {
      { "<leader>pm", "<cmd>MasonUpdate<CR>:Mason<CR>", desc = "Update LSP Servers" },
    },
    opts = {
      ui = {
        check_outdated_servers_on_open = true,
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
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
        "python-lsp-server",
        "pyright",
        -- "rust_analyzer", -- Prefer rustup component
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
    version = "^4",
    ft = { "rust" },
    init = function()
      vim.g.rustaceanvim = function()
        local targets = {
          "wasm32-unknown-unknown",
        }
        local machine = vim.loop.os_uname().machine
        if os:find("Darwin") then
          table.insert(targets, machine .. "-apple-darwin")
        elseif os:find("Linux") then
          table.insert(targets, machine .. "-unknown-linux-gnu")
        elseif os:find("Windows") then
          table.insert(targets, machine .. "-pc-windows-gnu")
          table.insert(targets, machine .. "-pc-windows-msvc")
        end

        local cfg = require("rustaceanvim.config")
        return {
          -- LSP config
          server = {
            on_attach = function(client, bufnr)
              lsp_on_attach(client, bufnr)
              vim.lsp.inlay_hint.enable(bufnr)
              vim.cmd("compiler cargo")
              map("<leader>cr", "<cmd>Make run<CR>", { desc = "cargo run" })
              map("<leader>cb", "<cmd>Make build<CR>", { desc = "cargo build" })
              map("<leader>cc", "<cmd>Make clippy<CR>", { desc = "cargo clippy" })
            end,
            default_settings = {
              ["rust-analyzer"] = {
                assist = { emitMustUse = true },
                cargo = {
                  features = "all",
                },
                check = {
                  command = "clippy",
                  features = "all",
                  targets = targets,
                },
                hover = {
                  actions = {
                    references = { enable = true },
                  },
                },
                files = {
                  excludeDirs = {
                    vim.env.CARGO_TARGET_DIR,
                    ".rustup",
                    ".cargo",
                    ".git",
                    ".github",
                    ".gitlab",
                    ".gitlab-ci",
                    "assets",
                    "bin",
                    "data",
                    "dist",
                    "docs",
                    "images",
                    "node_modules",
                    "public",
                    "static",
                    "target",
                    "tmp",
                  },
                },
                imports = {
                  group = { enable = false },
                  granularity = { enforce = true },
                  prefix = "crate",
                },
                inlayHints = {
                  bindingModeHints = { enable = true },
                  closingBraceHints = { minLines = 1 },
                  closureCaptureHints = { enable = true },
                  discriminantHints = { enable = true },
                  expressionAdjustmentHints = { enable = true },
                  lifetimeElisionHints = { enable = true },
                },
                interpret = { tests = true },
                lens = {
                  references = {
                    adt = { enable = true },
                    enumVariant = { enable = true },
                    method = { enable = true },
                    trait = { enable = true },
                  },
                },
                lru = { capacity = 512 },
                procMacro = {
                  -- enable = false,
                  ignored = {},
                },
                workspace = {
                  symbol = {
                    search = { limit = 512 },
                  },
                },
                -- Uncomment for debugging
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
        "folke/neodev.nvim",
        opts = {
          library = { plugins = { "nvim-dap-ui" }, types = true },
        },
      },
    },
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
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
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
        jsonls = get_options(),
        pyright = get_options(function(opts)
          opts.settings = {
            python = {
              -- just in case
              -- analysis = { typeCheckingMode = "off" },
            },
          }
        end),
        clangd = get_options(function(opts)
          opts.filetypes = { "c", "cpp" }
          opts.offsetEncoding = { "utf-16" }
          opts.cmd = {
            "clangd",
            "--offset-encoding=utf-16",
          }
        end),
        -- rust_analyzer is handled by rustaceanvim
        lua_ls = get_options(function(opts)
          opts.settings = {
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
        tsserver = get_options(function(opts)
          opts.filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
          }
        end),
        vimls = get_options(),
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
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    opts = {
      format_after_save = {
        lsp_fallback = true,
      },
      formatters = {
        rustfmt = {
          command = "rustfmt",
          args = { "--edition", "2021", "--emit=stdout" },
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
        markdown = { "prettierd" },
        rust = { "rustfmt" },
        toml = { "taplo" },
        typescript = { "eslint_d", "rustywind", "prettierd" },
        typescriptreact = { "eslint_d", "rustywind", "prettierd" },
        yaml = { "prettierd" },
        ["*"] = { "trim_whitespace" },
      },
    },
  },
  {
    "folke/trouble.nvim", -- quickfix LSP issues
    cmd = { "TroubleToggle" },
    keys = {
      { "<leader>tt", "<cmd>TroubleToggle<CR>", desc = "toggle diagnostics" },
      {
        "<leader>tw",
        "<cmd>TroubleToggle workspace_diagnostics<CR>",
        desc = "toggle workspace diagnostics",
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
    "zbirenbaum/copilot-cmp", -- Copilot auto-complete. Must load after nvim-cmp
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/nvim-cmp",
      {
        "zbirenbaum/copilot.lua", -- AI auto-complete
        build = ":Copilot auth",
        cond = function()
          return vim.fn.executable("node") == 1
        end,
        cmd = "Copilot",
        opts = {
          suggestion = { enabled = false, auto_trigger = false },
          panel = { enabled = false },
          copilot_node_command = vim.g.node_host_prog,
        },
      },
    },
    config = function(_, opts)
      local copilot_cmp = require("copilot_cmp")
      copilot_cmp.setup(opts)
      -- Fixes lazy loading on attach
      copilot_cmp._on_insert_enter()
    end,
  },
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
          ["<Tab>"] = cmp.mapping({
            i = function(fallback)
              if cmp.visible() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
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
            end,
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
            end,
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
            end,
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
            end,
          }),
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
          { name = "copilot" }, -- keyword_length doesn't seem to work with copilot
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
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    -- setup is deferred until later
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
    "nvim-telescope/telescope.nvim", -- Fuzzy finder
    cmd = "Telescope",
    version = false,
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim", -- Search dependency of telescope
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
        lazy = true,
      },
      "benfowler/telescope-luasnip.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      "nvim-telescope/telescope-dap.nvim",
      "folke/noice.nvim",
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
      { "<leader>f", "<cmd>Telescope fd<CR>", desc = "Find File" },
      {
        "<leader>H",
        "<cmd>Telescope fd find_command=rg,--files,--hidden,--no-ignore,--glob,!.git<CR>",
        desc = "Find Hidden File",
      },
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
      { "<leader>T", "<cmd>Telescope help_tags<CR>", desc = "Help" },
      { "<leader>N", "<cmd>Telescope luasnip<CR>", desc = "Snippets" },
      { "<c-u>", "<cmd>Telescope luasnip<CR>", mode = "i", desc = "Snippets" },
      { "<c-s>", "<cmd>Telescope symbols<CR>", mode = { "n", "i" }, desc = "Symbols" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.load_extension("notify")
      telescope.load_extension("luasnip")
      telescope.load_extension("fzf")
      telescope.load_extension("noice")
      telescope.load_extension("dap")
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
    "vim-test/vim-test", -- run unit tests
    cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast", "TestVisit" },
    keys = {
      { "<leader>Tn", "<cmd>TestNearest<CR>", desc = "run nearest test" },
      { "<leader>Tf", "<cmd>TestFile<CR>", desc = "run test file" },
      { "<leader>Ts", "<cmd>TestSuite<CR>", desc = "run test suite" },
      { "<leader>Tl", "<cmd>TestLast<CR>", desc = "run last test" },
      { "<leader>Tv", "<cmd>TestVisit<CR>", desc = "open last test file" },
    },
  },
  {
    "tpope/vim-dispatch", -- background build and test dispatcher
  },
  {
    "radenling/vim-dispatch-neovim", -- Adds neovim terminal support to vim-dispatch
  },
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
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
        "<leader>lp",
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
        "<leader>dL",
        "<cmd>Telescope dap list_breakpoints<CR>",
        desc = "List breakpoints",
      },
    },
    config = function()
      vim.fn.sign_define("DapBreakpoint", { text = "🔴" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "🟡" })
      vim.fn.sign_define("DapLogPoint", { text = "📕" })
      vim.fn.sign_define("DapStopped", { text = "󰏤" })
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
      dap.configurations.rust = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          cwd = "${workspaceFolder}",
          args = function()
            dap_args = vim.fn.input({ prompt = "Arguments: ", default = dap_args, completion = "file" })
            if dap_args == "" then
              return nil
            end
            return { dap_args }
          end,
          program = function()
            local pickers = require("telescope.pickers")
            local finders = require("telescope.finders")
            local conf = require("telescope.config").values
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            vim.cmd.write()
            vim.notify("Building...")
            return coroutine.create(function(co)
              vim.fn.system("cargo build")
              assert(vim.v.shell_error == 0, "Build failed...")

              local opts = {}
              pickers
                .new(opts, {
                  prompt_title = "Path to executable",
                  finder = finders.new_oneshot_job({
                    "fd",
                    "--exclude",
                    "*.dylib",
                    "--type",
                    "x",
                    "--max-depth",
                    "2",
                    ".",
                    vim.env.CARGO_TARGET_DIR,
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
          end,
          initCommands = initCommands,
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
      dap.listeners.after.event_initialized.dapui_config = function()
        dapui.open()
        map("<leader>dr", "<cmd>lua require('dap').run_to_cursor()<CR>", { desc = "Run until cursor", buffer = true })
        map("<leader>dR", "<cmd>lua require('dap').restart()<CR>", { desc = "Restart debugger", buffer = true })
        map("<leader>dS", "<cmd>lua require('dap').terminate()<CR>", { desc = "Stop debugger", buffer = true })
        map("<c-\\>", "<cmd>lua require('dap').pause()", { desc = "Pause Debugger", buffer = true })
        map("<c-'>", "<cmd>lua require('dap').step_over()<CR>", { desc = "Step over", buffer = true })
        map("<c-;>", "<cmd>lua require('dap').step_into()<CR>", { desc = "Step into", buffer = true })
        map("<c-:>", "<cmd>lua require('dap').step_out()<CR>", { desc = "Step out", buffer = true })
        map(
          "K",
          "<cmd>lua require('dapui').eval()<CR>",
          { mode = { "n", "v" }, desc = "Evaluate expression", buffer = true }
        )
      end
      dap.listeners.after.event_terminated.dapui_config = function()
        dapui.close()
        del_map("<leader>dr", { buffer = true })
        del_map("<leader>dR", { buffer = true })
        del_map("<leader>dS", { buffer = true })
        del_map("<c-\\>", { buffer = true })
        del_map("<c-'>", { buffer = true })
        del_map("<c-;>", { buffer = true })
        del_map("<c-:>", { buffer = true })
        del_map("K", { mode = { "n", "v" }, buffer = true })
      end
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    event = "VeryLazy",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    keys = {
      {
        "<leader>du",
        function()
          require("dapui").toggle({})
        end,
        desc = "Dap UI",
      },
    },
    opts = {},
  },
}, {
  checker = {
    enabled = true,
    notify = false,
  },
})

-- Defer treesitter setup to improve initial startup time
vim.defer_fn(function()
  require("nvim-treesitter.configs").setup({
    autotag = {
      enable = true,
      enable_rename = true,
      enable_close_on_slash = false,
      filetypes = {
        "html",
        "javascript",
        "javascriptreact",
        "rust",
        "typescript",
        "typescriptreact",
        "xml",
      },
    },
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
      enable = true,
      disable = { "rust" },
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
  })
  -- Disable treesitter indentexpr for Python since it's wonky atm
  if vim.bo.filetype == "python" then
    vim.cmd([[set indentexpr=]])
  end

  require("mason").setup({
    ui = {
      check_outdated_servers_on_open = true,
    },
  })
  require("mason-nvim-dap").setup({
    ensure_installed = { "codelldb", "debugpy", "node-debug2-adapter" },
  })
  require("mason-tool-installer").setup({
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
      -- "rust_analyzer", -- Prefer rustup component
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
  })
end, 0)

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
    au BufRead,BufNewFile Vagrantfile set filetype=ruby
    au BufRead,BufNewFile *.vert,*.frag set ft=glsl
    au BufRead,BufNewFile Makefile.toml set ft=cargo-make
    au Filetype help set nu rnu
    au Filetype * set formatoptions=croqnjp
    au Filetype markdown set comments=
    au FileType c,cpp setlocal commentstring=//\ %s
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
  aug END
]])
