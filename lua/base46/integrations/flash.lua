local M = {}
function M.GetHighlight(themeColors)
  local base30 = themeColors.base_30

  return {
    FlashMatch = { fg = base30.black, bg = base30.blue },
    FlashCurrent = { fg = base30.black, bg = base30.green },
    FlashLabel = { fg = base30.white, bold = true },
  }
end

return M
