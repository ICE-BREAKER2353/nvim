vim.pack.add{
  { src = 'https://github.com/nvim-lualine/lualine.nvim'}
}
-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
  -- options = {
  --   icons_enabled = true,
  --   --theme = 'onedark',
  --   -- theme = 'tokyonight-day',
  --   -- theme = 'dracula',
  --   -- theme = 'koehler',
  --   theme = 'auto',
  --   component_separators = '|',
  --   section_separators = '',
  -- },
}
