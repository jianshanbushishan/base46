local M = {}

function M.GetHighlight(themeColors)
  local base30 = themeColors.base_30

  return {
    Tabline = { bg = base30.black2 },
    TbFill = { bg = base30.black2 },
    TbBufOn = { fg = base30.white, bg = base30.black },
    TbBufOff = { fg = base30.light_grey, bg = base30.black2 },

    TbBufOnModified = { fg = base30.green, bg = base30.black },
    TbBufOffModified = { fg = base30.red, bg = base30.black2 },
    TbBufOnClose = { fg = base30.red, bg = base30.black },
    TbBufOffClose = { fg = base30.light_grey, bg = base30.black2 },
    TbTabNewBtn = { fg = base30.white, bg = base30.one_bg2 },
    TbTabOn = { fg = base30.red },
    TbTabOff = { fg = base30.white, bg = base30.black2 },
    TbTabCloseBtn = { fg = base30.black, bg = base30.nord_blue },
    TBTabTitle = { fg = base30.black, bg = base30.blue },
    TbThemeToggleBtn = { bold = true, fg = base30.white, bg = base30.one_bg3 },
    TbCloseAllBufsBtn = { bold = true, bg = base30.red, fg = base30.black },
  }
end

return M
