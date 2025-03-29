local M = {}
function M.GetHighlight(themeColors)
  local base30 = themeColors.base_30

  return {
    IndentBlanklineChar = { fg = base30.line },
    IndentBlanklineSpaceChar = { fg = base30.line },
    IndentBlanklineContextChar = { fg = base30.grey },
    IndentBlanklineContextStart = { bg = base30.one_bg2 },
  }
end

return M
