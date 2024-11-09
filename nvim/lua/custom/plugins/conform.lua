return {
  'stevearc/conform.nvim',
  opts = {},
  enabled = true,
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local conform = require 'conform'

    conform.setup {
      formatters_by_ft = {
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescriptreact = { 'prettier' },
        svelte = { 'prettier' },
        css = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },
        yaml = { 'prettier' },
        -- markdown = { 'prettier' },
        graphql = { 'prettier' },
        lua = { 'stylua' },
        python = { 'ruff_organize_imports', 'ruff', 'ruff_format' },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    }
    -- setup = function()
    --   require('conform').setup {
    --     formatters_by_ft = {
    --       python = { 'ruff_organize_imports' },
    --     },
    --     formatters = {
    --       ruff_organize_imports = {
    --         command = 'ruff',
    --         args = {
    --           'check',
    --           '--format',
    --           '--force-exclude',
    --           '--select=I001',
    --           '--fix',
    --           '--exit-zero',
    --           '--stdin-filename',
    --           '$FILENAME',
    --           '-',
    --         },
    --         stdin = true,
    --         cwd = require('conform.util').root_file {
    --           'pyproject.toml',
    --           'ruff.toml',
    --           '.ruff.toml',
    --         },
    --       },
    -- },
    -- }
  end,
}
