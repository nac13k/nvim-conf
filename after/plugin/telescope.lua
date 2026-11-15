-- Default config for telescope by Lumbreras

require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = { 'node_modules/', '%.log' },
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    winblend = 0,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    path_display = {},
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
  }
}

-- Git status picker, large, refreshed while open when `git status` changes
local function gitStatusLive()
  local cwd = vim.fn.getcwd()
  require('telescope.builtin').git_status({
    cwd = cwd,
    layout_config = { width = 0.95, height = 0.95, preview_width = 0.65 },
  })
  local promptBuf = vim.api.nvim_get_current_buf()
  if vim.bo[promptBuf].filetype ~= 'TelescopePrompt' then
    return
  end

  local finders = require('telescope.finders')
  local makeEntry = require('telescope.make_entry')
  local actionState = require('telescope.actions.state')
  local statusCmd = { 'git', 'status', '--porcelain', '-uall' }
  local last = vim.system(statusCmd, { cwd = cwd }):wait().stdout
  local timer = vim.uv.new_timer()

  timer:start(2000, 2000, function()
    vim.system(statusCmd, { cwd = cwd }, vim.schedule_wrap(function(res)
      if not vim.api.nvim_buf_is_valid(promptBuf) then
        if not timer:is_closing() then timer:close() end
        return
      end
      if res.code ~= 0 or res.stdout == last then
        return
      end
      last = res.stdout
      local picker = actionState.get_current_picker(promptBuf)
      if not picker then
        return
      end
      picker:refresh(finders.new_oneshot_job({ 'git', 'status', '-z', '-uall', '--', '.' }, {
        cwd = cwd,
        split_char = '\0',
        entry_maker = makeEntry.gen_from_git_status({ cwd = cwd }),
      }), { reset_prompt = false })
    end))
  end)
end

-- Mappping for telescope
-- Fuzzy Finder with (popup, plenary and telescope)
local opts = { noremap = true, silent = true }

vim.keymap.set('n', ';f', '<cmd>Telescope find_files<CR>', opts)
vim.keymap.set('n', ';r', '<cmd>Telescope live_grep<CR>', opts)
vim.keymap.set('n', ';g', gitStatusLive, opts) -- uncommitted files with diff preview, live refresh
vim.keymap.set('n', ';m', '<cmd>Telescope keymaps<CR>', opts)
vim.keymap.set('n', '\\\\', '<cmd>Telescope buffers<CR>', opts)
vim.keymap.set('n', ';;', '<cmd>Telescope help_tags<CR>', opts)
vim.keymap.set('n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
