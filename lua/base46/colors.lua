local M = {}

local function clamp(value, min_value, max_value)
  if value < min_value then
    return min_value
  end

  if value > max_value then
    return max_value
  end

  return value
end

local function normalize_hex(hex)
  if type(hex) ~= "string" then
    return nil
  end

  local normalized = hex:gsub("^#", "")
  if #normalized ~= 6 or normalized:find("[^%x]") then
    return nil
  end

  return normalized:lower()
end

function M.hex2rgb(hex)
  local normalized = normalize_hex(hex)
  if not normalized then
    return nil
  end

  return tonumber(normalized:sub(1, 2), 16), tonumber(normalized:sub(3, 4), 16), tonumber(normalized:sub(5, 6), 16)
end

function M.rgb2hex(r, g, b)
  r = clamp(math.floor((r or 0) + 0.5), 0, 255)
  g = clamp(math.floor((g or 0) + 0.5), 0, 255)
  b = clamp(math.floor((b or 0) + 0.5), 0, 255)
  return string.format("#%02x%02x%02x", r, g, b)
end

local function hsl2rgb_helper(p, q, a)
  if a < 0 then
    a = a + 6
  end

  if a >= 6 then
    a = a - 6
  end

  if a < 1 then
    return (q - p) * a + p
  end

  if a < 3 then
    return q
  end

  if a < 4 then
    return (q - p) * (4 - a) + p
  end

  return p
end

M.hsl2rgb_helper = hsl2rgb_helper

function M.hsl2rgb(h, s, l)
  h = (h or 0) / 60
  s = clamp(s or 0, 0, 1)
  l = clamp(l or 0, 0, 1)

  local t2
  if l <= 0.5 then
    t2 = l * (s + 1)
  else
    t2 = l + s - (l * s)
  end

  local t1 = l * 2 - t2
  return hsl2rgb_helper(t1, t2, h + 2) * 255, hsl2rgb_helper(t1, t2, h) * 255, hsl2rgb_helper(t1, t2, h - 2) * 255
end

function M.rgb2hsl(r, g, b)
  r = clamp((r or 0) / 255, 0, 1)
  g = clamp((g or 0) / 255, 0, 1)
  b = clamp((b or 0) / 255, 0, 1)

  local min_value = math.min(r, g, b)
  local max_value = math.max(r, g, b)
  local delta = max_value - min_value
  local h = 0
  local s = 0
  local l = (max_value + min_value) / 2

  if delta == 0 then
    return h, s, l
  end

  if max_value == r then
    h = ((g - b) / delta) % 6
  elseif max_value == g then
    h = ((b - r) / delta) + 2
  else
    h = ((r - g) / delta) + 4
  end

  h = h * 60

  if l < 0.5 then
    s = delta / (max_value + min_value)
  else
    s = delta / (2 - max_value - min_value)
  end

  return h, s, l
end

function M.hex2hsl(hex)
  local r, g, b = M.hex2rgb(hex)
  if r == nil then
    return nil
  end

  return M.rgb2hsl(r, g, b)
end

function M.hsl2hex(h, s, l)
  local r, g, b = M.hsl2rgb(h, s, l)
  return M.rgb2hex(r, g, b)
end

local function adjust_hex_hsl(hex, field, amount, min_value, max_value)
  local h, s, l = M.hex2hsl(hex)
  if h == nil then
    return nil
  end

  if field == "h" then
    h = clamp(h + ((amount or 0) / 100), min_value, max_value)
  elseif field == "s" then
    s = clamp(s + ((amount or 0) / 100), min_value, max_value)
  else
    l = clamp(l + ((amount or 0) / 100), min_value, max_value)
  end

  return M.hsl2hex(h, s, l)
end

function M.change_hex_hue(hex, percent)
  return adjust_hex_hsl(hex, "h", percent, 0, 360)
end

function M.change_hex_saturation(hex, percent)
  return adjust_hex_hsl(hex, "s", percent, 0, 1)
end

function M.change_hex_lightness(hex, percent)
  return adjust_hex_hsl(hex, "l", percent, 0, 1)
end

function M.compute_gradient(hex1, hex2, steps)
  steps = math.max(math.floor(steps or 0), 0)
  if steps == 0 then
    return {}
  end

  if steps == 1 then
    return { hex1 }
  end

  local h1, s1, l1 = M.hex2hsl(hex1)
  local h2, s2, l2 = M.hex2hsl(hex2)
  if h1 == nil or h2 == nil then
    return {}
  end

  local gradient = {}
  local h_step = (h2 - h1) / (steps - 1)
  local s_step = (s2 - s1) / (steps - 1)
  local l_step = (l2 - l1) / (steps - 1)

  for index = 0, steps - 1 do
    gradient[index + 1] = M.hsl2hex(h1 + (h_step * index), s1 + (s_step * index), l1 + (l_step * index))
  end

  return gradient
end

M.gradient = M.compute_gradient

return M
