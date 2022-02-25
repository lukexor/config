require'fzf_lsp'.setup{}
require'lspfuzzy'.setup{}

local capabilities = require'cmp_nvim_lsp'.update_capabilities(vim.lsp.protocol.make_client_capabilities())

local keymap_opts = { noremap=true, silent=true }
local g_set_keymap = function (...) vim.api.nvim_set_keymap(...) end

-- Default LSP shortcuts to no-ops for non-supported file types to avoid
-- confusion with default vim shortcuts.
function _G.no_lsp_client()
   vim.notify("No LSP client attached for filetype: `" .. vim.bo.filetype .. "`.", 3)
end

g_set_keymap('n', '<leader>L', '<Cmd>LspInfo<CR>', keymap_opts)
g_set_keymap('n', 'gd', '<Cmd>lua no_lsp_client()<CR>', keymap_opts)
g_set_keymap('n', 'gD', '<Cmd>lua no_lsp_client()<CR>', keymap_opts)
g_set_keymap('n', 'gT', '<Cmd>lua no_lsp_client()<CR>', keymap_opts)
g_set_keymap('n', 'gh', '<Cmd>lua no_lsp_client()<CR>', keymap_opts)
g_set_keymap('n', 'gH', '<Cmd>lua no_lsp_client()<CR>', keymap_opts)
g_set_keymap('n', 'gi', '<Cmd>lua no_lsp_client()<CR>', keymap_opts)
g_set_keymap('n', 'gr', '<Cmd>lua no_lsp_client()<CR>', keymap_opts)
g_set_keymap('n', 'gR', '<Cmd>lua no_lsp_client()<CR>', keymap_opts)
g_set_keymap('n', 'ga', '<Cmd>lua no_lsp_client()<CR>', keymap_opts)
g_set_keymap('n', 'gO', '<Cmd>lua no_lsp_client()<CR>', keymap_opts)
g_set_keymap('n', 'ge', '<Cmd>lua no_lsp_client()<CR>', keymap_opts)
g_set_keymap('n', '<localleader>f', '<Cmd>call <SID>NoLspClient()<CR>', keymap_opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local buf_set_keymap = function (...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local buf_set_option = function (...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <C-x><C-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "LspDiagnosticsSignError" })
  vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "LspDiagnosticsSignWarning" })
  vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "LspDiagnosticsSignHint" })
  vim.fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "LspDiagnosticsSignInformation" })

  vim.fn.sign_define('LightBulbSign', { text = "", texthl = "", linehl="", numhl="" })
  vim.api.nvim_exec([[
    augroup LspVirtualText
      autocmd!
      autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
      autocmd CursorHold,CursorHoldI *.rs lua require'lsp_extensions'.inlay_hints{ highlight = "VirtualTextInfo", prefix = " ▸ ", enabled = {"TypeHint", "ChainingHint"} }
    augroup END
  ]], true)

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', keymap_opts)
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', keymap_opts)
  buf_set_keymap('n', 'gT', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', keymap_opts)
  buf_set_keymap('n', 'gh', '<Cmd>lua vim.lsp.buf.hover()<CR>', keymap_opts)
  buf_set_keymap('n', 'gH', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', keymap_opts)
  buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', keymap_opts)
  buf_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', keymap_opts)
  buf_set_keymap('n', 'gR', '<Cmd>lua vim.lsp.buf.rename()<CR>', keymap_opts)
  buf_set_keymap('n', 'ga', '<Cmd>lua vim.lsp.buf.code_action()<CR>', keymap_opts)
  buf_set_keymap('n', 'gO', '<Cmd>lua lsp_organize_imports()<CR>', keymap_opts)
  buf_set_keymap('n', 'ge', '<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', keymap_opts)
  buf_set_keymap('n', 'gp', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', keymap_opts)
  buf_set_keymap('n', 'gn', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', keymap_opts)

  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<localleader>f", "<Cmd>lua vim.lsp.buf.formatting_sync(nil, 4000)<CR>", keymap_opts)
    vim.api.nvim_exec([[
      augroup LspFormat
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)
      augroup END
    ]], true)
  end

  require'lsp_signature'.on_attach({
    bind = true,
    doc_lines = 2,
    handler_opts = {
      border = "rounded"
    },
  })
end

local disable_formatting = function(opts)
  opts.on_attach = function(client)
      client.resolved_capabilities.document_formatting = false
      on_attach(client)
  end
end

local enhance_server_opts = {
  ["jsonls"] = function(opts)
    -- Range formatting for entire document
    opts.commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
        end
      }
    }
  end,
  ["diagnosticls"] = function(opts)
    local filetypes = {
      javascript = 'eslint',
      javascriptreact = 'eslint',
      typescript = 'eslint',
      typescriptreact = 'eslint',
      markdown = 'markdownlint',
    }
    opts.filetypes = vim.tbl_keys(filetypes)
    opts.init_options = {
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
    }
  end,
  ["rust_analyzer"] = function(opts)
    opts.settings = {
      ["rust-analyzer"] = {
        assist = {
          importGroup = false,
        },
        checkOnSave = { command = "clippy" },
      }
    }
  end,
  ["kotlin_language_server"] = function(opts)
    -- TODO: Figure out JAVA_HOME and PATH for kotlin_language_server
    local jdk_home = "/usr/local/Cellar/openjdk@11/11.0.12/libexec/openjdk.jdk/Contents/Home"
    opts.settings = {
      ["kotlin-language-server"] = {
        cmd_env = {
          PATH = jdk_home .. "/bin:" .. vim.env.PATH,
          JAVA_HOME = jdk_home,
        }
      }
    }
  end,
  ["html"] = disable_formatting,
  ["sumneko_lua"] = function(opts)
    opts.settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' }
        }
      }
    }
  end,
  ["tsserver"] = function(opts)
    disable_formatting(opts)
    _G.lsp_organize_imports = function()
      vim.lsp.buf.execute_command({
        command = "_typescript.organizeImports",
        arguments = {vim.api.nvim_buf_get_name(0)},
        title = ""
      })
    end
  end,
}

function Merge(t1, t2)
  for k, v in pairs(t2) do
    if (type(v) == "table") and (type(t1[k] or false) == "table") then
      Merge(t1[k], t2[k])
    else
      t1[k] = v
    end
  end
  return t1
end

local servers = {
  'bashls', 'cssls', 'diagnosticls', 'eslint', 'html', 'jsonls',
  'kotlin_language_server', 'rust_analyzer', 'sumneko_lua', 'tsserver', 'vimls',
  'yamlls'
}
local lsp_servers = require'nvim-lsp-installer.servers'
for _, server in ipairs(servers) do
  local available, requested = lsp_servers.get_server(server)
  if available and not requested:is_installed() then
        requested:install()
    end
end

local lsp_installer = require'nvim-lsp-installer'
lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  }

  if enhance_server_opts[server.name] then
    enhance_server_opts[server.name](opts)
  end

  local config = loadfile(vim.fn.getcwd() .. '/.lspconfig.lua')
  if config ~= nil then
    local config_opts = config()
    if config_opts ~= nil and config_opts[server.name] then
      Merge(opts, config_opts[server.name])
    end
  end

  server:setup(opts)
end)
