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
  -- Add mason to nvim to manage LSP dependencies
  use {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
  }
  -- Autocomplete with nvim-cmp
  use {'hrsh7th/nvim-cmp'}
  use {'hrsh7th/cmp-buffer'}
  use {'hrsh7th/cmp-path'}
  use {'hrsh7th/cmp-nvim-lsp'}
  use {'saadparwaiz1/cmp_luasnip'}
  -- Snippets
  use { 'L3MON4D3/LuaSnip' }
  use {'rafamadriz/friendly-snippets'}
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
  use {'theHamsta/nvim-dap-virtual-text'}

  -- Navigation plugins
  use {'phaazon/hop.nvim'}
end)
