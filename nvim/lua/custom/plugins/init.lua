-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

return {
  { 'nvim-tree/nvim-web-devicons', lazy = true },
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup { '*', css = { rgb_fn = true } }
    end,
  },
  {
    'craftzdog/solarized-osaka.nvim',
    name = 'solarized-osaka',
    lazy = false,
    priority = 1000,
    opts = {},
  },
  { 'rose-pine/neovim', name = 'rose-pine', lazy = false, priority = 1000, opts = {} },
  {
    'rebelot/kanagawa.nvim',
    name = 'kanagawa',
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    'sho-87/kanagawa-paper.nvim',
    name = 'kanagawa-paper',
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    opts = {},
  },
  --   vim.cmd [[
  --   highlight Normal guibg=none
  --   highlight NonText guibg=none
  --   highlight Normal ctermbg=none
  --   highlight NonText ctermbg=none
  -- ]],
  -- {
  --   'sainnhe/gruvbox-material',
  --   name = 'gruvbox-material',
  --   lazy = false,
  --   priority = 1000,
  --   opts = {},
  -- },
}
