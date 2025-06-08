local M = {}

function M.setup(lspconfig)
    require("mylsp.pyright").setup(lspconfig)
    require("mylsp.lua_ls").setup(lspconfig)
end

return M
