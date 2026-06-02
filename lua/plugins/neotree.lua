vim.pack.add{
  {src = 'https://github.com/nvim-neo-tree/neo-tree.nvim'},
}
--
-- require('neo-tree').setup(
--
--   cmd = 'Neotree',
--   keys = {
--     { '\\', ':Neotree reveal<CR>', { desc = 'NeoTree reveal' } },
--   },
--   opts = {
--     filesystem = {
--       window = {
--         mappings = {
--           ['\\'] = 'close_window',
--         },
--       },
--       filtered_items = {
--         visible = true,
--         hide_hidden = false,
--       },
--     },
--   }
-- )
