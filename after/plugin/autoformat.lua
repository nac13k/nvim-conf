-- Add this new autosave formatting in order to avoid the use of deprecated null-ls package
local function formatter()
  local bufType = vim.bo.filetype
  if bufType == 'typescript' or bufType == 'javascript' or bufType == 'typescriptreact' then
    vim.cmd('Prettier')
  else
    vim.lsp.buf.format({ async = false })
  end
end

vim.api.nvim_create_augroup('AutoFormatting', {})
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  group = 'AutoFormatting',
  callback = formatter
})

-- Add shortcurt to format the current buffer
vim.keymap.set('n', '<C-f>', formatter, { noremap = true, silent = true })
