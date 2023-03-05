-- Description: Mason configuration
-- Author: Lumbreras
-- License: MIT
-- Version: 0.1.0
-- References:
-- - https://vonheikemen.github.io/devlog/es/tools/setup-nvim-lspconfig-plus-nvim-cmp/
-- - https://gist.github.com/VonHeikemen/8fc2aa6da030757a5612393d0ae060bd

local mason = require('mason')
local masonLspCongig = require('mason-lspconfig')
local lspconfig = require('lspconfig')
local lsp_defaults = lspconfig.util.default_config

-- servers is the default lsp server list
local servers = {
  'bashls',
  'lua_ls',
  'cssls',
  'diagnosticls',
  'dockerls',
  'dotls',
  'eslint',
  'emmet_ls',
  'gopls',
  'golangci_lint_ls',
  'html',
  'jsonls',
  'remark_ls',
  'spectral',
  'pyright',
  'solargraph',
  'sqls',
  'tailwindcss',
  'terraformls',
  'yamlls',
}


-- setup mason
mason.setup()
masonLspCongig.setup {
  ensure_installed = servers,
}

lsp_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lsp_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)


-- Config servers
local custom_lsp_config = {}
local default_lsp_config = {
  on_attach = mason.on_attach,
  capabilities = lsp_defaults.capabilities,
}

-- setup servers, iterate over servers and setup each one
for _, server in ipairs(servers) do
  lspconfig[server].setup(custom_lsp_config[server] or default_lsp_config)
end
