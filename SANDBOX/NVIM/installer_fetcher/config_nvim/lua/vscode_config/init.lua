vscode = require("vscode")

-- Window control
-- See https://github.com/vscode-neovim/vscode-neovim/blob/master/runtime/vscode/overrides/vscode-window-commands.vim
vim.keymap.set("n", "<C-w><C-h>", "<C-w>h", {noremap=true})
vim.keymap.set("n", "<C-w><C-l>", "<C-w>l", {noremap=true})
vim.keymap.set("n", "<C-w><C-k>", "<C-w>k", {noremap=true})
vim.keymap.set("n", "<C-w><C-j>", "<C-w>j", {noremap=true})


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
vim.keymap.set("i", "<C-x>", function() vscode.call("editor.action.triggerSuggest") end)

-- Refactor functions and actions provided by LSP.
vim.keymap.set("n", "<leader>rn", function()
  vscode.call("editor.action.rename")
end)

-- Actions with 
vim.keymap.set({"n", "v"}, "<leader>x", function()
  vscode.call("editor.action.quickFix")
end)

