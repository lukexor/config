--
--                                    i  t
--                                   LE  ED.
--                                  L#E  E#K:
--                                 G#W.  E##W;
--                                D#K.   E#E##t
--                               E#K.    E#t ##f
--                             .E#E.     E#t  ;#D.
--                            .K#E       E#ELLE##K:
--                           .K#D        E#L;;;;;;,
--                          .W#G      .K E#t
--                         :W##########W E#t
--                         :,,,,,,,,,,,, .
--
--
--     Personal vim configuration of Luke Petherbridge <me@lukeworks.tech>

-- =============================================================================
-- Abbreviations
-- =============================================================================

local typos = {
  adn = "and",
  liek = "like",
  liekwise = "likewise",
  pritn = "print",
  retrun = "return",
  teh = "the",
  tehn = "then",
  tihs = "this",
  waht = "what",
}
for typo, fix in pairs(typos) do
  vim.cmd.iabbrev(typo .. " " .. fix)
end

-- =============================================================================
-- Settings
-- =============================================================================

-- Enable UI v2
require("vim._core.ui2").enable({ enable = true })

-- Theme & transparency
vim.cmd.colorscheme("slate")

-- Overrides for slate
vim.api.nvim_set_hl(0, "IncSearch", { fg = "#211c1c", bg = "#f9cc6c" })
vim.api.nvim_set_hl(0, "Visual", { bg = "#423a3b" })

-- Envs
vim.env.PAGER = "bat" -- Don"t use nvim as a pager within itself

-- Basic
vim.modeline = false        -- Disable modelines, as it's a security risk
vim.o.number = true         -- Line numbers
vim.o.relativenumber = true -- Relative line numbers
vim.o.numberwidth = 2       -- Width of the line number column
vim.o.cursorline = true     -- Highlight current line
vim.o.wrap = false          -- Don"t wrap lines
vim.o.scrolloff = 8         -- Keep 8 lines above/below cursor
vim.o.sidescrolloff = 8     -- Keep 8 columns left/right of cursor

-- Indentation
vim.o.tabstop = 2        -- Tab width
vim.o.shiftwidth = 2     -- Indent width
vim.o.softtabstop = 2    -- Soft tab stop
vim.o.shiftround = true  -- Round indent to multiple of shiftwidth
vim.o.expandtab = true   -- Use spaces instead of tabs
vim.o.smartindent = true -- Smart auto-indenting, for when indentexpr is unset
vim.o.breakindent = true -- Visually indent wrapped lines

-- Search
vim.o.ignorecase = true -- Case insensitive search
vim.o.smartcase = true  -- Case sensitive if uppercase in search

-- Visual
vim.g.c_comment_strings = 1 -- Highlight strings and numbers inside
vim.o.signcolumn = "yes" -- Always show sign column with 2 cols
vim.o.textwidth = 80 -- Auto-wrap inserted text
vim.o.showmatch = true -- Highlight matching brackets
vim.opt.matchpairs:append("<:>") -- Add < and > to match pairs
vim.o.completeopt = "menuone,popup,noselect" -- Completion options
vim.o.wildmode = "longest:full,full" -- Complete longest match, then full, cycle with Tab
vim.o.showmode = false -- Hide mode, shown in statusline
vim.o.pumheight = 10 -- Popup menu height
vim.o.pumblend = 10 -- Popup menu transparency
vim.o.virtualedit = "block" -- Allow cursor anywhere in Visual block mode
vim.o.redrawtime = 10000 -- Allow more time for loading syntax on large files
vim.o.maxmempattern = 20000 -- Increase memory (in Kb) for pattern matching
vim.o.synmaxcol = 500 -- Syntax highlighting limit
vim.opt.fillchars = { eob = " " } -- Hide ~ on empty lines
vim.o.list = true -- Show whitespace characters
vim.o.listchars = "tab:| ,trail:+,extends:,precedes:,nbsp:‗" -- Hidden characters
vim.o.conceallevel = 0 -- Show listchars

-- File handling
vim.g.loaded_netrw = 1                                                    -- disable netrw
vim.g.loaded_netrwPlugin = 1                                              -- disable netrw
vim.o.grepprg = "rg --no-heading --vimgrep"                               -- ripgrep
vim.o.title = true                                                        -- Update window title
vim.o.undofile = true                                                     -- Persistent undo
vim.o.updatecount = 50                                                    -- Save every 50 characters typed
vim.o.updatetime = 300                                                    -- Save swap after not typing for 300ms
vim.o.timeoutlen = 700                                                    -- Key timeout duration
vim.opt.spellfile:append(vim.fn.expand("~/.config/nvim/spell.utf-8.add")) -- Custom spell definitions
vim.opt.diffopt:append("iwhite,algorithm:patience")                       -- Better diffs: https://vimways.org/2018/the-power-of-diff/
vim.opt.diffopt:append("linematch:60")                                    -- Wider line diff margin

-- Behavior
vim.o.confirm = true                   -- Confirm actions instead of failing
vim.opt.iskeyword:append("-")          -- Treat dash as part of word
vim.opt.path:append("**")              -- include subdirectories in search
vim.o.mouse = ""                       -- Disable mouse
vim.o.jumpoptions = "stack,view,clean" -- Better jump list tracking

-- Folding
vim.o.foldmethod = "indent"
-- vim.o.foldmethod = "expr" -- Use expression for folding
-- vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use treesitter for folding
vim.o.foldlevel = 99 -- Start with all folds open

-- Split
vim.o.splitbelow = true -- Horizontal splits go below
vim.o.splitright = true -- Vertical splits go right

-- =============================================================================
-- Statusline
-- =============================================================================

