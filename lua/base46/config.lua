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
    "trouble",
    "codeactionmenu",
  },
}

function M.get()
  return vim.g.base46_config
end

function M.update(opts)
  vim.g.base46_config = vim.tbl_deep_extend("force", vim.g.base46_config, opts)
  vim.g.base46_cache = vim.g.base46_config.cacheroot
end

function M.init(opts)
  vim.g.base46_config = vim.tbl_deep_extend("force", M.default, opts or {})
  return vim.g.base46_config
end

return M
