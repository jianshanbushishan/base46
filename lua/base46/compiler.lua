local fs = require("base46.fs")
local term = require("base46.term")

local M = {}

local module_cache = {
  themes = {},
  integrations = {},
}

local compiled_signatures = {}

local color_keys = {
  fg = true,
  bg = true,
  sp = true,
  ctermfg = true,
  ctermbg = true,
}

local function report_error(notify_error, message)
  if notify_error then
    notify_error(message)
  end
end

local function get_theme_cache_path(cfg, theme)
  return fs.join_path(cfg.cachePath, theme)
end

local function get_theme_module(theme, notify_error)
  if module_cache.themes[theme] ~= nil then
    return module_cache.themes[theme]
  end

  local ok, theme_mod = pcall(require, "base46.themes." .. theme)
  if not ok then
    report_error(notify_error, string.format("Failed to load theme '%s': %s", theme, theme_mod))
    return nil
  end

  module_cache.themes[theme] = theme_mod
  return theme_mod
end

function M.get_theme_colors(theme, cfg, notify_error)
  local theme_mod = get_theme_module(theme, notify_error)
  if not theme_mod then
    return nil
  end

  local changed_themes = cfg.changed_themes or {}
  local overrides = changed_themes[theme]
  if overrides == nil then
    return theme_mod
  end

  return vim.tbl_deep_extend("force", vim.deepcopy(theme_mod), overrides)
end

local function get_integration_module(name, notify_error)
  if module_cache.integrations[name] ~= nil then
    return module_cache.integrations[name]
  end

  local ok, integration_mod = pcall(require, "base46.integrations." .. name)
  if not ok then
    report_error(notify_error, string.format("Failed to load integration '%s': %s", name, integration_mod))
    return nil
  end

  if type(integration_mod) ~= "table" or type(integration_mod.GetHighlight) ~= "function" then
    report_error(notify_error, string.format("Integration '%s' must export GetHighlight()", name))
    return nil
  end

  module_cache.integrations[name] = integration_mod
  return integration_mod
end

local function resolve_palette_color(value, theme_colors)
  if type(value) ~= "string" then
    return value
  end

  if value:lower() == "none" then
    return "NONE"
  end

  local base30 = theme_colors.base_30 or {}
  local base16 = theme_colors.base_16 or {}
  return base30[value] or base16[value] or value
end

local function normalize_highlights(highlights, theme_colors)
  if type(highlights) ~= "table" then
    return {}
  end

  local normalized = {}
  for group, attrs in pairs(highlights) do
    if type(attrs) == "table" then
      normalized[group] = {}
      for key, value in pairs(attrs) do
        if color_keys[key] then
          normalized[group][key] = resolve_palette_color(value, theme_colors)
        else
          normalized[group][key] = value
        end
      end
    else
      normalized[group] = attrs
    end
  end

  return normalized
end

local function merge_user_highlights(highlights, theme_colors, cfg)
  local highlight_cfg = cfg.highlight or {}
  local hl_add = normalize_highlights(highlight_cfg.hl_add, theme_colors)
  local hl_override = normalize_highlights(highlight_cfg.hl_override, theme_colors)

  highlights = vim.tbl_deep_extend("keep", highlights, hl_add)
  return vim.tbl_deep_extend("force", highlights, hl_override)
end

local function build_highlights(theme_colors, cfg, notify_error)
  local highlights = {}

  for _, integration_name in ipairs(cfg.integrations or {}) do
    local integration_mod = get_integration_module(integration_name, notify_error)
    if integration_mod then
      local ok, integration_hls = pcall(integration_mod.GetHighlight, theme_colors)
      if ok then
        highlights = vim.tbl_deep_extend("force", highlights, normalize_highlights(integration_hls, theme_colors))

        local polish_hl = theme_colors.polish_hl and theme_colors.polish_hl[integration_name]
        if polish_hl ~= nil then
          highlights = vim.tbl_deep_extend("force", highlights, normalize_highlights(polish_hl, theme_colors))
        end
      else
        report_error(
          notify_error,
          string.format("Failed to build highlights for '%s': %s", integration_name, integration_hls)
        )
      end
    end
  end

  return merge_user_highlights(highlights, theme_colors, cfg)
end

local function sorted_keys(tbl)
  local keys = {}
  for key in pairs(tbl or {}) do
    keys[#keys + 1] = key
  end

  table.sort(keys)
  return keys
end

local function serialize_lua(value)
  if type(value) == "string" then
    return string.format("%q", value)
  end

  return tostring(value)
end

local function generate_code(highlights, terminal_colors)
  local lines = { "local set_hl = vim.api.nvim_set_hl", "" }

  for _, highlight_group in ipairs(sorted_keys(highlights)) do
    local attrs = {}
    for _, key in ipairs(sorted_keys(highlights[highlight_group])) do
      attrs[#attrs + 1] = string.format("%s = %s", key, serialize_lua(highlights[highlight_group][key]))
    end

    lines[#lines + 1] =
      string.format("set_hl(0, %s, { %s })", serialize_lua(highlight_group), table.concat(attrs, ", "))
  end

  lines[#lines + 1] = ""

  for idx, color in ipairs(terminal_colors or {}) do
    lines[#lines + 1] = string.format("vim.g.terminal_color_%d = %s", idx - 1, serialize_lua(color))
  end

  return table.concat(lines, "\n")
end

local function get_compile_signature(theme, theme_colors, cfg)
  local signature_payload = {
    theme = theme,
    integrations = cfg.integrations,
    changed_theme = cfg.changed_themes and cfg.changed_themes[theme],
    highlight = cfg.highlight,
    polish_hl = theme_colors.polish_hl,
  }

  local ok, encoded = pcall(vim.json.encode, signature_payload)
  if not ok then
    return theme
  end

  return encoded
end

local function compile_theme(theme, cfg, theme_colors, signature, notify_error)
  local highlights = build_highlights(theme_colors, cfg, notify_error)
  local terminal_colors = term.GetHighlight(theme_colors)
  local code = generate_code(highlights, terminal_colors)

  if not fs.write_file(code, get_theme_cache_path(cfg, theme), notify_error) then
    return false
  end

  compiled_signatures[theme] = signature
  return true
end

local function ensure_compiled_theme(theme, cfg, notify_error)
  local theme_colors = M.get_theme_colors(theme, cfg, notify_error)
  if not theme_colors then
    return false
  end

  local signature = get_compile_signature(theme, theme_colors, cfg)
  local cache_path = get_theme_cache_path(cfg, theme)

  if vim.fn.filereadable(cache_path) ~= 1 or compiled_signatures[theme] ~= signature then
    return compile_theme(theme, cfg, theme_colors, signature, notify_error)
  end

  return true
end

function M.load_theme(theme, cfg, notify_error)
  if not ensure_compiled_theme(theme, cfg, notify_error) then
    return false
  end

  local cache_path = get_theme_cache_path(cfg, theme)
  local chunk, load_err = loadfile(cache_path)
  if not chunk then
    report_error(notify_error, string.format("Failed to load compiled theme '%s': %s", theme, load_err))
    return false
  end

  local ok, exec_err = pcall(chunk)
  if not ok then
    report_error(notify_error, string.format("Failed to apply compiled theme '%s': %s", theme, exec_err))
    return false
  end

  return true
end

function M.compile(theme, cfg, notify_error)
  local theme_colors = M.get_theme_colors(theme, cfg, notify_error)
  if not theme_colors then
    return false
  end

  local signature = get_compile_signature(theme, theme_colors, cfg)
  return compile_theme(theme, cfg, theme_colors, signature, notify_error)
end

return M
