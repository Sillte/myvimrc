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
          ensure_installed = { "pyright", "lua_ls", "ts_ls", "eslint"},
          automatic_enable = true,
        })

        local lspconfig = require("lspconfig")
        local mylsp_common = require("mylsp.common")
        local on_attach = mylsp_common.on_attach
        local capabilities = mylsp_common.capabilitijs
        local server_settings = {
          pyright = require("mylsp.pyright"),
          lua_ls = require("mylsp.lua_ls"),
          ts_ls = require("mylsp.ts_ls"),
          eslint = require("mylsp.eslint")
        }

        for server, cfg in pairs(server_settings) do
          lspconfig[server].setup(vim.tbl_deep_extend("force", {
            on_attach = on_attach,
            capabilities = capabilities,
          }, cfg))
        end
    end
  },
}
