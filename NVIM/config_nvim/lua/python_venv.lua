local M = {}

local uv = vim.uv or vim.loop

-- Pythonのバージョン。
-- Vim側のpythonthreedllに合わせる場合は、こちらも同じバージョンにする。
local default_python_version = "3.13"

-- Neovimの設定ディレクトリ
local config_path = vim.fn.stdpath("config")

-- VIM_PYTHON_VENV が指定されていれば優先。
-- 未指定の場合は、Vim側と同じ共有ディレクトリを既定値にする。
local function get_default_venv_path()
    local os_name = uv.os_uname().sysname

    if os_name == "Windows_NT" then
        local local_app_data = vim.env.LOCALAPPDATA
            or (vim.env.USERPROFILE .. "/AppData/Local")

        return local_app_data .. "/vim-python-shared/.venv"
    end

    local data_home = vim.env.XDG_DATA_HOME
        or (vim.env.HOME .. "/.local/share")

    return data_home .. "/vim-python-shared/.venv"
end

local function get_venv_path()
    local env_path = vim.env.VIM_PYTHON_VENV

    if env_path and env_path ~= "" then
        return vim.fn.expand(env_path)
    end
    vim.env.VIM_PYTHON_VENV = get_default_venv_path()
    return vim.env.VIM_PYTHON_VENV
end

local target_venv_path = get_venv_path()

-- uvが利用可能か
function M.is_uv_available()
    return vim.fn.executable("uv") == 1
end

-- 仮想環境のPython実行ファイルのパス
local function venv_to_executable(venv_path)
    local os_name = uv.os_uname().sysname

    if os_name == "Windows_NT" then
        return venv_path .. "/Scripts/python.exe"
    else
        return venv_path .. "/bin/python"
    end
end

-- 仮想環境が作成済みか
function M.is_venv_existent()
    local python_executable = venv_to_executable(target_venv_path)

    return vim.fn.executable(python_executable) == 1
end

-- 仮想環境を作成する
local function ensure_python_venv(venv_path)
    if M.is_venv_existent() then
        return true
    end

    if not M.is_uv_available() then
        vim.notify(
            "uv is not installed or not available in PATH.",
            vim.log.levels.ERROR
        )
        return false
    end

    local command = {
        "uv",
        "venv",
        "--python",
        default_python_version,
        venv_path,
    }

    local result = vim.system(command, { text = true }):wait()

    if result.code ~= 0 then
        vim.notify(
            "Failed to create Python venv:\n" .. (result.stderr or result.stdout or ""),
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

    vim.notify("Python venv created: " .. venv_path, vim.log.levels.INFO)
    return true
end

-- venvにNeovimのPython provider用パッケージをインストールする
local function install_dependency(venv_path)
    local python_executable = venv_to_executable(venv_path)

    local command = {
        "uv",
        "pip",
        "install",
        "--python",
        python_executable,
        "pynvim",
    }

    local result = vim.system(command, { text = true }):wait()

    if result.code ~= 0 then
        vim.notify(
            "Failed to install pynvim:\n" .. (result.stderr or result.stdout or ""),
            vim.log.levels.ERROR
        )
        return false
    end

    vim.notify("pynvim installed successfully.", vim.log.levels.INFO)
    return true
end

-- NeovimのPython hostとして使う実行ファイルのパスを取得する
function M.get_python3_host_prog()
    if not M.is_uv_available() then
        vim.notify(
            "uv is not installed or not available in PATH.",
            vim.log.levels.ERROR
        )
        return nil
    end

    if not ensure_python_venv(target_venv_path) then
        return nil
    end

    -- pynvimが利用可能か確認。
    -- 未導入の場合のみインストールする。
    local python_executable = venv_to_executable(target_venv_path)

    local check_command = {
        python_executable,
        "-c",
        "import pynvim",
    }

    local check_result = vim.system(check_command, { text = true }):wait()

    if check_result.code ~= 0 then
        if not install_dependency(target_venv_path) then
            return nil
        end
    end

    return python_executable
end

-- NeovimのPython host設定を行う
function M.setup()
    local python_executable = M.get_python3_host_prog()

    if not python_executable then
        return false
    end

    vim.g.python3_host_prog = python_executable

    return true
end

return M
