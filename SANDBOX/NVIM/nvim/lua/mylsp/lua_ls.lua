local M = {}

local default_settings = {
  Lua = {
    runtime = {
      version = "LuaJIT", -- Neovim内部Luaに合わせる
      path = vim.split(package.path, ";"),
    },
    diagnostics = {
      globals = { "vim" }, -- `vim` を未定義エラーにしない
    },
    workspace = {
      library = vim.api.nvim_get_runtime_file("", true),
      checkThirdParty = false, -- 外部ライブラリチェックしない
    },
    telemetry = {
      enable = false,
    },
  }
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
lspconfig.lua_ls.setup({
    on_attach = common.on_attach, 
    capabilities = common.capabilities, 
    settings=M.get_settings(), 
})
end

return M

