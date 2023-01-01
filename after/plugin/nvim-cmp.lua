-- set completeopt=menu,menuone,noselect

-- Setup nvim-cmp.
local cmp = require'cmp'
local lspkind = require('lspkind') -- Add icons to completion items

local function on_attach(_, bufnr)
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
	vim.cmd [[command! Format execute 'lua vim.lsp.buf.formatting()']]
end

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	mapping = {
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-e>'] = cmp.mapping.close(),
		['<C-y>'] = cmp.config.disable,  -- It disabled the default `<C-y>` mapping.
		['<CR>'] = cmp.mapping.confirm({ select = false }),
	},
	formatting = {
		format = lspkind.cmp_format({with_text = false, maxwidth = 50})
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'ultisnips' }, -- For ultisnips users.
		}, {
			-- { name = 'buffer' },
	})
})

-- Autoinstaller for Language Server Protocol
-- Start functions from lsp-installer
local lsp_installer = require("nvim-lsp-installer")
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
lsp_installer.on_server_ready(function(server)
	local opts = {
		capabilities = capabilities,
		on_attach = on_attach,
	}

	-- (optional) Customize the options passed to the server
	-- if server.name == "tsserver" then
	--     opts.root_dir = function() ... end
	-- end

	-- This setup() function is exactly the same as lspconfig's setup function.
	-- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/ADVANCED_README.md
	server:setup(opts)
end)


-- List of LSP servers to install
local servers = {
	'sorbet', -- sorbet Language Server for Ruby
	'angularls', -- angularls Language Server for Angular
	'eslint', -- eslint Language Server for Javascript
	'vimls', -- vimls Language Server for Vim Script
	'gopls', -- gopls Language Server for Go
	'graphql', -- graphql Language Server for GraphQL
	'jsonls', -- jsonls Language Server for JSON
	'dockerls', -- dockerls Language Server for Docker
	'bashls', -- bashls Language Server for Bash
	'html', -- html Language Server for HTML
	'pyright', -- pyright Language Server for Python
	'sqlls', -- sqlls Language Server for SQL
	'sumneko_lua', -- sumneko_lua Language Server for Lua
}

-- Install LSP servers if not installed
local lsp_installer_servers = require'nvim-lsp-installer.servers'
for _, server_name in ipairs(servers) do
	local ok, server = lsp_installer_servers.get_server(server_name)
	if ok then
		if not server:is_installed() then
			server:install()
		end
	end
end
