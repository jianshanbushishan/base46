local M = {}

M.cfg = function()
  return vim.g.base46_config
end

M.get_theme_tb = function(type)
  local default_path = "base46.themes." .. vim.g.base46_config.current_theme

  -- local present1, default_theme = pcall(require, default_path)
  local default_theme = require(default_path)
  if default_theme then
    return default_theme[type]
  else
    error("No such theme bruh >_< ")
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

  if vim.g.base46_config.highlight.hl_override then
    local overriden_hl = M.turn_str_to_color(vim.g.base46_config.highlight.hl_override)

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
      local valueInStr = ((type(optVal)) == "boolean" or type(optVal) == "number")
          and tostring(optVal)
        or '"' .. optVal .. '"'
      opts = opts .. optName .. "=" .. valueInStr .. ","
    end

    result = result .. "vim.api.nvim_set_hl(0," .. hlname .. "{" .. opts .. "})"
  end

  return result
end

M.saveStr_to_cache = function(filename, tb)
  -- Thanks to https://github.com/EdenEast/nightfox.nvim
  -- It helped me understand string.dump stuff

  local cachepath = vim.g.base46_config.cacheroot
  local lines = 'require("base46").compiled = string.dump(function()'
    .. M.table_to_str(tb)
    .. "end)"
  local file = io.open(cachepath .. filename, "wb")

  loadstring(lines, "=")()

  if file then
    file:write(require("base46").compiled)
    file:close()
  end
end

M.compile = function()
  -- All integration modules, each file returns a table
  local hl_files = vim.g.base46_config.pkgpath .. "/lua/base46/integrations"

  for _, file in ipairs(vim.fn.readdir(hl_files)) do
    local filename = vim.fn.fnamemodify(file, ":r")
    local integration = M.load_highlight(filename)

    -- merge new hl groups added by users
    if filename == "defaults" then
      integration = M.merge_tb(integration, (M.turn_str_to_color(vim.g.base46_config.highlight.hl_add)))
    end

    M.saveStr_to_cache(filename, integration)
  end

  local bg_file = io.open(vim.g.base46_config.cacheroot .. "bg", "wb")

  if bg_file then
    bg_file:write("vim.opt.bg='" .. M.get_theme_tb("type") .. "'")
    bg_file:close()
  end
end

M.load_all_highlights = function()
  require("plenary.reload").reload_module("base46")
  M.compile()

  for _, file in ipairs(vim.fn.readdir(vim.g.base46_config.cacheroot)) do
    M.set_highlight(file)
  end
end

M.override_theme = function(default_theme, theme_name)
  local changed_themes = vim.g.base46_config.changed_themes

  if changed_themes[theme_name] then
    return M.merge_tb(default_theme, changed_themes[theme_name])
  else
    return default_theme
  end
end

M.set_background = function(background)
  if vim.g.base46_config.theme.background == background then
    return
  end

  if background ~= "light" and background ~= "dark" then
    error("Invalid background val: " .. background)
    return
  end

  vim.g.base46_config.theme.background = background
  local theme = M.theme[vim.g.base46_config.theme.background]
  M.load_theme(theme)
end

M.load_theme = function(theme)
  local root = vim.g.base46_config.cachepath .. "/" .. theme .. "/"
  vim.g.base46_config = vim.tbl_deep_extend('force', vim.g.base46_config, {current_theme = theme, cacheroot = root})

  local f = io.open(root .. "bg", "r")
  if f == nil then
    vim.fn.mkdir(root, "p")
    require("base46").load_all_highlights()
  else
    io.close(f)
    M.set_highlight("defaults")
    M.set_highlight("statusline")
    for _, plugin in ipairs(vim.g.base46_config.integrations) do
      M.set_highlight(plugin)
    end
  end
end

M.set_highlight = function(plugin)
  loadfile(vim.g.base46_config.cacheroot .. plugin)()
end

M.setup = function(opts)
  local config = require("base46.config")
  vim.g.base46_config = vim.tbl_deep_extend('force', config, opts or {})

  local theme = vim.g.base46_config.theme[vim.g.base46_config.theme.background]
  M.load_theme(theme)
end

return M
