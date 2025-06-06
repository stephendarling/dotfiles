-- In your plugins/toggleterm.lua file (or wherever you configure it)
return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      winbar = {
        enabled = false,
      },
      start_in_insert = true,
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
        return 20
      end,
      -- Your existing options like size, highlights, etc. go here
      highlights = {
        Normal = { link = "Normal" },
        NormalFloat = { link = "Normal" },
        FloatBorder = { link = "FloatBorder" },
      },

      -- This is the new section to add
      on_open = function(term)
        -- Use vim.keymap.set for modern keymapping
        local keymap_opts = { buffer = term.bufnr, noremap = true, silent = true }

        -- Exit terminal mode with Esc or jk
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], keymap_opts)
        vim.keymap.set("t", "jk", [[<C-\><C-n>]], keymap_opts)

        -- Navigate between windows from terminal mode
        vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-W>h]], keymap_opts)
        vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-W>j]], keymap_opts)
        vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-W>k]], keymap_opts)
        vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-W>l]], keymap_opts)
      end,
    },
    -- Your keys table for opening the terminals remains the same
    keys = {
      {
        "<leader>tf",
        "<cmd>ToggleTerm direction=float<cr>",
        desc = "ToggleTerm Float",
      },
      {
        "<leader>tv",
        "<cmd>ToggleTerm direction=vertical<cr>",
        desc = "ToggleTerm Vertical",
      },
      {
        "<leader>th",
        "<cmd>ToggleTerm direction=horizontal<cr>",
        desc = "ToggleTerm Horizontal",
      },
      {
        "<leader>tt",
        "<cmd>ToggleTerm<cr>",
        desc = "Toggle",
      },
    },
  },
}
