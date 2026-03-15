-- lazy.nvim
return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      image = {
        enabled = false,
        -- your image configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
      animate = {
        ---@type snacks.animate.Duration|number
        duration = 1, -- ms per step
        easing = "linear",
        fps = 144, -- frames per second. Global setting for all animations
      },
    },
  },
}
