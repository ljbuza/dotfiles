return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    local dappython = require 'dap-python'
    dapui.setup()
    dap.listeners.before.attach['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.launch['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end
    vim.keymap.set('n', 'dc', dap.continue, { desc = 'Debug Continue' })
    vim.keymap.set('n', '<F10>', dap.step_over, { desc = 'Debug Step Over' })
    vim.keymap.set('n', '<F11>', dap.step_into, { desc = 'Debug Step Into' })
    vim.keymap.set('n', '<F12>', dap.step_out, { desc = 'Debug Step Out' })
    vim.keymap.set('n', '<Leader>b', dap.toggle_breakpoint, { desc = 'Toggle Breakpoint' })
    vim.keymap.set('n', '<Leader>B', dap.set_breakpoint, { desc = 'Set Breakpoint' })
    vim.keymap.set('n', '<leader>dn', dappython.test_method, { desc = 'Debug Test Method' })
    vim.keymap.set('n', '<leader>df', dappython.test_class, { desc = 'Debug Test Class' })
    vim.keymap.set('n', '<leader>ds <ESC>', dappython.debug_selection, { desc = 'Debug Selection' })
    -- vim.keymap.set('n', '<Leader>lp', dap.set_breakpoint(nil, nil, vim.fn.input 'Log point message: '))
    -- vim.keymap.set('n', '<Leader>dr', dap.repl.open, {})
    -- vim.keymap.set('n', '<Leader>dl', dap.run_last, {})
  end,

  -- enabled = vim.fn.has "win32" == 0,

  --   {
  --     "jay-babu/mason-nvim-dap.nvim",
  --     dependencies = { "nvim-dap" },
  --     cmd = { "DapInstall", "DapUninstall" },
  --     opts = { handlers = {} },
  --   },
  --   {
  --     "rcarriga/nvim-dap-ui",
  --     opts = { floating = { border = "rounded" } },
  --     config = require "plugins.configs.nvim-dap-ui",
  --   },
  --   {
  --     "rcarriga/cmp-dap",
  --     dependencies = { "nvim-cmp" },
  --     config = require "plugins.configs.cmp-dap",
  --   },
  -- },
  -- event = "User AstroFile",
}
