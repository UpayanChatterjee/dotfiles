return {
  {
    "caelestia-theme",
    dir = vim.fn.stdpath("config") .. "/lua/plugins/caelestia",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme caelestia")

      -- Watch colors.lua for changes and reload the colorscheme live.
      -- Caelestia writes files atomically (rename), so we restart the watcher
      -- after each event since rename-based writes unregister fs_event handles.
      local theme_file = vim.fn.expand("~/.local/state/caelestia/theme/colors.lua")

      local function start_watcher()
        local w = vim.uv.new_fs_event()
        if not w then return end
        w:start(theme_file, {}, function(err, _, _)
          w:stop()
          if not err then
            vim.schedule(function()
              vim.cmd("colorscheme caelestia")
            end)
          end
          vim.defer_fn(start_watcher, 200)
        end)
      end

      start_watcher()
    end,
  },
}
