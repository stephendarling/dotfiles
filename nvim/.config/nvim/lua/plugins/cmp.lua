return {
  {
    "Saghen/blink.cmp",
    opts = function(_, opts)
      opts.completion = opts.completion or {}
      opts.completion.list = opts.completion.list or {}
      opts.completion.list.max_items = 4 -- Set to your desired number of suggestions

      return opts
    end,
  },
}
