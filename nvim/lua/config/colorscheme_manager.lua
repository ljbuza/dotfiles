local M = {}

-- Path to store the colorscheme preference
local pref_file = vim.fn.stdpath("data") .. "/colorscheme_preference"

-- Save the current colorscheme to a file
function M.save_preference(colorscheme)
  local file = io.open(pref_file, "w")
  if file then
    file:write(colorscheme)
    file:close()
  end
end

-- Load the saved colorscheme preference
function M.load_preference()
  local file = io.open(pref_file, "r")
  if file then
    local colorscheme = file:read("*all")
    file:close()
    return colorscheme
  end
  return nil
end

-- Hook into LazyVim's colorscheme switching
function M.setup()
  -- Hook into LazyVim's colorscheme changes
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      local current = vim.g.colors_name
      if current then
        M.save_preference(current)
      end
    end,
  })
end

return M