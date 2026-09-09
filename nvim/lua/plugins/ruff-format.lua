return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    opts.formatters_by_ft.python = { "ruff_fix", "ruff_format" }
    opts.formatters = vim.tbl_deep_extend("force", opts.formatters or {}, {
      ruff_fix = {
        command = "ruff",
        args = {
          "check",
          "--fix",
          "--stdin-filename",
          "$FILENAME",
          "-",
        },
        stdin = true,
      },
      ruff_format = {
        command = "ruff",
        args = { "format", "-" },
        stdin = true,
      },
    })
  end,
}
