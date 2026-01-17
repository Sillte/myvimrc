-- lsp/eslint.lua
return {
    settings = {
        workingDirectories = { mode = "auto" },
    },
    on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
        })
    end,
}
