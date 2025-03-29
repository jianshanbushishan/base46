local M = {}
function M.GetHighlight(themeColors)
  local base30 = themeColors.base_30

  return {
    TelescopePromptPrefix = {
      fg = base30.red,
      bg = base30.black2,
    },

    TelescopeNormal = { bg = base30.darker_black },

    TelescopePreviewTitle = {
      fg = base30.black,
      bg = base30.green,
    },

    TelescopePromptTitle = {
      fg = base30.black,
      bg = base30.red,
    },

    TelescopeSelection = { bg = base30.black2, fg = base30.white },
    TelescopeResultsDiffAdd = { fg = base30.green },
    TelescopeResultsDiffChange = { fg = base30.yellow },
    TelescopeResultsDiffDelete = { fg = base30.red },

    TelescopeMatching = { bg = base30.one_bg, fg = base30.blue },
    TelescopeBorder = { fg = base30.one_bg3 },
    TelescopePromptBorder = { fg = base30.one_bg3 },
    TelescopeResultsTitle = { fg = base30.black, bg = base30.green },
    -- TelescopePreviewTitle = { fg = base30.black, bg = base30.blue },
    -- TelescopePromptPrefix = { fg = base30.red, bg = base30.black },
    -- TelescopeNormal = { bg = base30.black },
    TelescopePromptNormal = { bg = base30.black },
  }
end

return M