-- Git branch function with caching and Nerd Font icon
do
  local cached_branch = ""
  local last_check = 0
  _G.git_branch = function()
    local now = os.time()
    if now - last_check > 5 then
      last_check = now
      cached_branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
    end
    if cached_branch ~= "" then
      return " \u{e725} " .. cached_branch .. " " -- nf-dev-git_branch
    end
    return ""
  end

  -- File type with Nerd Font icon
  _G.file_type = function()
    local ft = vim.bo.filetype
    if ft == "" then
      return " \u{f15b} " -- nf-fa-file_o
    end

    local icons = {
      lua = "\u{e620} ",                              -- nf-dev-lua
      python = "\u{e73c} ",                           -- nf-dev-python
      javascript = "\u{e74e} ",                       -- nf-dev-javascript
      typescript = "\u{e628} ",                       -- nf-dev-typescript
      javascriptreact = "\u{e7ba} ",                  -- nf-dev-react
      typescriptreact = "\u{e7ba} ",                  -- nf-dev-react
      html = "\u{e736} ",                             -- nf-dev-html5
      css = "\u{e749} ",                              -- nf-dev-css3
      scss = "\u{e749} ",                             -- nf-dev-css3
      json = "\u{e60b} ",                             -- nf-dev-json
      markdown = "\u{e73e} ",                         -- nf-dev-markdown
      vim = "\u{e62b} ",                              -- nf-dev-vim
      sh = "\u{f489} ",                               -- nf-oct-terminal
      bash = "\u{f489} ",                             -- nf-oct-terminal
      zsh = "\u{f489} ",                              -- nf-oct-terminal
      rust = "\u{e7a8} ",                             -- nf-dev-rust
      go = "\u{e724} ",                               -- nf-dev-go
      c = "\u{e61e} ",                                -- nf-dev-c
      cpp = "\u{e61d} ",                              -- nf-dev-cplusplus
      java = "\u{e738} ",                             -- nf-dev-java
      php = "\u{e73d} ",                              -- nf-dev-php
      ruby = "\u{e739} ",                             -- nf-dev-ruby
      swift = "\u{e755} ",                            -- nf-dev-swift
      kotlin = "\u{e634} ",                           -- nf-custom-kotlin
      dart = "\u{e798} ",                             -- nf-dev-dart
      elixir = "\u{e62d} ",                           -- nf-custom-elixir
      haskell = "\u{e777} ",                          -- nf-dev-haskell
      sql = "\u{e706} ",                              -- nf-dev-database
      yaml = "\u{f481} ",                             -- nf-oct-file_symlink_file
      toml = "\u{e615} ",                             -- nf-seti-config
      xml = "\u{f05c} ",                              -- nf-fa-circle_xmark
      dockerfile = "\u{f308} ",                       -- nf-linux-docker
      gitcommit = "\u{f418} ",                        -- nf-oct-git_commit
      gitconfig = "\u{f1d3} ",                        -- nf-fa-git
      vue = "\u{fd42} ",                              -- nf-md-vuejs
      svelte = "\u{e697} ",                           -- nf-seti-svelte
      astro = "\u{e628} ",                            -- nf-seti-typescript
    }
    return ((icons[ft] or " \u{f15b} ") .. ft .. " ") -- nf-fa-file
  end

  -- File size with Nerd Font icon
  _G.file_size = function()
    local size = vim.fn.getfsize(vim.fn.expand("%"))
    if size < 0 then
      return ""
    end

    local size_str
    if size < 1024 then
      size_str = size .. "B"
    elseif size < 1024 * 1024 then
      size_str = string.format("%.1fK", size / 1024)
    else
      size_str = string.format("%.1fM", size / 1024 / 1024)
    end
    return " \u{f016} " .. size_str .. " " -- nf-fa-file_o
  end

  -- Mode indicators with Nerd Font icons
  _G.mode_icon = function()
    local mode = vim.fn.mode()
    local modes = {
      n = " \u{f121}  NORMAL",                   -- nf-fa-code
      i = " \u{f11c}  INSERT",                   -- nf-fa-keyboard
      v = " \u{f0168} VISUAL",                   -- nf-md-code_array
      V = " \u{f0168} V-LINE",                   -- nf-md-code_array
      ["\22"] = " \u{f0168} V-BLOCK",            -- nf-md-code_array
      c = " \u{f120} COMMAND",                   -- nf-fa-terminal
      s = " \u{f0c5} SELECT",                    -- nf-fa-copy
      S = " \u{f0c5} S-LINE",                    -- nf-fa-copy
      ["\19"] = " \u{f0c5} S-BLOCK",             -- nf-fa-copy
      R = " \u{f044} REPLACE",                   -- nf-fa-edit
      r = " \u{f044} REPLACE",                   -- nf-fa-edit
      ["!"] = " \u{f489} SHELL",                 -- nf-oct-terminal
      t = " \u{f120} TERMINAL",                  -- nf-fa-terminal
    }
    return modes[mode] or (" \u{f059} " .. mode) -- nf-fa-circle_question
  end

  -- LSP status
  function _G.lsp_status()
    local status = vim.lsp.status()
    if status == "" then
      return ""
    end
    local max = 40
    local truncated = vim.fn.strcharpart(status, 0, max)
    if vim.fn.strcharlen(status) > max then
      truncated = truncated .. "…"
    end
    return "\u{e0b1} \u{f013} " .. truncated -- nf-fa-cog
  end

  -- Diagnostic error counts
  function _G.diagnostic_errors()
    local counts = vim.diagnostic.count(0)
    local errors = counts[vim.diagnostic.severity.ERROR] or 0
    if errors == 0 then
      return ""
    end
    return string.format(" %d", errors)
  end

  function _G.diagnostic_warnings()
    local counts = vim.diagnostic.count(0)
    local warnings = counts[vim.diagnostic.severity.WARN] or 0
    if warnings == 0 then
      return ""
    end
    return string.format(" %d", warnings)
  end

  -- Function to change statusline based on window focus
  vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    callback = function()
      if vim.bo.filetype == "" then
        return
      end
      vim.wo.cursorline = true -- cursorline on active window
      vim.opt_local.statusline = table.concat({
        "  ",
        "%#SpecialChar#",
        "%{v:lua.mode_icon()}",
        "%#Special#",
        " \u{e0b1}", -- nf-pl-left_hard_divider
        " %f %h%m%r",
        "%{v:lua.git_branch()}",
        "\u{e0b1} ", -- nf-pl-left_hard_divider
        "%{v:lua.file_type()}",
        "\u{e0b1}",  -- nf-pl-left_hard_divider
        "%{v:lua.file_size()}",
        "%{v:lua.lsp_status()}",
        "%=", -- Right-align everything after this
        " %#DiagnosticSignError#%{v:lua.diagnostic_errors()}",
        " %#DiagnosticSignWarn#%{v:lua.diagnostic_warnings()}",
        "%#Special#",
        " \u{f017} %l:%c  %P ", -- nf-fa-clock_o for line/col
      })
    end,
  })
  vim.api.nvim_create_autocmd("LspProgress", {
    callback = function()
      vim.cmd.redrawstatus()
    end,
  })
  vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    callback = function()
      if vim.bo.filetype == "" then
        return
      end
      vim.wo.cursorline = false                                                       -- no cursorline on inactive window
      vim.wo.statusline = "  %f %h%m%r \u{e0b1} %{v:lua.file_type()} %=  %l:%c   %P " -- nf-pl-left_soft_divider
    end,
  })
end

-- =============================================================================
-- Keymaps
-- =============================================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
local function bool2str(b)
  return b and "enabled" or "disabled"
end

-- Navigation

-- Better movement in wrapped text and set location mark
map("n", "j", function()
  return vim.v.count > 0 and "m'" .. vim.v.count .. "j" or "gj"
end, { expr = true, silent = true })
map("n", "k", function()
  return vim.v.count > 0 and "m'" .. vim.v.count .. "k" or "gk"
end, { expr = true, silent = true })

map("i", "<C-c>", "<Esc>", { remap = true, desc = "Leave Insert" })

map("n", "<C-h>", "<C-w>h", { desc = "Go to Nth left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Nth below window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Nth above window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Nth right window" })

map("n", "gt", "<C-]>", { desc = "Go to Tag" })

