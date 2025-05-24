local wezterm = require("wezterm")
-- Change themes
wezterm.on("toggle-colorscheme", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if overrides.color_scheme == "gruvbox_material_dark_hard" then
		overrides.color_scheme = "SynthwaveAlpha"
	else
		overrides.color_scheme = "Dracula"
	end
	window:set_config_overrides(overrides)
end)
--Increase/Decrease opacity
local opa_def=0.9

wezterm.on("inc-opacity", function(window, pane)
  opa_def=opa_def+0.1
if opa_def > 1.0 then
  opa_def = 1.0
end
  local overrides = window:get_config_overrides() or {}
        overrides.window_background_opacity = opa_def
    window:set_config_overrides(overrides)
end)

wezterm.on("dec-opacity", function(window, pane)
  opa_def=opa_def-0.1
if opa_def < 0.0 then
  opa_def = 0.0
end
  local overrides = window:get_config_overrides() or {}
        overrides.window_background_opacity = opa_def
    window:set_config_overrides(overrides)
end)
return {
    --term = "xterm-256color", -- Set the terminal type
	-----------------------------------------------------------
	-- Change default Shell:
	-----------------------------------------------------------
	default_prog = { 'C:/Program Files/WindowsApps/Microsoft.PowerShell_7.5.1.0_x64__8wekyb3d8bbwe/pwsh.exe' },
	-----------------------------------------------------------
	-- Ararbic Support:
	-----------------------------------------------------------
	bidi_enabled = true,
	bidi_direction = "LeftToRight",
	-----------------------------------------------------------
	-- HighPerformance Configurations:
	-----------------------------------------------------------
	-- front_end = "OpenGL", -- current work-around for https://github.com/wez/wezterm/issues/4825
	front_end = "OpenGL",
	--webgpu_power_preference = "LowPower",
	-----------------------------------------------------------
	-- Fonts Configurations:
	-----------------------------------------------------------
	font = wezterm.font("JetBrainsMono NF", { weight = "Medium", stretch = "Normal", style = "Normal" }),
	font_size = 14,
	font_rules = {
		{
			italic = true,
			font = wezterm.font("JetBrainsMono NF", { weight = "Medium", stretch = "Normal", style = "Italic" }),
		},
		{
			intensity = "Bold",
			font = wezterm.font("JetBrainsMono NF", { weight = "Bold", stretch = "Normal", style = "Normal" }),
		},
		{
			intensity = "Bold",
			italic = true,
			font = wezterm.font("JetBrainsMono NF", { weight = "Bold", stretch = "Normal", style = "Italic" }),
		},
	},
	-----------------------------------------------------------
	-- Colorscheme Configurations:
	-----------------------------------------------------------
	color_scheme ="Dracula",
	color_schemes = {
		["gruvbox_material_dark_medium"] = {
			foreground = "#D4BE98",
			background = "#282828",
			cursor_bg = "#D4BE98",
			cursor_border = "#D4BE98",
			cursor_fg = "#282828",
			selection_bg = "#D4BE98",
			selection_fg = "#45403d",

			ansi = { "#282828", "#ea6962", "#a9b665", "#d8a657", "#7daea3", "#d3869b", "#89b482", "#d4be98" },
			brights = { "#eddeb5", "#ea6962", "#a9b665", "#d8a657", "#7daea3", "#d3869b", "#89b482", "#d4be98" },
		},
		["gruvbox_material_dark_hard"] = {
			foreground = "#D4BE98",
			background = "#141617",
			cursor_bg = "#D4BE98",
			cursor_border = "#D4BE98",
			cursor_fg = "#1D2021",
			selection_bg = "#D4BE98",
			selection_fg = "#3C3836",

			ansi = { "#1d2021", "#ea6962", "#a9b665", "#d8a657", "#7daea3", "#d3869b", "#89b482", "#d4be98" },
			brights = { "#eddeb5", "#ea6962", "#a9b665", "#d8a657", "#7daea3", "#d3869b", "#89b482", "#d4be98" },
		},
	},
	colors = {
		split = "#1b1b1b",
		visual_bell = "#1b1b1b",
	},
	-----------------------------------------------------------
	-- Window Configurations:
	-----------------------------------------------------------
	window_background_opacity = opa_def,
	prefer_egl = true,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",
	window_padding = {
		left = 10,
		right = 5,
		top = 10,
		bottom = 10,
	},
	adjust_window_size_when_changing_font_size = false,
	-----------------------------------------------------------
	-- Tab Configurations:
	-----------------------------------------------------------
	tab_bar_at_bottom = false,
	enable_tab_bar = true,
	use_fancy_tab_bar = true,
	hide_tab_bar_if_only_one_tab = true,
	-----------------------------------------------------------
	-- ScrollBar Configurations:
	-----------------------------------------------------------
	scrollback_lines = 5000,
	enable_scroll_bar = true,
	check_for_updates = false,
	-----------------------------------------------------------
	-- Animation Configurations:
	-----------------------------------------------------------
	animation_fps = 1,
	max_fps = 144,
	cursor_blink_ease_in = "Constant",
	cursor_blink_ease_out = "Constant",
	visual_bell = {
		fade_in_function = "EaseIn",
		fade_in_duration_ms = 150,
		fade_out_function = "EaseOut",
		fade_out_duration_ms = 150,
	},
	-----------------------------------------------------------
	-- Keybidings Configurations:
	-----------------------------------------------------------
	leader = { key = "`", mods = "CTRL", timeout_milliseconds = 2000 },
	disable_default_key_bindings = true,
	keys = {
		-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
		{ key = "a", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\x01" }) },
		{
			key = "E",
			mods = "CTRL|SHIFT|ALT",
			action = wezterm.action.EmitEvent("toggle-colorscheme"),
		},
		{
			key = "[",
			mods = "CTRL",
			action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
		},
		{
			key = "]",
			mods = "CTRL",
			action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
		},
		{
			key = 'r',
			mods = 'CTRL|SHIFT',
			action = wezterm.action.ReloadConfiguration,
  		},
		{ key = "0", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("dec-opacity"),},
		{ key = "9", mods = "CTRL|SHIFT", action = wezterm.action.EmitEvent("inc-opacity"),},
		{ key = "t", mods = "CTRL", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
		{ key = "w", mods = "CTRL", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
		{ key = "h", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
		{ key = "j", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
		{ key = "k", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
		{ key = "l", mods = "CTRL", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
		{ key = "H", mods = "CTRL|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }) },
		{ key = "J", mods = "CTRL|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }) },
		{ key = "K", mods = "CTRL|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }) },
		{ key = "L", mods = "CTRL|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }) },
		{ key = "1", mods = "CTRL", action = wezterm.action({ ActivateTab = 0 }) },
		{ key = "2", mods = "CTRL", action = wezterm.action({ ActivateTab = 1 }) },
		{ key = "3", mods = "CTRL", action = wezterm.action({ ActivateTab = 2 }) },
		{ key = "4", mods = "CTRL", action = wezterm.action({ ActivateTab = 3 }) },
		{ key = "5", mods = "CTRL", action = wezterm.action({ ActivateTab = 4 }) },
		{ key = "6", mods = "CTRL", action = wezterm.action({ ActivateTab = 5 }) },
		{ key = "7", mods = "CTRL", action = wezterm.action({ ActivateTab = 6 }) },
		{ key = "8", mods = "CTRL", action = wezterm.action({ ActivateTab = 7 }) },
		{ key = "9", mods = "CTRL", action = wezterm.action({ ActivateTab = 8 }) },
		{ key = "&", mods = "CTRL|SHIFT", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
		{ key = '=', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
		{ key = '-', mods = 'CTRL', action = wezterm.action.DecreaseFontSize },

		{
			key = 'a',
			mods = 'CTRL|SHIFT',
			action = wezterm.action.SplitPane {
			direction = 'Left',
			size = { Percent = 50 },
			},
	  	},
		{
			key = 's',
			mods = 'CTRL|SHIFT',
			action = wezterm.action.SplitPane {
			direction = 'Down',
			size = { Percent = 50 },
			},
	  	},
		{
			key = 'd',
			mods = 'CTRL|SHIFT',
			action = wezterm.action.SplitPane {
			direction = 'Up',
			size = { Percent = 50 },
			},
	  	},
		{
			key = 'f',
			mods = 'CTRL|SHIFT',
			action = wezterm.action.SplitPane {
			direction = 'Right',
			size = { Percent = 50 },
			},
	  	},

		{
			key = 'T',
			mods = 'LEADER|SHIFT',
			action = wezterm.action.ToggleAlwaysOnTop,
		},
		{ key = "z", mods = "CTRL", action = "TogglePaneZoomState" },
		{ key = "v", mods = "SHIFT|CTRL", action = wezterm.action.PasteFrom("Clipboard") },
		{ key = "c", mods = "SHIFT|CTRL", action = wezterm.action.CopyTo("Clipboard") },
	},
	default_cursor_style = "BlinkingBlock",
	cursor_blink_rate = 500,

	set_environment_variables = {},
}
