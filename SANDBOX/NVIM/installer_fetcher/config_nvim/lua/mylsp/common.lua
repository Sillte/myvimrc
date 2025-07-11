local M = {}


M.capabilities = require("cmp_nvim_lsp").default_capabilities()


M.on_attach = function(_, bufnr)
  local opts = {noremap = true, silent=true, buffer=bufnr}
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set({'n', 'i'}, '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', 'ge', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '<leader>R', vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<learder>A", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>F", function() vim.lsp.buf.format({ async = true }) end, opts)
end

return M

