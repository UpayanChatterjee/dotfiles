return {
  {
    "gwydion67/unicode.nvim",
    requires = { "folke/snacks.nvim" },
    config = function()
      require("unicode").setup()
    end,
  },
}
