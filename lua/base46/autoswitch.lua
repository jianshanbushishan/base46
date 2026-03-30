local M = {}

local watched_theme_cfg

function M.start(theme_cfg, on_change, notify_error)
  if watched_theme_cfg == theme_cfg then
    return
  end

  local present, fwatch = pcall(require, "fwatch")
  if not present then
    if notify_error then
      notify_error("Autoswitch depends on fwatch.nvim, install it first.")
    end
    return
  end

  local debounce
  fwatch.watch(theme_cfg, {
    on_event = function()
      if debounce then
        return
      end

      debounce = vim.defer_fn(function()
        debounce = nil
        on_change()
      end, 100)
    end,
  })

  watched_theme_cfg = theme_cfg
end

return M
