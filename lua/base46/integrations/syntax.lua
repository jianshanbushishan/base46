local M = {}
function M.GetHighlight(themeColors)
  local base16 = themeColors.base_16

  local syntax = {
    Boolean = {
      fg = base16.base09,
    },

    Character = {
      fg = base16.base08,
    },

    Conditional = {
      fg = base16.base0E,
    },

    Constant = {
      fg = base16.base08,
    },

    Define = {
      fg = base16.base0E,
      sp = "none",
    },

    Delimiter = {
      fg = base16.base0F,
    },

    Float = {
      fg = base16.base09,
    },

    Variable = {
      fg = base16.base05,
    },

    Function = {
      fg = base16.base0D,
    },

    Identifier = {
      fg = base16.base08,
      sp = "none",
    },

    Include = {
      fg = base16.base0D,
    },

    Keyword = {
      fg = base16.base0E,
    },

    Label = {
      fg = base16.base0A,
    },

    Number = {
      fg = base16.base09,
    },

    Operator = {
      fg = base16.base05,
      sp = "none",
    },

    PreProc = {
      fg = base16.base0A,
    },

    Repeat = {
      fg = base16.base0A,
    },

    Special = {
      fg = base16.base0C,
    },

    SpecialChar = {
      fg = base16.base0F,
    },

    Statement = {
      fg = base16.base08,
    },

    StorageClass = {
      fg = base16.base0A,
    },

    String = {
      fg = base16.base0B,
    },

    Structure = {
      fg = base16.base0E,
    },

    Tag = {
      fg = base16.base0A,
    },

    Todo = {
      fg = base16.base0A,
      bg = base16.base01,
    },

    Type = {
      fg = base16.base0A,
      sp = "none",
    },

    Typedef = {
      fg = base16.base0A,
    },
  }

  local semantic = {
    ["@lsp.type.class"] = { link = "Structure" },
    ["@lsp.type.decorator"] = { link = "Function" },
    ["@lsp.type.enum"] = { link = "Type" },
    ["@lsp.type.enumMember"] = { link = "Constant" },
    ["@lsp.type.function"] = { link = "@function" },
    ["@lsp.type.interface"] = { link = "Structure" },
    ["@lsp.type.macro"] = { link = "@macro" },
    ["@lsp.type.method"] = { link = "@method" },
    ["@lsp.type.namespace"] = { link = "@namespace" },
    ["@lsp.type.parameter"] = { link = "@parameter" },
    ["@lsp.type.property"] = { link = "@property" },
    ["@lsp.type.struct"] = { link = "Structure" },
    ["@lsp.type.type"] = { link = "@type" },
    ["@lsp.type.typeParamater"] = { link = "TypeDef" },
    ["@lsp.type.variable"] = { link = "@variable" },

    -- ["@event"] = { fg = theme.base08 },
    -- ["@modifier"] = { fg = theme.base08 },
    -- ["@regexp"] = { fg = theme.base0F },
  }

  local treesitter = require("base46.integrations.treesitter").GetHighlight(themeColors)

  syntax = vim.tbl_deep_extend("force", syntax, treesitter)
  syntax = vim.tbl_deep_extend("force", syntax, semantic)
  return syntax
end

return M
