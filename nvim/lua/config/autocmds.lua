-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
-- Watch the Caelestia theme file for changes
local theme_file = vim.fn.expand("~/.local/state/caelestia/theme/colors.lua")

local w = vim.uv.new_fs_event()
if w then
  w:start(
    theme_file,
    {},
    vim.schedule_wrap(function()
      local status, theme = pcall(dofile, theme_file)
      if status and theme then
        vim.opt.background = theme.mode
        require("mini.base16").setup({ palette = theme.palette })
      end
    end)
  )
end
