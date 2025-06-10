
vscode = require("vscode")

-- Window control
vim.keymap.set("n", "<C-w>h", "<C-w>h")
vim.keymap.set("n", "<C-w><C-h>", "<C-w>h")

vim.keymap.set("n", "<C-w>l", "<C-w>l")
vim.keymap.set("n", "<C-w><C-l>", "<C-w>l")

vim.keymap.set("n", "<C-w>j", "<C-w>j")
vim.keymap.set("n", "<C-w><C-j>", "<C-w>j")

vim.keymap.set("n", "<C-w>k", "<C-w>k")
vim.keymap.set("n", "<C-w><C-k>", "<C-w>k")


-- Diagnostics
vim.keymap.set("n", "[g", function() vscode.call("editor.action.marker.prev") end)
vim.keymap.set("n", "]g", function() vscode.call("editor.action.marker.next") end)

-- :QQ  is also command.
vim.keymap.set("n", "[q",  "<cmd>Qprev<CR>")
vim.keymap.set("n", "]q",  "<cmd>Qnext<CR>")

vim.keymap.set("n", "[c",  "<cmd>Qprev<CR>")
vim.keymap.set("n", "]c",  "<cmd>Qnext<CR>")


-- Why does this not work...?
vim.keymap.set("i", "<C-n>", function() vscode.call("editor.action.triggerSuggest") end)

vim.keymap.set("i", "<C-n>", function() vscode.call("editor.action.triggerSuggest") end)
-- Refactor functions and actions provided by LSP.
vim.keymap.set("n", "<leader>rn", function()
  vscode.call("editor.action.rename")
end)


vim.keymap.set("n", "<leader>x", function()
  vscode.call("editor.action.quickFix")
end)

