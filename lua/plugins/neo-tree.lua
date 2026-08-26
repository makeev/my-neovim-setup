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
    init = function()
      -- `nvim .` / `nvim <dir>`: load neo-tree right away so its netrw hijack
      -- replaces the directory buffer at startup. Otherwise that buffer
      -- survives until the first <CR> in the tree: entering its window fires
      -- the (debounced) hijack, which swaps a fresh empty buffer into the
      -- window on top of the file that was just opened.
      -- A one-shot BufEnter instead of a bare require() so cwd is already set
      -- up (same approach as LazyVim).
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("neo_tree_start_directory", { clear = true }),
        desc = "Load neo-tree when Neovim is started with a directory",
        once = true,
        callback = function()
          if package.loaded["neo-tree"] then
            return
          end
          local stats = vim.uv.fs_stat(vim.fn.argv(0))
          if stats and stats.type == "directory" then
            require("neo-tree")
          end
        end,
      })
    end,
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
