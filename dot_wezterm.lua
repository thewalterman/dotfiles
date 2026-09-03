local wezterm = require("wezterm")

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

wezterm.on("window-config-reloaded", function(window, pane)
	local id = tostring(window:window_id())
	local seen = wezterm.GLOBAL.seen_windows or {}
	local is_new_window = not seen[id]
	seen[id] = true
	wezterm.GLOBAL.seen_windows = seen
	if is_new_window then
		window:maximize()
		window:focus()
		local last_cols = pane:get_dimensions().cols
		for _ = 1, 20 do
			wezterm.sleep_ms(50)
			local cols = pane:get_dimensions().cols
			if cols == last_cols then
				break
			end
			last_cols = cols
		end
		pane:send_text("\x0c")
	end
end)

local config = wezterm.config_builder()

config.front_end = "WebGpu"
config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font("FiraCodeNerdFont")
config.color_scheme = "Dark Pastel (Gogh)"
config.window_decorations = "RESIZE"

config.window_background_image = wezterm.home_dir .. "/.config/wezterm/wallpaper.jpg"

config.window_background_image_hsb = {
	brightness = 0.01,
}

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