map("n", "n", "nzzzv", { desc = "Next search (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search (centered)" })
map("n", "*", "*zzzv", { desc = "Search forward" })
map("n", "#", "#zzzv", { desc = "Search backwards" })
map("n", "g*", "g*zzzv", { desc = "Search forwards without word boundary" })
map("n", "g#", "g#zzzv", { desc = "Search backwards without word boundary" })
map("n", "<C-f>", "<C-f>Mzz", { desc = "Page down (centered)" })
map("n", "<C-b>", "<C-b>Mzz", { desc = "Page up (centered)" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

map("n", "J", "mzJ`z", { desc = "Join lines and keep cursor" })

map("n", "<leader><CR>", "<cmd>nohlsearch|diffupdate|normal !<C-l><CR>", { desc = "Clear Highlighting" })
map("n", "<leader>G", ":silent grep ", { desc = "Grep" })
map("v", "<C-r>", '"hy:%s/\\<<C-r>h\\>//g<left><left>', { desc = "Search and Replace Selection" })
map("n", "<leader>sr", ":%s//g<left><left>", { desc = "Global Search and Replace" })
map("n", "<leader>sR", ":%s/\\<<C-r><C-w>\\>//g<left><left>", { desc = "Search and Replace word under cursor" })

map("n", "<leader>n", "<cmd>new<CR>", { desc = "New Buffer" })
map("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader><leader>", "<C-^>", { desc = "Alternate Buffer" })
map("n", "<leader>D", function()
  require("mini.bufremove").delete()
end, { desc = "Delete Buffer" })

-- Editing
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>W", "<cmd>noa w<CR>", { desc = "Save/No Formatting" })
map("n", "<leader>q", "<cmd>confirm q<CR>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>confirm qall<CR>", { desc = "Quit All" })
map("n", "<leader>O", "<cmd>%bd|e#|bd#<CR>", { desc = "Quit all but current" })

map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

map("c", "<C-a>", "<Home>", { desc = "Go to start of line" })
map("c", "<C-b>", "<Left>", { desc = "Go back one character" })
map("c", "<C-d>", "<Del>", { desc = "Delete one character under cursor" })
map("c", "<C-e>", "<End>", { desc = "Go to the end of line" })
map("c", "<C-f>", "<Right>", { desc = "Go forward one character" })
map("c", "<C-n>", "<Down>", { desc = "Recall newer command-line" })
map("c", "<C-p>", "<Up>", { desc = "Recall previous command-line" })
map("c", "<M-b>", "<S-Left>", { desc = "Go back one word" })
map("c", "<M-f>", "<S-Right>", { desc = "Go forward one word" })

map("i", "<C-bs>", "<C-w>", { desc = "Delete previous word" })

map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Case statements in bash use `;;`
map("n", "<leader>;", "A;<Esc>", { desc = "Append ;" })
map("n", "<leader>,", "A,<Esc>", { desc = "Append ," })

-- Add breaks in undo chain when typing punctuation
map("i", ".", ".<C-g>u", { desc = "." })
map("i", ",", ",<C-g>u", { desc = "," })
map("i", "!", "!<C-g>u", { desc = "!" })
map("i", "?", "?<C-g>u", { desc = "?" })

-- ASCII
map("n", "<leader>ab", "<cmd>.!toilet -w 200 -f term -F border<CR>", { desc = "ASCII Border" })
map("n", "<leader>aS", "<cmd>.!figlet -w 200 -f small<CR>", { desc = "ASCII Small" })
map("n", "<leader>as", "<cmd>.!figlet -w 200 -f standard<CR>", { desc = "ASCII Standard" })

-- Windows
map("n", "|", ":vsplit<CR>", { desc = "Split window vertically" })
map("n", "\\", ":split<CR>", { desc = "Split window horizontally" })
map("n", "<leader>h", "<C-w><S-H>", { desc = "Move window to left vertical splt" })
map("n", "<leader>l", "<C-w><S-L>", { desc = "Move window to right vertical splt" })
map("n", "<leader>k", "<C-w><S-K>", { desc = "Move window to top horizontal splt" })
map("n", "<leader>j", "<C-w><S-J>", { desc = "Move window to bottom horizontal splt" })
map("n", "<leader>-", "<C-w>_<C-w>|", { desc = "Maximize window" })
map("n", "<leader>=", "<C-w>=", { desc = "Equal Window Sizes" })
map({ "n", "i" }, "<C-Down>", "<cmd>resize -5<CR>", { desc = "Reduce Height" })
map({ "n", "i" }, "<C-Up>", "<cmd>resize +5<CR>", { desc = "Increase Height" })
map({ "n", "i" }, "<C-Right>", "<cmd>vertical resize +10<CR>", { desc = "Reduce Width" })
map({ "n", "i" }, "<C-Left>", "<cmd>vertical resize -10<CR>", { desc = "Increase Width" })

-- Tabs
map("n", "<leader>tn", ":tabnew<CR>", { desc = "New tab" })
map("n", "<leader>tx", ":tabclose<CR>", { desc = "Close tab" })
map("n", "<leader>tm", ":tabmove<CR>", { desc = "Move tab" })
map("n", "<leader>t>", ":tabmove +1<CR>", { desc = "Move tab right" })
map("n", "<leader>t<", ":tabmove -1<CR>", { desc = "Move tab left" })

map("n", "<leader>td", function()
  local current_file = vim.fn.expand("%:p")
  if current_file ~= "" then
    vim.cmd("tabnew " .. current_file)
  else
    vim.cmd("tabnew")
  end
end, { desc = "Duplicate current tab" })
map("n", "<leader>tr", function()
  local current_tab = vim.fn.tabpagenr()
  local last_tab = vim.fn.tabpagenr("$")
  for i = last_tab, current_tab + 1, -1 do
    vim.cmd(i .. "tabclose")
  end
end, { desc = "Close tabs to the right" })
map("n", "<leader>tL", function()
  local current_tab = vim.fn.tabpagenr()
  for _ = current_tab - 1, 1, -1 do
    vim.cmd("1tabclose")
  end
end, { desc = "Close tabs to the left" })

map("n", "Q", "<nop>", { desc = "Disable ExMode" })
map("n", "gQ", "<nop>", { desc = "Disable ExMode" })

-- Files
map("n", "<leader>fr", function()
  local old_name = vim.fn.expand("%")
  local new_name = require("mini.input").get({ prompt = "New file name: ", scope = "buffer", init_keys = { old_name } })
  if new_name ~= "" and new_name ~= old_name then
    vim.cmd("saveas " .. new_name)
    vim.fn.delete(old_name)
    print("File renamed to: " .. new_name)
  end
end, { desc = "Rename current file" })
map("n", "<leader>cn", "<cmd>edit $MYVIMRC<CR>", { desc = "Edit Nvim Config" })
map("n", "<leader>cr", "<cmd>source $MYVIMRC<CR>:edit<CR>", { desc = "Reload Nvim Config" })
map("n", "<leader>cR", "<cmd>restart<CR>", { desc = "Restart Nvim" })

map("n", "cd", function()
  vim.fn.chdir(vim.fn.expand("%:p:h"))
end, { desc = "Change to current file's directory" })
map("n", "lcd", function()
  vim.fn.chdir(vim.fn.expand("%:p:h"), "window")
end, { desc = "Change to current file's directory (local" })
map("n", "<leader>cx", function()
  local first_line = vim.fn.getline(1)
  if string.match(first_line, "^#!/") then
    local file = vim.fn.expand("%")
    local escaped_file = vim.fn.shellescape(file)
    vim.cmd("!chmod +x " .. escaped_file)
  else
    vim.notify("file is not a script. missing shebang")
  end
end, { desc = "Change to current file's directory (local" })

-- Clipboard
map({ "n", "v" }, "cy", '"+y', { desc = "Yank to clipboard" })
map({ "n", "v" }, "cY", '"+Y', { desc = "Yank to end of line to clipboard" })
map("n", "cyy", '"+yy', { desc = "Yank line to clipbard" })
map({ "n", "v" }, "cd", '"+d', { desc = "Delete to clipboard" })
map("n", "cD", '"+D', { desc = "Delete to end of line to clipboard" })
map("n", "cdd", '"+dd', { desc = "Delete line to clipbard" })
map({ "n", "v" }, "cp", '"+p', { desc = "Paste from clipboard after cursor" })
map({ "n", "v" }, "cP", '"+P', { desc = "Paste from clipboard before cursor" })

-- Visual
do
  local gutter_enabled = true
  local function toggle_gutter()
    gutter_enabled = not gutter_enabled
    vim.notify("gutter " .. bool2str(gutter_enabled))
    if gutter_enabled then
      vim.cmd("set rnu nu list signcolumn=yes foldcolumn=1")
    else
      vim.cmd("set nornu nonu nolist signcolumn=no foldcolumn=0")
    end
  end
  map("n", "<leader>ug", toggle_gutter, { desc = "Toggle Gutter" })
end
map("n", "<leader>us", function()
  vim.o.spell = not vim.o.spell
  vim.notify("spell " .. bool2str(vim.o.spell))
end, { desc = "Toggle Spellcheck" })
map("n", "<leader>uS", function()
  vim.o.conceallevel = vim.o.conceallevel == 0 and 1 or 0
  vim.notify("conceal " .. bool2str(vim.o.conceallevel == 1))
end, { desc = "Toggle Conceal" })
map("n", "<leader>uw", function()
  vim.o.wrap = not vim.o.wrap -- local to window
  vim.notify("wrap " .. bool2str(vim.o.wrap))
end, { desc = "Toggle Wrap" })
map("n", "<leader>uW", function()
  local wrap = not vim.opt.formatoptions:get().t
  if wrap then
    vim.opt.formatoptions:append("t")
  else
    vim.opt.formatoptions:remove("t")
  end
  vim.notify("auto-wrap " .. bool2str(wrap))
end, { desc = "Toggle Text Auto-Wrap" })

map("n", "<leader>S", function()
  local line = vim.fn.line(".")
  local col = vim.fn.col(".")
  local hi = vim.fn.synIDattr(vim.fn.synID(line, col, 1), "name")
  local trans = vim.fn.synIDattr(vim.fn.synID(line, col, 0), "name")
  local lo = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.synID(line, col, 0)), "name")
  vim.cmd(("echo 'hi<%s> trans<%s> lo<%s>'"):format(hi, trans, lo))
end, { desc = "Show syntax ID under cursor" })

-- Text Objects

map("o", "af", ":normal Vaf<CR>", { silent = true, desc = "around fold" })
map("v", "af", ":<C-u>silent! normal! [zV]z<CR>", { silent = true, desc = "around fold" })

-- =============================================================================
-- Autocmds
-- =============================================================================

vim.api.nvim_create_user_command("Diff", function()
  local orig_buf = vim.api.nvim_get_current_buf()
  local orig_cursor = vim.api.nvim_win_get_cursor(0)

  vim.cmd("tabnew")
  local tab = vim.api.nvim_get_current_tabpage()

  -- Left: original
  local saved_buf = vim.api.nvim_get_current_buf()
  vim.bo[saved_buf].buftype = "nofile"
  vim.bo[saved_buf].bufhidden = "wipe"
  vim.bo[saved_buf].swapfile = false
  vim.cmd("r ++edit #")
  vim.cmd("0d_")
  vim.cmd("diffthis")

  -- Right: modified
  vim.cmd("vert new")
  local current_buf = vim.api.nvim_get_current_buf()
  vim.bo[current_buf].buftype = "nofile"
  vim.bo[current_buf].bufhidden = "wipe"
  vim.bo[current_buf].swapfile = false
  local lines = vim.api.nvim_buf_get_lines(orig_buf, 0, -1, false)
  vim.api.nvim_buf_set_lines(current_buf, 0, -1, false, lines)
  vim.cmd("diffthis")

  local closed = false
  local function restore()
    if closed then
      return
    end
    closed = true
    if vim.api.nvim_tabpage_is_valid(tab) then
      vim.cmd("tabclose")
    end
    -- Restore cursor in orig_buf if it's visible somewhere
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == orig_buf then
        vim.api.nvim_win_set_cursor(win, orig_cursor)
        break
      end
    end
  end

  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = saved_buf,
    once = true,
    callback = function()
      vim.schedule(restore)
    end,
  })
  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = current_buf,
    once = true,
    callback = function()
      vim.schedule(restore)
    end,
  })
end, {
  desc = "Show modified diff",
})
map("n", "<leader>bd", "<cmd>Diff<CR>", { desc = "Show modified diff" })

local user_aug = vim.api.nvim_create_augroup("UserConfig", { clear = true })

do
  local ft_overrides = {
    ["*.nu"] = "nu",
    ["*.mdx"] = "markdown",
    ["Vagrantfile"] = "ruby",
    ["*.wgsl"] = "wgsl",
    ["*.vert,*.frag"] = "glsl",
    ["Makefile.toml"] = "cargo-make",
  }
  for pattern, ft in pairs(ft_overrides) do
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      group = user_aug,
      pattern = pattern,
      callback = function()
        vim.bo.filetype = ft
      end,
    })
  end
