return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
    "haydenmeade/neotest-jest",
    "marilari88/neotest-vitest",
    "thenbe/neotest-playwright",
  },
  config = function()
    local neotest = require("neotest")

    neotest.setup({
      summary = {
        follow = false,
      },
      adapters = {
        require("neotest-python"),
        require("neotest-jest"),
        require("neotest-vitest"),
        require("neotest-playwright").adapter({
          options = {
            persist_project_selection = true,
            enable_dynamic_test_discovery = true,
          },
        }),
      },
      consumers = {
        playwright = require("neotest-playwright.consumers").consumers,
      }
    })
  end,
}
