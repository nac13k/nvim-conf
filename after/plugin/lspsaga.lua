--  Config for lspsaga

local saga = require 'lspsaga'

saga.setup {
  -- Icon's order       Error, Warn, Info, Hint
  diagnostic_header = { "😡", "😥", "😤", "😐" },
  -- request timeout in milliseconds
  finder_request_timeout = 30000,
  ui = {
    boder = 'single',
    winblend = 1,
    win_height = 1.0,
    colors = {
      normal_bg = '#1e222a',
      title_fg = '#a9b1d6',
      cyan = '#008080',
      red = '#ff0000',
      green = '#98be65',
      yellow = '#ECBE7B',
      blue = '#51afef',
      magenta = '#c678dd',
      white = '#a9b1d6',
      black = '#1e222a',
      orange = '#FF8800',
      purple = '#a9b1d6',
    },
  }
}

-- Mappings
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>k', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', opts)
vim.keymap.set('n', '<leader>j', '<Cmd>Lspsaga diagnostic_jump_next<CR>', opts)
vim.keymap.set('n', '<C-x>', '<Cmd>Lspsaga hover_doc<CR>', opts)
vim.keymap.set('n', 'gd', '<Cmd>Lspsaga lsp_finder<CR>', opts)
vim.keymap.set('n', 'gr', '<Cmd>Lspsaga rename<CR>', opts)
vim.keymap.set('n', 'ca', '<Cmd>Lspsaga code_action<CR>', opts)

-- Floating terminal shortcuts -- disable because I use toggleterm
-- vim.keymap.set("n", "<C-d>", "<cmd>Lspsaga open_floaterm<CR>", { silent = true })
-- vim.keymap.set("t", "<C-d>", "<C-\\><C-n><cmd>Lspsaga close_floaterm<CR>", { silent = true })
