-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({ "n", "x" }, "<C-u>", "<C-u>zz", { desc = "Scroll Half Page Up (Centered)" })
vim.keymap.set({ "n", "x" }, "<C-d>", "<C-d>zz", { desc = "Scroll Half Page Down (Centered)" })
