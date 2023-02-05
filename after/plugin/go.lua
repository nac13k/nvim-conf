-- Add config for go.nvim by Lumbreras

vim.g.go_debug_mappings = {
  ['(go-debug-continue)'] = { key = 'c', arguments = '<nowait>' },
  ['(go-debug-next)'] = { key = 'n', arguments = '<nowait>' },
  ['(go-debug-step)'] = { key = 's' },
  ['(go-debug-print)'] = { key = 'p' },
}

require('go').setup({
  max_line_len = 120,
  test_dir = '',
  dap_debug = true,
})
-- require("dapui").setup()
-- require("nvim-dap-virtual-text").setup()

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require('go.format').goimport() -- require("go.format").gofmt() it's called by goimport
  end,
  group = format_sync_grp,
})

-- Mapping
vim.keymap.set('n', '<leader>ds', vim.cmd.GoDebug, {noremap = true, silent = true}) -- Start debugging
vim.keymap.set('n', '<leader>dt', vim.cmd.GoDbgStop, {noremap = true, silent = true}) -- Stop debugging
vim.keymap.set('n', '<leader>b', vim.cmd.GoBreakToggle, {noremap = true, silent = true}) -- Toggle breakpoint
