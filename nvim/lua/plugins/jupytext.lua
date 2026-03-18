return {
  "GCBallesteros/jupytext.nvim",
  config = function()
    -- This tells Jupytext to open notebooks as Markdown files
    -- which provides the best layout for Molten's outputs
    require("jupytext").setup({
      style = "markdown",
      output_extension = "md",
      force_ft = "markdown",
    })
  end,
}
