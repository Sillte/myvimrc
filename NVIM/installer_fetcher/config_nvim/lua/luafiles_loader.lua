local M = {}

function M.load_lua_files_from(dir)
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

return M
