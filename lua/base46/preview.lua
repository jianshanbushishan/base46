local fs = require("base46.fs")

local M = {}

local function get_preview_file()
  local matches = vim.api.nvim_get_runtime_file("preview.md", false)
  if #matches > 0 then
    return matches[1]
  end

  return fs.join_path(vim.fn.stdpath("data"), "lazy/base46/preview.md")
end

function M.open(themes, current, callbacks, notify_error)
  local present, snacks = pcall(require, "snacks")
  if not present then
    if notify_error then
      notify_error("You need to install snacks.nvim first.")
    end
    return
  end

  local items = {}
  local longest_name = 1
  local preview_file = get_preview_file()

  for index, theme in ipairs(themes) do
    items[#items + 1] = {
      idx = index,
      text = string.format("%s (%s)", theme.name, theme.type),
      name = theme.name,
      file = preview_file,
      score = index,
    }
    longest_name = math.max(longest_name, #theme.name)
  end

  longest_name = longest_name + 2

  local showed = false
  snacks.picker({
    items = items,
    title = "Themes",
    format = function(item)
      return {
        { string.format("%-" .. longest_name .. "s", item.name), "SnacksPickerMatch" },
        { item.text, "Comment" },
      }
    end,

    on_change = function(_, selection)
      if showed and selection then
        callbacks.preview(selection.name)
      end
    end,

    on_show = function(picker)
      local selected
      for _, item in ipairs(items) do
        if item.name == current then
          selected = item.idx
          break
        end
      end

      if selected ~= nil then
        picker.list:scroll(selected - 1)
      end

      showed = true
    end,

    on_close = function()
      callbacks.reset()
    end,

    actions = {
      confirm = function(picker, selected)
        if selected then
          callbacks.confirm(selected.name)
        end
        picker:close()
      end,
    },
  })
end

return M