end

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  group = user_aug,
  desc = "Highlight long lines",
  callback = function(ev)
    local win = vim.api.nvim_get_current_win()
    local buf = ev.buf
    local bo = vim.bo[buf]
    local matches = vim.fn.getmatches(win)
    for _, m in ipairs(matches) do
      if m.group == "WarningMsg" and m.pattern:find("\\%%>") then
        vim.fn.matchdelete(m.id, win)
      end
    end

    if vim.o.diff or bo.buftype ~= "" or bo.filetype == "gitcommit" or bo.filetype == "gitrebase" then
      return
    end

    local size = vim.fn.getfsize(vim.fn.expand("%"))
    if size <= 100000 then
      vim.fn.matchadd("WarningMsg", [[\%>]] .. 120 .. [[v.\+]])
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = user_aug,
  desc = "Highlight on yank",
  callback = function()
    vim.hl.on_yank({ higroup = "Search", timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = user_aug,
  desc = "Restore last cursor position",
  callback = function(ev)
    -- Ignore certain buf types
    local buf = ev.buf
    local bo = vim.bo[buf]
    if vim.o.diff or bo.buftype ~= "" or bo.filetype == "gitcommit" or bo.filetype == "gitrebase" then
      return
    end

    local last_pos = vim.api.nvim_buf_get_mark(buf, '"') -- {line, col}
    local line_count = vim.api.nvim_buf_line_count(buf)
    local row = last_pos[1]
    if row > 0 and row <= line_count then
      vim.api.nvim_win_set_cursor(0, last_pos)
      -- defer centering so it's applied after render
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "" then
          vim.cmd("normal! zz")
        end
      end)
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = user_aug,
  desc = "Remove trailing space on save",
  callback = function(ev)
    -- Trim trailing space
    if vim.bo[ev.buf].modifiable then
      local mt = require("mini.trailspace")
      mt.trim()
      mt.trim_last_lines()
    end
    -- Create missing directories
    local dir = vim.fn.expand("<afile>:p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- More reliable than FileType for existing help buffers
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = user_aug,
  desc = "Open help in vertical split",
  callback = function()
    if vim.bo.buftype == "help" then
      vim.cmd("wincmd L")
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = user_aug,
  pattern = { "markdown", "text", "gitcommit" },
  desc = "Wrap, linebreak and spellcheck on markdown and text files",
  callback = function()
    vim.wo.wrap = true
    vim.wo.linebreak = true
    vim.wo.spell = true
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = user_aug,
  desc = "Resize splits when resized",
  command = "tabdo wincmd =",
})

vim.api.nvim_create_autocmd("CmdwinEnter", {
  group = user_aug,
  desc = "Reminder how to quit command window",
  command = [[echohl Todo | echo 'You discovered the command-line window! You can close it with ":q".' | echohl None]],
})

-- t: auto-wrap text using 'textwidth'
-- c: auto-wrap comments using 'textwidth'
-- r: insert comment on <Enter>
-- q: format with "gq"
-- n: reorganize numbered lists on format
-- l: don't break long lines in insert if already longer than 'textwidth'
-- j: remove comment leader when joining lines
-- p: don't break single spaces following periods
vim.api.nvim_create_autocmd("FileType", {
  group = user_aug,
  desc = "Override file plugin format options",
  -- Can use CTRL-U to quickly delete auto-inserted comment leader
  callback = function()
    vim.opt_local.formatoptions = "crqnljp"
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group = user_aug,
  desc = "Markdown overrides",
  pattern = "markdown",
  callback = function()
    vim.wo.wrap = false
    vim.opt_local.formatoptions = "trqnljp"

    map("n", "<leader>pp", function()
      vim.cmd("MarkdownPreview")
    end, { desc = "Preview Markdown" })
  end,
})

-- =============================================================================
-- Plugins
-- =============================================================================

-- Utility to lazy load a plugin prior to calling a function
local function once(fn)
  local done = false
  return function(...)
    if not done then
      done = true
      fn(...)
    end
  end
end

map("n", "<leader>pu", function()
  vim.pack.update()
end, { desc = "Update plugins" })

vim.cmd.packadd("nvim.undotree")
vim.api.nvim_create_autocmd("FileType", {
  pattern = "nvim-undotree",
  callback = function()
    vim.cmd.wincmd("H") -- Left-aligned
    vim.api.nvim_win_set_width(0, 40)
  end,
})

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind

    if name == "markdown-preview.nvim" and (kind == "install" or kind == "update") then
      if not ev.data.active then
        vim.cmd.packadd("markdown-preview.nvim")
      end
      vim.fn["mkdp#util#install"]()
    end
  end,
})

local gh = function(x)
  return "https://github.com/" .. x
end
local cb = function(x)
  return "https://codeberg.org/" .. x
end
vim.pack.add({
  {
    src = gh("saghen/blink.cmp"),
    -- V2 is under active development with many breaking changes.
    version = vim.version.range("1.*"),
  },
  gh("immanuwell/droast.nvim"),
  gh("creativenull/efmls-configs-nvim"),
  gh("ibhagwan/fzf-lua"),
  cb("andyg/leap.nvim"),
  gh("mason-org/mason.nvim"),
  gh("chentoast/marks.nvim"),
  gh("nvim-mini/mini.nvim"),
  cb("mfussenegger/nvim-dap.git"),
  gh("brenoprata10/nvim-highlight-colors"),
  gh("nvim-neotest/nvim-nio"),
  gh("rcarriga/nvim-dap-ui"),
  gh("neovim/nvim-lspconfig"),
  gh("nvim-tree/nvim-tree.lua"),
  gh("nvim-treesitter/nvim-treesitter"),
  gh("iamcco/markdown-preview.nvim"),
  {
    src = gh("mrcjkb/rustaceanvim"),
    version = vim.version.range("^9"),
  },
})

-- omarchy theme
do
  local ok, theme = pcall(require, "plugins.theme")
  if ok then
    local plugin = theme[1]
    if plugin ~= nil then
      local url = plugin[1]
      vim.pack.add({ gh(url) })
      if type(plugin.config) == "function" then
        plugin.config()
      end
      local lazy = theme[2]
      if lazy ~= nil then
        local opts = lazy["opts"]
        if opts ~= nil and opts["colorscheme"] ~= nil then
          vim.cmd("colorscheme " .. opts["colorscheme"])
          -- Transparent background
          vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
          vim.api.nvim_set_hl(0, "normalnc", { bg = "none" })
          vim.api.nvim_set_hl(0, "endofbuffer", { bg = "none" })
          vim.api.nvim_set_hl(0, "normalfloat", { bg = "none" })
          vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
          vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
          vim.api.nvim_set_hl(0, "StatusLine", { bg = "#211c1c" })
          vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#211c1c" })
          vim.api.nvim_set_hl(0, "TabLine", { bg = "none" })
          vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none", fg = "#767676" })
          vim.api.nvim_set_hl(0, "TabLineSel", { bg = "none" })
          vim.api.nvim_set_hl(0, "ColorColumn", { bg = "none" })
          -- Force statusline to standout a bit
          vim.api.nvim_set_hl(0, "StatusLine", { bg = "#111111" })
          vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#111111" })
        end
      end
    end
  end
end

