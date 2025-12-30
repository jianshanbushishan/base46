# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Base46 is a Neovim color scheme management system extracted from NvChad. It provides dynamic theme compilation, light/dark theme switching with auto-detection, and integrations with 20+ Neovim plugins.

## Development Commands

**Code Formatting:**
```bash
stylua .
```
Uses `.stylua.toml` configuration (120 char width, 2-space indent, Unix line endings).

**No build system** - This is a pure Lua plugin loaded by Neovim's runtime system. Themes are compiled dynamically at runtime and cached to `nvim-data/colorscheme/`.

**Testing theme changes:**
- Reload Neovim after modifying theme or integration files
- Delete cached files: `nvim-data/colorscheme/*.lua` to force recompilation
- Preview themes: `:lua require('base46').preview()` (requires snacks.nvim)

## Architecture

### Core Flow

1. **Configuration** (`opts` table in `setup()`) → stored in `nvim-data/theme.conf` (JSON)
2. **Theme Compilation** → generates cached Lua file with highlight definitions
3. **Highlight Application** → loads cached file and applies via `nvim_set_hl()`

### Key Files

| File | Purpose |
|------|---------|
| `lua/base46/init.lua` | Main API: setup, LoadTheme, Compile, SetBackground, Preview |
| `lua/base46/colors.lua` | Color conversion utilities (HEX↔RGB↔HSL, gradients) |
| `lua/base46/term.lua` | Terminal color definitions |
| `lua/base46/themes/*.lua` | 70+ theme definitions (onedark, one_light, etc.) |
| `lua/base46/integrations/*.lua` | Plugin highlight modules (cmp, lsp, treesitter, etc.) |

### Theme Definition Format

Each theme in `lua/base46/themes/` exports a table with:
- `base_30`: Extended palette (30+ named colors: white, black2, darker_black, line, etc.)
- `base_16`: Base16 compatibility colors (base00-base0F)
- `type`: `"light"` or `"dark"`
- `polish_hl` (optional): Integration-specific highlight overrides

Example:
```lua
return {
  base_30 = {
    white = "#abb2bf",
    black2 = "#1e222a",
    -- ... more colors
  },
  base_16 = {
    base00 = "#1e222a",
    -- ... base01-base0F
  },
  type = "dark",
  polish_hl = {
    treesitter = { TSProperty = { fg = "red" } },
  }
}
```

### Integration Modules

Each integration in `lua/base46/integrations/` exports:
```lua
return {
  GetHighlight = function(themeColors)
    -- themeColors.base_30 and themeColors.base_16 are available
    return {
      HighlightGroup = { fg = "color_name", bg = "color_name", style = "bold" },
    }
  end
}
```

Color references use `base_30` names (strings) - they're resolved during compilation.

## Main API Functions

- `M.setup(opts)` - Initialize plugin, start fwatch for autoswitch
- `M.LoadTheme(theme)` - Load compiled theme from cache (compiles if missing)
- `M.Compile(theme)` - Generate cached Lua file from theme + integrations
- `M.SetBackground(background, force)` - Switch light/dark mode
- `M.SwitchBackground()` - Toggle between light/dark
- `M.SetTheme(theme, save)` - Set specific theme for current background type
- `M.Preview()` - Interactive theme picker (requires snacks.nvim)

## Configuration Schema

```lua
opts = {
  autoswitch = true,        -- Auto theme switching (requires fwatch.nvim)
  theme = {
    light = "one_light",    -- Theme for light background
    dark = "onedark",       -- Theme for dark background
    background = "dark",    -- Current: "light" or "dark"
  },
  ft = {                    -- Per-filetype theme overrides
    c = { dark = "vscode_dark" },
  },
  highlight = {
    hl_add = {},            -- Add new highlights
    hl_override = {},       -- Override existing highlights
  },
  changed_themes = {},      -- Theme modifications
  integrations = {          -- Which integration modules to load
    "defaults", "treesitter", "cmp", "lsp", ...
  },
}
```

## Working with Colors

Use `lua/base46/colors.lua` utilities:
- `hex2rgb(hex)`, `rgb2hex(r,g,b)` - HEX/RGB conversion
- `hex2hsl(hex)`, `hsl2hex(h,s,l)` - HEX/HSL conversion
- `change_hex_lightness(hex, amount)` - Adjust lightness
- `change_hex_saturation(hex, amount)` - Adjust saturation
- `change_hex_hue(hex, amount)` - Adjust hue
- `gradient(start_hex, end_hex, steps)` - Generate color gradient

## Adding a New Theme

1. Create `lua/base46/themes/your_theme.lua`
2. Export table with `base_30`, `base_16`, `type`
3. Reference existing themes for color palette structure
4. Theme will auto-appear in preview picker

## Adding a New Integration

1. Create `lua/base46/integrations/your_plugin.lua`
2. Export `GetHighlight = function(themeColors) return {...} end`
3. Add to `integrations` list in user config
4. Use `base_30` color names as strings in highlight definitions

## Auto-Switching Mechanism

When `autoswitch = true`:
- Uses `fwatch.nvim` to monitor `nvim-data/theme.conf`
- External scripts can modify this JSON file to trigger theme change
- Windows example (Python) in README.md - modifies `background` field
- 100ms deferred reload prevents rapid change spam
