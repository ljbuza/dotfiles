local manager = require("config.colorscheme_manager")

return {
  {
    "ribru17/bamboo.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("bamboo").setup({})
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({})
    end,
  },
  {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nordic").setup({})
    end,
  },
  {
    "neanias/everforest-nvim",
    name = "everforest",
    version = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("everforest").setup({})
    end,
  },
  {
    "everviolet/nvim",
    name = "evergarden",
    priority = 1000,
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
  { "EdenEast/nightfox.nvim" }, -- duskfox terafox nordfox
  -- { "ellisonleao/gruvbox.nvim" },
  {
    "LazyVim/LazyVim",
    opts = function()
      -- Initialize colorscheme manager to save user selections
      manager.setup()
      
      -- Get saved preference or use default
      local saved_scheme = manager.load_preference()
      local colorscheme = saved_scheme or "nightfox" -- Default if no preference is saved
      
      return {
        colorscheme = colorscheme,
      }
    end,
  },
}
