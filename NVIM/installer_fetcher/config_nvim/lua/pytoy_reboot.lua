--
--[[
--  This file is reading the generated files generated vim-pytoy `https://github.com/Sillte/vim-pytoy`.
--]]


local lazypath = require("_install_lazy").lazypath
vim.opt.rtp:prepend(lazypath)


-- Below two snippets are relatd to `pytoy.commands.devtools_commands.VimReboot`.
local reboot_json_file = vim.fn.stdpath("cache") .. "/pytoy_reboot.json"
local reboot_session_file = vim.fn.stdpath("cache") .. "/pytoy_reboot.vim"

if vim.fn.filereadable(reboot_json_file) == 1 then
  local lines = vim.fn.readfile(reboot_json_file)
  os.remove(reboot_json_file)
  local data = vim.fn.json_decode(table.concat(lines, "\n"))
  local plugin_path = data.plugin_folder

  if type(plugin_path) == "string" then
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
  if not vim.g.vscode and vim.fn.filereadable(reboot_session_file) == 1 then
    vim.cmd("silent! source " .. vim.fn.fnameescape(reboot_session_file))
    vim.cmd("silent! filetype detect")
  end
end
