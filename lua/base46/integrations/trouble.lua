local M = {}
function M.GetHighlight(themeColors)
  local base30 = themeColors.base_30

  return {
    TroubleCount = { fg = base30.pink },
    TroubleCode = { fg = base30.white },
    TroubleWarning = { fg = base30.orange },
    TroubleSignWarning = { link = "DiagnosticWarn" },
    TroubleTextWarning = { fg = base30.white },
    TroublePreview = { fg = base30.red },
    TroubleSource = { fg = base30.cyan },
    TroubleSignHint = { link = "DiagnosticHint" },
    TroubleTextHint = { fg = base30.white },
    TroubleHint = { fg = base30.orange },
    TroubleSignOther = { link = "DiagnosticNormal" },
    TroubleSignInformation = { fg = base30.white },
    TroubleTextInformation = { fg = base30.white },
    TroubleInformation = { fg = base30.white },
    TroubleError = { fg = base30.red },
    TroubleTextError = { fg = base30.white },
    TroubleSignError = { link = "DiagnosticError" },
    TroubleText = { fg = base30.white },
    TroubleFile = { fg = base30.yellow },
    TroubleFoldIcon = { link = "Folded" },
    TroubleNormal = { fg = base30.white },
    TroubleLocation = { fg = base30.red },
    TroubleIndent = { link = base30.Comment },
  }
end

return M
