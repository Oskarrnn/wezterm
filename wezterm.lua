-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font = wezterm.font("JetBrainsMonoNL Nerd Font")

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.default_prog = { "pwsh.exe" }
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 16
config.color_scheme = "AdventureTime"
config.window_decorations = "TITLE"

-- Keybindings
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	--Splitting
	{
		mods = "LEADER",
		key = "v",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "h",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{ key = "0", mods = "CTRL", action = act.PaneSelect },
	{ key = "9", mods = "CTRL", action = act.TogglePaneZoomState },
	{ key = "w", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
}

-- Finally, return the configuration to wezterm:
return config
