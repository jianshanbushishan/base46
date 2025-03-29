local M = {}

function M.SetHighlight(themeColors)
  local base16 = themeColors.base_16

  vim.g.terminal_color_0 = base16.base01
  vim.g.terminal_color_1 = base16.base08
  vim.g.terminal_color_2 = base16.base0B
  vim.g.terminal_color_3 = base16.base0A
  vim.g.terminal_color_4 = base16.base0D
  vim.g.terminal_color_5 = base16.base0E
  vim.g.terminal_color_6 = base16.base0C
  vim.g.terminal_color_7 = base16.base05
  vim.g.terminal_color_8 = base16.base03
  vim.g.terminal_color_9 = base16.base08
  vim.g.terminal_color_10 = base16.base0B
  vim.g.terminal_color_11 = base16.base0A
  vim.g.terminal_color_12 = base16.base0D
  vim.g.terminal_color_13 = base16.base0E
  vim.g.terminal_color_14 = base16.base0C
  vim.g.terminal_color_15 = base16.base07
end

return M
