-- set completeopt=menu,menuone,noselect
require('luasnip.loaders.from_vscode').lazy_load()

-- Setup nvim-cmp.
local cmp = require'cmp'
local luasnip = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-y>'] = cmp.config.disable,  -- It disabled the default `<C-y>` mapping.
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  },
  formatting = {
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = 'λ',
        luasnip = '⋗',
        buffer = 'Ω',
        path = 'ヽ(*ﾟдﾟ)ノ',
      }

      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'nvim_lsp', keyword_length = 1 },
    { name = 'buffer', keyword_length = 3 },
    { name = 'luasnip', keyword_length = 2 },
  }, {
    { name = 'buffer' },
  }),
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})

