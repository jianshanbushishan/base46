local colorize = require("base46.colors").change_hex_lightness

local M = {}
function M.GetHighlight(themeColors)
  local base30 = themeColors.base_30

  return {
    -- LSP References
    LspReferenceText = { fg = base30.darker_black, bg = base30.white },
    LspReferenceRead = { fg = base30.darker_black, bg = base30.white },
    LspReferenceWrite = { fg = base30.darker_black, bg = base30.white },

    -- Lsp Diagnostics
    DiagnosticHint = { fg = base30.purple },
    DiagnosticError = { fg = base30.red },
    DiagnosticWarn = { fg = base30.yellow },
    DiagnosticInfo = { fg = base30.green },
    LspSignatureActiveParameter = { fg = base30.black, bg = base30.green },

    RenamerTitle = { fg = base30.black, bg = base30.red },
    RenamerBorder = { fg = base30.red },

    LspInlayHint = {
      bg = colorize(base30.black2, vim.o.bg == "dark" and 0 or 3),
      fg = base30.light_grey,
    },
  }
end

return M
