-- ~/.config/yazi/init.lua
--require("arrow"):setup()
require("relative-motions"):setup({ show_numbers="relative", show_motion = true, enter_mode ="first" })

require("full-border"):setup()

require("git"):setup()

require("folder-rules"):setup()

require("copy-file-contents"):setup({
	clipboard_cmd = "clip",
	append_char = "\n",
	notification = true,
})

require("bunny"):setup({
	hops = {
    -- key and path attributes are required, desc is optional
	},
	desc_strategy = "path", -- If desc isn't present, use "path" or "filename", default is "path"
	notify = true, -- Notify after hopping, default is false
	fuzzy_cmd = "fzf", -- Fuzzy searching command, default is "fzf"
})

require("pref-by-location"):setup({
-- Disable this plugin completely.
-- disabled = false -- true|false (Optional)

-- Hide "enable" and "disable" notifications.
-- no_notify = false -- true|false (Optional)

-- You can backup/restore this file. But don't use same file in the different OS.
-- save_path =  -- full path to save file (Optional)
--       - Linux/MacOS: os.getenv("HOME") .. "/.config/yazi/pref-by-location"
--       - Windows: os.getenv("APPDATA") .. "\\yazi\\config\\pref-by-location"

-- You don't have to set "prefs". Just use keymaps below work just fine
prefs = { -- (Optional)
    -- location: String | Lua pattern (Required)
    --   - Support literals full path, lua pattern (string.match pattern): https://www.lua.org/pil/20.2.html
    --     And don't put ($) sign at the end of the location. %$ is ok.
    --   - If you want to use special characters (such as . * ? + [ ] ( ) ^ $ %) in "location"
    --     you need to escape them with a percent sign (%).
    --     Example: "/home/test/Hello (Lua) [world]" => { location = "/home/test/Hello %(Lua%) %[world%]", ....}

    -- sort: {} (Optional) https://yazi-rs.github.io/docs/configuration/yazi#manager.sort_by
    --   - extension: "none"|"mtime"|"btime"|"extension"|"alphabetical"|"natural"|"size"|"random", (Optional)
    --   - reverse: true|false (Optional)
    --   - dir_first: true|false (Optional)
    --   - translit: true|false (Optional)
    --   - sensitive: true|false (Optional)

    -- linemode: "none" |"size" |"btime" |"mtime" |"permissions" |"owner" (Optional) https://yazi-rs.github.io/docs/configuration/yazi#manager.linemode
    --   - Custom linemode also work. See the example below

    -- show_hidden: true|false (Optional) https://yazi-rs.github.io/docs/configuration/yazi#manager.show_hidden

    -- Some examples:
    -- Match any folder which has path start with "/mnt/remote/". Example: /mnt/remote/child/child2
    -- { location = "^/mnt/remote/.*", sort = { "extension", reverse = false, dir_first = true, sensitive = false} },
    -- -- Match any folder with name "Downloads"
    -- { location = ".*/Downloads", sort = { "btime", reverse = true, dir_first = true }, linemode = "btime" },
    -- -- Match exact folder with absolute path "/home/test/Videos"
    -- { location = "/home/test/Videos", sort = { "btime", reverse = true, dir_first = true }, linemode = "btime" },

    -- -- show_hidden for any folder with name "secret"
    -- {
    -- location = ".*/secret",
    -- sort = { "natural", reverse = false, dir_first = true },
    -- linemode = "size",
    -- show_hidden = true,
    -- },

    -- -- Custom linemode also work
    -- {
	-- location = ".*/abc",
	-- linemode = "size_and_mtime",
    -- },
    -- DO NOT ADD location = ".*". Which currently use your yazi.toml config as fallback.
    -- That mean if none of the saved perferences is matched, then it will use your config from yazi.toml.
    -- So change linemode, show_hidden, sort_xyz in yazi.toml instead.
},
})
require("searchjump"):setup({
	unmatch_fg = "#b2a496",
    match_str_fg = "#000000",
    match_str_bg = "#73AC3A",
    first_match_str_fg = "#000000",
    first_match_str_bg = "#73AC3A",
    lable_fg = "#EADFC8",
    lable_bg = "#BA603D",
    only_current = false,
    show_search_in_statusbar = true,
    auto_exit_when_unmatch = false,
    enable_capital_lable = true,
	search_patterns = ({"hell[dk]d","%d+.1080p","第%d+集","第%d+话","%.E%d+","S%d+E%d+",})
})

require("eza-preview"):setup({
    -- -- Determines the directory depth level to tree preview (default: 3)
    -- level = 3,

    -- -- Whether to follow symlinks when previewing directories (default: false)
    -- follow_symlinks = false

    -- -- Whether to show target file info instead of symlink info (default: false)
    -- dereference = false
})


