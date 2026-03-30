local fs = require("base46.fs")

local M = {}

local data_path = vim.fn.stdpath("data"):gsub("\\", "/")

M.default_cfg = {
  autoswitch = false,
  cachePath = data_path .. "/colorscheme",
  themeCfg = data_path .. "/theme.conf",
  themeList = data_path .. "/colorscheme/theme.list",
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
    "defaults",
    "treesitter",
    "devicons",
    -- "git",
    -- "syntax",
    "lsp",
    "mason",
  },
}

local function report_error(notify_error, message)
  if notify_error then
    notify_error(message)
  end
end

function M.get()
  return vim.g.base46Cfg
end

function M.setup(opts)
  opts = opts or {}
  vim.g.base46Cfg = vim.tbl_deep_extend("force", vim.deepcopy(M.default_cfg), opts)
  return vim.g.base46Cfg
end

function M.merge(cfg)
  vim.g.base46Cfg = vim.tbl_deep_extend("force", vim.g.base46Cfg or vim.deepcopy(M.default_cfg), cfg or {})
  return vim.g.base46Cfg
end

function M.validate_background(background, notify_error)
  if background == "light" or background == "dark" then
    return background
  end

  report_error(notify_error, "Invalid background value: " .. tostring(background))
  return M.default_cfg.theme.background
end

function M.load_theme_conf(notify_error)
  local cfg = M.get()
  local theme = fs.read_json_file(cfg.themeCfg, {}, notify_error)
  if vim.tbl_isempty(theme) then
    return false
  end

  theme.background = M.validate_background(theme.background or cfg.theme.background, notify_error)
  M.merge({ theme = theme })
  return true
end

function M.save_theme_conf(notify_error)
  local cfg = M.get()
  return fs.write_json_file(cfg.theme, cfg.themeCfg, notify_error)
end

return M
