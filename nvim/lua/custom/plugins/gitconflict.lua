return {
  'akinsho/git-conflict.nvim',
  version = '*',
  opts = { vim.keymap.set('n', 'co', '<Plug>(git-conflict-ours)', { desc = 'Resolve [O]urs conflict' }) },
  { vim.keymap.set('n', 'ct', '<Plug>(git-conflict-theirs)', { desc = 'Resolve [T]heirs conflict' }) },
  { vim.keymap.set('n', 'cb', '<Plug>(git-conflict-both)', { desc = 'Resolve [B]oth conflict' }) },
  { vim.keymap.set('n', 'c0', '<Plug>(git-conflict-none)', { desc = 'Resolve [0] conflict' }) },
  { vim.keymap.set('n', ']x', '<Plug>(git-conflict-prev-conflict)', { desc = 'Previous conflict' }) },
  { vim.keymap.set('n', '[x', '<Plug>(git-conflict-next-conflict)', { desc = 'Next conflict' }) },
  config = function()
    require('git-conflict').setup {

      debug = false,
      list_opener = 'vsplit',
      default_mappings = false,
      disable_diagnostics = true,
      highlights = {
        incoming = 'DiffText',
        current = 'DiffAdd',
      },
    }
  end,
}
