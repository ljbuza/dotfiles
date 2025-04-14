return {
  require("codecompanion").setup({
    strategies = {
      chat = {
        adapter = "anthropic",
      },
      inline = {
        adapter = "anthropic",
      },
    },
  }),
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      -- pyright will be automatically installed with mason and loaded with lspconfig
      pyright = {
        settings = {
          pyright = {
            disableOrganizeImports = true, -- Using Ruff
          },
          python = {
            analysis = {
              ignore = { "*" }, -- Using Ruff
              typeCheckingMode = "off", -- Using mypy
            },
          },
        },
      },
    },
  },
}
