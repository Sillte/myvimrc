local config_dir = vim.fn.stdpath("config")
local site_dir = config_dir .. "/site"
local lua_loader = require("luafiles_loader")

local function load_core_config()
    require("config.options")
    require("config.keymaps")
    require("config.autocmds")
    require("config.extras")
end

local function setup_python_host()
    vim.g.python3_host_prog = require("python_venv").get_python3_host_prog()
end

local function setup_lazy()
    local lazypath = require("_install_lazy").lazypath
    vim.opt.rtp:prepend(lazypath)
end

local function setup_plugin_manager()
    require("pytoy_reboot")

    if vim.g.vscode then
        require("vscode_config")
        require("vscode_lazy_setup")
        if vim.g.pytoy_reboot ~= nil then
            vim.opt.rtp:prepend(vim.g.pytoy_reboot)
        end
    else
        require("lazy_setup")
    end
end

local function source_legacy_plugins()
    local init_path = debug.getinfo(1, "S").source:sub(2)
    local plugin_file = vim.fs.joinpath(vim.fn.fnamemodify(init_path, ":h"), "_plugins.vim")
    vim.cmd("source " .. vim.fn.fnameescape(plugin_file))
end
lua_loader.load_lua_files_from(site_dir .. "/pre")
load_core_config()
setup_python_host()
setup_lazy()
setup_plugin_manager()
source_legacy_plugins()
lua_loader.load_lua_files_from(site_dir .. "/post")
