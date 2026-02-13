local M = {}

local ACTIVE_AGENT_FILE = '.vim-agent'
local SESSIONS_FILE = '.vim-agent-sessions'
local TOGGLE_KEY = '<C-a>'

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

local function getActiveAgent(root)
  return readFile(root .. '/' .. ACTIVE_AGENT_FILE)
end

local function setActiveAgent(root, agent)
  writeFile(root .. '/' .. ACTIVE_AGENT_FILE, agent)
end

local function parseSessions(lines)
  local sessions = {}
  local extras = {}

  for _, line in ipairs(lines or {}) do
    local agent, sessionId = line:match('^(%w+)%s*:%s*(%S+)%s*$')
    if agent and sessionId then
      sessions[agent] = sessionId
    else
      if vim.trim(line) ~= '' then
        table.insert(extras, line)
      end
    end
  end

  return sessions, extras
end

local function readSessions(root)
  local path = root .. '/' .. SESSIONS_FILE
  if vim.fn.filereadable(path) ~= 1 then
    return {}, {}
  end

  local lines = vim.fn.readfile(path) or {}
  return parseSessions(lines)
end

local function writeSessions(root, sessions, extras)
  local lines = {}
  if sessions.opencode then
    table.insert(lines, 'opencode:' .. sessions.opencode)
  end
  if sessions.claude then
    table.insert(lines, 'claude:' .. sessions.claude)
  end

  for _, line in ipairs(extras or {}) do
    table.insert(lines, line)
  end

  vim.fn.writefile(lines, root .. '/' .. SESSIONS_FILE)
end

local function detectInstalledAgents()
  local options = {}
  if vim.fn.executable('opencode') == 1 then
    table.insert(options, 'opencode')
  end
  if vim.fn.executable('claude') == 1 then
    table.insert(options, 'claude')
  end
  return options
end

local function notifyNoAgents()
  vim.notify('No hay agentes instalados', vim.log.levels.WARN)
end

local function selectWithTelescope(options, onChoice)
  local hasPickers, pickers = pcall(require, 'telescope.pickers')
  if not hasPickers then
    return false
  end

  local hasFinders, finders = pcall(require, 'telescope.finders')
  if not hasFinders then
    return false
  end

  local hasConfig, config = pcall(require, 'telescope.config')
  if not hasConfig then
    return false
  end

  local hasActions, actions = pcall(require, 'telescope.actions')
  if not hasActions then
    return false
  end

  local hasActionState, actionState = pcall(require, 'telescope.actions.state')
  if not hasActionState then
    return false
  end

  pickers.new({}, {
    prompt_title = 'Select Vim agent',
    finder = finders.new_table({ results = options }),
    sorter = config.values.generic_sorter({}),
    previewer = false,
    sorting_strategy = 'ascending',
    layout_strategy = 'center',
    layout_config = {
      height = 0.15,
      width = 0.3,
    },
    results_height = math.min(#options, 2),
    attach_mappings = function(promptBufnr, map)
      local function choose()
        local selection = actionState.get_selected_entry()
        actions.close(promptBufnr)
        if selection and selection[1] then
          onChoice(selection[1])
        end
      end

      actions.select_default:replace(choose)
      map('i', '<CR>', choose)
      map('n', '<CR>', choose)
      return true
    end,
  }):find()

  return true
end

local function toggleWithAgent(agent, root, sessions, extras)
  if agent == 'opencode' then
    local ok, opencodeTerminal = pcall(require, 'plugins.lumbreras.opencode_terminal')
    if not ok then
      return
    end

    opencodeTerminal.toggleWithSession(root, sessions.opencode, function(sessionId)
      sessions.opencode = sessionId
      writeSessions(root, sessions, extras)
    end)
  elseif agent == 'claude' then
    local ok, claudeTerminal = pcall(require, 'plugins.lumbreras.claude_terminal')
    if not ok then
      return
    end

    claudeTerminal.toggleWithSession(root, sessions.claude, function(sessionId)
      sessions.claude = sessionId
      writeSessions(root, sessions, extras)
    end)
  end
end

local function selectAgent(root)
  local installed = detectInstalledAgents()
  if #installed == 0 then
    notifyNoAgents()
    return
  end

  local function applySelection(choice)
    if not choice then
      return
    end

    setActiveAgent(root, choice)
    local sessions, extras = readSessions(root)
    toggleWithAgent(choice, root, sessions, extras)
  end

  if selectWithTelescope(installed, applySelection) then
    return
  end

  if vim.ui and vim.ui.select then
    vim.ui.select(installed, { prompt = 'Select Vim agent' }, applySelection)
    return
  end

  local choices = { 'Select Vim agent' }
  for _, label in ipairs(installed) do
    table.insert(choices, label)
  end
  local picked = vim.fn.inputlist(choices)
  if picked < 2 then
    return
  end
  applySelection(installed[picked - 1])
end

local function toggleActiveAgent()
  local root = resolveProjectRoot()
  local active = getActiveAgent(root)
  local installed = detectInstalledAgents()
  if #installed == 0 then
    notifyNoAgents()
    return
  end

  if not active or active == '' then
    selectAgent(root)
    return
  end

  local isInstalled = false
  for _, agent in ipairs(installed) do
    if agent == active then
      isInstalled = true
      break
    end
  end

  if not isInstalled then
    selectAgent(root)
    return
  end

  local sessions, extras = readSessions(root)
  toggleWithAgent(active, root, sessions, extras)
end

function M.select()
  selectAgent(resolveProjectRoot())
end

function M.toggle()
  toggleActiveAgent()
end

function M.setup()
  vim.api.nvim_create_user_command('SelectVimAgent', function()
    M.select()
  end, {})

  vim.keymap.set({ 'n', 'i', 'v', 'x', 's', 'o' }, TOGGLE_KEY, M.toggle, {
    noremap = true,
    silent = true,
    desc = 'Toggle Vim agent terminal',
  })

  vim.keymap.set('c', TOGGLE_KEY, [[<C-c><Cmd>lua require('plugins.lumbreras.vim_agent').toggle()<CR>]], {
    noremap = true,
    silent = true,
    desc = 'Toggle Vim agent terminal',
  })

  vim.keymap.set('t', TOGGLE_KEY, [[<C-\><C-n><Cmd>lua require('plugins.lumbreras.vim_agent').toggle()<CR>]], {
    noremap = true,
    silent = true,
    desc = 'Toggle Vim agent terminal',
  })
end

return M
