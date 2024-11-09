-- return {
--   'kevinhwang91/nvim-ufo',
--   dependencies = 'kevinhwang91/promise-async',
--   config = function()
--     require('ufo').setup()
--   end,
--   init = function()
--     vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
--     vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
--   end,
--   opts = {
--     foldcolumn = '1', -- '0' is not bad
--     foldlevel = 99, -- Using ufo provider need a large value, feel free to decrease the value
--     foldlevelstart = 99,
--     foldenable = true,
--   },
-- }
local M = {
  'kevinhwang91/nvim-ufo',
  dependencies = { 'kevinhwang91/promise-async' },
  opts = {
    filetype_exclude = { 'help', 'alpha', 'dashboard', 'neo-tree', 'Trouble', 'lazy', 'mason' },
  },
  config = function(_, opts)
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('local_detach_ufo', { clear = true }),
      pattern = opts.filetype_exclude,
      callback = function()
        require('ufo').detach()
      end,
    })

    vim.opt.foldlevelstart = 99
    require('ufo').setup(opts)
  end,
}

return M
