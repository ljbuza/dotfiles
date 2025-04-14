return {
  "olimorris/codecompanion.nvim",
  config = true,
  opts = {
    vim.keymap.set("n", "<leader>ai", "<Cmd>CodeCompanionChat<CR>", { desc = "CodeCompanion Chat" }),
    vim.keymap.set("n", "<leader>aa", "<Cmd>CodeCompanionActions<CR>", { desc = "CodeCompanion Actions" }),
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
}
