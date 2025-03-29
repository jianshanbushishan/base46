local M = {}

function M.GetHighlight(themeColors)
  local base30 = themeColors.base_30

  return {
    TblineFill = {
      bg = base30.black2,
    },

    TbLineBufOn = {
      fg = base30.white,
      bg = base30.black,
    },

    TbLineBufOff = {
      fg = base30.light_grey,
      bg = base30.black2,
    },

    TbLineBufOnModified = {
      fg = base30.green,
      bg = base30.black,
    },

    TbBufLineBufOffModified = {
      fg = base30.red,
      bg = base30.black2,
    },

    TbLineBufOnClose = {
      fg = base30.red,
      bg = base30.black,
    },

    TbLineBufOffClose = {
      fg = base30.light_grey,
      bg = base30.black2,
    },

    TblineTabNewBtn = {
      fg = base30.white,
      bg = base30.one_bg3,
      bold = true,
    },

    TbLineTabOn = {
      fg = base30.black,
      bg = base30.nord_blue,
      bold = true,
    },

    TbLineTabOff = {
      fg = base30.white,
      bg = base30.one_bg2,
    },

    TbLineTabCloseBtn = {
      fg = base30.black,
      bg = base30.nord_blue,
    },

    TBTabTitle = {
      fg = base30.black,
      bg = base30.white,
    },

    TbLineThemeToggleBtn = {
      bold = true,
      fg = base30.white,
      bg = base30.one_bg3,
    },

    TbLineCloseAllBufsBtn = {
      bold = true,
      bg = base30.red,
      fg = base30.black,
    },
  }
end

return M
