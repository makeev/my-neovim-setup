-- Strip trailing whitespace on save.
-- Uses a line-by-line edit instead of `:%s/\s\+$//e` so that the cursor
-- position and the last-search register are left untouched. Markdown is
-- skipped entirely: two trailing spaces there are a hard line break.
local strip_skip_ft = {
  markdown = true,
  gitcommit = true,
  diff = true,
}

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("strip_trailing_whitespace", { clear = true }),
  callback = function(args)
    if strip_skip_ft[vim.bo[args.buf].filetype] then
      return
    end

    local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
    local changed = false
    for i, line in ipairs(lines) do
      local stripped = line:gsub("%s+$", "")
      if stripped ~= line then
        lines[i] = stripped
        changed = true
      end
    end

    if changed then
      vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, lines)
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
})

-- Restore the last cursor position when opening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

-- Soft-wrap long lines for markdown files only
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
  end,
})
