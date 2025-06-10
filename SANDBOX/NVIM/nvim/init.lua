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

  if os.time() - restart_time <= 3 and plugin_path then

    -- This is required for success of `loading plugin`. 
    vim.opt.rtp:prepend(plugin_path)
    local ok, err = pcall(function() require("load_plugin").load_plugin_scripts(plugin_path) end)
    if ok then
        vim.notify("🌟 Restarted. Dev-plugin:" .. plugin_path, vim.log.levels.INFO)
        vim.g.dev_plugin = plugin_path
    else
        vim.notify("☔ Failed to read Dev-plugin:" .. tostring(err), vim.log.levels.ERROR)
        local rtp = vim.opt.rtp:get()
        for i, path in ipairs(rtp) do
            if path == plugin_path then
                table.remove(rtp, i)
                break
            end
        end
        vim.opt.rtp = rtp
    end
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
    require("vscode_config")
    require("vscode_lazy_setup")
else
    --Plugin manager.
    require("lazy_setup")
    require("mylsp") -- Language Sever.
end

