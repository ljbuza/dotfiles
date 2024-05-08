return {
  'akinsho/git-conflict.nvim',
  version = '*',
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
