-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local opts = { noremap = true, silent = true }
local keymap = LazyVim.safe_keymap_set
local wk = require("which-key")

local function entity_close()
  local ok, _ = pcall(vim.cmd.close)
  if not ok then
    Snacks.bufdelete()
  end
end

local function Toggle_venn()
  local venn_enabled = vim.inspect(vim.b.venn_enabled)
  if venn_enabled == "nil" then
    vim.b.venn_enabled = true
    vim.cmd([[setlocal ve=all]])
    -- draw a line on arrow key presses
    vim.api.nvim_buf_set_keymap(0, "n", "<Down>", "<C-v>j:VBox<CR>", { silent = true, noremap = true })
    vim.api.nvim_buf_set_keymap(0, "n", "<Up>", "<C-v>k:VBox<CR>", { silent = true, noremap = true })
    vim.api.nvim_buf_set_keymap(0, "n", "<Right>", "<C-v>l:VBox<CR>", { silent = true, noremap = true })
    vim.api.nvim_buf_set_keymap(0, "n", "<Left>", "<C-v>h:VBox<CR>", { silent = true, noremap = true })
  else
    vim.cmd([[setlocal ve=]])
    vim.api.nvim_buf_del_keymap(0, "n", "<Down>")
    vim.api.nvim_buf_del_keymap(0, "n", "<Up>")
    vim.api.nvim_buf_del_keymap(0, "n", "<Right>")
    vim.api.nvim_buf_del_keymap(0, "n", "<Left>")
    vim.b.venn_enabled = nil
  end
end

-- normal mode
-- keymap("i", "kj", "<Esc>", opts)
-- keymap("i", "jk", "<Esc>", opts)
-- save
keymap("n", "ss", "<cmd>w<CR>", opts)
-- Dismiss Notifications
keymap("n", "<Esc>", "<Esc><cmd>NoiceDismiss<CR>", { desc = "Dismiss Noice Message" })
-- toggle comment
keymap({ "n", "v" }, "<Leader>/", "<cmd>normal gcc<cr>", { desc = "Toggle Comment" })
-- close all
keymap("n", "<C-x>", entity_close, opts)

keymap({ "n", "i" }, "<Esc>", function()
  -- local MiniSnippets = require("mini.snippets")
  -- if MiniSnippets.session then
  --   MiniSnippets.session.stop()
  -- end
  vim.cmd.NoiceDismiss()
  vim.cmd.noh()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end, { desc = "Dismiss Noice Message, Remove Highlights & Stop Snippet" })
vim.keymap.del("n", "<leader>l")
------

wk.add({
  -- formatting and LSP diagnostics
  { "<leader>l", group = "LSP Actions", icon = "" },
  {
    "<leader>lf",
    function()
      LazyVim.format({ force = true })
      -- local filename = vim.api.nvim_buf_get_name(0)
      -- if filename:match("%.jsx?$") or filename:match("%.tsx?$") then
      --   vim.cmd('!rustywind --config-file "/home/Abhishek/.config/rustywind/config.json" --write ' .. filename)
      -- end
    end,
    desc = "Format",
  },
  {
    "<leader>lj",
    function()
      vim.diagnostic.jump({ count = 1, float = true })
    end,
    desc = "Go to next diagnostic",
  },
  {
    "<leader>lk",
    function()
      vim.diagnostic.jump({ count = -1, float = true })
    end,
    desc = "Go to previous diagnostic",
  },
  { "<leader>lv", vim.diagnostic.open_float, desc = "View Current Line Diagnostic" },
  ---┌────┐
  ---│Venn│
  ---└────┘
  {
    "<Enter>",
    function()
      if vim.b.venn_enabled == true then
        vim.api.nvim_feedkeys(":VBox\r", "n", false)
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Enter>", true, false, true), "n", false)
      end
    end,
    mode = { "v" },
    desc = "add Box (venn mode only)",
    opts,
  },
  {
    "<leader>uV",
    Toggle_venn,
    mode = "n",
    desc = "toggle venn mode",
  },
})
