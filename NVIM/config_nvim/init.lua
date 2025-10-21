local site_dir = vim.fn.stdpath("config") .. "/site"
local pre_site_dir = site_dir .. "/pre"
require("luafiles_loader").load_lua_files_from(pre_site_dir)

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.extras")

vim.g.python3_host_prog = require("python_venv").get_python3_host_prog()

local lazypath = require("_install_lazy").lazypath
vim.opt.rtp:prepend(lazypath)

require("pytoy_reboot")

if vim.g.vscode then
    require("vscode_config")
    require("vscode_config.path_solver")
    require("vscode_lazy_setup")
    if vim.g.pytoy_reboot ~= nil then
        vim.opt.rtp:prepend(vim.g.pytoy_reboot)
    end
else
    --Plugin manager.
    require("lazy_setup")
    require("mylsp") -- Language Sever.
end

-- Handling of `_vim` files.
local script_path = debug.getinfo(1, "S").source:sub(2)
vim.cmd("source " .. vim.fn.fnamemodify(script_path, ':h') .. '/_plugins.vim')


local post_site_dir = site_dir .. "/post"
require("luafiles_loader").load_lua_files_from(post_site_dir)
