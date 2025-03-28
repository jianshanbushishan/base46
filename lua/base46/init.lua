local M = {}

local config = {
  cachepath = vim.fn.stdpath("data") .. "/colorscheme/",
  themecfg = vim.fn.stdpath("data") .. "/theme.conf",

  theme = {
    light = "one_light",
    dark = "onedark",
    background = "light",
  },
}
local error = vim.log.levels.ERROR

function M.SetBackground(background, force)
  if config.theme.background == background and not force then
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
end

function M.LoadTheme(theme)
  local hlFile = config.cachepath .. "/" .. theme
  loadfile(hlFile)()
end

local function LoadThemeConf()
  local file = io.open(config.theme, "r")
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
  local file = io.open(config.themecfg, "w")
  if file ~= nil then
    file:write(vim.json.encode(config.theme))
    io.close(file)
  end
end

function M.setup(opts)
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
      fwatch.watch(config.themecfg, {
        on_event = function()
          if not defer then -- only set once in window
            defer = vim.defer_fn(function()
              defer = nil
              LoadThemeConf()
              M.SetBackground(config.theme.background, true)
              opts.refresh(config.theme.background)
            end, 100)
          end
        end,
      })
    end
  end

  M.SetBackground(config.theme.background, true)
  opts.refresh(config.theme.background)
end

function M.SwitchBackground()
  local background = "light"
  if config.cur_background == "light" then
    background = "dark"
  end

  M.SetBackground(background, false)
end

local function MergeTable(table1, table2)
  table1 = vim.tbl_deep_extend("force", table1, table2)
end

local function GenerateCode(hls)
  local lines = {}
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
    table.insert(lines, string.format("vim.api.nvim_set_hl(0, '%s', { %s })", hlGroup, valStr))
  end

  return table.concat(lines, "\n")
end

local function create_temp_file(content)
  local tempname = os.tmpname()

  local file = io.open(tempname, "w")
  if not file then
    vim.notify("Cant creat temp file!", error)
    return nil
  end

  file:write(content)
  file:close()

  return tempname
end

function M.Compile(theme)
  local themeColors = require("base46.themes." .. theme)

  for _, plugin in ipairs(M.config.integrations) do
    local pluginMod = require("base46.integrations." .. plugin)
    local hls = pluginMod.GetHighlight(themeColors)
    if themeColors.polish_hl ~= nil and themeColors.polish_hl[plugin] ~= nil then
      MergeTable(hls, themeColors.polish_hl[plugin])
    end

    local code = GenerateCode(hls)
    print(create_temp_file(code))
  end
end

return M
