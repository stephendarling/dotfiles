return {
  "ibhagwan/fzf-lua",
  config = function()
    local actions = require("fzf-lua").actions

    -- Sessions/directories where hidden files should be shown
    local show_hidden_names = { "dotfiles", "personal" }

    local tmux_session = vim.fn.system("tmux display-message -p '#S' 2>/dev/null"):gsub("%s+", "")
    local cwd_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

    local show_hidden = vim.tbl_contains(show_hidden_names, tmux_session)
      or vim.tbl_contains(show_hidden_names, cwd_name)

    require("fzf-lua").setup({
      files = {
        hidden = show_hidden,
      },
      actions = {
        files = {
          ["enter"] = actions.file_edit_or_qf,
          ["ctrl-i"] = actions.toggle_ignore,
          ["ctrl-h"] = actions.toggle_hidden,
        },
      },
    })
  end,
}
