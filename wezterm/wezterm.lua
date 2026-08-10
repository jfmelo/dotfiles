local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.initial_cols = 140
config.initial_rows = 35

config.adjust_window_size_when_changing_font_size = false

config.color_scheme = "catppuccin-mocha"

config.colors = {
	-- background = "#000000",
	cursor_bg = "#f8f8f2",
	cursor_fg = "#282a36",
}

config.enable_tab_bar = false
config.font = wezterm.font("IosevkaTermNerdFontMono")
config.font_size = 12.7

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.inactive_pane_hsb = {
	brightness = 0.15,
}

config.keys = {
	{ key = "|", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "|", mods = "CTRL|SHIFT|ALT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "l", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "k", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "j", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "PageUp", mods = "SHIFT", action = wezterm.action.ScrollByLine(-1) },
	{ key = "PageDown", mods = "SHIFT", action = wezterm.action.ScrollByLine(1) },
}

return config
