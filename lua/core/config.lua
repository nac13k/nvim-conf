-- Basic native configuration by Lumbreras
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.termguicolors = true -- Set true for true color support
vim.opt.numberwidth = 2
vim.opt.relativenumber = false -- Set true for relative line numbers instead of absolute
vim.opt.showcmd = true
vim.opt.showmode = false
vim.opt.showmatch = true
vim.opt.ruler = true
vim.opt.hidden = true
vim.opt.cursorline = true
vim.opt.backspace = "indent,eol,start" -- Fix backspace indentation

-- Tabulation settings
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 0
vim.opt.expandtab = true
vim.opt.smartindent = true
-- vim.opt.sw=2 -- Disabled because it's deprecated??

-- Remove vim temporary files
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.wrap = false

-- nvim-cmp config required
vim.opt.completeopt = "menu,menuone,noselect"

-- Search settings
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.ignorecase = true -- Ignore case when searching for a command (e.g. :lsprestart -> :LSPRestart)

-- Encoding configurations
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = "utf-8"

-- OS tweaks

-- Python location
vim.g.python3_host_prog = "/usr/bin/python3" -- Optional, for python3 support

-- Integrate clipboard with system clipboard
if vim.fn.has("unnamedplus") == 1 then
	vim.opt.clipboard = "unnamedplus" -- Share X winows clipboard with vim
else
	vim.opt.clipboard = "unnamed" -- Share system clipboard with vim
end
