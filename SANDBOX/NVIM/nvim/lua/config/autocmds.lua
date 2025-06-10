-- This file includes autocmd which is related to the entire configuration.
--
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    local buftype = vim.api.nvim_buf_get_option(0, "buftype")
    local filename = vim.api.nvim_buf_get_name(0)
    if buftype == "" and filename ~= "" and vim.fn.isdirectory(vim.fn.fnamemodify(filename, ":p:h")) == 1 then
      vim.cmd("lcd " .. vim.fn.fnamemodify(filename, ":p:h"))
      vim.cmd("cd " .. vim.fn.fnamemodify(filename, ":p:h"))
    end
  end
})

