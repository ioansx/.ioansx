local wezterm = require "wezterm"

local config = wezterm.config_builder()

-- Appearance
config.color_scheme = "Builtin Tango Dark"
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.max_fps = 120

-- Font
config.font = wezterm.font "FiraCode Nerd Font Mono"
config.font_size = 15

-- Keyboard concepts
config.send_composed_key_when_right_alt_is_pressed = false

return config
