local function load_lua_files_from(dir)
  local handle = vim.loop.fs_scandir(dir)
  if not handle then return end

  while true do
    local name, type = vim.loop.fs_scandir_next(handle)
    if not name then break end

    if type == "file" and name:match("%.lua$") then
      local path = dir .. "/" .. name
      dofile(path)
    end
  end
end

local site_dir = vim.fn.stdpath("config") .. "/site"
local pre_site_dir = site_dir .. "/pre"
load_lua_files_from(pre_site_dir)


require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.extras")
-- I wonder why this is required for lazynvim.
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

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

if vim.g.vscode then
    require("vscode_config")
    require("vscode_lazy_setup")
else
    --Plugin manager.
    require("lazy_setup")
    require("mylsp") -- Language Sever.
end

local script_path = debug.getinfo(1, "S").source:sub(2)
vim.cmd("source " .. vim.fn.fnamemodify(script_path, ':h') .. '/_plugins.vim')

local post_site_dir = site_dir .. "/post"
load_lua_files_from(post_site_dir)
