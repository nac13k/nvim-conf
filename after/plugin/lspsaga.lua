--  Config for lspsaga

local saga = require 'lspsaga'

saga.setup({
  ui = {
    border = 'single',
  },
})

-- Mappings
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>k', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', opts)
vim.keymap.set('n', '<leader>j', '<Cmd>Lspsaga diagnostic_jump_next<CR>', opts)
vim.keymap.set('n', '<C-x>', '<Cmd>Lspsaga hover_doc<CR>', opts)
vim.keymap.set('n', 'gd', '<Cmd>Lspsaga finder<CR>', opts)
vim.keymap.set('n', 'gr', '<Cmd>Lspsaga rename<CR>', opts)
vim.keymap.set('n', 'ca', '<Cmd>Lspsaga code_action<CR>', opts)