require("yatline"):setup({
    require("yatline"):setup({
	--theme = my_theme,
	section_separator = { open = "", close = "" },
	part_separator = { open = "", close = "" },
	inverse_separator = { open = "", close = "" },

	style_a = {
		fg = "black",
		bg_mode = {
			normal = "white",
			select = "brightyellow",
			un_set = "brightred"
		}
	},
	style_b = { bg = "brightblack", fg = "brightwhite" },
	style_c = { bg = "black", fg = "brightwhite" },

	permissions_t_fg = "green",
	permissions_r_fg = "yellow",
	permissions_w_fg = "red",
	permissions_x_fg = "cyan",
	permissions_s_fg = "white",

	tab_width = 20,
	tab_use_inverse = false,

	selected = { icon = "󰻭", fg = "yellow" },
	copied = { icon = "", fg = "green" },
	cut = { icon = "", fg = "red" },

	total = { icon = "󰮍", fg = "yellow" },
	succ = { icon = "", fg = "green" },
	fail = { icon = "", fg = "red" },
	found = { icon = "󰮕", fg = "blue" },
	processed = { icon = "󰐍", fg = "green" },

	show_background = false,

	display_header_line = true,
	display_status_line = true,

	component_positions = { "header", "tab", "status" },

	header_line = {
		left = {
			section_a = {
        			{type = "line", custom = false, name = "tabs", params = {"left"}},
			},
			section_b = {
			},
			section_c = {
			}
		},
		right = {
			section_a = {
        			{type = "string", custom = false, name = "date", params = {"%A, %d %B %Y"}},
			},
			section_b = {
        			{type = "string", custom = false, name = "date", params = {"%X"}},
			},
			section_c = {
			}
		}
	},

	status_line = {
		left = {
			section_a = {
        			{type = "string", custom = false, name = "tab_mode"},
			},
			section_b = {
        			{type = "string", custom = false, name = "hovered_size"},
			},
			section_c = {
        			{type = "string", custom = false, name = "hovered_path"},
        			{type = "coloreds", custom = false, name = "count"},
			}
		},
		right = {
			section_a = {
        			{type = "string", custom = false, name = "cursor_position"},
			},
			section_b = {
        			{type = "string", custom = false, name = "cursor_percentage"},
			},
			section_c = {
        			{type = "string", custom = false, name = "hovered_file_extension", params = {true}},
        			{type = "coloreds", custom = false, name = "permissions"},
			}
		}
	},
})
})

require("omp"):setup({config= "C:/Users/LENOVO LEGION/OneDrive - Hanoi University of Science and Technology/Documents/oh-my-posh-themes/gruvbox.omp.json"})
--Simple tag
require("simple-tag"):setup({
-- UI display mode (icon, text, hidden)
ui_mode = "icon", -- (Optional)

-- Disable tag key hints (popup in bottom right corner)
hints_disabled = false, -- (Optional)

-- linemode order: adjusts icon/text position. Fo example, if you want icon to be on the mose left of linemode then set linemode_order larger than 1000.
-- More info: https://github.com/sxyazi/yazi/blob/077faacc9a84bb5a06c5a8185a71405b0cb3dc8a/yazi-plugin/preset/components/linemode.lua#L4-L5
linemode_order = 500, -- (Optional)

-- You can backup/restore this folder. But don't use backed up folder in the different OS.
-- save_path =  -- full path to save tags folder (Optional)
--       - Linux/MacOS: os.getenv("HOME") .. "/.config/yazi/tags"
--       - Windows: os.getenv("APPDATA") .. "\\yazi\\config\\tags"

-- Set tag colors
colors = { -- (Optional)
-- Set this same value with `theme.toml` > [manager] > hovered > reversed
-- Default theme use "reversed = true".
-- More info: https://github.com/sxyazi/yazi/blob/077faacc9a84bb5a06c5a8185a71405b0cb3dc8a/yazi-config/preset/theme-dark.toml#L25
reversed = true, -- (Optional)

-- More colors: https://yazi-rs.github.io/docs/configuration/theme#types.color
-- format: [tag key] = "color"
["*"] = "#bf68d9", -- (Optional)
["$"] = "green",
["!"] = "#cc9057",
["1"] = "cyan",
["p"] = "red",
},

-- Set tag icons. Only show when ui_mode = "icon".
-- Any text or nerdfont icons should work
-- Default icon from mactag.yazi: ●; , , 󱈤
-- More icon from nerd fonts: https://www.nerdfonts.com/cheat-sheet
icons = { -- (Optional)
-- default icon
default = "󰚋",

-- format: [tag key] = "tag icon"
["*"] = "*",
["$"] = "",
["!"] = "",
["p"] = "",
},

})