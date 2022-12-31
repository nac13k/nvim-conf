-- Set leader key to space
vim.g.mapleader = " "

-- Useful (to start a new config) shortcut to activatee the vim filemanager
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Fix uppercase common typos while you are using neovim
-- no one is really happy until you have this shortcuts
vim.cmd([[
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall
]])

-- Split
vim.keymap.set("n", "<leader>h", vim.cmd.split)
vim.keymap.set("n", "<leader>v", vim.cmd.vsplit)
-- Remap switch panes shortcut
vim.keymap.set("", "<C-j>", "<C-W>j")
vim.keymap.set("", "<C-k>", "<C-W>k")
vim.keymap.set("", "<C-h>", "<C-W>h")
vim.keymap.set("", "<C-l>", "<C-W>l")

-- Buffer navigation
vim.keymap.set("n", "<leader>q", vim.cmd.bp) -- previous buffer
vim.keymap.set("n", "<leader>w", vim.cmd.bn) -- next buffer
vim.keymap.set("n", "<leader>cb", vim.cmd.bd) -- close current buffer
