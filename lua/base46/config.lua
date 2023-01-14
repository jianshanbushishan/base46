local M = {}

M.default = {
  cachepath = vim.fn.stdpath("data") .. "/colorscheme/",
  themecfg = vim.fn.stdpath("data") .. "/theme.conf",
  cur_background = "",

  theme = {
    light = "one_light",
    dark = "onedark",
    background = "light",
  },

  ft = {},

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

M.get = function()
  return vim.g.base46_config
end

M.update = function(opts)
  vim.g.base46_config = vim.tbl_deep_extend("force", vim.g.base46_config, opts)
end

M.init = function(opts)
  vim.g.base46_config = vim.tbl_deep_extend("force", M.default, opts or {})
  return vim.g.base46_config
end

return M
