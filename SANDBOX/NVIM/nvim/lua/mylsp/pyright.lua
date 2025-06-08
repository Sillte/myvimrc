local M = {}

local default_settings = {
    python = {
        analysis = {
            typeCheckingMode = "basic",
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            },
    },
}

local current_settings = default_settings
function M.set_settings(new_setting)
    current_settings = new_setting
end

function M.get_settings()
    return current_settings
end

local common = require("mylsp.common")

M.setup = function(lspconfig)
lspconfig.pyright.setup({
    on_attach = common.on_attach, 
    capabilities = common.capabilities, 
    settings=M.get_settings(), 
})
end

return M
