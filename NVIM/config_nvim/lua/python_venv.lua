
local M = {}

-- =========================================================
-- Configuration
-- =========================================================

-- Neovim's libuv API
local vim_loop = vim.uv or vim.loop

-- Python version
-- Match this with Vim's pythonthreedll version when necessary.


local default_python_version = vim.env.VIM_PYTHON_VERSION or  "3.13"

-- =========================================================
-- uv
-- =========================================================

-- uv executable path
local uv_executable = nil

-- Search for uv executable
local function find_uv()
    -- Search in the current PATH first
    if vim.fn.executable("uv") == 1 then
        return "uv"
    end

    local os_name = vim_loop.os_uname().sysname
    local candidates = {}

    if os_name == "Windows_NT" then
        local local_app_data = vim.env.LOCALAPPDATA
            or (vim.env.USERPROFILE .. "/AppData/Local")

        candidates = {
            local_app_data .. "/Programs/uv/uv.exe",
            local_app_data .. "/Microsoft/WinGet/Links/uv.exe",
        }
    else
        candidates = {
            vim.fn.expand("~/.local/bin/uv"),
            "/usr/local/bin/uv",
            "/usr/bin/uv",
        }
    end

    for _, path in ipairs(candidates) do
        if vim.fn.executable(path) == 1 then
            return path
        end
    end

    return nil
end

-- Check whether uv is available
function M.is_uv_available()
    if uv_executable
        and vim.fn.executable(uv_executable) == 1 then
        return true
    end

    uv_executable = find_uv()

    return uv_executable ~= nil
end

-- Execute uv command
local function run_uv(args)
    if not M.is_uv_available() then
        return {
            code = -1,
            stderr = "uv is not installed or not available.",
        }
    end

    local command = { uv_executable }
    vim.list_extend(command, args)

    return vim.system(command, { text = true }):wait()
end

-- =========================================================
-- Python virtual environment
-- =========================================================

-- Default virtual environment path
local function get_default_venv_path()
    local os_name = vim_loop.os_uname().sysname

    if os_name == "Windows_NT" then
        local local_app_data = vim.env.LOCALAPPDATA
            or (vim.env.USERPROFILE .. "/AppData/Local")

        return local_app_data .. "/vim-python-shared/.venv"
    end

    local data_home = vim.env.XDG_DATA_HOME
        or (vim.env.HOME .. "/.local/share")

    return data_home .. "/vim-python-shared/.venv"
end

-- Get virtual environment path
local function get_venv_path()
    local env_path = vim.env.VIM_PYTHON_VENV

    if env_path and env_path ~= "" then
        return vim.fn.expand(env_path)
    end

    local path = get_default_venv_path()
    vim.env.VIM_PYTHON_VENV = path

    return path
end

local target_venv_path = get_venv_path()

-- Get Python executable path from venv
local function venv_to_executable(venv_path)
    local os_name = vim_loop.os_uname().sysname

    if os_name == "Windows_NT" then
        return venv_path .. "/Scripts/python.exe"
    end

    return venv_path .. "/bin/python"
end

-- Check whether virtual environment exists
function M.is_venv_existent()
    local python_executable =
        venv_to_executable(target_venv_path)

    return vim.fn.executable(python_executable) == 1
end

-- Create virtual environment if necessary
local function ensure_python_venv(venv_path)
    if M.is_venv_existent() then
        return true
    end

    local result = run_uv({
        "venv",
        "--python",
        default_python_version,
        venv_path,
    })

    if result.code ~= 0 then
        vim.notify(
            "Failed to create Python venv:\n"
                .. (result.stderr or result.stdout or ""),
            vim.log.levels.ERROR
        )
        return false
    end

    if not M.is_venv_existent() then
        vim.notify(
            "uv venv completed, but Python executable was not found.",
            vim.log.levels.ERROR
        )
        return false
    end

    vim.notify(
        "Python venv created: " .. venv_path,
        vim.log.levels.INFO
    )

    return true
end

-- =========================================================
-- Neovim Python provider
-- =========================================================

-- Get Python executable for Neovim provider
function M.get_python3_host_prog()
    local python_executable =
        venv_to_executable(target_venv_path)

    -- Create venv if necessary
    if not ensure_python_venv(target_venv_path) then
        return nil
    end

    -- Install pynvim if necessary
    if not is_pynvim_installed(python_executable) then
        if not install_dependency(python_executable) then
            return nil
        end
    end

    return python_executable
end

-- Setup Neovim Python provider
function M.get_python3_host_prog()
    if not ensure_python_venv(target_venv_path) then
        return nil
    end

    return venv_to_executable(target_venv_path)
end

return M
