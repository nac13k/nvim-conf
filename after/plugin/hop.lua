-- Add config gor hop a easymotion like

require'hop'.setup{}

-- Mapping
vim.keymap.set('n', '<leader>f', vim.cmd.HopChar2, {noremap = true, silent = true})
vim.keymap.set('n', '<leader>\\', vim.cmd.HopPattern, {noremap = true, silent = true})
