local M = {}

M.set_background = function(background)
  local config = require("base46.config").get()
  if config.cur_background == background then
    return
  end

  if background ~= "light" and background ~= "dark" then
    error("Invalid background val: " .. background)
    background = "light"
  end

  require("base46.config").update({ cur_background = background })
  local theme = config.theme[background]
  M.load_theme(theme)
end

M.load_theme = function(theme)
  if theme == nil then
    local valid = require("base46.utils").get_valid_theme()
    if valid == "" then
      error("ERR: no themes installed.")
      return
    else
      print("invalid theme: " .. theme .. ", set theme to " .. valid)
      theme = valid
    end
  end

  local config = require("base46.config").get()
  local root = config.cachepath .. "/" .. theme .. "/"
  require("base46.config").update({ current_theme = theme, cacheroot = root })

  local f = io.open(root .. "bg", "r")
  local utils = require("base46.utils")
  if f == nil then
    vim.fn.mkdir(root, "p")
    utils.load_all_highlights()
  else
    local content = f:read("*l")
    local background = content:gmatch("'(.*)'")()
    if background ~= "light" and background ~= "dark" then
      error("Invalid background val: " .. background .. " with theme: " .. theme)
      background = "light"
    end
    io.close(f)

    utils.set_highlight("defaults")
    utils.set_highlight("statusline")
    for _, plugin in ipairs(config.integrations) do
      utils.set_highlight(plugin)
    end
    require("base46.config").update({ cur_background = background })
  end
end

M.load_conf = function(f)
  local content = f:read("*a")
  local opts = vim.json.decode(content)
  io.close(f)
  require("base46.config").update({theme = opts,})
end

M.setup = function(opts)
  local config = require("base46.config").init(opts)
  local f = io.open(config.themecfg, "r")
  if f ~= nil then
    M.load_conf(f)
  else
    local f = io.open(config.themecfg, "w")
    f:write(vim.json.encode(config.theme))
    io.close(f)
  end

  if opts.autoswitch then
    local fwatch = require("fwatch")
    local defer = nil
    fwatch.watch(config.themecfg, {
      on_event = function()
        if not defer then -- only set once in window
          defer = vim.defer_fn(function()
            defer = nil
            local f = io.open(config.themecfg, "r")
            if f ~= nil then
              M.load_conf(f)
              config = require("base46.config").get() 
              M.set_background(config.theme.background)
            end
          end, 100)
        end
      end,
    })
  end

  config = require("base46.config").get() 
  M.set_background(config.theme.background)
end

M.switch_background = function()
  local background = "light"
  local config = require("base46.config").get()
  if config.cur_background == "light" then
    background = "dark"
  end
  require("base46").set_background(background)
end

return M
