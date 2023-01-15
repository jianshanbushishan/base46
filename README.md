## 简介
我很喜欢nvchad中的neovim主题，但在使用nvchad的过程中，经常遇到新增插件后，由于配置不当，导致nvchad启动失败，而没有任何报错，即使把修改还原后由于缓存的存在依然会导致启动失败。

在看到lazy.nvim并体验过之后，产生了把所有插件用lazy.nvim重新配置下的想法，在选择配色方案的时候，对nvchad的ui和主题念念不忘，于是决定把它从nvchad中抽取出来变成一个独立的插件。

在抽取完成后，又针对主题的使用产生了一些新的想法：
1. 支持类似vscode的light/dark主题配置和自动切换（配合autodark的脚本和fwatch的文件监控可以做到）
2. 支持侧边栏的形式预览主题效果，nvchad中是用telescope做预览不是很好用（看不到各种文件类型的代码在该主题下的高亮效果）。
3. 支持根据文件类型自动显示不同的主题

## 配置
lazy.nvim中的配置
```lua
local M = {
  {
    "jianshanbushishan/nvchad_ui",
    lazy = false,
    priority = 900,
    opts = {
      cmp = {
        icons = true,
        lspkind_text = true,
        style = "default", -- default/flat_light/flat_dark/atom/atom_colored
        border_color = "grey_fg", -- only applicable for "default" style, use color names from base30 variables
        selected_item_bg = "colored", -- colored / simple
      },

      statusline = {
        theme = "default", -- default/vscode/vscode_colored/minimal
        -- default/round/block/arrow separators work only for default statusline theme
        -- round and block will work for minimal theme only
        separator_style = "default",
        overriden_modules = nil,
      },

      tabufline = {
        enabled = true,
        lazyload = true, -- lazyload it when there are 1+ buffers
        overriden_modules = nil,
      },

      tree_side = require("plugins.nvimtree").opts.view.side,
    },
  },
  {
    "jianshanbushishan/base46",
    lazy = false,
    priority = 1000,
    dependencies = { "rktjmp/fwatch.nvim" },

    init = function()
      vim.keymap.set("n", "<leader>tp", "<cmd>lua require('base46').preview()<cr>")
    end,

    opts = {
      autoswitch = true, --depend on fwatch
      theme = {
        light = "one_light",
        dark = "onedark",
        background = "dark",
      },

      ft = {
        c = {dark="vscode_dark"},
      },

      highlight = {
        hl_add = {
          NvimTreeOpenedFile = { fg = "teal", },
        },
        hl_override = {
          CursorLine = {
            bg = "black2",
          },
          Comment = {
            italic = true,
          },
          NvimTreeCursorLine = { fg = "green", underline = true, italic = true },
          NvimTreeOpenedFolderName = { fg = "green", },
        },
      },

      changed_themes = {},

      integrations = {
        "statusline",
        "cmp",
        "defaults",
        "treesitter",
        "devicons",
        -- "git",
        "telescope",
        "syntax",
        "tbline",
        "lsp",
        "notify",
        "nvimtree",
        "mason",
        "blankline",
      },
    },
  },
}

return M
```
windows autodark用于自动修改light/dark的python脚本
```python
import sys
import json

vim_theme = "c:\\Users\\xxx\\AppData\\Local\\nvim-data\\theme.conf"
with open(vim_theme, encoding="utf8", mode="r") as f:
    content = json.loads(f.read())

    content["background"] = sys.argv[-1]
    with open(vim_theme, encoding="utf8", mode="w") as f:
        f.write(json.dumps(content))
```

