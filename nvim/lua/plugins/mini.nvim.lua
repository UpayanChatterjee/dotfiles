return {
  {
    "nvim-mini/mini.nvim",
    version = false,
    config = function()
      local palette_path = vim.fn.expand("~/.local/state/caelestia/theme/colors.lua")
      local status, theme = pcall(dofile, palette_path)

      if status and theme then
        -- Set the background mode (light/dark) automatically
        vim.opt.background = theme.mode

        -- Apply the base16 theme
        require("mini.base16").setup({
          palette = theme.palette,
          use_terminal = false, -- Use our precise hex colors
        })
      end
    end,
  },
}
