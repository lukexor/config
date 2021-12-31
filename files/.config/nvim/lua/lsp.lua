require'fzf_lsp'.setup{}
require'lspfuzzy'.setup{}

local cmp = require'cmp'
cmp.setup{
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  mapping = {
    ['<Tab>'] = cmp.mapping.confirm({ select = true })
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'ultisnips' },
  }, {
    { name = 'path' },
  }),
  experimental = {
    ghost_text = true,
  },
}
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  })
})

local capabilities = require'cmp_nvim_lsp'.update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local buf_set_keymap = function (...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local buf_set_option = function (...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  vim.fn.sign_define("DiagnosticSignError", { text = "❗️", texthl = "LspDiagnosticsSignError" })
  vim.fn.sign_define("DiagnosticSignWarn", { text = "⚠️ ", texthl = "LspDiagnosticsSignWarning" })
  vim.fn.sign_define("DiagnosticSignHint", { text = "❔", texthl = "LspDiagnosticsSignHint" })
  vim.fn.sign_define("DiagnosticSignInformation", { text = "ℹ️ ", texthl = "LspDiagnosticsSignInformation" })

  vim.api.nvim_exec([[
    augroup LspVirtualText
      autocmd!
      autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
      autocmd CursorHold,CursorHoldI *.rs lua require'lsp_extensions'.inlay_hints{ highlight = "VirtualTextInfo", prefix = " ▸ ", only_current_line = true, enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }
    augroup END
  ]], true)

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gT', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gH', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gO', '<cmd>lua lsp_organize_imports()<CR>', opts)
  buf_set_keymap('n', 'ge', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)

  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<localleader>f", "<cmd>lua vim.lsp.buf.formatting_sync(nil, 4000)<CR>", opts)
    vim.api.nvim_exec([[
      augroup LspFormat
        autocmd! * <buffer>
        autocmd BufWrite <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)
      augroup END
    ]], true)
  end

  require'lsp_signature'.on_attach({
    doc_lines = 0,
    handler_opts = {
      border = "none"
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

  server:setup(opts)
end)
