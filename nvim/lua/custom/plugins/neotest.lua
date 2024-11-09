return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/neotest-python',
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-python' {
          dap = {
            justMyCode = false,
            console = 'integratedTerminal',
          },
          args = { '--log-level', 'DEBUG', '--quiet' },
          runner = 'pytest',
          python = '.venv/bin/python',
        },
      },
    }
  end,
}
