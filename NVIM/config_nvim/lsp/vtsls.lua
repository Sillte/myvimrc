-- lsp/vtsls.lua
return {
    settings = {
        vtsls = {
            autoUseWorkspaceTsdk = true,
            experimental = {
                completion = { enableServerSideFuzzyMatch = true }
            },
            tsserver = {
                globalPlugins = {
                    {
                        name = "@vue/typescript-plugin",
                        -- get_package関数を使わず、Neovimのデータディレクトリから直接パスを生成
                        location = vim.fn.stdpath("data") ..
                            "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                        languages = { "vue" },
                        configNamespace = "typescript",
                        enableForWorkspaceTypeScriptVersions = true,
                    },
                },
            },
        },
    },
    filetypes = {
        "javascript", "javascriptreact", "javascript.jsx",
        "typescript", "typescriptreact", "typescript.tsx",
        "vue",
    },
}
