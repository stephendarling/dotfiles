return {
  "stevearc/oil.nvim",
  config = true,
  keys = {
    { "-", "<CMD>Oil<CR>", mode = "n" },
  },
  opts = {
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ["<C-s>"] = false,
    },
  },
}
