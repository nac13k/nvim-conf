local M = {}
local opencodeTerminal
local isSetup = false
local sessionRoot

local function gitStatusChanged(root)
  local output = vim.fn.system({ 'git', '-C', root, 'status', '--porcelain' })
  if vim.v.shell_error ~= 0 then
    return {}
  end

  local changed = {}
  for line in string.gmatch(output, '([^\n]+)') do
    local path = line:sub(4)
    local renameTarget = path:match('%-%> (.+)$')
    if renameTarget and renameTarget ~= '' then
      path = renameTarget
    end

    if path ~= '' then
      table.insert(changed, path)
    end
  end

  return changed
end

local function syncProjectBuffers(root)
  if not root or root == '' then
    return
  end

  local changed = gitStatusChanged(root)

  for _, relativePath in ipairs(changed) do
    local absolutePath = root .. '/' .. relativePath
    if vim.fn.filereadable(absolutePath) == 1 then
      local bufnr = vim.fn.bufnr(absolutePath)
      if bufnr == -1 then
        bufnr = vim.fn.bufadd(absolutePath)
      end

      if bufnr > 0 and vim.fn.bufloaded(bufnr) == 0 then
        vim.fn.bufload(bufnr)
      end
    end
  end

  vim.cmd('checktime')
end

local function resolveProjectRoot()
  local currentBuffer = vim.api.nvim_buf_get_name(0)
  local startPath = currentBuffer ~= '' and vim.fs.dirname(currentBuffer) or vim.fn.getcwd()

  if startPath and startPath ~= '' then
    local gitDir = vim.fs.find('.git', { path = startPath, upward = true })[1]
    if gitDir then
      return vim.fs.dirname(gitDir)
    end
  end

  return vim.fn.getcwd()
end

function M.setup()
  if isSetup then
    return
  end

  local hasToggleterm, toggletermTerminal = pcall(require, 'toggleterm.terminal')
  if not hasToggleterm then
    return
  end

  local Terminal = toggletermTerminal.Terminal

  opencodeTerminal = Terminal:new({
    cmd = 'opencode',
    dir = vim.fn.getcwd(),
    direction = 'float',
    hidden = true,
    on_exit = function()
      vim.schedule(function()
        syncProjectBuffers(sessionRoot)
      end)
    end,
  })

  function M.toggle()
    if vim.fn.executable('opencode') ~= 1 then
      vim.notify('OpenCode binary not found in PATH: opencode', vim.log.levels.WARN)
      return
    end

    sessionRoot = resolveProjectRoot()
    opencodeTerminal.dir = sessionRoot
    opencodeTerminal:toggle()

    vim.schedule(function()
      syncProjectBuffers(sessionRoot)
    end)
  end

  function M.sync()
    syncProjectBuffers(sessionRoot or resolveProjectRoot())
  end

  vim.keymap.set('n', '<leader>oo', M.toggle, {
    noremap = true,
    silent = true,
    desc = 'Toggle OpenCode terminal',
  })

  vim.keymap.set('t', '<leader>oo', [[<C-\><C-n><Cmd>lua require('plugins.lumbreras.opencode_terminal').toggle()<CR>]], {
    noremap = true,
    silent = true,
    desc = 'Toggle OpenCode terminal',
  })

  vim.keymap.set('n', '<C-o><C-o>', M.toggle, {
    noremap = true,
    silent = true,
    desc = 'Toggle OpenCode terminal with double Ctrl-O',
  })

  vim.keymap.set('t', '<C-o><C-o>', [[<C-\><C-n><Cmd>lua require('plugins.lumbreras.opencode_terminal').toggle()<CR>]], {
    noremap = true,
    silent = true,
    desc = 'Toggle OpenCode terminal with double Ctrl-O',
  })

  vim.keymap.set('n', '<C-q>', M.toggle, {
    noremap = true,
    silent = true,
    desc = 'Quick toggle OpenCode terminal',
  })

  vim.keymap.set('t', '<C-q>', [[<C-\><C-n><Cmd>lua require('plugins.lumbreras.opencode_terminal').toggle()<CR>]], {
    noremap = true,
    silent = true,
    desc = 'Quick toggle OpenCode terminal',
  })

  vim.keymap.set('n', '<leader>os', M.sync, {
    noremap = true,
    silent = true,
    desc = 'Sync buffers modified by OpenCode',
  })

  vim.api.nvim_create_augroup('OpenCodeTerminalSync', { clear = true })
  vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
    group = 'OpenCodeTerminalSync',
    callback = function()
      if sessionRoot then
        syncProjectBuffers(sessionRoot)
      end
    end,
  })

  isSetup = true
end

return M
