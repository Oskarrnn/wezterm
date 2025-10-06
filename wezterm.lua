-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Define the home row keys to use for the shortcuts
local home_row_keys = { "a", "s", "d", "f", "g", "h", "j", "k", "l" }
--local up_row_keys = { "q", "w", "e", "r", "t", "y", "u", "i", "o" }
local num_shortcuts = #home_row_keys

-- Font Settings
config.font_size = 14
config.font = wezterm.font("JetBrainsMonoNL Nerd Font")
config.line_height = 1

-- Colors
config.colors = {
  cursor_bg = "white",
  cursor_border = "blue",
}

-- Appearance
-- config.window_background_opacity = 0
-- config.win32_system_backdrop = 'Mica'
config.window_background_gradient = {
  orientation = 'Vertical',

  colors = {
    '#0f0c29',
    '#302b63',
    '#24243e',
  },
  interpolation = 'Linear',
  blend = 'Rgb',
}
config.color_scheme = "TokyoNight Moon"
--config.window_decorations = "RESIZE"
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- Muscellaneous Settings
config.prefer_egl = true


-- For example, changing the initial geometry for new windows:
config.default_prog = { "pwsh.exe" }

-- or, changing the font size and color scheme.
config.initial_cols = 160
config.initial_rows = 36

-- Keybindings
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
  --Splitting
  {
    mods = "LEADER",
    key = "c",
    action = act.SpawnTab "CurrentPaneDomain",
  },
  { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
  {
    mods = "LEADER",
    key = "b",
    action = act.ActivateTabRelative(-1),
  },
  {
    mods = "LEADER",
    key = "n",
    action = act.ActivateTabRelative(1),
  },
  {
    mods = "LEADER",
    key = "v",
    action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  {
    mods = "LEADER",
    key = "i",
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  { key = "0", mods = "CTRL",   action = act.PaneSelect },
  { key = "9", mods = "CTRL",   action = act.TogglePaneZoomState },
}
-- Tab Key Shortcut based on the Home Row
for i = 1, num_shortcuts do
  -- Get the key (e.g., "a", "s", "d", etc.)
  local key_char = home_row_keys[i]

  -- The tab index is 0-based, so i-1 (e.g., 1 -> 0, 9 -> 8)
  local tab_index = i - 1

  -- leader + home row key to activate that tab
  table.insert(config.keys, {
    key = key_char,
    mods = "LEADER",
    action = act.ActivateTab(tab_index),
    -- Optional: Add a descriptive name for clarity
    name = "Activate Tab #" .. i .. " (" .. key_char .. ")",
  })
end
-- Tab Bar Config
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = false

-- tmux status
wezterm.on("update-right-status", function(window, _)
  local SOLID_LEFT_ARROW = ""
  local ARROW_FOREGROUND = { Foreground = { Color = "#c6a0f6" } }
  local prefix = ""
  if window:leader_is_active() then
    prefix = " " .. utf8.char(0x1f30a) -- ocean wave
    SOLID_LEFT_ARROW = utf8.char(0xe0b2)
  end
  if window:active_tab():tab_id() ~= 1 then
    ARROW_FOREGROUND = { Foreground = { Color = "1e2030" } }
  end
  window:set_left_status(wezterm.format {
    { Background = { Color = "#b7bdf8" } },
    { Text = prefix },
    ARROW_FOREGROUND,
    { Text = SOLID_LEFT_ARROW }
  })
end)
-- Finally, return the configuration to wezterm:
return config
