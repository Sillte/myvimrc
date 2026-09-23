local M = {}

function M.setup(plugin_namespace)
    if vim.g.mapleader == nil then
        vim.g.mapleader = "\\"
    end

    if vim.g.maplocalleader == nil then
        vim.g.maplocalleader = "\\"
    end

    require("lazy").setup({
        spec = {
            { import = plugin_namespace },
        },
        install = { colorscheme = { "habamax" } },
        checker = { enabled = true },
    })
end

return M