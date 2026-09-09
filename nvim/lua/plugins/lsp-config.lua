-- This file should be placed at ~/.config/nvim/lua/plugins/lsp.lua

return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Disable inlay hints globally
      opts.inlay_hints = { enabled = false }
      
      -- Make sure the setting is applied to all servers
      opts.setup = opts.setup or {}
      local prev_setup = opts.setup
      
      opts.setup = setmetatable({}, {
        __index = function(_, server)
          local prev = prev_setup[server]
          return function(server_name, server_opts)
            -- Ensure inlay hints are disabled for all servers
            server_opts.settings = server_opts.settings or {}
            server_opts.settings.inlayHints = { enable = false }
            
            -- Special handling for specific servers
            if server_name == "tsserver" then
              server_opts.settings.typescript = server_opts.settings.typescript or {}
              server_opts.settings.typescript.inlayHints = {
                includeInlayParameterNameHints = "none",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = false,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = false,
                includeInlayFunctionLikeReturnTypeHints = false,
                includeInlayEnumMemberValueHints = false,
              }
              
              server_opts.settings.javascript = server_opts.settings.javascript or {}
              server_opts.settings.javascript.inlayHints = {
                includeInlayParameterNameHints = "none",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = false,
                includeInlayVariableTypeHints = false,
                includeInlayPropertyDeclarationTypeHints = false,
                includeInlayFunctionLikeReturnTypeHints = false,
                includeInlayEnumMemberValueHints = false,
              }
            end
            
            -- Call any previous server-specific setup, but always
            -- return false/nil so LazyVim still configures the server.
            if prev then
              prev(server_name, server_opts)
            end
            return false
          end
        end
      })
      
      return opts
    end,
  },
  
  -- Also configure nvim-cmp to not show inlay hints
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.experimental = opts.experimental or {}
      opts.experimental.ghost_text = false
      return opts
    end,
  },
}