local M = {}
function M.GetHighlight(themeColors)
  local base30 = themeColors.base_30

  return {
    DevIconDefault = { fg = base30.red },
    DevIconc = { fg = base30.blue },
    DevIconcss = { fg = base30.blue },
    DevIcondeb = { fg = base30.cyan },
    DevIconDockerfile = { fg = base30.cyan },
    DevIconhtml = { fg = base30.baby_pink },
    DevIconjpeg = { fg = base30.dark_purple },
    DevIconjpg = { fg = base30.dark_purple },
    DevIconjs = { fg = base30.sun },
    DevIconkt = { fg = base30.orange },
    DevIconlock = { fg = base30.red },
    DevIconlua = { fg = base30.blue },
    DevIconmp3 = { fg = base30.white },
    DevIconmp4 = { fg = base30.white },
    DevIconout = { fg = base30.white },
    DevIconpng = { fg = base30.dark_purple },
    DevIconpy = { fg = base30.cyan },
    DevIcontoml = { fg = base30.blue },
    DevIconts = { fg = base30.teal },
    DevIconttf = { fg = base30.white },
    DevIconrb = { fg = base30.pink },
    DevIconrpm = { fg = base30.orange },
    DevIconvue = { fg = base30.vibrant_green },
    DevIconwoff = { fg = base30.white },
    DevIconwoff2 = { fg = base30.white },
    DevIconxz = { fg = base30.sun },
    DevIconzip = { fg = base30.sun },
    DevIconZig = { fg = base30.orange },
    DevIconMd = { fg = base30.blue },
    DevIconTSX = { fg = base30.blue },
    DevIconJSX = { fg = base30.blue },
    DevIconSvelte = { fg = base30.red },
    DevIconJava = { fg = base30.orange },
    DevIconDart = { fg = base30.cyan },
  }
end

return M
