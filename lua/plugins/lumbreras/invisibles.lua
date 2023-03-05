local invisibles = "eol:☠,space:⠿,tab:▸␣,trail:~,extends:>,precedes:<,nbsp:█"

-- function that enable or disable invisibles characters in neovim
function Toggle_invisibles()
  vim.o.listchars = invisibles
  vim.o.list = not vim.o.list
end

vim.keymap.set('n', '<leader>ii', Toggle_invisibles, {noremap = true, silent = true})
