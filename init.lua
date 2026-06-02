vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Iterate over all Lua files in the plugins directory and load them
local plugins_dir = vim.fs.joinpath(vim.fn.stdpath 'config', 'lua', 'plugins')
for file_name, type in vim.fs.dir(plugins_dir) do
  if type == 'file' and file_name:match '%.lua$' and file_name ~= 'init.lua' then
    local module = file_name:gsub('%.lua$', '')
    require('plugins.' .. module)
  end
end

vim.pack.del(vim.iter(vim.pack.get())
  :filter(function(x) return not x.active end)
  :map(function(x) return x.spec.name end)
  :totable())
-- vim.pack.update()
require('user.settings')
require('user.keymaps')
require('user.yankHighlight')
-- require('user.gitsigns')
