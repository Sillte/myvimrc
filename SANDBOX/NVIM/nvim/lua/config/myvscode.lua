vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("", "<F2>", ":edit $MYVIMRC<CR>")
vim.keymap.set("i", "<ESC>", "<ESC>:set iminsert=0<CR>", {noremap=true})
vim.opt.clipboard = "unnamedplus"



