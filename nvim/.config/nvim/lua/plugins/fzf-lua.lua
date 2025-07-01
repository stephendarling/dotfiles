return {
  "ibhagwan/fzf-lua",
  config = function()
    local actions = require("fzf-lua").actions
    require("fzf-lua").setup({
      files = {
        hidden = true,
        ignore = false,
        -- cmd = "rg --files --hidden --glob '!.git/*'",
      },
      oldfiles = {
        cwd_only = true, -- Only show files from current working directory
        prompt = "Recent Files (cwd)> ",
        stat_file = true, -- Verify files still exist
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
