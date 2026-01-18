-- lua/plugins/lsp.lua
return {
    {
        "folke/neoconf.nvim",
        priority = 100,
        opts = {
            local_settings = ".neoconf.json",
            global_settings = "neoconf.json",
            import = {
                vscode = true,
            },
            live_reload = true,
            filetype_jsonc = true,
            plugins = {
                lspconfig = { enabled = true },
                jsonls = { enabled = true, configured_servers_only = true },
                lua_ls = { enabled_for_neovim_config = true, enabled = false },
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "folke/neoconf.nvim" },
            { "williamboman/mason.nvim", opts = {} },
            {
                "williamboman/mason-lspconfig.nvim",
                opts = {
                    automatic_enable = true,
                    ensure_installed = {
                        "pyright", "ruff",
                        "lua_ls",
                        "vtsls", "eslint", "vue_ls",
                        "marksman",
                    },
                }
            },
            {
                'saghen/blink.cmp',
                version = '*',
                opts = {
                    keymap = { preset = 'default' },
                    sources = {
                        default = { 'lsp', 'path', 'snippets', 'buffer' },
                    },
                },
            },
        },
        config = function()
            vim.diagnostic.config({
                float = { border = "rounded", focusable = false },
                virtual_text = true, -- 行末にエラーを表示
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local bufnr = args.buf
                    local opts = { noremap = true, silent = true, buffer = bufnr }

                    -- 基本操作
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    vim.keymap.set({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help, opts)
                    vim.keymap.set('n', '<A-r>', vim.lsp.buf.rename, opts)
                    vim.keymap.set("n", "<A-a>", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "]g", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
                    vim.keymap.set("n", "[g", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)

                    vim.keymap.set("n", "<A-f>", function()
                        vim.lsp.buf.format({ async = true })
                    end, opts)
                    vim.keymap.set('n', '<F10>', function()
                        vim.diagnostic.enable(not vim.diagnostic.is_enabled())
                    end, opts)
                end,
            })
            local lspconfig = require('lspconfig')
            local capabilities = require('blink.cmp').get_lsp_capabilities()

            lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, {
                capabilities = capabilities,
            })
        end,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- Luaファイルを開いた時だけロード
        opts = {
            library = {
                -- Neovimのプラグインの型定義を読み込む
                { path = "${3rd}/luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    }
}
