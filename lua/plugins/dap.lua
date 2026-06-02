vim.pack.add {
  { src = 'https://github.com/mfussenegger/nvim-dap'},
  { src = 'https://github.com/rcarriga/nvim-dap-ui'},
  { src = 'https://github.com/nvim-neotest/nvim-nio'},
  { src = 'https://github.com/mason-org/mason.nvim'},
  { src = 'https://github.com/jay-babu/mason-nvim-dap.nvim'},
  { src = 'https://github.com/leoluz/nvim-dap-go'},
  { src = 'https://github.com/Pocco81/DAPInstall.nvim'},
  { src = 'https://github.com/rcarriga/cmp-dap'},
}

local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
  return
end

local dap_ui_status_ok, dapui = pcall(require, "dapui")
if not dap_ui_status_ok then
  return
end

-- require('nvim-dap-virtual-text').setup({
--   highlight = 'Comment',
--   prefix = '● ',
--   use_treesitter = true,
--   treesitter_code = { 'identifier', 'function_call' }
-- })

-- dap.adapters.python = {
--   type = 'executable',
--   command = 'python',
--   args = { '-m', 'debugpy.adapter' },
-- }
-- dap.configurations.python = {
--   {
--     type = 'python',
--     request = 'launch',
--     name = 'Launch file',
--     program = "${file}",
--     pythonPath = function()
--       return 'python'
--     end,
--   },
-- }



-- Set up the UI
dapui.setup({
  icons = {
    expanded = '▾',
    collapsed = '▸',
  },
  mappings = {
    -- Use `<C-k>` to toggle the variables sidebar
    expand = { '<CR>', '<2-LeftMouse>' },
    open = 'o',
    remove = 'd',
    edit = 'e',
  },
  sidebar = {
    open_on_start = true,
    elements = {
      { id = 'scopes',      size = 0.1 },
      { id = 'breakpoints', size = 0.1 },
      { id = 'stacks',      size = 0.1 },
    },
    size = 0,
    position = 'left',
  },
})

local api = vim.api
if not api.nvim_create_user_command then
  return
end

local cmd = api.nvim_create_user_command
cmd('DapSetLogLevel',
  function(opts)
    require('dap').set_log_level(unpack(opts.fargs))
  end,
  {
    nargs = 1,
    complete = function()
      return vim.tbl_keys(require('dap.log').levels)
    end
  }
)
cmd('DapShowLog', 'split | e ' .. vim.fn.stdpath('cache') .. '/dap.log | normal! G', {})
cmd('DapContinue', function() require('dap').continue() end, { nargs = 0 })
cmd('DapToggleBreakpoint', function() require('dap').toggle_breakpoint() end, { nargs = 0 })
cmd('DapToggleRepl', function() require('dap.repl').toggle() end, { nargs = 0 })
cmd('DapStepOver', function() require('dap').step_over() end, { nargs = 0 })
cmd('DapStepInto', function() require('dap').step_into() end, { nargs = 0 })
cmd('DapStepOut', function() require('dap').step_out() end, { nargs = 0 })
cmd('DapTerminate', function() require('dap').terminate() end, { nargs = 0 })
cmd('DapLoadLaunchJSON', function() require('dap.ext.vscode').load_launchjs() end, { nargs = 0 })
cmd('DapRestartFrame', function() require('dap').restart_frame() end, { nargs = 0 })


if api.nvim_create_autocmd then
  local group = api.nvim_create_augroup('dap-launch.json', { clear = true })
  local pattern = '*/.vscode/launch.json'
  api.nvim_create_autocmd('BufNewFile', {
    group = group,
    pattern = pattern,
    callback = function(args)
      local lines = {
        '{',
        '   "version": "0.2.0",',
        '   "configurations": [',
        '       {',
        '           "type": "<adapter-name>",',
        '           "request": "launch",',
        '           "name": "Launch"',
        '       }',
        '   ]',
        '}'
      }
      api.nvim_buf_set_lines(args.buf, 0, -1, true, lines)
    end
  })
  api.nvim_create_autocmd('BufWritePost', {
    group = group,
    pattern = pattern,
    callback = function(args)
      require('dap.ext.vscode').load_launchjs(args.file)
    end
  })
end

-- dap.adapters.codelldb = {
--   type = 'server',
--   port = "${port}",
--   executable = {
--     -- CHANGE THIS to your path!
--     command = 'codelldb',
--     args = { "--port", "${port}" },
--     -- On windows you may have to uncomment this:
--     options = {
--       detached = false,
--     }
--   }
-- }
-- dap.configurations.rust = {
--   {
--     type = "codelldb",
--     request = "launch",
--     name = "Debug Rust",
--     program = function()
--       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
--     end,
--     cwd = "${workspaceFolder}",
--     externalTerminal = false,
--     stopOnEntry = true,
--     args = {},
--     showDisassembly = "never"
--   }
-- }
-- dap.configurations.cpp = {
--   {
--     type = "codelldb",
--     request = "launch",
--     name = "codelldb Debug",
--     program = function()
--       return vim.fn.input('Path to executable: ', vim.fn.getcwd())
--     end,
--     cwd = "${workspaceFolder}",
--     externalTerminal = false,
--     stopOnEntry = true,
--     args = {},
--     showDisassembly = "never"
--   },
-- }
-- dap.configurations.asm = dap.configurations.cpp
-- dap.configurations.c = dap.configurations.cpp
-- require('dap-go').setup()
