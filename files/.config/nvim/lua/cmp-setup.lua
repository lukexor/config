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
  cmdline = {
    ['/'] = {
      sources = {
        { name = 'buffer' }
      }
    },
    [':'] = {
      sources = cmp.config.sources({
        { name = 'path' }
      })
    },
  },
  experimental = {
    ghost_text = true,
  },
}
