-- nvim-treesitter `main` branch.
--
-- The rewritten plugin does NOT read `ensure_installed` from `opts` any more --
-- `setup()` only accepts `install_dir`. Parsers have to be installed explicitly
-- via `require("nvim-treesitter").install()`, and highlighting has to be started
-- with `vim.treesitter.start()`: Nvim 0.12 only auto-starts it for lua, markdown,
-- help and query (see $VIMRUNTIME/ftplugin).
local ensure_installed = {
  "bash",
  "c",
  "diff",
  "html",
  "javascript",
  "jsdoc",
  -- NOTE: no "jsonc" -- the `main` branch dropped it, jsonc files use the
  -- json parser instead.
  "json",
  "lua",
  "luadoc",
  "luap",
  "markdown",
  "markdown_inline",
  "ninja",
  "printf",
  "python",
  "query",
  "regex",
  "rst",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = function()
      require("nvim-treesitter").update()
    end,
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup({})

      -- Install whatever is still missing, in the background.
      local installed = {}
      for _, lang in ipairs(ts.get_installed()) do
        installed[lang] = true
      end

      local missing = vim.tbl_filter(function(lang)
        return not installed[lang]
      end, ensure_installed)

      if #missing > 0 then
        ts.install(missing)
      end

      -- Start highlighting for any filetype that has a parser available.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if lang and vim.treesitter.language.add(lang) then
            pcall(vim.treesitter.start, args.buf, lang)
          end
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      enable = true,
      max_lines = 3,
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20,
      trim_scope = "outer",
      mode = "cursor",
      separator = nil,
    },
  },
}
