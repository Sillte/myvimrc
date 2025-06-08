return {
  {
    "neovim/nvim-lspconfig",
    name = "lspconfig", 
    event = { "BufReadPre", "BufNewFile" }, 
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
  config = function()
    local lspconfig = require("lspconfig")
    require("mylsp").setup(lspconfig)
  end,
  },
}