-- blink
vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    vim.pack.add({
      gh("L3MON4D3/LuaSnip"),
    })
    vim.g.snips_author = vim.fn.system("git config --get user.name | tr -d '\n'")
    vim.g.snips_email = vim.fn.system("git config --get user.email | tr -d '\n'")
    vim.g.snips_github = "https://github.com/lukexor"

    require("luasnip.loaders.from_snipmate").lazy_load({ paths = vim.env.HOME .. "/.config/nvim/snippets" })
    require("luasnip.loaders.from_lua").lazy_load({ paths = vim.env.HOME .. "/.config/nvim/snippets" })
    require("blink.cmp").setup({
      signature = { enabled = true },
      keymap = {
        preset = "none",
        ["<C-Space>"] = { "show", "hide" },
        ["<C-k>"] = { "show_documentation", "hide_documentation" },
        ["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
        ["<Tab>"] = { "select_and_accept", "fallback" },
        ["<C-n>"] = { "select_next", "fallback_to_mappings" },
        ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-l>"] = { "snippet_forward", "fallback" },
        ["<C-h>"] = { "snippet_backward", "fallback" },
      },
      completion = {
        menu = {
          auto_show = false,
          auto_show_delay_ms = 500,
          draw = {
            components = {
              -- nvim-highlight-colors integration
              kind_icon = {
                text = function(ctx)
                  local icon = ctx.kind_icon
                  if ctx.item.source_name == "LSP" then
                    local color_item =
                        require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
                    if color_item and color_item.abbr ~= "" then
                      icon = color_item.abbr
                    end
                  end
                  return icon .. ctx.icon_gap
                end,
                highlight = function(ctx)
                  local highlight = "BlinkCmpKind" .. ctx.kind
                  if ctx.item.source_name == "LSP" then
                    local color_item =
                        require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
                    if color_item and color_item.abbr_hl_group then
                      highlight = color_item.abbr_hl_group
                    end
                  end
                  return highlight
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 300,
        },
      },
      sources = {
        default = { "lsp", "buffer", "snippets", "path" },
        providers = {
          snippets = {
            min_keyword_length = 2,
          },
        },
      },
      snippets = {
        preset = "luasnip",
      },
      fuzzy = {
        implementation = "prefer_rust_with_warning",
        prebuilt_binaries = { download = true },
      },
    })
  end,
})

-- droast
require("droast").setup({ args = { "--preset", "production" } })

-- fzf-lua
local ensure_fzf = once(function()
  local actions = require("fzf-lua.actions")
  require("fzf-lua").setup({
    winopts = { backdrop = 85 },
    keymap = {
      builtin = {
        ["<C-f>"] = "preview-page-down",
        ["<C-b>"] = "preview-page-up",
        ["<C-p>"] = "toggle-preview",
      },
      fzf = {
        ["ctrl-a"] = "toggle-all",
        ["ctrl-t"] = "first",
        ["ctrl-g"] = "last",
        ["ctrl-d"] = "half-page-down",
        ["ctrl-u"] = "half-page-up",
      },
    },
    files = {
      cmd = "rg --files",
      hidden = false,
    },
    actions = {
      files = {
        ["enter"] = actions.file_edit_or_qf,
        ["ctrl-s"] = actions.file_split,
        ["ctrl-v"] = actions.file_vsplit,
        ["ctrl-t"] = actions.file_tabedit,
        ["alt-q"] = actions.file_sel_to_qf,
        ["alt-Q"] = actions.file_sel_to_ll,
        ["alt-i"] = actions.toggle_ignore,
        ["alt-h"] = actions.toggle_hidden,
        ["alt-f"] = actions.toggle_follow,
      },
    },
  })
  require("fzf-lua").register_ui_select()
end)

map({ "n", "v", "i" }, "<C-x><C-f>", function()
  ensure_fzf()
  require("fzf-lua").complete_file({
    cmd = "fd",
    winopts = { preview = { hidden = true } },
  })
end, { silent = true, desc = "Fuzzy complete path" })

map("n", "<leader>ff", function()
  ensure_fzf()
  require("fzf-lua").files()
end, { desc = "FZF Files" })
map("n", "<leader>fF", function()
  ensure_fzf()
  require("fzf-lua").git_files()
end, { desc = "FZF Git Files" })
map("n", "<leader>fg", function()
  ensure_fzf()
  require("fzf-lua").live_grep()
end, { desc = "FZF Live Grep" })
map("n", "<leader>fb", function()
  ensure_fzf()
  require("fzf-lua").buffers()
end, { desc = "FZF Buffers" })
map("n", "<leader>fh", function()
  ensure_fzf()
  require("fzf-lua").help_tags()
end, { desc = "FZF Help Tags" })
map("n", "<leader>fm", function()
  ensure_fzf()
  require("fzf-lua").marks()
end, { desc = "FZF Marks" })
map("n", "z=", function()
  ensure_fzf()
  require("fzf-lua").spell_suggest()
end, { desc = "FZF Marks" })
map("n", "<leader>fk", function()
  ensure_fzf()
  require("fzf-lua").keymaps()
end, { desc = "FZF Keymaps" })
map("n", "<leader>fx", function()
  ensure_fzf()
  require("fzf-lua").diagnostics_document()
end, { desc = "FZF Diagnostics Document" })
map("n", "<leader>fX", function()
  ensure_fzf()
  require("fzf-lua").diagnostics_workspace()
end, { desc = "FZF Diagnostics Workspace" })
map("n", "<leader>fs", function()
  ensure_fzf()
  require("fzf-lua").spellcheck()
end, { desc = "FZF Spellcheck" })
map("n", "<leader>fu", function()
  ensure_fzf()
  require("fzf-lua").undotree()
end, { desc = "FZF Undotree" })

local unicode = nil
local function fzf_unicode()
  -- TODO: Find more comprehensive emoji/icon source
  local MiniIcons = require("mini.icons")
  if unicode == nil then
    unicode = {}
    for _, cat in ipairs({ "default", "directory", "extension", "file", "filetype", "lsp", "os" }) do
      for _, name in ipairs(MiniIcons.list(cat)) do
        local icon = MiniIcons.get(cat, name)
        table.insert(unicode, string.format("%s  %s", icon, name))
      end
    end
  end

  ensure_fzf()
  require("fzf-lua").fzf_exec(unicode, {
    complete = true,
    winopts = { title = " Icons " },
  })
end
map("n", "<leader>fe", fzf_unicode, { desc = "FZF Emoji" })
map("i", "<C-x><C-e>", fzf_unicode, { desc = "FZF Emoji" })

-- leap
map({ "n", "x", "o" }, "s", "<Plug>(leap)")
map({ "x", "o" }, "x", "<Plug>(leap-next-to)")
map("n", "S", "<Plug>(leap-from-window)")

require("leap").opts.preview = function(ch0, ch1, ch2)
  return not (ch1:match("%s") or (ch0:match("%a") and ch1:match("%a") and ch2:match("%a")))
end

-- LuaSnip
map("n", "<leader>cs", function()
  require("luasnip.loaders").edit_snippet_files()
end, { desc = "Edit Snippets" })

-- mason
require("mason").setup()

map("n", "<leader>Li", "<cmd>Mason<CR>", { desc = "Mason" })

-- marks
require("marks").setup()

-- mini
require("mini.extra").setup()
require("mini.ai").setup({
  custom_textobjects = {
    i = require("mini.extra").gen_ai_spec.indent(),
  },
})
require("mini.align").setup() -- `ga` or `gA`
require("mini.bracketed").setup()
require("mini.bufremove").setup()
require("mini.diff").setup({
  view = {
    style = "sign",
    signs = { add = "▎", change = "▎", delete = "▎" },
  },
})
vim.api.nvim_create_user_command("Git", function(ev)
  vim.api.nvim_del_user_command("Git")
  require("mini.git").setup()
  vim.cmd(ev.mods .. " Git " .. ev.args)
end, { nargs = "*" })
map("n", "<leader>gs", "<cmd>horizontal Git status<CR>", { desc = "Git Status" })
map("n", "<leader>gb", "<cmd>vertical Git blame %<CR>", { desc = "Git Blame" })

require("mini.hipatterns").setup({
  highlighters = {
    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
  },
})
require("mini.icons").setup()
require("mini.input").setup()
require("mini.operators").setup()
require("mini.trailspace").setup()

require("mini.notify").setup({
  lsp_progress = {
    enable = false, -- LSP status is in the statusline
  },
})
map("n", "<leader>H", function()
  require("mini.notify").show_history()
end, { desc = "Show notification history" })

require("mini.surround").setup({
  mappings = {
    add = "gza",
    delete = "gzd",
    find = "gzf",
    find_left = "gzF",
    highlight = "gzh",
    replace = "gzr",
  },
})
-- Surround text with punctuation easier 'gza' + {motion}
map("n", '<leader>"', 'gzaiw"', { remap = true, desc = 'surround text with ""' })
map("n", "<leader>'", "gzaiw'", { remap = true, desc = "surround text with ''" })
map("n", "<leader>(", "gzaiw(", { remap = true, desc = "surround text with ( )" })
map("n", "<leader>)", "gzaiw)", { remap = true, desc = "surround text with ()" })
map("n", "<leader><", "gzaiw>", { remap = true, desc = "surround text with <>" })
map("n", "<leader>>", "gzaiw>", { remap = true, desc = "surround text with <>" })
map("n", "<leader>[", "gzaiw[", { remap = true, desc = "surround text with [ ]" })
map("n", "<leader>]", "gzaiw]", { remap = true, desc = "surround text with []" })
map("n", "<leader>`", "gzaiw`", { remap = true, desc = "surround text with ``" })
map("n", "<leader>{", "gzaiw{", { remap = true, desc = "surround text with { }" })
map("n", "<leader>}", "gzaiw}", { remap = true, desc = "surround text with {}" })
map("n", "<leader>|", "gzaiw|", { remap = true, desc = "surround text with ||" })
-- Same mappers for visual mode
map("v", '<leader>"', 'gza"', { remap = true, desc = 'surround text with ""' })
map("v", "<leader>'", "gza'", { remap = true, desc = "surround text with ''" })
map("v", "<leader>(", "gza(", { remap = true, desc = "surround text with ( )" })
map("v", "<leader>)", "gza)", { remap = true, desc = "surround text with ()" })
map("v", "<leader><", "gza>", { remap = true, desc = "surround text with <>" })
map("v", "<leader>>", "gza>", { remap = true, desc = "surround text with <>" })
map("v", "<leader>[", "gza[", { remap = true, desc = "surround text with [ ]" })
map("v", "<leader>]", "gza]", { remap = true, desc = "surround text with []" })
map("v", "<leader>`", "gza`", { remap = true, desc = "surround text with ``" })
map("v", "<leader>{", "gza{", { remap = true, desc = "surround text with { }" })
map("v", "<leader>}", "gza}", { remap = true, desc = "surround text with {}" })
map("v", "<leader>|", "gza|", { remap = true, desc = "surround text with ||" })

-- nvim-dap / nvim-dap-ui

do
  local ensure_dap = once(function()
    local dap = require("dap")
    local dapui = require("dapui")

    dap.defaults.fallback.exception_breakpoints = { "uncaught" }
    dap.adapters.codelldb = {
      type = "executable",
      command = "codelldb",
    }
    dap.listeners.before.attach.dapui_config = function()
      dapui.open({ layout = 1 })
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open({ layout = 1 })
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    require("dapui").setup({
      expand_lins = true,
      controls = { enabled = false },
      floating = { border = "rounded" },
      render = {
        max_type_length = 60,
        max_value_lins = 200,
      },
      layouts = {
        -- Default layout: Scopes only on the bottom
        {
          elements = {
            { id = "scopes", size = 1.0 },
          },
          size = 50,
          position = "left",
        },
        -- Breakpoints + Stacks + threads on the left
        {
          elements = {
            { id = "breakpoints", size = 0.4 },
            { id = "stacks",      size = 0.6 },
          },
          size = 50,
          position = "right",
        },
        -- Watches + Repl on the right
        {
          elements = {
            { id = "repl",    size = 0.8 },
            { id = "watches", size = 0.2 },
          },
          size = 10,
          position = "bottom",
        },
      },
    })
  end)

  vim.fn.sign_define("DapBreakpoint", { text = "󰑊" })
  vim.fn.sign_define("DapBreakpointCondition", { text = " " })
  vim.fn.sign_define("DapLogPoint", { text = " " })
  vim.fn.sign_define("DapStopped", { text = "" })
  vim.fn.sign_define("DapBreakpointRejected", { text = " " })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "dap-repl",
    desc = "Set up DAP autocomplete",
    callback = function()
      require("dap.ext.autocompl").attach()
    end,
  })

  map("n", "<leader>db", function()
    ensure_dap()
    require("dap").toggle_breakpoint()
  end, { desc = "Toggle breakpoint" })
  map("n", "<leader>dc", function()
    ensure_dap()
    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end, { desc = "Set conditional breakpoint" })
  map("n", "<leader>dC", function()
    ensure_dap()
    require("dap").clear_breakpoints()
  end, { desc = "Clear breakpoints" })
  map("n", "<leader>dlp", function()
    ensure_dap()
    require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
  end, { desc = "Set logpoint" })
  map("n", "<c-/>", function()
    ensure_dap()
    require("dap").continue()
  end, { desc = "Debug/Continue" })
  map("n", "<leader>dl", function()
    ensure_dap()
    require("dap").run_last()
  end, { desc = "Run Last Debugger" })
  map("n", "<c-\\>", function()
    ensure_dap()
    require("dap").pause()
  end, { desc = "Pause Debugger" })
  map("n", "<leader>ds", function()
    ensure_dap()
    require("dap").terminate()
  end, { desc = "Stop debugger" })
  map("n", "<leader>dr", function()
    ensure_dap()
    require("dap").run_to_cursor()
  end, { desc = "Run until cursor" })
  map("n", "<leader>dR", function()
    ensure_dap()
    require("dap").restart()
  end, { desc = "Restart debugger" })
  map("n", "<c-'>", function()
    ensure_dap()
    require("dap").step_over()
  end, { desc = "Step over" })
  map("n", "<c-;>", function()
    ensure_dap()
    require("dap").step_into()
  end, { desc = "Step into" })
  map("n", "<c-:>", function()
    ensure_dap()
    require("dap").step_out()
  end, { desc = "Step out" })

  map("n", "<leader>du", function()
    ensure_dap()
    require("dapui").toggle({ layout = 1 })
  end, { desc = "DAP Scope" })
  map("n", "<leader>dws", function()
    ensure_dap()
    require("dapui").toggle({ layout = 2 })
  end, { desc = "DAP Breakpoints/Stacks/Threads" })
  -- Reference:
  --
  -- Expressions
  -- - my_var               -- inspect variable
  -- - my_vec[3]            -- array index
  -- - my_var.field.nested  -- struct field
  --
  -- LLDB
  -- - bt                   -- backtrace current thread
  -- - bt all               -- backtrace all threads
  -- - th list              -- list thread status
  -- - th select 2          -- switch to thread
  -- - fr info              -- frame details
  -- - fr select 3          -- jump to stack frame
  -- - dis --pc             -- disassemble around current PC
  -- - dis -n my_fn         -- disassemble function
  map("n", "<leader>dww", function()
    ensure_dap()
    require("dapui").toggle({ layout = 3 })
  end, { desc = "DAP Watches/REPL" })
  map({ "n", "v" }, "<leader>de", function()
    ensure_dap()
    require("dapui").eval()
  end, { desc = "DAP Eval" })
  -- Reference:
  --
  -- Basic
  -- - my_var               -- local variable
  -- - my_vec[0]            -- array index
  -- - my_var.field.nested  -- struct field
  -- - *my_ptr              -- deref pointer
  -- - &my_var              -- address
  -- - my_var->field        -- deref field (*my_var).field
  --
  -- Formatters
  -- - my_var,x             -- hex display
  -- - my_var,b             -- binary display
  -- - my_var,d             -- decimal display
  -- - my_var,o             -- octal display
  -- - my_var,p             -- pointer display
  -- - my_var,[8]           -- cast to array of 8 elems
  -- - my_var,x[8]          -- cast to array of 8 elems in hex
  --
  -- Math
  -- - my_var * 2           -- multiply by 2
  -- - my_var > 0           -- conditional
  map("n", "<leader>dwa", function()
    ensure_dap()
    require("dapui").elements.watches.add(vim.fn.input("Watch: "))
    require("dapui").open({ layout = 3 })
  end, { desc = "DAP Add Watch" })
