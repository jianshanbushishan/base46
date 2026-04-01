local colors = require("base46.colors")
local colorize = colors.change_hex_lightness
local saturate = colors.change_hex_saturation

local M = {}

-- Helper to convert hex to RGB
local function hexToRgb(hex)
  if not hex or type(hex) ~= "string" then
    return 0, 0, 0
  end
  hex = hex:gsub("#", "")
  if #hex ~= 6 then
    return 0, 0, 0
  end
  return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
end

-- Helper to blend two hex colors together
local function blend(fg, bg, alpha)
  local fg_r, fg_g, fg_b = hexToRgb(fg)
  local bg_r, bg_g, bg_b = hexToRgb(bg)
  local r = math.floor(alpha * fg_r + (1 - alpha) * bg_r)
  local g = math.floor(alpha * fg_g + (1 - alpha) * bg_g)
  local b = math.floor(alpha * fg_b + (1 - alpha) * bg_b)
  return string.format("#%02X%02X%02X", r, g, b)
end

local function shift(hex, lightness, saturation)
  local new_hex = hex

  if saturation and saturation ~= 0 then
    new_hex = saturate(new_hex, saturation) or new_hex
  end

  if lightness and lightness ~= 0 then
    new_hex = colorize(new_hex, lightness) or new_hex
  end

  return new_hex
end

local function pick(base30, names)
  for _, name in ipairs(names) do
    if base30[name] then
      return base30[name]
    end
  end

  return base30.white
end

function M.GetHighlight(themeColors)
  local base30 = themeColors.base_30
  local isLight = themeColors.type == "light"

  local statusline_bg = base30.statusline_bg or base30.black

  -- In NvChad, base30.white is the primary text color (dark in light theme, light in dark theme)
  local text_fg = base30.white

  -- Create a perfect subtle foreground by blending the main text color with the background
  local subtle_fg = blend(text_fg, statusline_bg, 0.6)

  -- For colorful backgrounds, we use base30.black as foreground to guarantee high contrast
  -- (base30.black is light in light themes, dark in dark themes)
  local contrast_fg = base30.black

  -- Modern & Beautiful: Subtle tints from accent colors for module backgrounds
  local tint_alpha = isLight and 0.15 or 0.20
  local lsp_bg = blend(base30.blue, statusline_bg, tint_alpha)
  local git_bg = blend(base30.purple, statusline_bg, tint_alpha)
  local cwd_bg = blend(base30.teal, statusline_bg, tint_alpha)

  -- Neutral background to break up accent colors
  local neutral_bg = base30.one_bg or base30.one_bg2

  -- Premium high-contrast anchors
  local pos_bg = base30.blue -- Changed to match Normal Mode feel or use teal
  pos_bg = base30.teal -- Teal looks great for position

  -- Mode colors (solid high-contrast anchors)
  local mode_colors = {
    Normal = base30.blue,
    Insert = base30.green,
    Visual = base30.purple,
    Command = base30.yellow,
    Replace = base30.red,
    Terminal = base30.cyan,
    Select = base30.pink,
    Confirm = base30.teal,
  }

  local hls = {
    StatusLine = { bg = statusline_bg, fg = subtle_fg },
    StatusLineNC = { bg = statusline_bg, fg = subtle_fg },

    -- Sequence Left: Mode -> File -> FileSize -> Git
    -- St_file uses a neutral background to contrast with the Mode's solid accent
    St_file = { fg = text_fg, bg = neutral_bg, bold = true },
    St_file_sep = { fg = neutral_bg, bg = statusline_bg },

    -- FileSize is flat on the background for a modern look
    St_filesize = { fg = subtle_fg, bg = statusline_bg },

    -- Git uses a purple tint
    St_git = { fg = text_fg, bg = git_bg },
    St_gitIcons = { fg = base30.purple, bg = git_bg, bold = true },
    St_git_sep = { fg = git_bg, bg = statusline_bg },

    -- Sequence Right: LSP -> CWD -> LineCol -> Position
    -- LSP uses a blue tint
    St_Lsp = { fg = text_fg, bg = lsp_bg, bold = true },
    St_LspMsg = { fg = subtle_fg, bg = lsp_bg },
    St_Lsp_sep = { fg = lsp_bg, bg = statusline_bg },

    -- CWD uses a teal tint
    St_cwd_text = { fg = text_fg, bg = cwd_bg },
    St_cwd_icon = { fg = base30.teal, bg = cwd_bg, bold = true },
    St_cwd_sep = { fg = cwd_bg, bg = statusline_bg },

    -- LineCol uses a neutral background to break up the teal tints
    St_linecol = { fg = text_fg, bg = neutral_bg },
    St_linecol_sep = { fg = neutral_bg, bg = statusline_bg },

    -- Position is a solid high-contrast anchor
    St_pos = { fg = contrast_fg, bg = pos_bg, bold = true },
    St_pos_sep = { fg = pos_bg, bg = statusline_bg },
    St_pos_icon = { fg = contrast_fg, bg = pos_bg, bold = true },
    St_pos_text = { fg = contrast_fg, bg = pos_bg, bold = true },

    St_cursor = { fg = contrast_fg, bg = pos_bg, bold = true },

    -- Diagnostics on main background
    St_diagnostics = { bg = statusline_bg },
    St_lspError = { fg = base30.red, bg = statusline_bg },
    St_lspWarning = { fg = base30.yellow, bg = statusline_bg },
    St_LspHints = { fg = base30.purple, bg = statusline_bg },
    St_LspInfo = { fg = base30.cyan, bg = statusline_bg },

    St_EmptySpace = { bg = statusline_bg },
  }

  -- Generate mode highlights dynamically
  for mode, color in pairs(mode_colors) do
    hls["St_" .. mode .. "Mode"] = { fg = contrast_fg, bg = color, bold = true }
    hls["St_" .. mode .. "ModeSep"] = { fg = color, bg = statusline_bg }
  end

  return hls
end

return M
