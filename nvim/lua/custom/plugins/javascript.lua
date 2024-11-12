return {
  -- correctly setup lspconfig
  {
    'neovim/nvim-lspconfig',
    opts = {
      -- make sure mason installs the server
      servers = {
        --- @deprecated -- tsserver renamed to ts_ls but not yet released, so keep this for now
        --- the proper approach is to check the nvim-lspconfig release version when it's released to determine the server name dynamically
        tsserver = {
          enabled = false,
        },
        ts_ls = {
          enabled = false,
        },
        vtsls = {
          -- explicitly add default filetypes, so that we can extend
          -- them in related extras
          filetypes = {
            'javascript',
            'javascriptreact',
            'javascript.jsx',
            'typescript',
            'typescriptreact',
            'typescript.tsx',
          },
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = 'always' },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = 'literals' },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
          -- keys = {
          --   {
          --     'gD',
          --     function()
          --       local params = vim.lsp.util.make_position_params()
          --       LazyVim.lsp.execute {
          --         command = 'typescript.goToSourceDefinition',
          --         arguments = { params.textDocument.uri, params.position },
          --         open = true,
          --       }
          --     end,
          --     desc = 'Goto Source Definition',
          --   },
          --   {
          --     'gR',
          --     function()
          --       LazyVim.lsp.execute {
          --         command = 'typescript.findAllFileReferences',
          --         arguments = { vim.uri_from_bufnr(0) },
          --         open = true,
          --       }
          --     end,
          --     desc = 'File References',
          --   },
          --   {
          --     '<leader>co',
          --     LazyVim.lsp.action['source.organizeImports'],
          --     desc = 'Organize Imports',
          --   },
          --   {
          --     '<leader>cM',
          --     LazyVim.lsp.action['source.addMissingImports.ts'],
          --     desc = 'Add missing imports',
          --   },
          --   {
          --     '<leader>cu',
          --     LazyVim.lsp.action['source.removeUnused.ts'],
          --     desc = 'Remove unused imports',
          --   },
          --   {
          --     '<leader>cD',
          --     LazyVim.lsp.action['source.fixAll.ts'],
          --     desc = 'Fix all diagnostics',
          --   },
          --   {
          --     '<leader>cV',
          --     function()
          --       LazyVim.lsp.execute { command = 'typescript.selectTypeScriptVersion' }
          --     end,
          --     desc = 'Select TS workspace version',
          --   },
          -- },
        },
      },
      setup = {
        --- @deprecated -- tsserver renamed to ts_ls but not yet released, so keep this for now
        --- the proper approach is to check the nvim-lspconfig release version when it's released to determine the server name dynamically
        tsserver = function()
          -- disable tsserver
          return true
        end,
        ts_ls = function()
          -- disable tsserver
          return true
        end,
      },
    },
  },

  {
    'mfussenegger/nvim-dap',
    optional = true,
    dependencies = {
      {
        'williamboman/mason.nvim',
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          table.insert(opts.ensure_installed, 'js-debug-adapter')
        end,
      },
    },
    opts = function()
      local dap = require 'dap'
      if not dap.adapters['pwa-node'] then
        require('dap').adapters['pwa-node'] = {
          type = 'server',
          host = 'localhost',
          port = '${port}',
          executable = {
            command = 'node',
            args = {},
          },
        }
      end
      if not dap.adapters['node'] then
        dap.adapters['node'] = function(cb, config)
          if config.type == 'node' then
            config.type = 'pwa-node'
          end
          local nativeAdapter = dap.adapters['pwa-node']
          if type(nativeAdapter) == 'function' then
            nativeAdapter(cb, config)
          else
            cb(nativeAdapter)
          end
        end
      end

      local js_filetypes = { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }

      local vscode = require 'dap.ext.vscode'
      vscode.type_to_filetypes['node'] = js_filetypes
      vscode.type_to_filetypes['pwa-node'] = js_filetypes

      for _, language in ipairs(js_filetypes) do
        if not dap.configurations[language] then
          dap.configurations[language] = {
            {
              type = 'pwa-node',
              request = 'launch',
              name = 'Launch file',
              program = '${file}',
              cwd = '${workspaceFolder}',
            },
            {
              type = 'pwa-node',
              request = 'attach',
              name = 'Attach',
              processId = require('dap.utils').pick_process,
              cwd = '${workspaceFolder}',
            },
          }
        end
      end
    end,
  },

  -- Filetype icons
  {
    'echasnovski/mini.icons',
    opts = {
      file = {
        ['.eslintrc.js'] = { glyph = '󰱺', hl = 'MiniIconsYellow' },
        ['.node-version'] = { glyph = '', hl = 'MiniIconsGreen' },
        ['.prettierrc'] = { glyph = '', hl = 'MiniIconsPurple' },
        ['.yarnrc.yml'] = { glyph = '', hl = 'MiniIconsBlue' },
        ['eslint.config.js'] = { glyph = '󰱺', hl = 'MiniIconsYellow' },
        ['package.json'] = { glyph = '', hl = 'MiniIconsGreen' },
        ['tsconfig.json'] = { glyph = '', hl = 'MiniIconsAzure' },
        ['tsconfig.build.json'] = { glyph = '', hl = 'MiniIconsAzure' },
        ['yarn.lock'] = { glyph = '', hl = 'MiniIconsBlue' },
      },
    },
  },
}