end

-- nvim-highlight-colors
do
  local ensure_nvim_highlight = once(function()
    require("nvim-highlight-colors").setup({
      enable_tailwind = true,
    })
  end)
  map("n", "<leader>uc", function()
    ensure_nvim_highlight()
    require("nvim-highlight-colors").toggle()
  end, { desc = "Toggle highlighting colors" })
end

-- nvim-tree
do
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  local ensure_nvim_tree = once(function()
    require("nvim-tree").setup({
      on_attach = function(bufnr)
        require("nvim-tree.api").map.on_attach.default(bufnr)
        map("n", "<CR>", function()
          require("nvim-tree.api").node.open.no_window_picker()
        end, { buffer = bufnr, desc = "Open" })
      end,
      view = {
        width = 35,
        float = {
          enable = true,
          open_win_config = function()
            local cols = vim.opt.columns:get()
            local lines = vim.opt.lines:get()
            local width = 120
            local height = math.floor(width * lines / cols)
            return {
              border = "double",
              relative = "editor",
              width = width,
              height = height,
              col = (cols - width) / 2,
              row = (lines - height) / 2,
            }
          end,
        },
      },
      filters = {
        dotfiles = false,
      },
      renderer = {
        group_empty = true,
      },
    })
  end)
  map("n", "<leader>e", function()
    ensure_nvim_tree()
    require("nvim-tree.api").tree.toggle({
      path = "<args>",
      find_file = true,
      update_root = "<bang>",
      focus = true,
    })
  end, { desc = "Toggle NvimTree" })
  vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "none" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
  vim.api.nvim_set_hl(0, "NvimTreeSignColumn", { bg = "none" })
  vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { fg = "#767676", bg = "none" })
  vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "none" })
end

-- nvim-treesitter
map("n", "<leader>ti", function()
  require("nvim-treesitter").install({
    "bash",
    "rust",
    "cpp",
    "css",
    "dockerfile",
    "fish",
    "glsl",
    "html",
    "javascript",
    "json",
    "make",
    "proto",
    "python",
    "toml",
    "tsx",
    "typescript",
    "yaml",
  })
end, { desc = "Install Treesitter Parsers" })

-- obsidian
do
  local ensure_obsidian = once(function()
    vim.pack.add({ gh("obsidian-nvim/obsidian.nvim") })
    require("obsidian").setup({
      -- When enabled, conceallevel must be set to 1 or 2
      ui = { enable = false },
      legacy_commands = false,
      workspaces = {
        { name = "Notes", path = vim.fn.expand("~/Documents/Ares") },
      },
      picker = { name = "fzf-lua" },
    })
  end)
  vim.api.nvim_create_user_command("Obsidian", function(ev)
    ensure_obsidian()
    vim.cmd(ev.mods .. "Obsidian " .. ev.args)
  end, { nargs = "*" })

  map("n", "<leader>oe", function(ev)
    vim.defer_fn(function()
      vim.cmd(ev.mods .. "Obsidian new")
    end, 500)
  end, { desc = "New note" })
  map("n", "<leader>of", "<cmd>Obsidian quick_switch<CR>", { desc = "Find note" })
  map("n", "<leader>os", "<cmd>Obsidian search<CR>", { desc = "Search notes" })
  map("n", "<leader>ot", "<cmd>Obsidian today<CR>", { desc = "Today's daily note" })
