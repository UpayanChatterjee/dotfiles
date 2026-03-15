return {
  {
    "nvim-mini/mini.nvim",
    version = false,
    config = function()
      local palette_path = vim.fn.expand("~/.local/state/caelestia/theme/colors.lua")
      local status, theme = pcall(dofile, palette_path)

      if status and theme then
        -- Load raw JSON for extra Material 3 keys
        local json_path = vim.fn.expand("~/.local/state/caelestia/scheme.json")
        local f = io.open(json_path, "r")
        local json = f and vim.fn.json_decode(f:read("*a"))
        if f then f:close() end

        vim.opt.background = theme.mode

        -- Custom Base16 mapping for higher detail
        local base16_palette = {
          base00 = theme.palette.bg0,
          base01 = theme.palette.bg1,
          base02 = theme.palette.bg2,
          base03 = theme.palette.fg3, -- Comments
          base04 = theme.palette.fg2,
          base05 = theme.palette.fg0, -- Main Text
          base06 = theme.palette.fg1,
          base07 = theme.palette.fg0,
          base08 = theme.palette.red,
          base09 = theme.palette.orange,
          base0A = theme.palette.yellow,
          base0B = theme.palette.green,
          base0C = theme.palette.aqua,
          base0D = theme.palette.blue,
          base0E = theme.palette.purple,
          base0F = theme.palette.faded_red,
        }

        require("mini.base16").setup({
          palette = base16_palette,
          use_terminal = false,
        })

        -- EXTRA REFINEMENT: Direct overrides for that "comprehensive" feel
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = theme.palette.bg1 })
        vim.api.nvim_set_hl(0, "FloatBorder", { fg = theme.palette.blue, bg = theme.palette.bg1 })
        vim.api.nvim_set_hl(0, "CursorLine", { bg = theme.palette.bg1 })
        vim.api.nvim_set_hl(0, "LineNr", { fg = theme.palette.fg3 })
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = theme.palette.yellow, bold = true })
        
        -- High-visibility selection using Material 3 container pair
        local selection_bg = "#" .. json.colours.primaryContainer
        local selection_fg = "#" .. json.colours.onPrimaryContainer
        vim.api.nvim_set_hl(0, "Visual", { bg = selection_bg, fg = selection_fg })
      end
    end,
  },
}
