-- Lumbreas config for copilot. Read more about it here: https://github.com/github/copilot.vim

-- Set default maps to copilot config
vim.g.copilot_no_maps = 0

-- Remap copilot to use the same keybindings as vim
vim.keymap.set('i', '<C-j>', '<Plug>(copilot-next)', {noremap = false})
vim.keymap.set('i', '<C-k>', '<Plug>(copilot-previous)', {noremap = false})
