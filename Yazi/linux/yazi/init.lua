function Linemode:btime()
	local time = math.floor(self._file.cha.btime or 0)
	if time == 0 then
		return ""
	elseif os.date("%Y", time) == os.date("%Y") then
		return os.date("%m/%d/%y %H:%M", time)
	else
		return os.date("%m/%d  %Y", time)
	end
end
function Linemode:mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		return ""
	elseif os.date("%Y", time) == os.date("%Y") then
		return os.date("%y/%m/%d %H:%M:%S", time)
	else
		return os.date("%m/%d  %Y", time)
	end
end
require("augment-command"):setup({
    prompt = false,
    default_item_group_for_prompt = "hovered",
    smart_enter = true,
    smart_paste = false,
    smart_tab_create = false,
    smart_tab_switch = false,
    confirm_on_quit = true,
    open_file_after_creation = false,
    enter_directory_after_creation = false,
    use_default_create_behaviour = false,
    enter_archives = true,
    extract_retries = 3,
    recursively_extract_archives = true,
    preserve_file_permissions = false,
    must_have_hovered_item = true,
    skip_single_subdirectory_on_enter = true,
    skip_single_subdirectory_on_leave = true,
    smooth_scrolling = false,
    scroll_delay = 0.02,
    wraparound_file_navigation = false,
})
require("custom-shell"):setup({
    history_path = "default",
    save_history = true,
})
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

	show_background = true,

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
require("mime-ext"):setup {
	-- Expand the existing filename database (lowercase), for example:
	with_files = {
		makefile = "text/makefile",
		-- ...
	},

	-- Expand the existing extension database (lowercase), for example:
	with_exts = {
		mk = "text/makefile",
		-- ...
	},

	-- If the mime-type is not in both filename and extension databases,
	-- then fallback to Yazi's preset `mime` plugin, which uses `file(1)`
	fallback_file1 = false,
}
require("relative-motions"):setup({ show_numbers="relative", show_motion = true, enter_mode ="first" })
require("projects"):setup({
    save = {
        method = "yazi", -- yazi | lua
        lua_save_path = "", -- comment out to get the default value
                            -- windows: "%APPDATA%/yazi/state/projects.json"
                            -- unix: "~/.local/state/yazi/projects.json"
    },
    last = {
        update_after_save = true,
        update_after_load = true,
        load_after_start = false,
    },
    merge = {
        quit_after_merge = false,
    },
    notify = {
        enable = true,
        title = "Projects",
        timeout = 3,
        level = "info",
    },
})
require("git"):setup()
require("copy-file-contents"):setup({
	append_char = "\n",
	notification = true,
})
require("restore"):setup({
    -- Set the position for confirm and overwrite dialogs.
    -- don't forget to set height: `h = xx`
    -- https://yazi-rs.github.io/docs/plugins/utils/#ya.input
    position = { "center", w = 70, h = 40 }, -- Optional

    -- Show confirm dialog before restore.
    -- NOTE: even if set this to false, overwrite dialog still pop up
    show_confirm = true,  -- Optional

    -- colors for confirm and overwrite dialogs
    theme = { -- Optional
      -- Default using style from your flavor or theme.lua -> [confirm] -> title.
      -- If you edit flavor or theme.lua you can add more style than just color.
      -- Example in theme.lua -> [confirm]: title = { fg = "blue", bg = "green"  }
      title = "blue", -- Optional. This valid has higher priority than flavor/theme.lua

      -- Default using style from your flavor or theme.lua -> [confirm] -> content
      -- Sample logic as title above
      header = "green", -- Optional. This valid has higher priority than flavor/theme.lua

      -- header color for overwrite dialog
      -- Default using color "yellow"
      header_warning = "yellow", -- Optional
      -- Default using style from your flavor or theme.lua -> [confirm] -> list
      -- Sample logic as title and header above
      list_item = { odd = "blue", even = "blue" }, -- Optional. This valid has higher priority than flavor/theme.lua
    },
})
require("bunny"):setup({
	hops = {
    -- key and path attributes are required, desc is optional
	},
	desc_strategy = "path", -- If desc isn't present, use "path" or "filename", default is "path"
	notify = true, -- Notify after hopping, default is false
	fuzzy_cmd = "fzf", -- Fuzzy searching command, default is "fzf"
})
require("full-border"):setup {
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
}
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
	  --   location = ".*/secret",
	  --   sort = { "natural", reverse = false, dir_first = true },
	  --   linemode = "size",
	  --   show_hidden = true,
    -- },

    -- -- Custom linemode also work
    -- {
	  --   location = ".*/abc",
	  --   linemode = "size_and_mtime",
    -- },
    -- -- DO NOT ADD location = ".*". Which currently use your yazi.toml config as fallback.
    -- -- That mean if none of the saved perferences is matched, then it will use your config from yazi.toml.
    -- -- So change linemode, show_hidden, sort_xyz in yazi.toml instead.
  },
})
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
-- Show symlink in status bar
Status:children_add(function(self)
	local h = self._current.hovered
	if h and h.link_to then
		return " -> " .. tostring(h.link_to)
	else
		return ""
	end
end, 3300, Status.LEFT)
-- Show user/group of files in status bar
Status:children_add(function()
	local h = cx.active.current.hovered
	if h == nil or ya.target_family() ~= "unix" then
		return ""
	end

	return ui.Line {
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
		":",
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
		" ",
	}
end, 500, Status.RIGHT)
-- Show username and hostname in header
Header:children_add(function()
	if ya.target_family() ~= "unix" then
		return ""
	end
	return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("blue")
end, 500, Header.LEFT)