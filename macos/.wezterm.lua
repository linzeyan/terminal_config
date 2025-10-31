-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.
config.check_for_updates = false
config.warn_about_missing_glyphs = false

-- How many lines of scrollback you want to retain per tab
config.scrollback_lines = 3500
config.enable_scroll_bar = true
-- changing the initial geometry for new windows:
config.initial_cols = 180
config.initial_rows = 60

-- or, changing the font size and color scheme.
config.font_size = 14
config.font = wezterm.font_with_fallback {'FiraCode Nerd Font Mono', 'PT Mono'}
config.font = wezterm.font 'FiraCode Nerd Font Mono'
-- config.font = wezterm.font { family = 'FiraCode Nerd Font Mono', weight = 'Bold', italic = true }

-- ======= scheme =======
-- 指定基礎方案
-- config.color_scheme = 'OneDark (base16)'
-- config.color_scheme = 'OneHalfDark'
config.color_scheme = "Tomorrow Night"
-- 修改你想要的顏色
config.colors = {
    background = "#1b1d22", -- 比原本 #282c34 再暗一點
    foreground = "#c8c8c8", -- 降低亮度
    cursor_bg = "#aaaaaa", -- 淡灰游標，不太刺眼
    selection_bg = "#3c4048" -- 柔和選取顏色
}
-- ======= background_image =======
-- config.window_background_image = '/path/to/wallpaper.jpg'
-- config.window_background_image_hsb = {
--     -- Darken the background image by reducing it to 1/3rd
--     brightness = 0.3,

--     -- You can adjust the hue by scaling its value.
--     -- a multiplier of 1.0 leaves the value unchanged.
--     hue = 1.0,

--     -- You can adjust the saturation also.
--     saturation = 1.0
-- }
-- 視窗背景不透明度 0.0 （表示完全半透明/透明）到 1.0 （表示完全不透明）
config.window_background_opacity = 0.95
-- 文本背景不透明度 0.0 （完全半透明）到 1.0 （完全不透明）
-- config.text_background_opacity = 0.1

-- ======= Key Binding =======
config.keys = {
    {
        key = 'k',
        mods = 'CMD',
        action = wezterm.action.ClearScrollback 'ScrollbackAndViewport'
    }, {
        key = 'd',
        mods = 'CMD',
        action = wezterm.action.SplitHorizontal {domain = 'CurrentPaneDomain'}
    }, {
        key = 'd',
        mods = 'CMD|SHIFT',
        action = wezterm.action.SplitVertical {domain = 'CurrentPaneDomain'}
    },

}
-- Finally, return the configuration to wezterm:
return config
