local M = {}

local dataPath = vim.fn.stdpath("data")
dataPath = string.gsub(dataPath, "\\", "/")

local config = {
  cachePath = dataPath .. "/colorscheme/",
  themeCfg = dataPath .. "/theme.conf",

  theme = {
    light = "one_light",
    dark = "onedark",
    background = "light",
  },

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
local error = vim.log.levels.ERROR

function M.SetBackground(background, force)
  if vim.opt.background:get() == background and not force then
    return
  end

  if background ~= "light" and background ~= "dark" then
    local msg = "Invalid background val: " .. background
    vim.notify(msg, error, { title = "Base46.nvim" })
    background = "light"
  end

  config.theme.background = background
  vim.opt.background = background

  local theme = config.theme[background]
  M.LoadTheme(theme)
  vim.cmd("doautocmd ColorScheme")
end

function M.LoadTheme(theme)
  local hlFile = config.cachePath .. "/" .. theme
  if vim.fn.filereadable(hlFile) ~= 1 then
    M.Compile(theme)
  end

  loadfile(hlFile)()
end

local function Save2File(content, filePath)
  local file = io.open(filePath, "w")
  if not file then
    vim.notify(string.format("Cant write file: %s!", filePath), error)
    return nil
  end

  file:write(content)
  file:close()
end

local function LoadThemeConf()
  local file = io.open(config.themeCfg, "r")
  if file == nil then
    return false
  end

  local content = file:read("*a")
  local opts = vim.json.decode(content)
  io.close(file)
  config.theme = opts

  return true
end

local function SaveThemeConf()
  local content = vim.json.encode(config.theme)
  Save2File(content, config.themeCfg)
end

function M.setup(opts)
  if opts.integrations ~= nil then
    config.integrations = opts.integrations
  end

  if not LoadThemeConf() then
    SaveThemeConf()
  end

  if opts.autoswitch then
    local present, fwatch = pcall(require, "fwatch")
    if not present then
      local msg = "this feature depend on fwatch, install it first."
      vim.notify(msg, error, { title = "base46.nvim" })
    else
      local defer = nil
      fwatch.watch(config.themeCfg, {
        on_event = function()
          if not defer then -- only set once in window
            defer = vim.defer_fn(function()
              defer = nil
              LoadThemeConf()
              M.SetBackground(config.theme.background, true)
            end, 100)
          end
        end,
      })
    end
  end

  M.SetBackground(config.theme.background, true)
end

function M.SwitchBackground()
  local background = "light"
  if vim.opt.background:get() == "light" then
    background = "dark"
  end

  M.SetBackground(background, false)
end

local function GenerateCode(hls, terms)
  local lines = { "local sethl = vim.api.nvim_set_hl", "" }
  for hlGroup, hlGroupVals in pairs(hls) do
    local vals = {}

    for key, val in pairs(hlGroupVals) do
      if type(val) == "string" then
        val = string.format("'%s'", val)
      else
        val = tostring(val)
      end
      table.insert(vals, string.format("%s = %s", key, val))
    end

    local valStr = table.concat(vals, ", ")
    local line = string.format("sethl(0, '%s', { %s })", hlGroup, valStr)
    table.insert(lines, line)
  end

  table.insert(lines, "")
  for idx, color in ipairs(terms) do
    local valStr = string.format("vim.g.terminal_color_%d = '%s'", idx - 1, color)
    table.insert(lines, valStr)
  end
  return table.concat(lines, "\n")
end

function M.Compile(theme)
  local themeColors = require("base46.themes." .. theme)

  local colors = {}
  for _, plugin in ipairs(config.integrations) do
    local pluginMod = require("base46.integrations." .. plugin)
    local hls = pluginMod.GetHighlight(themeColors)
    if themeColors.polish_hl ~= nil and themeColors.polish_hl[plugin] ~= nil then
      hls = vim.tbl_deep_extend("force", hls, themeColors.polish_hl[plugin])
    end
    colors = vim.tbl_deep_extend("force", colors, hls)
  end

  local termsMod = require("base46.term")
  local terms = termsMod.GetHighlight(themeColors)
  local code = GenerateCode(colors, terms)
  Save2File(code, config.cachePath .. theme)
end

function M.GetThemeList()
  local themes = {}
  local files = vim.api.nvim_get_runtime_file("lua/base46/themes/*.lua", true)
  for _, path in ipairs(files) do
    local filename = vim.fn.fnamemodify(path, ":t:r")
    table.insert(themes, filename)
  end
  return themes
end

function M.SetTheme(theme, save)
  local themeColors = require("base46.themes." .. theme)
  local background = themeColors.type
  config.theme[background] = theme
  M.SetBackground(background, true)
  if save then
    SaveThemeConf()
  end
end

return M
