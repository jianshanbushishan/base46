return {
    cachepath = vim.fn.stdpath("data") .. "/colorscheme/",
    pkgpath = "",
    cur_background = "",

    theme = {
      light = "one_light",
      dark = "onedark",
      background = "light",
    },

    highlight = {
      hl_add = {},
      hl_override = {},
    },

    changed_themes = {},

    integrations = {
      "statusline",
      "cmp",
      "defaults",
      "treesitter",
      "devicons",
      "git",
      "telescope",
      "syntax",
      "tbline",
      "lsp",
      "notify",
      "nvimtree",
      "mason",
      "blankline",
    },
}