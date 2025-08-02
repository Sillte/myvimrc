local util = require("lspconfig.util")

return {
  root_dir = util.root_pattern("tsconfig.json", "package.json", ".git"),

  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    require("mylsp.common").on_attach(client, bufnr)
  end,

  settings = {}
}
