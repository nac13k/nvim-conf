-- Lumbreas config for copilot. Read more about it here: https://github.com/github/copilot.vim

-- Set default maps to copilot config
vim.g.copilot_no_maps = 0
-- Use the language server bundled with the plugin instead of downloading it via npx
vim.g.copilot_npx = false

-- Remap copilot to use the same keybindings as vim
vim.keymap.set('i', '<C-j>', '<Plug>(copilot-next)', {noremap = false})
vim.keymap.set('i', '<C-k>', '<Plug>(copilot-previous)', {noremap = false})
