return {
  "ibhagwan/fzf-lua",
  config = function()
    local actions = require("fzf-lua").actions

    require("fzf-lua").setup({
      files = {
        hidden = false,
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
