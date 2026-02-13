local ok, claudeTerminal = pcall(require, 'plugins.lumbreras.claude_terminal')
if not ok then
  return
end

claudeTerminal.setup()
