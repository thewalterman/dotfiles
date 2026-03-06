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

config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font("FiraCodeNerdFont")
config.color_scheme = "Dark+"

config.window_decorations = "NONE"

config.window_background_image = "Pictures/wallpaper.jpg"

config.window_background_image_hsb = {
	brightness = 0.1,
}

config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.CompleteSelection("ClipboardAndPrimarySelection"),
	},
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

config.keys = {
	{
		key = "{",
		mods = "CTRL|SHIFT",
		action = wezterm.action.MoveTabRelative(-1),
	},
	{
		key = "}",
		mods = "CTRL|SHIFT",
		action = wezterm.action.MoveTabRelative(1),
	},
	{
		key = "n",
		mods = "CTRL",
		action = wezterm.action.RotatePanes("Clockwise"),
	},
	{
		key = "|",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitHorizontal({}),
	},
	{
		key = "?",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitVertical({}),
	},
}

return config
