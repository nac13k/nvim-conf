local M = {}
local opencodeTerminal
local isSetup = false
local sessionRoot
local sessionSnapshotBeforeLaunch
local TOGGLE_KEY = '<C-g>o'
local SESSION_FILE = '.opencode-session'
local SESSION_FILE_LEGACY = '.opencode-sesion'

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

local function ensureSessionFile(root)
  if not root or root == '' then
    return nil
  end

  local sessionPath = root .. '/' .. SESSION_FILE
  if vim.fn.filereadable(sessionPath) == 1 then
    return sessionPath
  end

  local legacyValue = readFile(root .. '/' .. SESSION_FILE_LEGACY)
  if legacyValue then
    writeFile(sessionPath, legacyValue)
  else
    vim.fn.writefile({ '' }, sessionPath)
  end

  return sessionPath
end

local function listOpencodeSessions()
  local output = vim.fn.system({ 'opencode', 'session', 'list' })
  if vim.v.shell_error ~= 0 then
    return {}
  end

  local sessions = {}
  for line in string.gmatch(output, '([^\n]+)') do
    local sessionId = line:match('^(ses_[%w]+)')
    if sessionId then
      table.insert(sessions, sessionId)
    end
  end

  return sessions
end

local function opencodeSessionExists(sessionId)
  if not sessionId or sessionId == '' then
    return false
  end

  local sessions = listOpencodeSessions()
  for _, value in ipairs(sessions) do
    if value == sessionId then
      return true
    end
  end

  return false
end

local function sessionsAsSet(sessions)
  local values = {}
  for _, sessionId in ipairs(sessions) do
    values[sessionId] = true
  end
  return values
end

local function findNewSessionId(beforeSessions, afterSessions)
  local beforeSet = sessionsAsSet(beforeSessions or {})
  for _, sessionId in ipairs(afterSessions or {}) do
    if not beforeSet[sessionId] then
      return sessionId
    end
  end
  return nil
end

local function resolveOpencodeSessionId(root)
  ensureSessionFile(root)
  local saved = readFile(root .. '/' .. SESSION_FILE) or readFile(root .. '/' .. SESSION_FILE_LEGACY)
  if saved and opencodeSessionExists(saved) then
    return saved
  end

  return nil
end

local function persistLatestOpencodeSessionId(root)
  if not root or root == '' then
    return
  end

  ensureSessionFile(root)

  local saved = readFile(root .. '/' .. SESSION_FILE) or readFile(root .. '/' .. SESSION_FILE_LEGACY)
  if saved and opencodeSessionExists(saved) then
    writeFile(root .. '/' .. SESSION_FILE, saved)
    return
  end

  local latest = findNewSessionId(sessionSnapshotBeforeLaunch, listOpencodeSessions())
  if latest and latest ~= '' then
    writeFile(root .. '/' .. SESSION_FILE, latest)
  end
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

  opencodeTerminal = Terminal:new({
    cmd = 'opencode',
    dir = vim.fn.getcwd(),
    direction = 'float',
    hidden = true,
    on_exit = function()
      vim.schedule(function()
        persistLatestOpencodeSessionId(sessionRoot)
        syncProjectBuffers(sessionRoot)
      end)
    end,
  })

  function M.toggleWithSession(root, sessionId, onSession)
    if vim.fn.executable('opencode') ~= 1 then
      vim.notify('OpenCode binary not found in PATH: opencode', vim.log.levels.WARN)
      return
    end

    sessionRoot = root and root ~= '' and root or resolveProjectRoot()
    ensureSessionFile(sessionRoot)
    sessionSnapshotBeforeLaunch = listOpencodeSessions()

    local wasOpen = false
    if opencodeTerminal and opencodeTerminal.is_open then
      wasOpen = opencodeTerminal:is_open()
    end

    local resolvedSessionId = sessionId
    if resolvedSessionId and not opencodeSessionExists(resolvedSessionId) then
      resolvedSessionId = nil
    end

    if not resolvedSessionId then
      resolvedSessionId = resolveOpencodeSessionId(sessionRoot)
    end

    if resolvedSessionId then
      opencodeTerminal.cmd = 'opencode --session ' .. resolvedSessionId
    else
      opencodeTerminal.cmd = 'opencode'
    end

    opencodeTerminal.dir = sessionRoot
    opencodeTerminal:toggle()

    vim.schedule(function()
      persistLatestOpencodeSessionId(sessionRoot)
      syncProjectBuffers(sessionRoot)
      if onSession then
        local latest = readFile(sessionRoot .. '/' .. SESSION_FILE)
        if latest and latest ~= '' then
          onSession(latest)
        end
      end
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
    desc = 'Toggle OpenCode terminal',
  })

  vim.keymap.set('c', TOGGLE_KEY, [[<C-c><Cmd>lua require('plugins.lumbreras.opencode_terminal').toggle()<CR>]], {
    noremap = true,
    silent = true,
    desc = 'Toggle OpenCode terminal',
  })

  vim.keymap.set('t', TOGGLE_KEY, [[<C-\><C-n><Cmd>lua require('plugins.lumbreras.opencode_terminal').toggle()<CR>]], {
    noremap = true,
    silent = true,
    desc = 'Toggle OpenCode terminal',
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
