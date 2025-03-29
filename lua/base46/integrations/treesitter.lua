local M = {}
function M.GetHighlight(themeColors)
  local base30 = themeColors.base_30
  local base16 = themeColors.base_16

  return {
    ["@variable"] = { fg = base16.base05 },
    ["@variable.builtin"] = { fg = base16.base09 },
    ["@variable.parameter"] = { fg = base16.base08 },
    ["@variable.member"] = { fg = base16.base08 },
    ["@variable.member.key"] = { fg = base16.base08 },

    ["@module"] = { fg = base16.base08 },
    -- ["@module.builtin"] = { fg = theme.base08 },

    ["@constant"] = { fg = base16.base08 },
    ["@constant.builtin"] = { fg = base16.base09 },
    ["@constant.macro"] = { fg = base16.base08 },

    ["@string"] = { fg = base16.base0B },
    ["@string.regex"] = { fg = base16.base0C },
    ["@string.escape"] = { fg = base16.base0C },
    ["@character"] = { fg = base16.base08 },
    -- ["@character.special"] = { fg = theme.base08 },
    ["@number"] = { fg = base16.base09 },
    ["@number.float"] = { fg = base16.base09 },

    ["@annotation"] = { fg = base16.base0F },
    ["@attribute"] = { fg = base16.base0A },
    ["@error"] = { fg = base16.base08 },

    ["@keyword.exception"] = { fg = base16.base08, italic = true },
    ["@keyword"] = { fg = base16.base0E },
    ["@keyword.function"] = { fg = base16.base0E, italic = true },
    ["@keyword.return"] = { fg = base16.base0E, italic = true },
    ["@keyword.operator"] = { fg = base16.base0E },
    ["@keyword.import"] = { link = "Include", italic = true },
    ["@keyword.conditional"] = { fg = base16.base0E, italic = true },
    ["@keyword.conditional.ternary"] = { fg = base16.base0E },
    ["@keyword.repeat"] = { fg = base16.base0A, italic = true },
    ["@keyword.storage"] = { fg = base16.base0A },
    ["@keyword.directive.define"] = { fg = base16.base0E, italic = true },
    ["@keyword.directive"] = { fg = base16.base0A },

    ["@function"] = { fg = base16.base0D },
    ["@function.builtin"] = { fg = base16.base0D, bold = true },
    ["@function.macro"] = { fg = base16.base08 },
    ["@function.call"] = { fg = base16.base0D },
    ["@function.method"] = { fg = base16.base0D },
    ["@function.method.call"] = { fg = base16.base0D },
    ["@constructor"] = { fg = base16.base0C },

    ["@operator"] = { fg = base16.base05 },
    ["@reference"] = { fg = base16.base05 },
    ["@punctuation.bracket"] = { fg = base16.base0F },
    ["@punctuation.delimiter"] = { fg = base16.base0F },
    ["@symbol"] = { fg = base16.base0B },
    ["@tag"] = { fg = base16.base0A },
    ["@tag.attribute"] = { fg = base16.base08 },
    ["@tag.delimiter"] = { fg = base16.base0F },
    ["@text"] = { fg = base16.base05 },
    ["@text.emphasis"] = { fg = base16.base09 },
    ["@text.strike"] = { fg = base16.base0F, strikethrough = true },
    ["@type.builtin"] = { fg = base16.base0A },
    ["@definition"] = { sp = base16.base04, underline = true },
    ["@scope"] = { bold = true },
    ["@property"] = { fg = base16.base08 },

    -- markup
    ["@markup.heading"] = { fg = base16.base0D },
    ["@markup.raw"] = { fg = base16.base09 },
    ["@markup.link"] = { fg = base16.base08 },
    ["@markup.link.url"] = { fg = base16.base09, underline = true },
    ["@markup.link.label"] = { fg = base16.base0C },
    ["@markup.list"] = { fg = base16.base08 },
    ["@markup.strong"] = { bold = true },
    ["@markup.underline"] = { underline = true },
    ["@markup.italic"] = { italic = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.quote"] = { bg = base30.black2 },

    ["@comment"] = { fg = base30.grey_fg, italic = true },
    ["@comment.todo"] = { fg = base30.grey, bg = base30.white, italic = true },
    ["@comment.warning"] = { fg = base30.black2, bg = base16.base09, italic = true },
    ["@comment.note"] = { fg = base30.black2, bg = base30.white, italic = true },
    ["@comment.danger"] = { fg = base30.black2, bg = base30.red, italic = true },

    ["@diff.plus"] = { fg = base30.green },
    ["@diff.minus"] = { fg = base30.red },
    ["@diff.delta"] = { fg = base30.light_grey },
  }
end

return M
