local M = {}

function M.start_ime_hook()
  local script_path = debug.getinfo(1, "S").source:sub(2)
  local base_dir = vim.fn.fnamemodify(script_path, ":h")
  local exe_path = base_dir .. "/IMEOFFHOOK/IMEOFFHOOK_EXE.exe"

  vim.fn.jobstart({ exe_path }, { detach = true })
end

local uname = vim.loop.os_uname()
if uname.sysname == "Windows_NT" then
    vim.defer_fn(function()
      M.start_ime_hook()
    end, 0)
end

return M

