require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true,
    disable = {},
  },
  incremental_selection = {
    enable = false,
  },
  ensure_installed = {
    "tsx",
    "javascript",
    "json",
    "yaml",
    "html",
    "scss",
    "ruby",
    "lua",
    "go"
  },
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.file_to_parsername = { "javascript", "typescript.tsx" }
