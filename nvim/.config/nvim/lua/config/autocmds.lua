-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("TermEnter", {
  callback = function(ev)
    -- Map <C-l> in terminal mode to itself, allowing the shell's clear command
    vim.keymap.set("t", "<C-l>", "<C-l>", { buffer = ev.buf, nowait = true, desc = "Clear terminal screen" })
  end,
})
