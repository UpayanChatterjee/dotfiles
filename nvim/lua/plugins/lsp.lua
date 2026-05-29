return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                -- Force lua_ls to recognize 'hl' as a valid global
                globals = { "hl" },
              },
            },
          },
        },
      },
    },
  },
}
