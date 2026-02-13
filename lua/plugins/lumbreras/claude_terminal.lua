local M = {}
local claudeTerminal
local isSetup = false
local sessionRoot
local TOGGLE_KEY = '<C-g>c'
local SESSION_FILE = '.claude-session'
local SESSION_FILE_LEGACY = '.claude-sesion'

local function readFile(path)
  if vim.fn.filereadable(path) ~= 1 then
    return nil
  end

  local lines = vim.fn.readfile(path)
  if not lines or #lines == 0 then
    return nil
  end

  local value = vim.trim(lines[1] or '')
  if value == '' then
    return nil
  end

  return value
end

local function writeFile(path, value)
  if not value or value == '' then
    return
  end

  vim.fn.writefile({ value }, path)
end

local function ensureClaudeSessionId(root, preferred, generate)
  if preferred and preferred ~= '' then
    writeFile(root .. '/' .. SESSION_FILE, preferred)
    return preferred
  end

  local sessionId = readFile(root .. '/' .. SESSION_FILE) or readFile(root .. '/' .. SESSION_FILE_LEGACY)
  if sessionId and sessionId ~= '' then
    writeFile(root .. '/' .. SESSION_FILE, sessionId)
    return sessionId
  end

  if not generate then
    return nil
  end

  local generated = vim.trim(vim.fn.system('uuidgen')):lower()
  if generated == '' or vim.v.shell_error ~= 0 then
    return nil
  end

  writeFile(root .. '/' .. SESSION_FILE, generated)
  return generated
end

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

  claudeTerminal = Terminal:new({
    cmd = 'claude',
    dir = vim.fn.getcwd(),
    direction = 'float',
    hidden = true,
    on_exit = function()
      vim.schedule(function()
        syncProjectBuffers(sessionRoot)
      end)
    end,
  })

  function M.toggleWithSession(root, sessionId, onSession)
    if vim.fn.executable('claude') ~= 1 then
      vim.notify('Claude binary not found in PATH: claude', vim.log.levels.WARN)
      return
    end

    sessionRoot = root and root ~= '' and root or resolveProjectRoot()
    local wasOpen = false
    if claudeTerminal and claudeTerminal.is_open then
      wasOpen = claudeTerminal:is_open()
    end
    local resolvedSessionId = ensureClaudeSessionId(sessionRoot, sessionId, false)
    if resolvedSessionId then
      claudeTerminal.cmd = 'claude --resume ' .. resolvedSessionId
    else
      resolvedSessionId = ensureClaudeSessionId(sessionRoot, sessionId, true)
      if not resolvedSessionId then
        vim.notify('Could not create Claude session id file', vim.log.levels.WARN)
        return
      end
      claudeTerminal.cmd = 'claude --session-id ' .. resolvedSessionId
    end
    claudeTerminal.dir = sessionRoot
    claudeTerminal:toggle()

    if onSession then
      onSession(resolvedSessionId)
    end

    vim.schedule(function()
      syncProjectBuffers(sessionRoot)
    end)
  end

  function M.toggle()
    M.toggleWithSession(nil, nil, nil)
  end

  function M.sync()
    syncProjectBuffers(sessionRoot or resolveProjectRoot())
  end

  vim.keymap.set({ 'n', 'i', 'v', 'x', 's', 'o' }, TOGGLE_KEY, M.toggle, {
    noremap = true,
    silent = true,
    desc = 'Toggle Claude terminal',
  })

  vim.keymap.set('c', TOGGLE_KEY, [[<C-c><Cmd>lua require('plugins.lumbreras.claude_terminal').toggle()<CR>]], {
    noremap = true,
    silent = true,
    desc = 'Toggle Claude terminal',
  })

  vim.keymap.set('t', TOGGLE_KEY, [[<C-\><C-n><Cmd>lua require('plugins.lumbreras.claude_terminal').toggle()<CR>]], {
    noremap = true,
    silent = true,
    desc = 'Toggle Claude terminal',
  })

  vim.api.nvim_create_augroup('ClaudeTerminalSync', { clear = true })
  vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
    group = 'ClaudeTerminalSync',
    callback = function()
      if sessionRoot then
        syncProjectBuffers(sessionRoot)
      end
    end,
  })

  isSetup = true
end

return M
