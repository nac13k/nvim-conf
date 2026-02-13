local ok, vimAgent = pcall(require, 'plugins.lumbreras.vim_agent')
if not ok then
  return
end

vimAgent.setup()
