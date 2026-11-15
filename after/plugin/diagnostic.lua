-- Overwrite the diagnostic signs and virtual text
-- Author: Lumbreras
-- License: MIT
-- Version: 0.1.0

vim.diagnostic.config({
  virtual_text = {prefix = '', spacing = 0}, -- (optional) Enable virtual text. e.g. {prefix = '', spacing = 0}
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✘',
      [vim.diagnostic.severity.WARN] = '▲',
      [vim.diagnostic.severity.HINT] = '⚑',
      [vim.diagnostic.severity.INFO] = 'ℹ',
    },
  },
  underline = true, -- (optional) Enable underline, enabled by default
  update_in_insert = false, -- (optional) Update diagnostics insert mode, false by default
  severity_sort = false, -- (optional) Sort diagnostics by severity. false by default
  float = true, -- (optional) Enable floating windows, false by default. e.g. {border = 'rounded', source = 'always'}
})
