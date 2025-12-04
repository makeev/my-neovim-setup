return {
  "johmsalas/text-case.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("textcase").setup({
      default_keymappings_enabled = true,
      prefix = "ga",
    })
  end,
  keys = {
    { "ga", mode = { "n", "x" } },
  },
}
