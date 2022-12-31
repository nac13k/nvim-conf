-- Add config gor hop a easymotion like

require'hop'.setup{}

-- Mapping
vim.keymap.set('n', '<leader>f', '<cmd>HopChar2<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>\\', '<cmd>HopPattern<CR>', {noremap = true, silent = true})

-- map <leader>f :HopChar2<CR>
-- map <leader>\ :HopPattern<CR>
