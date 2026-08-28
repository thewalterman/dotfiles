local wezterm = require("wezterm")

wezterm.on("window-config-reloaded", function(window, pane)
	local id = tostring(window:window_id())
	local seen = wezterm.GLOBAL.seen_windows or {}
	local is_new_window = not seen[id]
	seen[id] = true
	wezterm.GLOBAL.seen_windows = seen
	if is_new_window then
		window:maximize()
	end
end)

local config = wezterm.config_builder()

config.front_end = "WebGpu"
config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font("FiraCodeNerdFont")
config.color_scheme = "Dark Pastel (Gogh)"
config.window_decorations = "RESIZE"

local act = wezterm.action

config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = act.CompleteSelection("ClipboardAndPrimarySelection"),
	},
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},
}

config.keys = {
	{
		key = "+",
		mods = "CTRL",
		action = act.DisableDefaultAssignment,
	},
	{
		key = "+",
		mods = "CTRL|SHIFT",
		action = act.DisableDefaultAssignment,
	},
	{
		key = "=",
		mods = "CTRL",
		action = act.DisableDefaultAssignment,
	},
	{
		key = "=",
		mods = "CTRL|SHIFT",
		action = act.DisableDefaultAssignment,
	},
	{
		key = "-",
		mods = "CTRL",
		action = act.DisableDefaultAssignment,
	},
	{
		key = "0",
		mods = "CTRL",
		action = act.ResetFontSize,
	},
	{
		key = "{",
		mods = "CTRL|SHIFT",
		action = act.MoveTabRelative(-1),
	},
	{
		key = "}",
		mods = "CTRL|SHIFT",
		action = act.MoveTabRelative(1),
	},
	{
		key = "<",
		mods = "CTRL|SHIFT",
		action = act.RotatePanes("CounterClockwise"),
	},
	{
		key = ">",
		mods = "CTRL|SHIFT",
		action = act.RotatePanes("Clockwise"),
	},
	{
		key = "|",
		mods = "CTRL|SHIFT",
		action = act.SplitHorizontal({}),
	},
	{
		key = "_",
		mods = "CTRL|SHIFT",
		action = act.SplitVertical({}),
	},
}

return config
