-- Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

local buf_set_keymap = function (...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
local buf_set_option = function (...) vim.api.nvim_buf_set_option(bufnr, ...) end

local format_async = function(err, _, result, _, bufnr)
  if err ~= nil or result == nil then return end
  if not vim.api.nvim_buf_get_option(bufnr, "modified") then
    local view = vim.fn.winsaveview()
    vim.lsp.util.apply_text_edits(result, bufnr)
    vim.fn.winrestview(view)
    if bufnr == vim.api.nvim_get_current_buf() then
      vim.api.nvim_command("noautocmd :update")
    end
  end
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  local signs = { Error = "❗", Warning = "❕", Hint = "❔", Information = " " }
  for type, icon in pairs(signs) do
    local hl = "LspDiagnosticsSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end

  vim.api.nvim_exec([[
    augroup LspLightbulb
      autocmd!
      autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
    augroup END
  ]], true)

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'gh', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gH', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<CR>:wall<CR>', opts)
  buf_set_keymap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gO', '<cmd>lua lsp_organize_imports()<CR>', opts)
  buf_set_keymap('n', '[e', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']e', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', 'ge', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

  if client.resolved_capabilities.document_formatting then
    vim.lsp.handlers["textDocument/formatting"] = format_async
    vim.api.nvim_exec([[
      augroup LspFormat
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting()
      augroup END
    ]], true)
  end
end

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = 'single',
    winhighlight = 'NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder',
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
    luasnip = true;
  };
}

vim.api.nvim_exec([[
  augroup LspInlay
    autocmd!
    autocmd VimEnter,InsertLeave,BufEnter,BufWinEnter,TabEnter *.rs lua require'lsp_extensions'.inlay_hints{ highlight = "VirtualTextInfo", prefix = " ▸ ", aligned = false, enabled = { "TypeHint", "ChainingHint", "ParameterHint" } }
  augroup END
]], true)

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

local function setup_servers()
  require'lspinstall'.setup()
  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do
    local formatting = true
    if (server == 'html' or server == 'rust' or server == 'typescript' or server == 'javascript') then
      formatting = false
    end
    if server == 'typescript' then
      _G.lsp_organize_imports = function()
        local params = {
          command = "_typescript.organizeImports",
              arguments = {vim.api.nvim_buf_get_name(0)},
              title = ""
          }
          vim.lsp.buf.execute_command(params)
      end
    end
    if server == 'json' then
      -- Range formatting for entire document
      require'lspconfig'[server].setup{
        commands = {
          Format = {
            function()
              vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
            end
          }
        },
        on_attach = function(client)
          client.resolved_capabilities.document_formatting = formatting
          on_attach(client)
        end,
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 150,
        }
      }
    elseif server == 'diagnosticls' then
      local filetypes = {
        javascript = 'eslint',
        javascriptreact = 'eslint',
        typescript = 'eslint',
        typescriptreact = 'eslint',
        markdown = 'markdownlint',
      }
      require'lspconfig'[server].setup{
        filetypes = vim.tbl_keys(filetypes),
        init_options = {
          linters = {
            eslint = {
              sourceName = 'eslint',
              command = 'eslint_d',
              rootPatterns = { 'package.json' },
              debounce = 150,
              args = { '--stdin', '--stdin-filename', '%filepath', '--format', 'json' },
              parseJson = {
                errorsRoot = '[0].messages',
                line = 'line',
                column = 'column',
                endLine = 'endLine',
                endColumn = 'endColumn',
                message = '${message} [${ruleId}]',
                security = 'severity'
              },
              securities = {
                [2] = 'error',
                [1] = 'warning'
              }
            }
          },
          formatters = {
            prettier = {
              command = 'prettier',
              args = { '--stdin-filepath', '%filename' }
            }
          },
          filetypes = filetypes,
          formatFiletypes = {
            css = 'prettier',
            javascript = 'prettier',
            javascriptreact = 'prettier',
            json = 'prettier',
            typescript = 'prettier',
            typescriptreact = 'prettier'
          }
        },
        on_attach = function(client)
          client.resolved_capabilities.document_formatting = formatting
          on_attach(client)
        end,
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 150,
        }
      }
    elseif server == 'rust' then
      require'lspconfig'[server].setup{
        on_attach = function(client)
          client.resolved_capabilities.document_formatting = formatting
          on_attach(client)
        end,
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 150,
        },
        settings = {
          ["rust-analyzer"] = {
            updates = {
              channel = "nightly"
            },
            assist = {
              importGroup = false,
            },
            cargo = {
              features = { "serde" },
              -- target = "wasm32-unknown-unknown"
            },
            checkOnSave = { command = "clippy" }
          }
        }
      }
    else
      require'lspconfig'[server].setup{
        on_attach = function(client)
          client.resolved_capabilities.document_formatting = formatting
          on_attach(client)
        end,
        capabilities = capabilities,
        flags = {
          debounce_text_changes = 150,
        }
      }
    end
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end
