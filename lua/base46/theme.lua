local autoswitch = require("base46.autoswitch")
local compiler = require("base46.compiler")
local config = require("base46.config")
local fs = require("base46.fs")
local preview = require("base46.preview")

local M = {}

local error_level = vim.log.levels.ERROR
local notify_title = "base46.nvim"

local theme_list_cache

local function notify_error(message)
  vim.notify(message, error_level, { title = notify_title })
end

function M.SetBackground(background, force, save)
  background = config.validate_background(background, notify_error)
  if vim.opt.background:get() == background and not force then
    return
  end

  local theme = config.get().theme[background]
  if theme == nil then
    notify_error(string.format("No theme configured for background '%s'", background))
    return
  end

  config.merge({ theme = { background = background } })
  vim.opt.background = background

  vim.cmd("highlight clear")
  if not compiler.load_theme(theme, config.get(), notify_error) then
    return
  end

  vim.cmd("doautocmd ColorScheme")

  if save then
    config.save_theme_conf(notify_error)
  end
end

function M.LoadTheme(theme)
  return compiler.load_theme(theme, config.get(), notify_error)
end

function M.Compile(theme)
  return compiler.compile(theme, config.get(), notify_error)
end

function M.setup(opts)
  config.setup(opts)

  if not config.load_theme_conf(notify_error) then
    config.save_theme_conf(notify_error)
  end

  if config.get().autoswitch then
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        autoswitch.start(config.get().themeCfg, function()
          if config.load_theme_conf(notify_error) then
            M.SetBackground(config.get().theme.background, true)
          end
        end, notify_error)
      end,
      once = true,
    })
  end

  M.SetBackground(config.get().theme.background, true)
end

function M.SwitchBackground()
  local background = "light"
  if vim.opt.background:get() == "light" then
    background = "dark"
  end

  M.SetBackground(background, false, true)
end

function M.GetThemeList()
  if theme_list_cache ~= nil then
    return vim.deepcopy(theme_list_cache)
  end

  local themes = fs.read_json_file(config.get().themeList, {}, notify_error)
  if vim.tbl_isempty(themes) then
    themes = {}

    for _, path in ipairs(vim.api.nvim_get_runtime_file("lua/base46/themes/*.lua", true)) do
      local name = vim.fn.fnamemodify(path, ":t:r")
      local theme_colors = compiler.get_theme_colors(name, config.get(), notify_error)
      if theme_colors ~= nil then
        themes[#themes + 1] = {
          name = name,
          type = theme_colors.type,
        }
      end
    end

    table.sort(themes, function(left, right)
      return left.name < right.name
    end)

    fs.write_json_file(themes, config.get().themeList, notify_error)
  end

  theme_list_cache = themes
  return vim.deepcopy(theme_list_cache)
end

function M.SetTheme(theme, save)
  local theme_colors = compiler.get_theme_colors(theme, config.get(), notify_error)
  if not theme_colors then
    return
  end

  local background = config.validate_background(theme_colors.type, notify_error)
  config.merge({ theme = { [background] = theme } })
  M.SetBackground(background, true)

  if save then
    config.save_theme_conf(notify_error)
  end
end

function M.GetCurrentTheme()
  local background = config.get().theme.background
  return config.get().theme[background]
end

function M.ResetTheme()
  config.load_theme_conf(notify_error)
  M.SetBackground(config.get().theme.background, true)
end

function M.Preview()
  preview.open(M.GetThemeList(), M.GetCurrentTheme(), {
    preview = function(theme)
      M.SetTheme(theme, false)
    end,
    confirm = function(theme)
      M.SetTheme(theme, true)
    end,
    reset = function()
      M.ResetTheme()
    end,
  }, notify_error)
end

return M
