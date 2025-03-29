local M = {}

function M.GetHighlight(themeColors)
  local base16 = themeColors.base_16

  return {
    base16.base01,
    base16.base08,
    base16.base0B,
    base16.base0A,
    base16.base0D,
    base16.base0E,
    base16.base0C,
    base16.base05,
    base16.base03,
    base16.base08,
    base16.base0B,
    base16.base0A,
    base16.base0D,
    base16.base0E,
    base16.base0C,
    base16.base07,
  }
end

return M
