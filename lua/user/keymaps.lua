-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
local opts = { noremap = true, silent = true }
-- Neotree
vim.api.nvim_set_keymap('n', '<leader>tt', '<cmd>Neotree toggle<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>tf', '<cmd>Neotree focus<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>tc', '<cmd>Neotree current<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>u', '<cmd>UndotreeToggle<CR>', opts)

vim.api.nvim_set_keymap('n', '<leader>bp', '<cmd>bprevious<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>bn', '<cmd>bnext<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>bd', '<cmd>bdelete<CR>', { silent = true })

vim.api.nvim_set_keymap('n', '<leader>cr', '<cmd>!cargo run<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>ct', '<cmd>!cargo test<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>cb', '<cmd>!cargo build<CR>', { silent = true })

vim.api.nvim_set_keymap('v', 'J', ":m '>+1<CR>gv=gv", { silent = true })
vim.api.nvim_set_keymap('v', 'K', ":m '<-2<CR>gv=gv", { silent = true })
vim.api.nvim_set_keymap('n', '<leader>y', "\"+y", { silent = true })
vim.api.nvim_set_keymap('v', '<leader>y', "\"+y", { silent = true })
vim.api.nvim_set_keymap('n', '<leader>Y', "\"+Y", { silent = true })
vim.keymap.set("n", "<leader>xc", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("v", "<leader>xc", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.api.nvim_set_keymap('n', '<leader>p', "\"+p", { silent = true })
vim.api.nvim_set_keymap('v', '<leader>p', "\"+p", { silent = true })
vim.api.nvim_set_keymap('n', '<leader>P', "\"+P", { silent = true })

-- Setup keybindings
vim.api.nvim_set_keymap('n', '<leader>db', ':lua require("dap").toggle_breakpoint()<CR>',
	{ noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dB',
	"<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dc', ':lua require("dap").continue()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ds', ':lua require("dap").step_over()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>di', ':lua require("dap").step_into()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>do', ':lua require("dap").step_out()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dl', ':lua require("dap").repl.open()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dk', ':lua require("dap").disconnect()<CR>', { noremap = true, silent = true })

-- Open DapUI
vim.api.nvim_set_keymap('n', '<leader>du', ':lua require("dapui").toggle()<CR>', { noremap = true, silent = true })
-- Pause
vim.api.nvim_set_keymap('n', '<leader>dp', ':lua require("dap").pause()<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
	vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
	vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
	vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
vim.keymap.set('n', '<leader>tx', ':ToggleTerm<cr>', opts)
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
