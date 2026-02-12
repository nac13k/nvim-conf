-- Add this new autosave formatting in order to avoid the use of deprecated null-ls package
vim.g.neoformat_enabled_ruby = { 'rubocop' }

local function detectRubocopRunner()
  if vim.b.rubocop_runner ~= nil then
    return vim.b.rubocop_runner
  end

  local cwd = vim.fn.getcwd()
  local has_gemfile = vim.fn.filereadable(cwd .. '/Gemfile') == 1

  if has_gemfile and vim.fn.executable('bundle') == 1 then
    vim.fn.system({ 'bundle', 'exec', 'rubocop', '-v' })
    if vim.v.shell_error == 0 then
      vim.b.rubocop_runner = { exe = 'bundle', args = { 'exec', 'rubocop' } }
      return vim.b.rubocop_runner
    end
  end

  if vim.fn.executable('rubocop') == 1 then
    vim.b.rubocop_runner = { exe = 'rubocop', args = {} }
    return vim.b.rubocop_runner
  end

  vim.b.rubocop_runner = false
  return nil
end

local function configureRubocopFormatter()
  local runner = detectRubocopRunner()
  if not runner then
    return false
  end

  vim.g.neoformat_ruby_rubocop = {
    exe = runner.exe,
    args = vim.list_extend(vim.deepcopy(runner.args), { '-A', '--stdin', '%:p' }),
    stdin = 1,
  }

  return true
end

local function formatter()
  local bufType = vim.bo.filetype
  if bufType == 'typescript' or bufType == 'javascript' or bufType == 'typescriptreact' then
    vim.cmd('Neoformat prettier')
  elseif bufType == 'ruby' then
    if configureRubocopFormatter() then
      vim.cmd('Neoformat rubocop')
    end
  else
    vim.cmd('Neoformat')
    -- vim.lsp.buf.format({ async = false })
  end
end

vim.api.nvim_create_augroup('AutoFormatting', {})
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  group = 'AutoFormatting',
  callback = formatter
})

-- Add shortcurt to format the current buffer
vim.keymap.set('n', '<C-f>', formatter, { noremap = true, silent = true })
