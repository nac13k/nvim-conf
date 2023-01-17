vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Beuatyfull UI for LSP
  use {'glepnir/lspsaga.nvim', branch = 'main' }
  -- Add commong syntax highlight with treesitter
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  --  Add vim-cool to remove highlight after finish search and press any key to change the nvim mode
  use { 'romainl/vim-cool' }
  -- Add nvim comment (easy comment)
  use { 'terrortylor/nvim-comment' }
  --  Add cmp to nvim for autocompletion
  use {'neovim/nvim-lspconfig' }
  -- Easy instalation for LSP
  use {'williamboman/nvim-lsp-installer' }
  use {'hrsh7th/cmp-nvim-lsp'}
  use {'hrsh7th/cmp-buffer'}
  use {'hrsh7th/nvim-cmp'}
  use {'onsails/lspkind-nvim'}
  -- Cmp plugins for ultisnips users.
  use {'quangnguyen30192/cmp-nvim-ultisnips'}
  -- Ultisnipets
  use {'SirVer/ultisnips'}
  use {'honza/vim-snippets'}
  -- Fuzzy finder with telescope plugins
  use {'nvim-lua/popup.nvim'}
  use {'nvim-lua/plenary.nvim'}
  use {'nvim-telescope/telescope.nvim'}
  -- Icons
  use {'kyazdani42/nvim-web-devicons'}
  -- nvim-tree a lua plugin similar to nerd-tree
  use {'kyazdani42/nvim-tree.lua'}
  -- nvim-bufferline
  use {'akinsho/nvim-bufferline.lua', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons'}
  -- delimitMate add auto close parentheses
  use {'Raimondi/delimitMate'}
  -- Status line
  use {'hoob3rt/lualine.nvim'}
  -- Toogle terminal
  use {'akinsho/nvim-toggleterm.lua', tag = "*"}
  -- focus.nvim nicely panes when work with splited buffers
  use {'beauwilliams/focus.nvim'}

  -- DBML syntax support
  use {'jidn/vim-dbml'}
  -- Markdown
  use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })

  -- Git plugins
  use {'lewis6991/gitsigns.nvim'}

  -- Themes and ui improves
  use {'morhetz/gruvbox'}
  use {'tomasr/molokai'}
  use {'EdenEast/nightfox.nvim'}
  use {'folke/tokyonight.nvim', branch = 'main'}

  -- Github Copilot
  use {'github/copilot.vim'}

  -- Plugins for lang
  use {'ray-x/go.nvim'}
  use {'ray-x/guihua.lua', run = 'cd lua/fzy && make'}
  -- Enable debugger and a better ui
  use {'mfussenegger/nvim-dap'}
  use {'rcarriga/nvim-dap-ui'}

  -- Navigation plugins
  use {'phaazon/hop.nvim'}

end)
