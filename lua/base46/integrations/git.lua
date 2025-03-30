local M = {}
function M.GetHighlight(themeColors)
  local base30 = themeColors.base_30
  local base16 = themeColors.base_16
  local isLight = themeColors.type == "light"

  local bgs = {}
  if isLight == "light" then
    bgs["DiffAdd"] = "#C2DFDF"
    bgs["DiffText"] = "#FAFEBD"
    bgs["DiffChange"] = "#E0F1FF"
    bgs["DiffDelete"] = "#FFE4E1"
  else
    bgs["DiffAdd"] = "#4c5b2b"
    bgs["DiffText"] = "#33406a"
    bgs["DiffChange"] = "#4c5b2b"
    bgs["DiffDelete"] = "#4c1918"
  end

  return {
    diffOldFile = {
      fg = base30.baby_pink,
    },

    diffNewFile = {
      fg = base30.blue,
    },

    DiffAdd = {
      -- fg = base30.blue,
      bg = bgs["DiffAdd"],
    },

    DiffAdded = {
      fg = base30.green,
    },

    DiffChange = {
      -- fg = base30.light_grey,
      bg = bgs["DiffChange"],
    },

    DiffChangeDelete = {
      fg = base30.red,
    },

    DiffModified = {
      fg = base30.orange,
    },

    DiffDelete = {
      -- fg = base30.red,
      bg = bgs["DiffDelete"],
    },

    DiffRemoved = {
      fg = base30.red,
    },

    DiffText = {
      -- fg = base30.white,
      bg = bgs["DiffText"],
    },

    -- git commits
    gitcommitOverflow = {
      fg = base16.base08,
    },

    gitcommitSummary = {
      fg = base16.base0B,
    },

    gitcommitComment = {
      fg = base16.base03,
    },

    gitcommitUntracked = {
      fg = base16.base03,
    },

    gitcommitDiscarded = {
      fg = base16.base03,
    },

    gitcommitSelected = {
      fg = base16.base03,
    },

    gitcommitHeader = {
      fg = base16.base0E,
    },

    gitcommitSelectedType = {
      fg = base16.base0D,
    },

    gitcommitUnmergedType = {
      fg = base16.base0D,
    },

    gitcommitDiscardedType = {
      fg = base16.base0D,
    },

    gitcommitBranch = {
      fg = base16.base09,
      bold = true,
    },

    gitcommitUntrackedFile = {
      fg = base16.base0A,
    },

    gitcommitUnmergedFile = {
      fg = base16.base08,
      bold = true,
    },

    gitcommitDiscardedFile = {
      fg = base16.base08,
      bold = true,
    },

    gitcommitSelectedFile = {
      fg = base16.base0B,
      bold = true,
    },
  }
end

return M
