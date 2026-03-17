return {
  {
    "caelestia-theme",
    dir = vim.fn.stdpath("config") .. "/lua/plugins/caelestia",
    lazy = false,
    priority = 1000,
    config = function()
      -- Automatically load the Caelestia theme
      vim.cmd("colorscheme caelestia")
    end,
  },
}
