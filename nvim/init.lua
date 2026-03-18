-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- Ensure termguicolors is enabled if not already
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.g.python3_host_prog = vim.fn.expand("/home/tony/.conda/envs/nvim/bin/python3")

require("nvim-highlight-colors").setup({})
