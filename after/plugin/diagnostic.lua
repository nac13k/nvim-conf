-- Overwrite the diagnostic signs and virtual text
-- Author: Lumbreras
-- License: MIT
-- Version: 0.1.0

local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({name = 'DiagnosticSignError', text = '✘'})
sign({name = 'DiagnosticSignWarn', text = '▲'})
sign({name = 'DiagnosticSignHint', text = '⚑'})
sign({name = 'DiagnosticSignInfo', text = 'ℹ'})

vim.diagnostic.config({
  virtual_text = {prefix = '', spacing = 0}, -- (optional) Enable virtual text. e.g. {prefix = '', spacing = 0}
  signs = true, -- (optional) Enable signs, disabled by default
  underline = true, -- (optional) Enable underline, enabled by default
  update_in_insert = false, -- (optional) Update diagnostics insert mode, false by default
  severity_sort = false, -- (optional) Sort diagnostics by severity. false by default
  float = true, -- (optional) Enable floating windows, false by default. e.g. {border = 'rounded', source = 'always'}
})
