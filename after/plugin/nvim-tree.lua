-- Config for nvim-tree by Lumbreras
--
require'nvim-tree'.setup {
  -- disables netrw completely
  disable_netrw       = true,
  -- hijack netrw window on startup
  hijack_netrw        = true,
  -- open the tree when running this setup function
  -- open_on_setup       = false,
  -- open the tree when opening a file
  respect_buf_cwd     = true,
  -- will not open on setup if the filetype is in this list
  -- ignore_ft_on_setup  = {},
  -- closes neovim automatically when the tree is the last **WINDOW** in the view
  -- auto_close          = true,
  -- opens the tree when changing/opening a new tab if the tree wasn't previously opened
  open_on_tab         = false,
  -- hijacks new directory buffers when they are opened.
  hijack_directories   = {
    -- enable the feature
    enable = true,
    -- allow to open the tree if it was previously closed
    auto_open = true,
  },
  -- hijack the cursor in the tree to put it at the start of the filename
  hijack_cursor       = true,
  -- updates the root directory of the tree on `DirChanged` (when you run `:cd` usually)
  update_cwd          = false,
  -- show lsp diagnostics in the signcolumn
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  filters = {
    dotfiles = false,
    custom = { '^\\.git$', 'node_modules', '^\\.cache' }, -- Regex filters, will ignore files/folders matching the regex
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  -- update the focused file on `BufEnter`, un-collapses the folders recursively until it finds the file
  update_focused_file = {
    -- enables the feature
    enable      = true,
    -- update the root directory of the tree to the one of the folder containing the file if the file is not under the current root directory
    -- only relevant when `update_focused_file.enable` is true
    update_cwd  = false,
    -- list of buffer names / filetypes that will not update the cwd if the file isn't found under the current root directory
    -- only relevant when `update_focused_file.update_cwd` is true and `update_focused_file.enable` is true
    ignore_list = {}
  },
  -- configuration options for the system open command (`s` in the tree by default)
  system_open = {
    -- the command to run this, leaving nil should work in most cases
    cmd  = nil,
    -- the command arguments as a list
    args = {}
  },

  view = {
    width = 30, -- width of the window, can be either a number (columns) or a string in `%`, for left or right side placement
    -- hide_root_folder = false, -- Hide the root path of the current folder on top of the tree 
    side = 'left', -- side of the tree, can be one of 'left' | 'right' | 'top' | 'bottom'
    -- auto_resize = false, -- if true the tree will resize itself after opening a file
    -- mappings = {
    --   -- custom only false will merge the list with the default mappings
    --   -- if true, it will only use your list to set the mappings
    --   custom_only = false,
    --   -- list of mappings to set on the tree manually
    --   list = {}
    -- }
  },
  renderer = {
    add_trailing           = false,
    highlight_opened_files = 'all',
    highlight_git          = true,
    -- ':~'
    root_folder_modifier = '',
    group_empty = true,
    special_files = {
      'README.md',
      'Makefile',
      'MAKEFILE',
    },
    icons = {
      padding = ' ',
      -- ' >> '
      symlink_arrow = '',
      show = {
        git = true,
        folder = true,
        file = true,
        folder_arrow = true,
      },
      glyphs = {
        default = '',
        symlink = '',
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌"
        },
        folder = {
          arrow_open = "",
          arrow_closed = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
      }
    }
  },
  actions = {
    open_file = {
      quit_on_open = true,
      resize_window = false,
      window_picker = {
        enable = false,
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        exclude = {
          filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
          buftype = { "nofile", "terminal", "help" },
        }
      }
    }
  },
  trash = {
    cmd = "trash",
    require_confirm = true,
  },
}

-- Mapping
-- NvimTreeOpen and NvimTreeClose are available if you need them
vim.keymap.set('n', '<leader>n', vim.cmd.NvimTreeToggle, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>r', vim.cmd.NvimTreeRefresh, { noremap = true, silent = true })
