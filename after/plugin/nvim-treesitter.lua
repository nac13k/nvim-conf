-- nvim-treesitter (main branch, nvim >= 0.12). Needs tree-sitter-cli (brew install tree-sitter-cli).
-- Highlight/folds come from Neovim core; this plugin installs parsers + queries and provides indent.
require('nvim-treesitter').install({
  'tsx',
  'typescript',
  'javascript',
  'json',
  'yaml',
  'html',
  'scss',
  'ruby',
  'lua',
  'go',
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('UserTreesitter', {}),
  callback = function(args)
    -- no-op error when there is no parser for this filetype
    if pcall(vim.treesitter.start, args.buf) then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
