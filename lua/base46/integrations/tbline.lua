local M = {}

function M.GetHighlight(themeColors)
  local base30 = themeColors.base_30

  return {
    Tabline = { bg = base30.black2 },
    TbFill = { bg = base30.black2 },

    TbBufOn = { fg = base30.white, bg = base30.black, underline = true },
    TbBufOff = { fg = base30.light_grey, bg = base30.black2 },

    TbBufOnModified = { fg = base30.green, bg = base30.black },
    TbBufOffModified = { fg = base30.red, bg = base30.black2 },

    TbBufSepOn = { fg = base30.red, bg = base30.black },
    TbBufSepOff = { fg = base30.light_grey, bg = base30.black2 },
  }
end

return M
