local M = {}

M.on_move = function()
  local cursor_pos = vim.api.nvim_win_get_cursor(M.winnr)
  if cursor_pos[1] < 2 then
    cursor_pos[1] = cursor_pos[1] + 1
  elseif cursor_pos[1] > M.endline then
    cursor_pos[1] = M.endline
  else
    local start = cursor_pos[1] - 1
    local theme = vim.api.nvim_buf_get_lines(M.bufnr, start, start + 1, false)[1]
    M.switch2theme(theme)
    return
  end

  vim.api.nvim_win_set_cursor(M.winnr, cursor_pos)
end

M.preview_themes = function()
  vim.cmd("vnew")

  vim.wo.foldenable = false
  vim.bo.buftype = "nofile"
  vim.bo.buflisted = false
  vim.bo.filetype = "preview"
  vim.opt.number = false
  vim.opt.cursorline = true
  vim.opt.winfixwidth = true

  local bufnr = vim.api.nvim_get_current_buf()
  local winnr = vim.api.nvim_get_current_win()
  M.bufnr = bufnr
  M.winnr = winnr

  local map_opts = { noremap = true, silent = true }
  local bufname = "ThemePreview"
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<Esc>", "<cmd>q!<CR>", map_opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<cmd>q!<CR>", map_opts)

  vim.api.nvim_win_set_width(winnr, 30)
  vim.api.nvim_buf_set_name(bufnr, bufname)

  local autocmd_id = vim.api.nvim_create_autocmd("CursorMoved", {
    pattern = bufname,
    callback = function()
      M.on_move()
    end,
  })
  vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
    buffer = bufnr,
    callback = function(a)
      vim.api.nvim_del_autocmd(autocmd_id)
    end,
  })

  local cfg = require("base46").cfg()
  local path = cfg.pkgpath .. "/lua/base46/themes"
  local line = 1
  local current_theme = vim.g.current_theme
  local cursor_pos = {1,1}

  vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, { "    themes preview" })
  for _, file in ipairs(vim.fn.readdir(path)) do
    local theme = vim.fn.fnamemodify(file, ":r")
    if theme == current_theme then
      cursor_pos = { line + 1, 0 }
    end
    vim.api.nvim_buf_set_lines(bufnr, line, line, false, { theme })
    line = line + 1
  end

  M.endline = line
  vim.api.nvim_win_set_cursor(winnr, cursor_pos)
  vim.bo.modifiable = false
end

M.switch2theme = function(theme)
  if theme == vim.g.current_theme then
    return
  end
  require("base46").load_theme(theme)
end

return M