end

-- =============================================================================
-- LSP
-- =============================================================================

map("n", "<leader>Lh", "<cmd>checkhealth vim.lsp<CR>", { desc = "LSP health" })
map("n", "<leader>Lr", "<cmd>lsp restart<CR>", { desc = "Restart LSP" })

do
  local highlight_capable_bufs = {}
  local highlight_enabled = false
  vim.api.nvim_create_autocmd("LspAttach", {
    group = user_aug,
    desc = "LSP Keymaps",
    callback = function(ev)
      if not highlight_capable_bufs[ev.buf] then
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          highlight_capable_bufs[ev.buf] = true
        end
      end
    end,
  })
  vim.api.nvim_create_autocmd("BufDelete", {
    group = user_aug,
    callback = function(ev)
      highlight_capable_bufs[ev.buf] = nil
    end,
  })
  vim.api.nvim_create_autocmd("CursorHold", {
    group = user_aug,
    desc = "Highlight references under cursor",
    callback = function(ev)
      if
          highlight_enabled
          and highlight_capable_bufs[ev.buf]
          and vim.fn.mode() ~= "i"
          and vim.bo.buftype == ""
          and vim.bo.filetype ~= "NvimTree"
      then
        vim.lsp.buf.clear_references()
        vim.lsp.buf.document_highlight()
      end
    end,
  })
  vim.api.nvim_create_autocmd("CursorMovedI", {
    group = user_aug,
    desc = "Clear highlights when entering insert mode",
    callback = function()
      vim.lsp.buf.clear_references()
    end,
  })
  map("n", "<leader>uh", function()
    highlight_enabled = not highlight_enabled
    if not highlight_enabled then
      vim.lsp.buf.clear_references()
    end
    vim.notify("lsp highlights " .. bool2str(highlight_enabled))
  end, { desc = "Toggle LSP reference highlights" })
end

vim.lsp.config("bashls", {})
vim.lsp.config("clangd", {
  cmd = { "clangd", "--background-index", "--clang-tidy" },
})

vim.lsp.config("cssls", {
  settings = {
    css = {
      lint = {
        unknownAtRules = "ignore",
      },
    },
  },
})

-- efm
do
  local shellcheck = require("efmls-configs.linters.shellcheck")
  local shfmt = require("efmls-configs.formatters.shfmt")

  local cpplint = require("efmls-configs.linters.cpplint")
  local clangfmt = require("efmls-configs.formatters.clang_format")

  local prettier_d = require("efmls-configs.formatters.prettier_d")
  local eslint_d = require("efmls-configs.linters.eslint_d")

  local fixjson = require("efmls-configs.formatters.fixjson")

  local luacheck = require("efmls-configs.linters.luacheck")
  local stylua = require("efmls-configs.formatters.stylua")

  local markdownlint = require("efmls-configs.linters.markdownlint")

  local flake8 = require("efmls-configs.linters.flake8")
  local black = require("efmls-configs.formatters.black")

  local protolint = require("efmls-configs.formatters.protolint")

  local taplo = require("efmls-configs.formatters.taplo")

  local yamllint = require("efmls-configs.linters.yamllint")

  vim.lsp.config("efm", {
    filetypes = {
      "bash",
      "c",
      "cpp",
      "css",
      "html",
      "javascript",
      "javascriptreact",
      "json",
      "jsonc",
      "lua",
      "markdown",
      "proto",
      "python",
      "sh",
      "toml",
      "typescript",
      "typescriptreact",
      "yaml",
    },
    init_options = { documentFormatting = true },
    settings = {
      languages = {
        bash = { shellcheck, shfmt },
        c = { clangfmt, cpplint },
        cpp = { clangfmt, cpplint },
        css = { prettier_d },
        html = { prettier_d },
        javascript = { eslint_d, prettier_d },
        javascriptreact = { eslint_d, prettier_d },
        jsonc = { eslint_d, fixjson },
        json = { eslint_d, fixjson },
        lua = { luacheck, stylua },
        markdown = { markdownlint, prettier_d },
        proto = { protolint },
        python = { flake8, black },
        sh = { shellcheck, shfmt },
        toml = { taplo },
        typescript = { eslint_d, prettier_d },
        typescriptreact = { eslint_d, prettier_d },
        yaml = { yamllint, prettier_d },
      },
    },
  })

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = user_aug,
    callback = function(ev)
      -- avoid formatting non-file buffers (helps prevent weird write prompts)
      if vim.bo[ev.buf].buftype ~= "" or not vim.bo[ev.buf].modifiable or vim.api.nvim_buf_get_name(ev.buf) == "" then
        return
      end
      local clients = vim.lsp.get_clients({ bufnr = ev.buf })
      local has_efm = false
      local can_format = false
      for _, c in ipairs(clients) do
        if c.name == "efm" then
          has_efm = true
        end
        if c:supports_method("textDocument/formatting", ev.buf) then
          can_format = true
        end
        if has_efm and can_format then
          break
        end
      end
      if can_format then
        vim.lsp.buf.format({
          bufnr = ev.buf,
          timeout_ms = 2000,
          filter = has_efm and function(c)
            return c.name == "efm"
          end or nil,
        })
      end
    end,
  })
end

do
  local lua_root_markers = {
    ".git",
    ".luarc.json",
    ".luarc.jsonc",
    "init.lua",
  }
  local fname = vim.fn.expand("%")
  local lua_root = vim.fs.root(fname, lua_root_markers)
  if lua_root == vim.env.HOME then
    lua_root = nil
  end
  vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_dir = lua_root or vim.fn.fnamemodify(fname, ":p:h"),
    root_markers = lua_root_markers,
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          "lua/?.lua",
          "lua/?/init.lua",
        },
        diagnostics = {
          enable = true,
          globals = { "vim" },
        },
        telemetry = { enable = false },
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME .. "/lua",
            vim.env.VIMRUNTIME .. "/lua/vim/lsp",
            vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
            "${3rd}/luv/library", -- Types for vim.uv
          },
        },
      },
    },
  })
end

vim.lsp.config("pyright", {})
vim.lsp.config("tailwindcss", {
  filetypes = {
    "css",
    "html",
    "javascript",
    "javascriptreact",
    "markdown",
    "mdx",
    "rust",
    "typescript",
    "typescriptreact",
  },
  settings = {
    tailwindCSS = {
      includeLanguages = {
        rust = "html",
      },
    },
  },
})
vim.lsp.config("ts_ls", {
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
})

vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      keyOrdering = false,
    },
  },
})

