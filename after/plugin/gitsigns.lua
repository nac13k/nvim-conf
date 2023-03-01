-- Config for gitsigns module by Lumbreras. Read more about it here: https://github.com/lewis6991/gitsigns.nvim

require('gitsigns').setup {
  signcolumn = false,  -- Toggle with `:Gitsigns toggle_signs`, enable the signcolumn at left side of the number bar
  numhl      = true,  -- Toggle with `:Gitsigns toggle_numhl`, highlight the line number of the current line in diff mode
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl` highlight the lines with changes
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`, highlight the word changes
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`, show the blame information of the current line
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 200,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  on_attach = function()
    local gs = package.loaded.gitsigns

    vim.keymap.set('n', '<leader>gd', gs.toggle_deleted, { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>gs', gs.toggle_signs, { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>gh', gs.toggle_linehl , { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>gb', gs.toggle_current_line_blame, { noremap = true, silent = true })
  end,
}
