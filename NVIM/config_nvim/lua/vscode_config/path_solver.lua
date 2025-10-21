local M = {}

local function is_wsl()
    local uname = vim.loop.os_uname()
    if uname.sysname ~= "Linux" then
        return false
    end
    return uname.release:match("Microsoft") or uname.release:match("WSL")
end

-- PATH を補正する関数
function M.fix_path()
    if not (vim.g.vscode and is_wsl()) then return end
    local handle = io.popen("sh -l -c 'echo $PATH' 2>/dev/null")
    local path = handle:read("*a")
    handle:close()
    if path then
        path = path:gsub("\n$", "")
        vim.env.PATH = path
    end
end

M.fix_path()

return M
