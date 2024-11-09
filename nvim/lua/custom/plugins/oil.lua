return {
  'stevearc/oil.nvim',
  lazy = false,
  opts = {},
  dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if prefer nvim-web-devicons
  config = function()
    local oil = require 'oil'
    require('oil').setup {
      columns = {
        'icon',
      },
      default_file_explorer = true,
      vim.keymap.set('n', '-', function()
        oil.open()

        -- Wait until oil has opened, for a maximum of 1 second.
        vim.wait(1000, function()
          return oil.get_cursor_entry() ~= nil
        end)
        if oil.get_cursor_entry() then
          oil.open_preview()
        end
      end),
      keymaps = {
        ['g?'] = 'actions.show_help',
        ['<CR>'] = 'actions.select',
        ['<C-s>'] = { 'actions.select', opts = { vertical = true }, desc = 'Open the entry in a vertical split' },
        ['<C-h>'] = { 'actions.select', opts = { horizontal = true }, desc = 'Open the entry in a horizontal split' },
        ['<C-t>'] = { 'actions.select', opts = { tab = true }, desc = 'Open the entry in new tab' },
        ['<C-p>'] = { 'actions.preview', opts = {}, desc = 'Preview the entry' },
        ['<C-c>'] = 'actions.close',
        ['<C-l>'] = 'actions.refresh',
        ['-'] = { 'actions.parent', opts = {}, desc = 'Go to parent directory' },
        ['_'] = 'actions.open_cwd',
        ['`'] = 'actions.cd',
        ['~'] = { 'actions.cd', opts = { scope = 'tab' }, desc = ':tcd to the current oil directory' },
        ['gs'] = 'actions.change_sort',
        ['gx'] = 'actions.open_external',
        ['g.'] = 'actions.toggle_hidden',
        ['g\\'] = 'actions.toggle_trash',
      },
    }
  end,
  -- Optional dependencies
  -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
}
