local M = {}

local error = vim.log.levels.ERROR
M.set_background = function(background)
  local config = require("base46.config").get()
  if config.cur_background == background then
    return
  end

  if background ~= "light" and background ~= "dark" then
    local msg = "Invalid background val: " .. background
    vim.notify(msg, error, { title = "Base46.nvim" })
    background = "light"
  end

  require("base46.config").update({ cur_background = background })
  vim.opt.background = background
  local theme = M.get_theme_by_filetype()
  M.load_theme(theme)
end

M.load_theme = function(theme)
  if theme == nil then
    local valid = require("base46.utils").get_valid_theme()
    if valid == "" then
      local msg = "ERR: no themes installed."
      vim.notify(msg, error, { title = "Base46.nvim" })
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
      local msg = "Invalid background val: " .. background .. " with theme: " .. theme
      vim.notify(msg, error, { title = "Base46.nvim" })
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
  require("base46.config").update({ theme = opts })
end

M.setup = function(opts)
  local config = require("base46.config").init(opts)
  local f = io.open(config.themecfg, "r")
  if f ~= nil then
    M.load_conf(f)
  else
    f = io.open(config.themecfg, "w")
    if f ~= nil then
      f:write(vim.json.encode(config.theme))
      io.close(f)
    end
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
              local fc = io.open(config.themecfg, "r")
              if fc ~= nil then
                M.load_conf(fc)
                config = require("base46.config").get()
                M.set_background(config.theme.background)
              end
            end, 100)
          end
        end,
      })
    end
  end

  vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function()
      if vim.bo.filetype ~= "preview" then
        local theme = M.get_theme_by_filetype()
        M.load_theme(theme)
      end
    end,
  })

  config = require("base46.config").get()
  M.set_background(config.theme.background)
  require("base46.term")
end

M.get_theme_by_filetype = function()
  local config = require("base46.config").get()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" and config.current_theme then
    return config.current_theme
  end

  local filetype = vim.bo.filetype
  local background = config.cur_background
  if vim.tbl_get(config.ft, filetype) then
    local conf = config.ft[filetype]
    if vim.tbl_get(conf, background) then
      return conf[background]
    end
  end

  return config.theme[background]
end

M.switch_background = function()
  local background = "light"
  local config = require("base46.config").get()
  if config.cur_background == "light" then
    background = "dark"
  end
  M.set_background(background)
end

M.preview = function()
  local preview = require("base46.preview")
  preview.open_themes_list()
end

return M
