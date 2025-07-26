return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("mason-lspconfig").setup({
          ensure_installed = { "pyright", "lua_ls" },
          automatic_enable = true,
        })

        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local server_settings = {
          pyright = require("mylsp.pyright"),
          lua_ls = require("mylsp.lua_ls"),
        }

        vim.lsp.config('*', {
          capabilities = capabilities,
          on_attach = require("mylsp.common").on_attach,
        })

        for server, cfg in pairs(server_settings) do
          vim.lsp.config(server, cfg)
        end
    end
  },
}
