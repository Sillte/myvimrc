return {
    {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
  },
  config = function()
    local cmp = require("cmp")
    cmp.setup({
      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Insert}), 
        ["<C-p>"] = cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Insert}), 
        ["<C-e>"] = cmp.mapping.abort(), 
        ["<CR>"] = cmp.mapping.confirm({select = true}),
        ["<C-Space>"] = cmp.mapping.complete(), 
      }),
    })
  end
}, 
}


