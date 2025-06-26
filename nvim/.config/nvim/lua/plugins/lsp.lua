return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "goimports",
        "gofumpt",
        "terraform-ls",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = false,
                compositeLiteralFields = false,
                compositeLiteralTypes = false,
                constantValues = false,
                functionTypeParameters = false,
                parameterNames = false,
                rangeVariableTypes = false,
              },
              analyses = {
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          },
        },
      },
      setup = {
        gopls = function(_, opts)
          -- workaround for gopls not supporting semanticTokensProvider
          -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
          LazyVim.lsp.on_attach(function(client, _)
            if not client.server_capabilities.semanticTokensProvider then
              local semantic = client.config.capabilities.textDocument.semanticTokens
              client.server_capabilities.semanticTokensProvider = {
                full = true,
                legend = {
                  tokenTypes = semantic.tokenTypes,
                  tokenModifiers = semantic.tokenModifiers,
                },
                range = true,
              }
            end
          end, "gopls")
          -- end workaround
        end,
      },
    },
  },
  {
    "stevearc/conform.nvim",
    lazy = false, -- or load it on demand with a filetype or command
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      -- Map filetypes to formatters
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "goimports", "gofumpt" },
        -- Terraform and HCL
        terraform = { "terraform_fmt" },
        hcl = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
      },
      -- Set up format on save
      format_on_save = {
        lsp_fallback = true,
        async = false, -- Set to true if you don't mind a brief visual flicker
        timeout_ms = 500,
      },
      -- You can also add specific formatter configurations here if needed
      -- formatters = {
      --   terraform_fmt = {
      --     command = "terraform",
      --     args = { "fmt", "-" },
      --     -- If terraform fmt is not in your PATH, you might need to specify the path:
      --     -- path = "/usr/local/bin/terraform",
      --   },
      -- },
    },
  },
}
