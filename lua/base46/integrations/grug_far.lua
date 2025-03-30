local M = {}
function M.GetHighlight()
  return {
    GrugFarResultsMatch = { link = "DiffChange" },
    GrugFarResultsMatchAdded = { link = "DiffAdd" },
    GrugFarResultsMatchRemoved = { link = "DiffDelete" },
  }
end

return M
