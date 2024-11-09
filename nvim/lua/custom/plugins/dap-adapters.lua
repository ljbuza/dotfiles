return {
  {
    'mfussenegger/nvim-dap-python',
    ft = 'python',
    dependencies = {
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
    },
    -- keys = {
    --   {
    --     '<leader>dPt',
    --     function()
    --       require('dap-python').test_method()
    --     end,
    --     desc = 'Debug Method',
    --     ft = 'python',
    --   },
    --   {
    --     '<leader>dPc',
    --     function()
    --       require('dap-python').test_class()
    --     end,
    --     desc = 'Debug Class',
    --     ft = 'python',
    --   },
    -- },
    config = function(_, opts)
      local path = '~/.local/share/nvim/mason/packages/debugpy/venv/bin/python'
      require('dap-python').setup(path)
      require('dap-python').test_runner = 'pytest'
    end,
  },
}
