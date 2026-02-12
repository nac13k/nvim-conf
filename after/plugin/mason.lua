-- Description: Mason configuration
-- Author: Lumbreras
-- License: MIT
-- Version: 0.1.0
-- References:
-- - https://vonheikemen.github.io/devlog/es/tools/setup-nvim-lspconfig-plus-nvim-cmp/
-- - https://gist.github.com/VonHeikemen/8fc2aa6da030757a5612393d0ae060bd
-- mason.lua (actualizado para nvim-lspconfig >= 3.0 y Neovim >= 0.11)

-- Setup Mason & LSPConfig integration
local mason = require('mason')
local mason_lspconfig = require('mason-lspconfig')

-- Lista de servidores LSP a instalar
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

-- Configuración base de Mason
mason.setup()
mason_lspconfig.setup({
  ensure_installed = servers,
  automatic_installation = true,
})

-- Habilitar capacidades extendidas (para nvim-cmp, etc.)
local capabilities = vim.tbl_deep_extend(
  'force',
  vim.lsp.protocol.make_client_capabilities(),
  require('cmp_nvim_lsp').default_capabilities()
)

-- Configuración personalizada para servidores específicos
local custom_lsp_config = {
  solargraph = {
    on_attach = function(client, bufnr)
      -- Ejemplo de customización por servidor
      local opts = { buffer = bufnr, noremap = true, silent = true }
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    end,
    capabilities = capabilities,
    settings = {
      ruby = {
        diagnostics = true,
        formatting = true,
      },
    },
  },
}

-- Configuración por defecto (para los demás)
local default_lsp_config = {
  capabilities = capabilities,
  on_attach = function(_, bufnr)
    local opts = { buffer = bufnr, noremap = true, silent = true }
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  end,
}

-- 🚀 Nueva API de configuración (reemplaza require('lspconfig'))
mason_lspconfig.setup({
  function(server_name)
    local config = custom_lsp_config[server_name] or default_lsp_config
    vim.lsp.config(server_name, config)
  end,
})

-- mason.setup()
-- masonLspCongig.setup {
--   ensure_installed = servers,
--   automatic_enable = false,
-- }
--
-- lsp_defaults.capabilities = vim.tbl_deep_extend(
--   'force',
--   lsp_defaults.capabilities,
--   require('cmp_nvim_lsp').default_capabilities()
-- )
--
--
-- -- Config servers
-- local custom_lsp_config = {
--   -- custom config for solargraph server (ruby)
--   -- enabling all the features for solargraph
--   solargraph = {
--     -- on_attach = function(client)
--     --   client.resolved_capabilities.document_formatting = true
--     --   client.resolved_capabilities.document_range_formatting = true
--     --   mason.on_attach(client)
--     -- end,
--     on_attach = mason.on_attach,
--     capabilities = lsp_defaults.capabilities,
--     settings = {
--       ruby = {
--         diagnostics = true,
--         formatting = true,
--       },
--     },
--   }
-- }
-- local default_lsp_config = {
--   on_attach = mason.on_attach,
--   capabilities = lsp_defaults.capabilities,
-- }
--
-- -- setup servers, iterate over servers and setup each one
-- for _, server in ipairs(servers) do
--   lspconfig[server].setup(custom_lsp_config[server] or default_lsp_config)
-- end
