local colorize = require("base46.colors").change_hex_lightness

local M = {}
function M.GetHighlight(themeColors)
  local base30 = themeColors.base_30
  local base16 = themeColors.base_16

  return {
    MatchWord = {
      bg = base30.grey,
      fg = base30.white,
    },

    Pmenu = { bg = base30.one_bg },
    PmenuSbar = { bg = base30.one_bg },
    PmenuSel = { bg = base30.pmenu_bg, fg = base30.black },
    PmenuThumb = { bg = base30.grey },

    MatchParen = { link = "MatchWord" },

    Comment = { fg = base30.grey_fg, italic = true },

    CursorLineNr = { fg = base30.white },
    LineNr = { fg = base30.grey },

    -- floating windows
    FloatBorder = { fg = base30.blue, bg = base30.darker_black },
    NormalFloat = { bg = base30.darker_black },

    SnacksPickerInputTitle = { fg = base30.blue, bg = base30.darker_black },
    SnacksPickerBoxTitle = { fg = base30.blue, bg = base30.darker_black },

    NvimInternalError = { fg = base30.red },
    WinSeparator = { fg = base30.line },

    Normal = {
      fg = base16.base05,
      bg = base16.base00,
    },

    Bold = {
      bold = true,
    },

    Debug = {
      fg = base16.base08,
    },

    Directory = {
      fg = base16.base0D,
    },

    Error = {
      fg = base16.base00,
      bg = base16.base08,
    },

    ErrorMsg = {
      fg = base16.base08,
      bg = base16.base00,
    },

    Exception = {
      fg = base16.base08,
    },

    FoldColumn = {
      fg = base16.base0C,
      bg = base16.base01,
    },

    Folded = {
      fg = base30.light_grey,
      bg = base30.black2,
    },

    IncSearch = {
      fg = base16.base01,
      bg = base16.base09,
    },

    Italic = {
      italic = true,
    },

    Macro = {
      fg = base16.base08,
    },

    ModeMsg = {
      fg = base16.base0B,
    },

    MoreMsg = {
      fg = base16.base0B,
    },

    Question = {
      fg = base16.base0D,
    },

    Search = {
      fg = base16.base01,
      bg = base16.base0A,
    },

    Substitute = {
      fg = base16.base01,
      bg = base16.base0A,
      sp = "none",
    },

    SpecialKey = {
      fg = base16.base03,
    },

    TooLong = {
      fg = base16.base08,
    },

    UnderLined = {
      underline = true,
    },

    Visual = {
      bg = base16.base02,
    },

    VisualNOS = {
      fg = base16.base08,
    },

    WarningMsg = {
      fg = base16.base08,
    },

    WildMenu = {
      fg = base16.base08,
      bg = base16.base0A,
    },

    Title = {
      fg = base16.base0D,
      sp = "none",
    },

    Conceal = {
      bg = "NONE",
    },

    Cursor = {
      fg = base16.base00,
      bg = base16.base05,
    },

    NonText = {
      fg = base16.base03,
    },

    SignColumn = {
      fg = base16.base03,
      sp = "NONE",
    },

    ColorColumn = {
      bg = base16.base01,
      sp = "none",
    },

    CursorColumn = {
      bg = base16.base01,
      sp = "none",
    },

    CursorLine = {
      bg = "none",
      sp = "none",
    },

    QuickFixLine = {
      bg = base16.base01,
      sp = "none",
    },

    -- spell
    SpellBad = {
      undercurl = true,
      sp = base16.base08,
    },

    SpellLocal = {
      undercurl = true,
      sp = base16.base0C,
    },

    SpellCap = {
      undercurl = true,
      sp = base16.base0D,
    },

    SpellRare = {
      undercurl = true,
      sp = base16.base0E,
    },

    healthSuccess = {
      bg = base30.green,
      fg = base30.black,
    },

    -- lazy.nvim
    LazyH1 = {
      bg = base30.green,
      fg = base30.black,
    },

    LazyButton = {
      bg = base30.one_bg,
      fg = colorize(base30.light_grey, vim.o.bg == "dark" and 10 or -20),
    },

    LazyH2 = {
      fg = base30.red,
      bold = true,
      underline = true,
    },

    LazyReasonPlugin = { fg = base30.red },
    LazyValue = { fg = base30.teal },
    LazyDir = { fg = base16.base05 },
    LazyUrl = { fg = base16.base05 },
    LazyCommit = { fg = base30.green },
    LazyNoCond = { fg = base30.red },
    LazySpecial = { fg = base30.blue },
    LazyReasonFt = { fg = base30.purple },
    LazyOperator = { fg = base30.white },
    LazyReasonKeys = { fg = base30.teal },
    LazyTaskOutput = { fg = base30.white },
    LazyCommitIssue = { fg = base30.pink },
    LazyReasonEvent = { fg = base30.yellow },
    LazyReasonStart = { fg = base30.white },
    LazyReasonRuntime = { fg = base30.nord_blue },
    LazyReasonCmd = { fg = base30.sun },
    LazyReasonSource = { fg = base30.cyan },
    LazyReasonImport = { fg = base30.white },
    LazyProgressDone = { fg = base30.green },
  }
end

return M
