-- Mason + native LSP config (nvim >= 0.11, mason-lspconfig v2)
-- mason-lspconfig v2 auto-enables installed servers via vim.lsp.enable()

local servers = {
  'bashls',
  'lua_ls',
  'cssls',
  'diagnosticls',
  'dockerls',
  'dotls',
  'emmet_ls',
  'gopls',
  'golangci_lint_ls',
  'html',
  'jsonls',
  'marksman',
  'spectral',
  'pyright',
  'solargraph',
  'rubocop',
  'sqlls',
  'tailwindcss',
  'terraformls',
  'ts_ls',
  'yamlls',
}

vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

vim.lsp.config('solargraph', {
  settings = {
    solargraph = {
      diagnostics = true,
      formatting = true,
    },
  },
})

-- K (hover) is a default LSP mapping since nvim 0.11
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspAttach', {}),
  callback = function(args)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf, silent = true })
  end,
})

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = servers,
})
