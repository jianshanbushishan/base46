local M = {}
function M.GetHighlight(themeColors)
  local base30 = themeColors.base_30

  return {
    TodoBgFix = { fg = base30.black2, bg = base30.red, bold = true },
    TodoBgHack = { fg = base30.black2, bg = base30.orange, bold = true },
    TodoBgNote = { fg = base30.black2, bg = base30.white, bold = true },
    TodoBgPerf = { fg = base30.black2, bg = base30.purple, bold = true },
    TodoBgTest = { fg = base30.black2, bg = base30.purple, bold = true },
    TodoBgTodo = { fg = base30.black2, bg = base30.yellow, bold = true },
    TodoBgWarn = { fg = base30.orange, bold = true },
    TodoFgFix = { fg = base30.red },
    TodoFgHack = { fg = base30.orange },
    TodoFgNote = { fg = base30.white },
    TodoFgPerf = { fg = base30.purple },
    TodoFgTest = { fg = base30.purple },
    TodoFgTodo = { fg = base30.yellow },
    TodoFgWarn = { fg = base30.orange },
    TodoSignFix = { link = "TodoFgFix" },
    TodoSignHack = { link = "TodoFgHack" },
    TodoSignNote = { link = "TodoFgNote" },
    TodoSignPerf = { link = "TodoFgPerf" },
    TodoSignTest = { link = "TodoFgTest" },
    TodoSignTodo = { link = "TodoFgTodo" },
    TodoSignWarn = { link = "TodoFgWarn" },
  }
end

return M
