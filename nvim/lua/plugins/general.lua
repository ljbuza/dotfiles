return {
  -- require("codecompanion").setup({
  --   strategies = {
  --     chat = {
  --       adapter = "anthropic",
  --     },
  --     inline = {
  --       adapter = "anthropic",
  --     },
  --   },
  -- }),
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    -- turn off global inlay hints
    opts.inlay_hints = { enabled = false }

    opts.servers = opts.servers or {}

    -- ensure basedpyright is enabled and configured
    opts.servers.basedpyright = vim.tbl_deep_extend("force", opts.servers.basedpyright or {}, {
      enabled = true,
      settings = {
        basedpyright = {
          disableOrganizeImports = true, -- Using Ruff
        },
        python = {
          analysis = {
            ignore = { "*" }, -- Using Ruff
            typeCheckingMode = "off", -- Using mypy
          },
        },
      },
    })

    -- keep your tsserver inlay-hints tweaks
    opts.servers.tsserver = vim.tbl_deep_extend("force", opts.servers.tsserver or {}, {
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "none",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = false,
            includeInlayVariableTypeHints = false,
            includeInlayPropertyDeclarationTypeHints = false,
            includeInlayFunctionLikeReturnTypeHints = false,
            includeInlayEnumMemberValueHints = false,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "none",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = false,
            includeInlayVariableTypeHints = false,
            includeInlayPropertyDeclarationTypeHints = false,
            includeInlayFunctionLikeReturnTypeHints = false,
            includeInlayEnumMemberValueHints = false,
          },
        },
      },
    })

    return opts
  end,
}
