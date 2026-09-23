local vscode = require("vscode")
local opts = { noremap = true, silent = true }

-- Diagnostics
vim.keymap.set("n", "[g", function() vscode.action("editor.action.marker.prev") end, opts)
vim.keymap.set("n", "]g", function() vscode.action("editor.action.marker.next") end, opts)

-- Quickfix navigation
vim.keymap.set("n", "[q", "<cmd>Qprev<CR>", opts)
vim.keymap.set("n", "]q", "<cmd>Qnext<CR>", opts)
vim.keymap.set("n", "[c", "<cmd>Qprev<CR>", opts)
vim.keymap.set("n", "]c", "<cmd>Qnext<CR>", opts)

-- Quickfix from normal and visual modes
vim.keymap.set({ "n", "v" }, "<leader>X", function()
    vscode.action("editor.action.quickFix")
end, opts)

-- Go to definition
vim.keymap.set("n", "gd", function() vscode.action("editor.action.revealDefinition") end, opts)
vim.keymap.set("n", "gD", function() vscode.action("editor.action.revealDeclaration") end, opts)
vim.keymap.set("n", "gr", function() vscode.action("editor.action.referenceSearch.trigger") end, opts)
vim.keymap.set("n", "gy", function() vscode.action("editor.action.goToTypeDefinition") end, opts)
vim.keymap.set("n", "gf", function() vscode.action("editor.action.openLink") end, opts)
vim.keymap.set("n", "<A-r>", function() vscode.action("editor.action.rename") end, opts)
vim.keymap.set("n", "<A-a>", function() vscode.action("editor.action.quickFix") end, opts)
vim.keymap.set("n", "K", function() vscode.action("editor.action.showHover") end, opts)
vim.keymap.set({ "n", "i" }, "<C-k>", function() vscode.action("editor.action.triggerParameterHints") end, opts)
