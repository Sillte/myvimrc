local M = {}
local uv = vim.uv or vim.loop

function M.load_lua_files_from(dir)
    local handle = uv.fs_scandir(dir)
    if not handle then
        return
    end
    local files = {}

    while true do
        local name, type = uv.fs_scandir_next(handle)
        if not name then break end
        if type == "file" and name:match("%.lua$") then
            table.insert(files, name)
        end
    end

    table.sort(files)

    for _, name in ipairs(files) do
        local path = vim.fs.joinpath(dir, name)
        local ok, err = pcall(dofile, path)

        if not ok then
            vim.notify(
                "Failed to load: " .. path .. "\n" .. err,
                vim.log.levels.ERROR
            )
        end
    end
end

return M
