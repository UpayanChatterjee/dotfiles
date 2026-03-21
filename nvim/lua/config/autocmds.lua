-- Autocmds are automatically loaded on the VeryLazy event
-- Watch the Caelestia theme file for changes
local theme_dir = vim.fn.expand("~/.local/state/caelestia/theme")
local theme_file = "colors.lua"

local function apply_theme()
  -- Using pcall to avoid errors if the theme isn't ready
  -- pcall(vim.cmd, "colorscheme caelestia")
  pcall(vim.cmd, "colorscheme everforest")
end

-- Watch for changes (persistent handle to avoid GC)
-- _G.caelestia_watcher = _G.caelestia_watcher or (vim.uv or vim.loop).new_fs_event()
-- if _G.caelestia_watcher then
--   _G.caelestia_watcher:stop() -- Stop existing watcher if reloading
--   _G.caelestia_watcher:start(
--     theme_dir,
--     {},
--     vim.schedule_wrap(function(err, filename)
--       if filename == theme_file then
--         apply_theme()
--       end
--     end)
--   )
-- end

-- Force initial application after a tiny delay to ensure plugins are loaded
vim.defer_fn(apply_theme, 50)
