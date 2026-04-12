return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                -- Ignore E501 in the linter
                pycodestyle = {
                  ignore = { "E501" },
                  maxLineLength = 150, -- Increase if you still want a limit
                },
                -- Stop the formatter from aggressively breaking lines
                autopep8 = {
                  ignore = { "E501" },
                  max_line_length = 150,
                },
                -- Also ignore in flake8 if you happen to have it enabled
                flake8 = {
                  ignore = { "E501" },
                  maxLineLength = 150,
                },
              },
            },
          },
        },
      },
    },
  },
}
