function ToogleFold()
    if vim.o.foldlevel == 0 then
      vim.o.foldlevel = 99
    else
      vim.o.foldlevel = 0
    end
end

function FoldPlusOne()
    vim.o.foldlevel = vim.o.foldlevel + 1
end

-- config
vim.o.foldmethod = 'indent'
vim.keymap.set('n', '<leader>z', ToogleFold, {noremap = true, silent = true})
vim.keymap.set('n', '<leader>Z', FoldPlusOne, {noremap = true, silent = true})
