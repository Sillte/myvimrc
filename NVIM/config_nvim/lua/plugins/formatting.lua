return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "ruff_format", "ruff_organize_imports" },
            typescript = function(bufnr)
                -- DenoプロジェクトかNode.jsプロジェクトかを判別
                if vim.fs.root(bufnr, { "deno.json", "deno.jsonc" }) then
                    return { "deno_fmt" }
                end
                return { "prettierd", "prettier", stop_after_first = true }
            end,
        },
        format_on_save = {
            timeout_ms = 500,
            lsp_fallback = true,
        },
    },
}
