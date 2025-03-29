local M = {}
function M.GetHighlight(themeColors)
  local base30 = themeColors.base_30

  return {
    BufferLineBackground = {
      fg = base30.light_grey,
      bg = base30.black2,
    },

    BufferlineIndicatorVisible = {
      fg = base30.black2,
      bg = base30.black2,
    },

    -- buffers
    BufferLineBufferSelected = {
      fg = base30.white,
      bg = base30.black,
    },

    BufferLineBufferVisible = {
      fg = base30.light_grey,
      bg = base30.black2,
    },

    -- for diagnostics = "nvim_lsp"
    BufferLineError = {
      fg = base30.light_grey,
      bg = base30.black2,
    },
    BufferLineErrorDiagnostic = {
      fg = base30.light_grey,
      bg = base30.black2,
    },

    -- close buttons
    BufferLineCloseButton = {
      fg = base30.light_grey,
      bg = base30.black2,
    },
    BufferLineCloseButtonVisible = {
      fg = base30.light_grey,
      bg = base30.black2,
    },
    BufferLineCloseButtonSelected = {
      fg = base30.red,
      bg = base30.black,
    },
    BufferLineFill = {
      fg = base30.grey_fg,
      bg = base30.black2,
    },
    BufferlineIndicatorSelected = {
      fg = base30.black,
      bg = base30.black,
    },

    -- modified
    BufferLineModified = {
      fg = base30.red,
      bg = base30.black2,
    },
    BufferLineModifiedVisible = {
      fg = base30.red,
      bg = base30.black2,
    },
    BufferLineModifiedSelected = {
      fg = base30.green,
      bg = base30.black,
    },

    -- separators
    BufferLineSeparator = {
      fg = base30.black2,
      bg = base30.black2,
    },
    BufferLineSeparatorVisible = {
      fg = base30.black2,
      bg = base30.black2,
    },
    BufferLineSeparatorSelected = {
      fg = base30.black2,
      bg = base30.black2,
    },

    BufferLineNumbers = {
      fg = base30.light_grey,
      bg = base30.black2,
    },

    BufferLineNumbersSelected = {
      fg = base30.white,
      bg = base30.black,
    },
    BufferLineNumbersVisible = {
      fg = base30.white,
      bg = base30.black,
    },
    -- tabs
    BufferLineTab = {
      fg = base30.light_grey,
      bg = base30.one_bg3,
    },
    BufferLineTabSelected = {
      fg = base30.black2,
      bg = base30.nord_blue,
    },
    BufferLineTabClose = {
      fg = base30.red,
      bg = base30.black,
    },

    BufferLineDevIconDefaultSelected = {
      bg = "none",
    },
    BufferLineDevIconZig = {
      fg = base30.light_grey,
      bg = base30.black2,
    },
    BufferLineDevIconC = {
      fg = base30.light_grey,
      bg = base30.black2,
    },
    BufferLineDevIconH = {
      fg = base30.light_grey,
      bg = base30.black2,
    },
    BufferLineDevIconPy = {
      fg = base30.light_grey,
      bg = base30.black2,
    },
    BufferLineDevIconRs = {
      fg = base30.light_grey,
      bg = base30.black2,
    },
    BufferLineDevIconLua = {
      fg = base30.light_grey,
      bg = base30.black2,
    },

    BufferLineDuplicate = {
      fg = "NONE",
      bg = base30.black2,
    },
    BufferLineDuplicateSelected = {
      fg = base30.red,
      bg = base30.black,
    },
    BufferLineDuplicateVisible = {
      fg = base30.blue,
      bg = base30.black2,
    },

    -- custom area
    BufferLineRightCustomAreaText1 = {
      fg = base30.white,
    },

    BufferLineRightCustomAreaText2 = {
      fg = base30.red,
    },
  }
end

return M
