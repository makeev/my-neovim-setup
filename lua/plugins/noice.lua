return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    notify = {
      enabled = false  -- disable the vim.notify integration
    },
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
  }
}
