return {
    settings = {
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
}


