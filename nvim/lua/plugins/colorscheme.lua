return {
  -- {
  --   "ribru17/bamboo.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("bamboo").setup({})
  --     require("bamboo").load()
  --   end,
  -- },
  -- {
  --   "rebelot/kanagawa.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("kanagawa").setup({})
  --     require("kanagawa").load()
  --   end,
  -- },
  -- {
  --   "AlexvZyl/nordic.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("nordic").setup({})
  --   end,
  -- },
  -- {
  --   "neanias/everforest-nvim",
  --   name = "everforest",
  --   version = false,
  --   lazy = false,
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     require("everforest").setup({})
  --     require("everforest").load()
  --   end,
  -- },
  {
    "everviolet/nvim",
    name = "evergarden",
    --   lazy = false,
    priority = 1000, -- Colorscheme plugin is loaded first before any other plugins
    opts = {
      theme = {
        variant = "fall", -- 'winter'|'fall'|'spring'|'summer'
        accent = "green",
      },
      editor = {
        transparent_background = false,
        sign = { color = "none" },
        float = {
          color = "mantle",
          invert_border = false,
        },
        completion = {
          color = "surface0",
        },
      },
    },
  },
  -- { "ellisonleao/gruvbox.nvim" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "evergarden",
    },
  },
}
