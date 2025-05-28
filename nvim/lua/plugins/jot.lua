return {
  "letieu/jot.lua",
  dependencies = { "nvim-lua/plenary.nvim" },

  opts = {
    vim.keymap.set("n", "<leader>fj", function()
      require("jot").open()
    end, { desc = "Jot Notes" }),
  },
}
