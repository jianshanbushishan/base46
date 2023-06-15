local M = {}

M.get_valid_theme = function()
  local themes = vim.api.nvim_get_runtime_file("lua/base46/themes/*.lua", true)

  for _, file in ipairs(themes) do
    local filename = vim.fn.fnamemodify(file, ":t:r")
    return filename
  end

  return ""
end

M.get_theme_tb = function(type)
  local config = require("base46.config").get()
  local default_path = "base46.themes." .. config.current_theme

  -- local present1, default_theme = pcall(require, default_path)
  local default_theme = require(default_path)
  if default_theme then
    return default_theme[type]
  else
    vim.notify("No such theme bruh >_< ", vim.log.levels.ERROR, { title = "Base46.nvim" })
  end
end

M.merge_tb = function(table1, table2)
  return vim.tbl_deep_extend("force", table1, table2)
end

M.turn_str_to_color = function(tb_in)
  local tb = vim.deepcopy(tb_in)
  local colors = M.get_theme_tb("base_30")

  for _, groups in pairs(tb) do
    for k, v in pairs(groups) do
      if k == "fg" or k == "bg" then
        if v:sub(1, 1) == "#" or v == "none" or v == "NONE" then
        else
          groups[k] = colors[v]
        end
      end
    end
  end

  return tb
end

M.extend_default_hl = function(highlights)
  local polish_hl = M.get_theme_tb("polish_hl")

  -- polish themes
  if polish_hl then
    for key, value in pairs(polish_hl) do
      if highlights[key] then
        highlights[key] = M.merge_tb(highlights[key], value)
      end
    end
  end

  local config = require("base46.config").get()
  if config.highlight.hl_override then
    local overriden_hl = M.turn_str_to_color(config.highlight.hl_override)

    for key, value in pairs(overriden_hl) do
      if highlights[key] then
        highlights[key] = M.merge_tb(highlights[key], value)
      end
    end
  end
end

M.load_highlight = function(group)
  group = require("base46.integrations." .. group)
  M.extend_default_hl(group)
  return group
end

-- convert table into string
M.table_to_str = function(tb)
  local result = ""

  for hlgroupName, hlgroup_vals in pairs(tb) do
    local hlname = "'" .. hlgroupName .. "',"
    local opts = ""

    for optName, optVal in pairs(hlgroup_vals) do
      local valueInStr = ((type(optVal)) == "boolean" or type(optVal) == "number") and tostring(optVal)
        or '"' .. optVal .. '"'
      opts = opts .. optName .. "=" .. valueInStr .. ","
    end

    result = result .. "vim.api.nvim_set_hl(0," .. hlname .. "{" .. opts .. "})"
  end

  return result
end

M.save_to_cache = function(filename, tb)
  -- Thanks to https://github.com/EdenEast/nightfox.nvim
  -- It helped me understand string.dump stuff

  local config = require("base46.config").get()

  local lines = 'require("base46").compiled = string.dump(function()' .. M.table_to_str(tb) .. "end)"
  local file = io.open(config.cacheroot .. filename, "wb")

  loadstring(lines, "=")()

  if file then
    file:write(require("base46").compiled)
    file:close()
  end
end

M.compile = function()
  -- All integration modules, each file returns a table
  local hl_files = vim.api.nvim_get_runtime_file("lua/base46/integrations/*.lua", true)
  local config = require("base46.config").get()

  for _, file in ipairs(hl_files) do
    local filename = vim.fn.fnamemodify(file, ":t:r")
    local integration = M.load_highlight(filename)

    -- merge new hl groups added by users
    if filename == "defaults" then
      integration = M.merge_tb(integration, (M.turn_str_to_color(config.highlight.hl_add)))
    end

    M.save_to_cache(filename, integration)
  end

  local ex_files = vim.api.nvim_get_runtime_file("lua/base46/extended_integrations/*.lua", true)
  for _, integration in ipairs(ex_files) do
    local filename = vim.fn.fnamemodify(integration, ":t:r")
    M.save_to_cache(filename, require("base46.extended_integrations." .. filename))
  end

  local bg_file = io.open(config.cacheroot .. "bg", "wb")

  if bg_file then
    bg_file:write("vim.opt.bg='" .. M.get_theme_tb("type") .. "'")
    bg_file:close()
  end
end

M.create_highlight_for_preview = function(namespace, bufnr, pos)
  local config = require("base46.config").get()
  local filepath = config.cachepath .. "colors.json"
  local colors = {}
  if vim.fn.filereadable(filepath) == 0 then
    colors = M.export_colors()
  else
    local f = io.open(filepath, "r")
    if f == nil then
      return
    end

    local content = f:read("*a")
    f:close()

    colors = vim.json.decode(content)
  end

  for theme, color in pairs(colors) do
    local hl_name = M.get_hl_name(theme)
    vim.api.nvim_set_hl(0, hl_name, { fg = color.fg, bg = color.bg })
    vim.api.nvim_buf_add_highlight(bufnr, namespace, hl_name, pos[theme], 0, -1)
  end
end

M.get_hl_name = function(theme)
  local hl_name = "Preview_%s"
  hl_name = hl_name:format(theme:gsub("-", "_"))
  return hl_name
end

M.export_colors = function()
  local themes = vim.api.nvim_get_runtime_file("lua/base46/themes/*.lua", true)

  local colors = {}
  for _, file in ipairs(themes) do
    local theme = vim.fn.fnamemodify(file, ":t:r")
    local color = require("base46.themes." .. theme).base_16
    colors[theme] = { bg = color.base00, fg = color.base05 }
  end

  local config = require("base46.config").get()
  local content = vim.json.encode(colors)
  local f = io.open(config.cachepath .. "colors.json", "w")
  if f then
    f:write(content)
    f:close()
  end

  return colors
end

M.load_all_highlights = function()
  require("plenary.reload").reload_module("base46")
  M.compile()

  local config = require("base46.config").get()
  for _, file in ipairs(vim.fn.readdir(config.cacheroot)) do
    M.set_highlight(file)
  end
end

M.override_theme = function(default_theme, theme_name)
  local config = require("base46.config").get()
  local changed_themes = config.changed_themes

  if changed_themes[theme_name] then
    return M.merge_tb(default_theme, changed_themes[theme_name])
  else
    return default_theme
  end
end

M.set_highlight = function(plugin)
  local config = require("base46.config").get()
  loadfile(config.cacheroot .. plugin)()
end

return M
