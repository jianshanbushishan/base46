local colorize = require("base46.colors").change_hex_lightness

local M = {}

local function GenModesHL(hls, base30, modename, col)
  hls["St_" .. modename .. "Mode"] = { fg = base30.black, bg = base30[col], bold = true }
  hls["St_" .. modename .. "ModeSep"] = { fg = base30[col], bg = base30.grey }
end

local function AddStatusModeHls(hls, base30)
  GenModesHL(hls, base30, "Normal", "nord_blue")
  GenModesHL(hls, base30, "Visual", "cyan")
  GenModesHL(hls, base30, "Insert", "dark_purple")
  GenModesHL(hls, base30, "Terminal", "green")
  GenModesHL(hls, base30, "NTerminal", "yellow")
  GenModesHL(hls, base30, "Replace", "orange")
  GenModesHL(hls, base30, "Confirm", "teal")
  GenModesHL(hls, base30, "Command", "green")
  GenModesHL(hls, base30, "Select", "blue")
end

function M.GetHighlight(themeColors)
  local base30 = themeColors.base_30
  local statusline_bg = base30.statusline_bg
  local light_grey = colorize(base30.light_grey, 8)

  local hls = {
    StatusLine = { bg = statusline_bg },
    St_gitIcons = { fg = light_grey, bg = statusline_bg, bold = true },
    St_Lsp = { fg = base30.nord_blue, bg = statusline_bg },
    St_LspMsg = { fg = base30.green, bg = statusline_bg },
    St_EmptySpace = { fg = base30.grey, bg = base30.lightbg },
    St_file = { bg = base30.lightbg, fg = base30.white },
    St_file_sep = { bg = statusline_bg, fg = base30.lightbg },
    St_cwd_icon = { fg = base30.one_bg, bg = base30.red },
    St_cwd_text = { fg = base30.white, bg = base30.lightbg },
    St_cwd_sep = { fg = base30.red, bg = statusline_bg },
    St_pos_sep = { fg = base30.green, bg = base30.lightbg },
    St_pos_icon = { fg = base30.black, bg = base30.green },
    St_pos_text = { fg = base30.green, bg = base30.lightbg },

    -- lsp highlights
    St_lspError = { fg = base30.red, bg = statusline_bg },
    St_lspWarning = { fg = base30.yellow, bg = statusline_bg },
    St_LspHints = { fg = base30.purple, bg = statusline_bg },
    St_LspInfo = { fg = base30.green, bg = statusline_bg },

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

  AddStatusModeHls(hls, base30)
  return hls
end

return M
