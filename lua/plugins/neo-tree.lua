return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = "Neotree explorer toggle"
      }
    },
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = true, -- loaded by the <leader>e keymap above
    opts = {
      -- Never open files into these windows. neo-tree's default only lists
      -- "Trouble" (the v2 filetype); Trouble v3 uses lowercase "trouble", so
      -- without it neo-tree opens the file inside the Trouble panel, Trouble
      -- yanks it back and focus stays in the tree ("empty panel, works on
      -- the second <CR>").
      open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "edgy" },
		 filesystem = {
				bind_to_cwd = false,
				follow_current_file = { enabled = true },
				use_libuv_file_watcher = true,
			},
    },
  }
}
