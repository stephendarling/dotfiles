-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({ "n", "x" }, "<C-u>", "<C-u>zz", { desc = "Scroll Half Page Up (Centered)" })
vim.keymap.set({ "n", "x" }, "<C-d>", "<C-d>zz", { desc = "Scroll Half Page Down (Centered)" })
vim.api.nvim_set_keymap("n", "<leader>gd", ":DiffviewOpen origin/main...HEAD --imply-local<cr>", {
  noremap = true,
  silent = true,
  desc = "Diffview (origin/main...head) + local",
})

-- Create an autogroup for your diffview mappings to keep them organized and clear on reload
local diffview_augroup = vim.api.nvim_create_augroup("DiffviewKeymaps", { clear = true })

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = diffview_augroup, -- Assign to the autogroup
  pattern = "*", -- Trigger for any buffer
  callback = function()
    -- Get the filetype of the current buffer
    local filetype = vim.bo.filetype

    -- Check if the filetype is one of Diffview's known types
    -- Use the exact filetype you found: "DiffviewFiles"
    if filetype == "diffview" or filetype == "DiffviewFiles" then -- Assuming 'diffview' for the main pane still, and 'DiffviewFiles' for the file panel
      -- Set buffer-local mapping for 'q' to close Diffview
      vim.api.nvim_set_keymap("n", "q", ":DiffviewClose<CR>", {
        noremap = true,
        silent = true,
        desc = "Close Diffview",
      })

      -- You can add other buffer-local mappings here too for consistency within Diffview
      -- For example, to toggle the file panel with 'L' only in Diffview
      vim.api.nvim_set_keymap("n", "L", ":DiffviewToggleFiles<CR>", {
        noremap = true,
        silent = true,
        desc = "Toggle Diffview Files Panel",
      })
      -- Add more Diffview internal keymaps if you like (e.g., [c, ]c for hunks)
    end
  end,
})
