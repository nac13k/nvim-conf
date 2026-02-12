local ok, opencodeTerminal = pcall(require, 'plugins.lumbreras.opencode_terminal')
if not ok then
  return
end

opencodeTerminal.setup()
