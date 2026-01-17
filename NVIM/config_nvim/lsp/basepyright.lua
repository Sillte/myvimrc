-- lsp/basepyright.lua
return {
  settings = {
    python = {
      analysis = {
        -- 型チェックの厳格さ: "off", "basic", "strict" から選択
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace", -- 開いていないファイルの診断も行うか
        -- 特定の警告を無視したい場合などはここに追加
        diagnosticSeverityOverrides = {
          -- 例: 推論が不十分な場合の警告を抑える
        },
      },
    },
  },
}
