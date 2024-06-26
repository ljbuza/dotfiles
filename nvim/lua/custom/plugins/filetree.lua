vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('neo-tree').setup {
      close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
      popup_border_style = 'rounded',
      enable_git_status = true,
      use_libuv_file_watcher = true,
      view = {
        adaptive_size = true,
      },
    }
  end,
  -- opts = {
  --   window = {
  --     width = 30,
  --     mappings = {
  --       ['<space>'] = false, -- disable space until we figure out which-key disabling
  --       ['[b'] = 'prev_source',
  --       [']b'] = 'next_source',
  --       O = 'system_open',
  --       Y = 'copy_selector',
  --       h = 'parent_or_close',
  --       l = 'child_or_open',
  --       o = 'open',
  --     },
  --     fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
  --       ['<C-j>'] = 'move_cursor_down',
  --       ['<C-k>'] = 'move_cursor_up',
  --     },
  --   },
  -- },
}
