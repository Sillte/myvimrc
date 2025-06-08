require("config.options")
require("config.keymaps")
require("config.autocmds")

-- I wonder why this is required for lazynvim.
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

local lazypath = require("_install_lazy").lazypath

-- Below two snippets are relatd to `pytoy.commands.devtools_commands.VimReboot`.
-- vscode restart special: 
local restart_file = vim.fn.stdpath("cache") .. "/vscode_restarted.json"
if vim.g.vscode and vim.fn.filereadable(restart_file) == 1 then
  local lines = vim.fn.readfile(restart_file)
  local data = vim.fn.json_decode(table.concat(lines, "\n"))

  local plugin_path = data.plugin_folder
  local restart_time = tonumber(data.time)

  if os.time() - restart_time <= 3 then
    vim.opt.rtp:prepend(plugin_path)
    require("load_plugin").load_plugin_scripts(plugin_path)
    vim.notify("Restarted via vscode-neovim. dev-version plugin loaded:" .. plugin_path, vim.log.levels.INFO)
    vim.g.dev_plugin = plugin_path
  end
  os.remove(restart_file)
end

-- reboot for the normal nvim. 
if vim.g.pytoy_reboot ~= nil then
    print("g:pytoy exists and its value is: " .. tostring(vim.g.pytoy_reboot))
    local myplugin = require("load_plugin")
    myplugin.load_plugin_scripts(tostring(vim.g.pytoy_reboot))
    vim.opt.rtp:prepend(vim.g.pytoy_reboot)
    vim.opt.rtp:prepend(lazypath)
    vim.g.dev_plugin = tostring(vim.g.pytoy_reboot)
else
    vim.opt.rtp:prepend(lazypath)
end


if vim.g.vscode then
    require("vscode_lazy_setup")
else
    --Plugin manager.
    require("lazy_setup")
    require("mylsp") -- Language Sever.
end