vim.g.rustaceanvim = function()
  return {
    server = {
      on_attach = function(_, bufnr)
        vim.cmd("compiler cargo")

        local rls = function(args)
          return function()
            vim.cmd.RustLsp(args)
          end
        end

        map("n", "gA", rls({ "hover", "actions" }), { silent = true, buffer = bufnr, desc = "Hover Actions" })
        map("n", "<leader>ra", rls("codeAction"), { buffer = bufnr, desc = "Rust Code Action" })
        map("n", "<leader>rr", rls("runnables"), { buffer = bufnr, desc = "Runnables" })
        map("n", "<leader>rR", rls({ "runnables", bang = true }), { buffer = bufnr, desc = "Rerun Last" })
        map("n", "<leader>rt", rls("testables"), { buffer = bufnr, desc = "Testables" })
        map("n", "<leader>rd", rls("debuggables"), { buffer = bufnr, desc = "Debuggables" })
        map("n", "<leader>re", rls("explainError"), { buffer = bufnr, desc = "Explain Error" })
        map(
          "n",
          "<leader>rE",
          rls({ "explainError", "current" }),
          { buffer = bufnr, desc = "Explain Error (current line)" }
        )
        map("n", "<leader>rD", rls({ "renderDiagnostic", "current" }), { buffer = bufnr, desc = "Render Diagnostic" })
        map("n", "<leader>rm", rls("expandMacro"), { buffer = bufnr, desc = "Expand Macro" })
        map("n", "<leader>rp", rls("parentModule"), { buffer = bufnr, desc = "Parent Module" })
        map("n", "J", rls("joinLines"), { buffer = bufnr, desc = "Join lines" })
        map("n", "<C-A-j>", rls({ "moveItem", "down" }), { buffer = bufnr, desc = "Move line down" })
        map("n", "<C-A-k>", rls({ "moveItem", "up" }), { buffer = bufnr, desc = "Move line up" })
        map("n", "<leader>rw", rls("reloadWorkspace"), { buffer = bufnr, desc = "Reload Workspace" })
        map("n", "<leader>rs", rls("workspaceSymbol"), { buffer = bufnr, desc = "Workspace Symbol" })
        map(
          "n",
          "<leader>rS",
          rls({ "workspaceSymbol", bang = true }),
          { buffer = bufnr, desc = "Workspace Symbol (with deps)" }
        )
        map("n", "<leader>ro", rls("openDocs"), { buffer = bufnr, desc = "Open docs.rs" })
        map("n", "<leader>rl", rls("logFile"), { buffer = bufnr, desc = "RA Log File" })
        map("n", "<leader>rvm", rls({ "view", "mir" }), { buffer = bufnr, desc = "View MIR" })
        map("n", "<leader>rvh", rls({ "view", "hir" }), { buffer = bufnr, desc = "View HIR" })
        map("n", "<leader>rg", rls("crateGraph"), { buffer = bufnr, desc = "Crate Graph" })
        map("n", "<leader>rf", rls("flyCheck"), { buffer = bufnr, desc = "Fly Check" })
      end,
      default_settings = {
        ["rust-analyzer"] = {
          assist = {
            emitMustUse = true, -- insert #[must_use] when generating as_ methods for enums.
          },
          cargo = {
            features = "all", -- pass --all-features to cargo
            targetDir = true, -- Avoid locking CARGO_TARGET_DIR by using a sub-directory
            -- target = "wasm32-unknown-unknown", -- target triple override
          },
          check = {
            command = "clippy",
            extraArgs = { "-j", "8" },
          },
          files = {
            exclude = {
              "target",
              "_",
              "data",
              "artifacts",
              "docs",
              "dist",
              "build",
              "vendor",
              "node_modules",
              ".git",
              ".direnv",
            },
          },
          imports = {
            -- Whether to enforce the import granularity setting for all files.
            -- Unfortunately, not yet stable for rustfmt
            -- See: https://rust-lang.github.io/rustfmt/?version=v1.9.0&search=#imports_granularity
            -- granularity = { enforce = true },
            group = { enable = false }, -- Don't group imports
          },
          interpret = { tests = true },
          lru = { capacity = 512 }, -- Increased syntax tree LRU
          runnables = {
            extraTestBinaryArgs = { "--nocapture" },
          },
          procMacro = {
            ignored = {
              thiserror = {
                "Error",
              },
              serde = {
                "Serialize",
                "Deserialize",
              },
              leptos_macro = {
                "server",
              },
            },
          },
          -- trace = {
          --   server = "verbose",
          -- },
        },
      },
    },
  }
end

vim.lsp.config["*"] = {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
}

vim.lsp.enable({
  "bashls",
  "cssls",
  "clangd",
  "efm",
  "jsonls",
  "lua_ls",
  "pyright",
  "tailwindcss",
  "ts_ls",
  "yamlls",
})

do
  local diagnostic_signs = {
    Error = "\u{f057} ", -- nf-fa-remove_sign
    Warn = "\u{f071} ",  -- nf-fa-exclamation_triangle
    Hint = "\u{ea61}",   -- nf-cod-lightbulb
    Info = "\u{f05a}",   -- nf-fa-circle_info
  }
  vim.diagnostic.config({
    virtual_text = {
      prefix = "●",
      spacing = 4,
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
        [vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
        [vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
        [vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
      },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      border = "rounded",
      source = true,
      header = "",
      prefix = "",
      style = "minimal",
    },
  })
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = user_aug,
  desc = "LSP Keymaps",
  callback = function(ev)
    map("n", "<leader>ui", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ 0 }), { 0 })
    end, { buffer = ev.buf, desc = "Toggle Inlay Hints" })

    map("n", "gd", function()
      ensure_fzf()
      require("fzf-lua").lsp_definitions()
    end, { buffer = ev.buf, desc = "Go to definition" })
    map("n", "gD", function()
      ensure_fzf()
      require("fzf-lua").lsp_declarations()
    end, { buffer = ev.buf, desc = "Go to declaration" })
    map("n", "gi", function()
      ensure_fzf()
      require("fzf-lua").lsp_implementations()
    end, { buffer = ev.buf, desc = "Go to implementation" })
    map("n", "gT", function()
      ensure_fzf()
      require("fzf-lua").lsp_typedefs()
    end, { buffer = ev.buf, desc = "Go to type definition" })
    map("n", "gr", function()
      ensure_fzf()
      require("fzf-lua").lsp_references()
    end, { buffer = ev.buf, desc = "Go to reference" })
    map("n", "gh", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Show help" })
    map("n", "gs", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "Show signature help" })
    map("n", "gS", function()
      ensure_fzf()
      require("fzf-lua").lsp_document_symbols()
    end, { buffer = ev.buf, desc = "Document symbols" })
    map("n", "gR", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename references" })
    map("n", "ga", function()
      ensure_fzf()
      require("fzf-lua").lsp_code_actions()
    end, { buffer = ev.buf, desc = "Execute code action" })
  end,
})

do
  -- Floating window borders
  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  ---@diagnostic disable-next-line: duplicate-set-field
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
  end
end

-- LSP diagnostic keymaps (always available)
map("n", "gn", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
map("n", "gp", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })
map("n", "ge", vim.diagnostic.open_float, { desc = "Show diagnostics" })
local quickfix_open = false
map("n", "<leader>te", function()
  quickfix_open = not quickfix_open
  if quickfix_open then
    vim.diagnostic.setqflist()
  else
    vim.cmd("cclose")
  end
end, { desc = "Show diagnostics list" })

-- =============================================================================
-- Terminal
-- =============================================================================

vim.api.nvim_create_autocmd("TermOpen", {
  group = user_aug,
  desc = "Disable gutter in terminal",
  callback = function()
    vim.cmd("setlocal nornu nonu nolist signcolumn=no foldcolumn=0")
  end,
})

local terminal_state = { buf = nil, win = nil, is_open = false }

local function CloseFloatingTerminal()
  if terminal_state.is_open and terminal_state.win and vim.api.nvim_win_is_valid(terminal_state.win) then
    vim.api.nvim_win_close(terminal_state.win, false)
    terminal_state.is_open = false
    return true
  end
  return false
end

-- Parse omarchy's current theme alacritty.toml and sync terminal palette
local function load_omarchy_terminal_colors()
  local path = vim.fn.expand("~/.config/omarchy/current/theme/alacritty.toml")
  local f = io.open(path, "r")
  if not f then
    return
  end
  local content = f:read("*a")
  f:close()

  local section = nil
  local colors = { normal = {}, bright = {} }
  local order = { "black", "red", "green", "yellow", "blue", "magenta", "cyan", "white" }

  for line in content:gmatch("[^\n]+") do
    local s = line:match("^%[colors%.(%w+)%]")
    if s then
      section = s
    end
    if section == "normal" or section == "bright" then
      local key, val = line:match('^(%w+)%s*=%s*"(#%x+)"')
      if key and val then
        colors[section][key] = val
      end
    end
  end

  for i, name in ipairs(order) do
    local c = colors.normal[name]
    if c then
      vim.g["terminal_color_" .. (i - 1)] = c
    end
    local bc = colors.bright[name]
    if bc then
      vim.g["terminal_color_" .. (i + 7)] = bc
    end
  end
end

local function ToggleFloatingTerminal()
  if CloseFloatingTerminal() then
    return
  end

  if not terminal_state.buf or not vim.api.nvim_buf_is_valid(terminal_state.buf) then
    terminal_state.buf = vim.api.nvim_create_buf(false, true)
    vim.bo[terminal_state.buf].bufhidden = "hide"
  end

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  load_omarchy_terminal_colors()
  terminal_state.win = vim.api.nvim_open_win(terminal_state.buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  vim.wo[terminal_state.win].winblend = 0
  vim.wo[terminal_state.win].winhighlight = "Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder"
  vim.api.nvim_set_hl(0, "FloatingTermNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "FloatingTermBorder", { bg = "none" })

  local has_terminal = vim.bo[terminal_state.buf].buftype == "terminal"
  if not has_terminal then
    vim.fn.jobstart(vim.env.SHELL, { term = true })
  end

  terminal_state.is_open = true
  vim.cmd("startinsert")

  local term_aug = vim.api.nvim_create_augroup("FloatingTermLeave", { clear = true })
  vim.api.nvim_create_autocmd("BufLeave", {
    group = term_aug,
    buffer = terminal_state.buf,
    desc = "Close terminal on exit",
    callback = function()
      CloseFloatingTerminal()
    end,
    once = true,
  })
  vim.api.nvim_create_autocmd("TermClose", {
    group = term_aug,
    buffer = terminal_state.buf,
    desc = "Close terminal on exit",
    callback = function()
      if vim.v.event.status == 0 and vim.api.nvim_buf_is_valid(terminal_state.buf) then
        vim.api.nvim_buf_delete(0, {})
        terminal_state.buf = nil
        terminal_state.is_open = false
      end
    end,
  })
end

map("n", "<leader>tt", ToggleFloatingTerminal, { noremap = true, silent = true, desc = "Toggle floating terminal" })
map("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Terminal normal mode" })
map("t", "<C-q>", CloseFloatingTerminal, { noremap = true, silent = true, desc = "Close floating terminal" })
