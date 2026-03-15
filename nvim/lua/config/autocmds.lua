-- Autocmds are automatically loaded on the VeryLazy event
-- Watch the Caelestia theme file for changes
local theme_file = vim.fn.expand("~/.local/state/caelestia/theme/colors.lua")

local function apply_theme()
  -- Using pcall to avoid errors if the theme isn't ready
  pcall(vim.cmd, "colorscheme caelestia")
end

-- Watch for changes
local w = vim.uv.new_fs_event()
if w then
  w:start(
    theme_file,
    {},
    vim.schedule_wrap(function()
      apply_theme()
    end)
  )
end

-- Force initial application after a tiny delay to ensure plugins are loaded
vim.defer_fn(apply_theme, 50)
