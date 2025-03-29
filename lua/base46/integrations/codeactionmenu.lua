local M = {}
function M.GetHighlight(themeColors)
  local base30 = themeColors.base_30

  return {
    CodeActionMenuWarningMessageText = { fg = base30.white },
    CodeActionMenuWarningMessageBorder = { fg = base30.red },
    CodeActionMenuMenuIndex = { fg = base30.blue },
    CodeActionMenuMenuKind = { fg = base30.green },
    CodeActionMenuMenuTitle = { fg = base30.white },
    CodeActionMenuMenuDisabled = { link = "Comment" },
    CodeActionMenuMenuSelection = { fg = base30.blue },
    CodeActionMenuDetailsTitle = { fg = base30.white },
    CodeActionMenuDetailsLabel = { fg = base30.yellow },
    CodeActionMenuDetailsPreferred = { fg = base30.green },
    CodeActionMenuDetailsDisabled = { link = "Comment" },
    CodeActionMenuDetailsUndefined = { link = "Comment" },
  }
end

return M
