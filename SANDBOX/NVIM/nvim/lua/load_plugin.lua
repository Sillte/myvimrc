local function load_plugin_scripts(plugin_path)
  local uv = vim.loop
  local sep = package.config:sub(1, 1)
  local plugin_dir = plugin_path .. sep .. "plugin"

  -- ファイル読み込み用関数
  local function read_file_and_exec(filepath)
    local ext = filepath:match("^.+%.(.+)$")
    if ext == "vim" then
      vim.cmd("source " .. vim.fn.fnameescape(filepath))
    elseif ext == "lua" then
      dofile(filepath)
    else
      vim.notify("Unsupported plugin file type: " .. filepath, vim.log.levels.WARN)
    end
  end

  -- ディレクトリが存在しない場合
  local stat = uv.fs_stat(plugin_dir)
  if not stat or stat.type ~= "directory" then
    vim.notify("Plugin directory not found: " .. plugin_dir, vim.log.levels.WARN)
    return
  end

  -- pluginディレクトリ内のすべてのファイルを対象に実行
  local dir = uv.fs_scandir(plugin_dir)
  if not dir then return end

  while true do
    local name, typ = uv.fs_scandir_next(dir)
    if not name then break end
    if typ == "file" then
      local full_path = plugin_dir .. sep .. name
      read_file_and_exec(full_path)
    end
  end
end

return {
  load_plugin_scripts = load_plugin_scripts
}
