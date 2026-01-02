local wezterm = require("wezterm")
local act = wezterm.action


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
-- Center when startup
wezterm.on("gui-startup", function(cmd)
  local screen            = wezterm.gui.screens().active
  local ratio             = 0.7
  local width, height     = screen.width * ratio, screen.height * ratio
  local tab, pane, window = wezterm.mux.spawn_window {
    position = {
      x = (screen.width - width) / 2,
      y = (screen.height - height) / 2,
      origin = 'ActiveScreen' }
  }
  -- window:gui_window():maximize()
  window:gui_window():set_inner_size(width, height)
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
  initial_rows = 20,
  initial_cols = 80,
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
	window_close_confirmation = "AlwaysPrompt",
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
	leader = { key = ";", mods = "ALT", timeout_milliseconds = 2000 },
	disable_default_key_bindings = true,
	keys = {
		-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
		{ key = ";", mods = "LEADER|ALT", action = act({ SendString = "\x01" }) },

		{ key = "T", mods = "LEADER|SHIFT|ALT", action = act.EmitEvent("toggle-colorscheme"), },

    { key = 'UpArrow', mods = 'SHIFT', action = act.ScrollByLine(-1) },
    { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollByLine(1) },
    -- Windows
    { key = 'n', mods = 'SHIFT|CTRL', action = wezterm.action.SpawnWindow },

    --Tabs
		{ key = "t", mods = "CTRL", action = act({ SpawnTab = "CurrentPaneDomain" }) },
		{ key = "W", mods = "CTRL|SHIFT", action = act({ CloseCurrentTab = {confirm = true}}) },
		{ key = "1", mods = "CTRL", action = act({ ActivateTab = 0 }) },
		{ key = "2", mods = "CTRL", action = act({ ActivateTab = 1 }) },
		{ key = "3", mods = "CTRL", action = act({ ActivateTab = 2 }) },
		{ key = "4", mods = "CTRL", action = act({ ActivateTab = 3 }) },
		{ key = "5", mods = "CTRL", action = act({ ActivateTab = 4 }) },
		{ key = "6", mods = "CTRL", action = act({ ActivateTab = 5 }) },
		{ key = "7", mods = "CTRL", action = act({ ActivateTab = 6 }) },
		{ key = "8", mods = "CTRL", action = act({ ActivateTab = 7 }) },
		{ key = "9", mods = "CTRL", action = act({ ActivateTab = 8 }) },
		{ key = "&", mods = "CTRL|SHIFT", action = act({ CloseCurrentTab = { confirm = true } }) },


		{ key = ",", mods = "ALT", action = act.ActivateTabRelative(-1) },
		{ key = ".", mods = "ALT", action = act.ActivateTabRelative(1) },
		{ key = "<", mods = "ALT|SHIFT", action = act.MoveTabRelative(-1) },
		{ key = ">", mods = "ALT|SHIFT", action = act.MoveTabRelative(1) },
{ key = 'F9', mods = 'ALT', action = wezterm.action.ShowTabNavigator },
    --Pane
		{ key = "|", mods = "LEADER", action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }), },
		{ key = "\\", mods = "LEADER", action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }), },

		{ key = "w", mods = "CTRL", action = act({ CloseCurrentPane = { confirm = true } }) },
		{ key = "h", mods = "CTRL", action = act({ ActivatePaneDirection = "Left" }) },
		{ key = "j", mods = "CTRL", action = act({ ActivatePaneDirection = "Down" }) },
		{ key = "k", mods = "CTRL", action = act({ ActivatePaneDirection = "Up" }) },
		{ key = "l", mods = "CTRL", action = act({ ActivatePaneDirection = "Right" }) },

		{ key = 'h', mods = 'CTRL|SHIFT', action = act.SplitPane { direction = 'Left', size = { Percent = 50 }, }, },
		{ key = 'j', mods = 'CTRL|SHIFT', action = act.SplitPane { direction = 'Down', size = { Percent = 50 }, }, },
		{ key = 'k', mods = 'CTRL|SHIFT', action = act.SplitPane { direction = 'Up', size = { Percent = 50 }, }, },
		{ key = 'l', mods = 'CTRL|SHIFT', action = act.SplitPane { direction = 'Right', size = { Percent = 50 }, }, },

		{ key = '/', mods = 'LEADER', action = act.RotatePanes 'Clockwise'},
		{ key = '?', mods = 'LEADER', action = act.RotatePanes 'CounterClockwise'},
    --Misc
    {key = "P", mods = "CTRL|SHIFT", action = act.ActivateCommandPalette},
    { key = "F5", mods = "LEADER", action = act.ReloadConfiguration,},
		{ key = "_", mods = "LEADER|SHIFT", action = act.EmitEvent("dec-opacity"),},
		{ key = "+", mods = "LEADER|SHIFT", action = act.EmitEvent("inc-opacity"),},
		{ key = '=', mods = 'LEADER', action = act.IncreaseFontSize },
		{ key = '-', mods = 'LEADER', action = act.DecreaseFontSize },

		{ key = 'T', mods = 'LEADER|SHIFT', action = act.ToggleAlwaysOnTop, },
		{ key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
		{ key = "v", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },
		{ key = "c", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },

    --Key tables
 { key = "r", mods = "LEADER", action = act.ActivateKeyTable { name = "resize_pane", one_shot = false } },
 -- { key = "c", mods = "LEADER", action = act.ActivateKeyTable { name = "copy_mode", one_shot = false } },
	},
  key_tables = {
    resize_pane = {
      { key = "h",      action = act.AdjustPaneSize { "Left", 5 } },
      { key = "j",      action = act.AdjustPaneSize { "Down", 5 } },
      { key = "k",      action = act.AdjustPaneSize { "Up", 5 } },
      { key = "l",      action = act.AdjustPaneSize { "Right", 5 } },
      { key = "Escape", action = "PopKeyTable" },
      { key = "Enter",  action = "PopKeyTable" },
    },
    -- search_mode = {
    --   { key = 'Enter', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
    --   { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
    --   { key = 'n', mods = 'NONE', action = act.CopyMode 'NextMatch' },
    --   { key = 'N', mods = 'SHIFT', action = act.CopyMode 'PriorMatch' },
    --   { key = 'r', mods = 'NONE', action = act.CopyMode 'CycleMatchType' },
    --   { key = 'u', mods = 'NONE', action = act.CopyMode 'ClearPattern' },
    --   { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PriorMatchPage' },
    --   { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'NextMatchPage' },
    --   { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
    --   { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'NextMatch' },
    -- },

    -- copy_mode = {
    --   { key = 'Tab', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
    --   { key = 'Tab', mods = 'SHIFT', action = act.CopyMode 'MoveBackwardWord' },
    --   { key = 'Enter', mods = 'NONE', action = act.CopyMode 'MoveToStartOfNextLine' },
    --   { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
    --   { key = 'Space', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Cell' } },
    --   { key = '$', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
    --   { key = '$', mods = 'SHIFT', action = act.CopyMode 'MoveToEndOfLineContent' },
    --   { key = ',', mods = 'NONE', action = act.CopyMode 'JumpReverse' },
    --   { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
    --   { key = ';', mods = 'NONE', action = act.CopyMode 'JumpAgain' },
    --   { key = 'F', mods = 'NONE', action = act.CopyMode{ JumpBackward = { prev_char = false } } },
    --   { key = 'F', mods = 'SHIFT', action = act.CopyMode{ JumpBackward = { prev_char = false } } },
    --   { key = 'G', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackBottom' },
    --   { key = 'G', mods = 'SHIFT', action = act.CopyMode 'MoveToScrollbackBottom' },
    --   { key = 'H', mods = 'NONE', action = act.CopyMode 'MoveToViewportTop' },
    --   { key = 'H', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportTop' },
    --   { key = 'L', mods = 'NONE', action = act.CopyMode 'MoveToViewportBottom' },
    --   { key = 'L', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportBottom' },
    --   { key = 'M', mods = 'NONE', action = act.CopyMode 'MoveToViewportMiddle' },
    --   { key = 'M', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportMiddle' },
    --   { key = 'O', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
    --   { key = 'O', mods = 'SHIFT', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
    --   { key = 'T', mods = 'NONE', action = act.CopyMode{ JumpBackward = { prev_char = true } } },
    --   { key = 'T', mods = 'SHIFT', action = act.CopyMode{ JumpBackward = { prev_char = true } } },
    --   { key = 'V', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Line' } },
    --   { key = 'V', mods = 'SHIFT', action = act.CopyMode{ SetSelectionMode =  'Line' } },
    --   { key = '^', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLineContent' },
    --   { key = '^', mods = 'SHIFT', action = act.CopyMode 'MoveToStartOfLineContent' },
    --   { key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
    --   { key = 'b', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
    --   { key = 'b', mods = 'CTRL', action = act.CopyMode 'PageUp' },
    --   { key = 'c', mods = 'CTRL', action = act.CopyMode 'Close' },
    --   { key = 'd', mods = 'CTRL', action = act.CopyMode{ MoveByPage = (0.5) } },
    --   { key = 'e', mods = 'NONE', action = act.CopyMode 'MoveForwardWordEnd' },
    --   { key = 'f', mods = 'NONE', action = act.CopyMode{ JumpForward = { prev_char = false } } },
    --   { key = 'f', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
    --   { key = 'f', mods = 'CTRL', action = act.CopyMode 'PageDown' },
    --   { key = 'g', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackTop' },
    --   { key = 'g', mods = 'CTRL', action = act.CopyMode 'Close' },
    --   { key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
    --   { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
    --   { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
    --   { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
    --   { key = 'm', mods = 'ALT', action = act.CopyMode 'MoveToStartOfLineContent' },
    --   { key = 'o', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEnd' },
    --   { key = 'q', mods = 'NONE', action = act.CopyMode 'Close' },
    --   { key = 't', mods = 'NONE', action = act.CopyMode{ JumpForward = { prev_char = true } } },
    --   { key = 'u', mods = 'CTRL', action = act.CopyMode{ MoveByPage = (-0.5) } },
    --   { key = 'v', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Cell' } },
    --   { key = 'v', mods = 'CTRL', action = act.CopyMode{ SetSelectionMode =  'Block' } },
    --   { key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
    --   { key = 'y', mods = 'NONE', action = act.Multiple{ { CopyTo =  'ClipboardAndPrimarySelection' }, { CopyMode =  'Close' } } },
    --   { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PageUp' },
    --   { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'PageDown' },
    --   { key = 'End', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
    --   { key = 'Home', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
    --   { key = 'LeftArrow', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
    --   { key = 'LeftArrow', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
    --   { key = 'RightArrow', mods = 'NONE', action = act.CopyMode 'MoveRight' },
    --   { key = 'RightArrow', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
    --   { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'MoveUp' },
    --   { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'MoveDown' },
    -- },
  };

	default_cursor_style = "BlinkingBlock",
	cursor_blink_rate = 500,
	set_environment_variables = {},
}
