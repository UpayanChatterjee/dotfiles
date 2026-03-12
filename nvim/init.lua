-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- Ensure termguicolors is enabled if not already
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

require("nvim-highlight-colors").setup({})
