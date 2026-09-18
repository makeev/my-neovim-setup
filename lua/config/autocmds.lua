-- Strip trailing whitespace on save.
-- Delete only each line's whitespace suffix, preserving marks and extmarks
-- in the remaining text, the cursor position and the last-search register.
-- Markdown is skipped entirely: two trailing spaces there are a hard line break.
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
    for i, line in ipairs(lines) do
      local first = line:find("%s+$")
      if first then
        vim.api.nvim_buf_set_text(args.buf, i - 1, first - 1, i - 1, #line, {})
      end
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
