local M = {
  lastline = -1,
}

M.get_select = function()
  local cursor_pos = vim.api.nvim_win_get_cursor(M.winnr)
  if cursor_pos[1] < 2 then
    cursor_pos[1] = cursor_pos[1] + 1
    vim.api.nvim_win_set_cursor(M.winnr, cursor_pos)
  elseif cursor_pos[1] > M.endline then
    cursor_pos[1] = M.endline
    vim.api.nvim_win_set_cursor(M.winnr, cursor_pos)
  end

  local start = cursor_pos[1] - 1
  return start
end

M.on_move = function()
  if M.lastline ~= -1 then
    local theme =
      vim.api.nvim_buf_get_lines(M.bufnr, M.lastline, M.lastline + 1, false)[1]
    local hl_name = require("base46.utils").get_hl_name(theme)
    vim.api.nvim_buf_clear_namespace(M.bufnr, M.namespace, M.lastline, M.lastline + 1)
    vim.api.nvim_buf_add_highlight(M.bufnr, M.namespace, hl_name, M.lastline, 0, -1)
  end

  local line = M.get_select()
  local cursor_pos = vim.api.nvim_win_get_cursor(M.winnr)
  vim.api.nvim_buf_set_virtual_text(
    M.bufnr,
    M.namespace,
    line,
    { { tostring("<-------"), "Error" } },
    {}
  )

  M.lastline = line
  local theme = vim.api.nvim_buf_get_lines(M.bufnr, line, line + 1, false)[1]
  M.switch2theme(theme)
end

M.close = function()
  -- vim.api.nvim_buf_clear_namespace(M.bufnr, M.namespace, 0, -1)
  vim.api.nvim_win_close(M.winnr, true)
end

M.open_themes_list = function()
  vim.cmd("vnew")

  vim.wo.foldenable = false
  vim.bo.buftype = "nofile"
  vim.bo.buflisted = false
  vim.bo.filetype = "preview"
  vim.opt.number = false
  vim.opt.cursorline = true
  vim.opt.winfixwidth = true
  vim.o.guicursor = "n:hor2"

  local bufnr = vim.api.nvim_get_current_buf()
  local winnr = vim.api.nvim_get_current_win()
  M.bufnr = bufnr
  M.winnr = winnr

  local map_opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "q",
    "<cmd>lua require('base46.preview').close()<cr><esc>",
    map_opts
  )
  vim.api.nvim_buf_set_keymap(bufnr, "n", "l", "", map_opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "h", "", map_opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "v", "", map_opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "V", "", map_opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "r", "", map_opts)
  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "<cr>",
    "<cmd>lua require('base46.preview').save_conf()<cr><esc>",
    map_opts
  )

  vim.api.nvim_win_set_width(winnr, 30)

  vim.api.nvim_create_autocmd("CursorMoved", {
    callback = function()
      M.on_move()
    end,
    buffer = bufnr,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
      vim.o.guicursor = "n:hor2"
    end,
    buffer = bufnr,
  })

  vim.api.nvim_create_autocmd("BufLeave", {
    callback = function()
      vim.o.guicursor = "n:block"
    end,
    buffer = bufnr,
  })

  local config = require("base46.config").get()
  local themes = vim.api.nvim_get_runtime_file("lua/base46/themes/*.lua", true)
  local line = 1
  local cursor_pos = { 1, 1 }

  vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, { "Base46 Themes Preview" })
  local theme_pos = {}
  for _, file in ipairs(themes) do
    local theme = vim.fn.fnamemodify(file, ":t:r")
    if theme == config.current_theme then
      cursor_pos = { line + 1, 0 }
    end
    theme_pos[theme] = line
    vim.api.nvim_buf_set_lines(bufnr, line, line, false, { theme })
    line = line + 1
  end

  M.endline = line
  local utils = require("base46.utils")
  M.namespace = vim.api.nvim_create_namespace("base46_preview")
  utils.create_highlight_for_preview(M.namespace, bufnr, theme_pos)
  vim.api.nvim_set_hl(0, "PreviewCursorLine", { underline = true, italic = true })
  vim.wo.winhl = "CursorLine:PreviewCursorLine"

  vim.api.nvim_win_set_cursor(winnr, cursor_pos)
  vim.bo.modifiable = false
end

M.switch2theme = function(theme)
  local config = require("base46.config").get()
  if theme == config.current_theme then
    return
  end
  require("base46").load_theme(theme)
end

M.save_conf = function()
  local config = require("base46.config").get()
  local f = io.open(config.themecfg, "w")
  if f ~= nil then
    local conf = {
      background = config.cur_background,
      [config.cur_background] = config.current_theme,
    }
    conf = require("base46.utils").merge_tb(config.theme, conf)
    f:write(vim.json.encode(conf))
    io.close(f)
  end
end

return M
