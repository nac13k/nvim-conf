-- Config for gitsigns module by Lumbreras. Read more about it here: https://github.com/lewis6991/gitsigns.nvim

require('gitsigns').setup {
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`, enable the signcolumn at left side of the number bar
  numhl      = true,  -- Toggle with `:Gitsigns toggle_numhl`, highlight the line number of the current line in diff mode
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl` highlight the lines with changes
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`, highlight the word changes
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`, show the blame information of the current line
  -- current_line_blame_opts = {
  --   virt_text = true,
  --   virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
  --   delay = 200,
  --   ignore_whitespace = false,
  -- },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  on_attach = function()
    local gs = package.loaded.gitsigns

    -- Inline diff: removed lines (red, above) + added lines and changed words (green)
    vim.keymap.set('n', '<leader>gd', function()
      local on = not require('gitsigns.config').config.linehl
      gs.toggle_linehl(on)
      gs.toggle_word_diff(on)
      gs.toggle_deleted(on)
    end, { silent = true, desc = 'Toggle inline diff' })
    vim.keymap.set('n', '<leader>gs', gs.toggle_signs, { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>gh', gs.toggle_linehl , { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>gb', gs.toggle_current_line_blame, { noremap = true, silent = true })
    -- Review uncommitted changes
    vim.keymap.set('n', '<leader>gv', gs.diffthis, { silent = true, desc = 'Side-by-side diff vs index' })
    vim.keymap.set('n', '<leader>gp', gs.preview_hunk_inline, { silent = true, desc = 'Preview hunk inline' })
    vim.keymap.set('n', '<leader>gq', function() gs.setqflist('all') end, { silent = true, desc = 'All repo hunks to quickfix' })
    vim.keymap.set('n', '<leader>gj', function() gs.nav_hunk('next') end, { silent = true, desc = 'Next hunk' })
    vim.keymap.set('n', '<leader>gk', function() gs.nav_hunk('prev') end, { silent = true, desc = 'Prev hunk' })
  end,
}
