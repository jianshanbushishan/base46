local M = {}

local dataPath = vim.fn.stdpath("data")
dataPath = string.gsub(dataPath, "\\", "/")

local defaultCfg = {
  cachePath = dataPath .. "/colorscheme/",
  themeCfg = dataPath .. "/theme.conf",
  themeList = dataPath .. "/colorscheme/theme.list",

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
local function ChangeConfig(cfg)
  vim.g.base46Cfg = vim.tbl_deep_extend("force", vim.g.base46Cfg, cfg)
end

function M.SetBackground(background, force)
  if vim.opt.background:get() == background and not force then
    return
  end

  if background ~= "light" and background ~= "dark" then
    local msg = "Invalid background val: " .. background
    vim.notify(msg, error, { title = "Base46.nvim" })
    background = "light"
  end

  ChangeConfig({ theme = { background = background } })
  vim.opt.background = background

  vim.cmd("highlight clear")
  local theme = vim.g.base46Cfg.theme[background]
  M.LoadTheme(theme)
  vim.cmd("doautocmd ColorScheme")
end

function M.LoadTheme(theme)
  local hlFile = vim.g.base46Cfg.cachePath .. "/" .. theme
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

local function LoadFile2Json(filePath)
  local file = io.open(filePath, "r")
  if file == nil then
    return {}
  end

  local content = file:read("*a")
  local obj = vim.json.decode(content)
  io.close(file)

  return obj
end

local function LoadThemeConf()
  local themeConf = vim.g.base46Cfg.themeCfg
  if vim.fn.filereadable(themeConf) ~= 1 then
    return false
  end

  local opts = LoadFile2Json(themeConf)
  ChangeConfig({ theme = opts })

  return true
end

local function SaveJson2File(obj, filePath)
  local content = vim.json.encode(obj)
  Save2File(content, filePath)
end

function M.setup(opts)
  vim.g.base46Cfg = vim.tbl_deep_extend("force", defaultCfg, opts)

  if not LoadThemeConf() then
    SaveJson2File(vim.g.base46Cfg.theme, vim.g.base46Cfg.themeCfg)
  end

  if opts.autoswitch then
    local present, fwatch = pcall(require, "fwatch")
    if not present then
      local msg = "this feature depend on fwatch, install it first."
      vim.notify(msg, error, { title = "base46.nvim" })
    else
      local defer = nil
      fwatch.watch(vim.g.base46Cfg.themeCfg, {
        on_event = function()
          if not defer then -- only set once in window
            defer = vim.defer_fn(function()
              defer = nil
              LoadThemeConf()
              M.SetBackground(vim.g.base46Cfg.theme.background, true)
            end, 100)
          end
        end,
      })
    end
  end

  M.SetBackground(vim.g.base46Cfg.theme.background, true)
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
  for _, plugin in ipairs(vim.g.base46Cfg.integrations) do
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
  Save2File(code, vim.g.base46Cfg.cachePath .. theme)
end

function M.GetThemeList()
  local themes = {}
  local themeList = vim.g.base46Cfg.themeList

  if vim.fn.filereadable(themeList) == 1 then
    themes = LoadFile2Json(themeList)
  else
    local files = vim.api.nvim_get_runtime_file("lua/base46/themes/*.lua", true)
    for _, path in ipairs(files) do
      local theme = {}
      theme.name = vim.fn.fnamemodify(path, ":t:r")
      local themeColors = require("base46.themes." .. theme.name)
      theme.type = themeColors.type
      table.insert(themes, theme)
    end
    SaveJson2File(themes, themeList)
  end

  return themes
end

function M.SetTheme(theme, save)
  local themeColors = require("base46.themes." .. theme)
  local background = themeColors.type
  ChangeConfig({ theme = { [background] = theme } })
  M.SetBackground(background, true)
  if save then
    SaveJson2File(vim.g.base46Cfg.theme, vim.g.base46Cfg.themeCfg)
  end
end

function M.GetCurrentTheme()
  local background = vim.g.base46Cfg.theme.background
  return vim.g.base46Cfg.theme[background]
end

function M.ResetTheme()
  LoadThemeConf()
  M.SetBackground(vim.g.base46Cfg.theme.background, true)
end

function M.Preview()
  local themes = M.GetThemeList()
  local items = {}
  local longest_name = 1
  local path = vim.fn.stdpath("data")
  local previewFile = string.format("%s/lazy/base46/preview.md", path)

  local present, snacks = pcall(require, "snacks")
  if not present then
    vim.notify("you need to install snakcs.nvim first", error)
    return
  end

  -- 准备 items 数据，并计算最长名称用于格式化
  for i, theme in ipairs(themes) do
    table.insert(items, {
      idx = i,
      text = string.format("%s (%s)", theme.name, theme.type),
      name = theme.name,
      file = previewFile,
      score = i,
    })
    longest_name = math.max(longest_name, #theme.name)
  end

  longest_name = longest_name + 2

  local current = M.GetCurrentTheme()
  local showed = false
  snacks().picker({
    items = items,
    title = "Themes",
    format = function(item)
      local ret = {}
      -- 第一列：名称，左对齐并填充空格
      ret[#ret + 1] = { string.format("%-" .. longest_name .. "s", item.name), "SnacksPickerMatch" } -- 使用特定高亮组
      -- 第二列：路径
      ret[#ret + 1] = { item.text, "Comment" } -- 使用 Comment 高亮组
      return ret
    end,

    on_change = function(_, selection)
      if showed then
        M.SetTheme(selection.name, false)
      end
    end,

    on_show = function(picker)
      local selected = nil
      for _, item in ipairs(items) do
        if item.name == current then
          selected = item.idx
        end
      end
      if selected ~= nil then
        picker.list:scroll(selected - 1)
      end
      showed = true
    end,

    on_close = function(_)
      M.ResetTheme()
    end,

    actions = {
      confirm = function(picker, selected)
        M.SetTheme(selected.name, true)
        picker:close()
      end,
    },
  })
end

return M
