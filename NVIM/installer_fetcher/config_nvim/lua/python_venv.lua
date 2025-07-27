local M = {}

local config_path = vim.fn.stdpath("config")
local target_venv_path = config_path .. "/.venv"
local target_requirement_path = config_path .. "/python_requirements.txt"
local python_version = "3.12"

local function ensure_python_venv(venv_path)
  if vim.fn.isdirectory(venv_path) == 0 then
    local project_dir = vim.fn.fnamemodify(venv_path, ":h") 
    local command = "cd " .. vim.fn.shellescape(project_dir)
                    .. " && uv venv " .. " --python " .. python_version
                    .. venv_path
    vim.fn.system(command)
  end
  return venv_path
end


local function venv_to_executable(venv_path)
  local os_name = vim.loop.os_uname().sysname
  if os_name == "Windows_NT" then
    return venv_path .. "/Scripts/python.exe"
  else
    return venv_path .. "/bin/python"
  end
end
 
local function install_dependency(venv_path, requirements_file)
    local project_dir = vim.fn.fnamemodify(venv_path, ":h") 
    local command = "cd " .. vim.fn.shellescape(project_dir)
                    .. " && uv pip install -r "
                    .. vim.fn.shellescape(requirements_file)
    vim.fn.system(command)
    if vim.v.shell_error == 0 then
        print("Success of installment.")
    else
        print("Failure of installment.")
    end
end


function M.is_uv_available()
    -- Return whether `uv` can be used with `vim.system`.
    vim.fn.system("uv --help")
    return vim.v.shell_error == 0
end

function M.is_venv_existent()
    -- Return whether already `venv` is generated.
    return vim.fn.isdirectory(target_venv_path) == 1
end

function M.get_python3_host_prog()
    if M.is_venv_existent() == false then
        ensure_python_venv(target_venv_path)
        install_dependency(target_venv_path, target_requirement_path)
    end
    return venv_to_executable(target_venv_path)
end

return M




