local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action
local mux = wezterm.mux

-- Workspaces
wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)

-- Styling
config.color_scheme = "Catppuccin Mocha"
config.window_padding = {
	left = "1.5cell",
	right = "1.5cell",
	top = "0.75cell",
	bottom = "0.75cell",
}
config.use_fancy_tab_bar = false
config.tab_max_width = 32
config.font = wezterm.font({
	family = "MonoLisa",
	weight = "Regular",
	harfbuzz_features = { "clig=1", "calt=1", "liga=1" },
})
config.front_end = "WebGpu"
config.window_background_opacity = 0.95
config.native_macos_fullscreen_mode = true

-- Misc
config.scrollback_lines = 5000

-- Keybindings
config.leader = { key = ",", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	-- Launcher
	{ key = "l", mods = "LEADER", action = act.ShowLauncher },

	-- Panes --
	-- Split
	{ key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- Jump
	{ key = "l", mods = "CTRL", action = act.ActivatePaneDirection("Right") },
	{ key = "h", mods = "CTRL", action = act.ActivatePaneDirection("Left") },
	{ key = "k", mods = "CTRL", action = act.ActivatePaneDirection("Up") },
	{ key = "j", mods = "CTRL", action = act.ActivatePaneDirection("Down") },

	-- Resize
	{ key = "k", mods = "CTRL|SUPER", action = act.AdjustPaneSize({ "Up", 5 }) },
	{ key = "j", mods = "CTRL|SUPER", action = act.AdjustPaneSize({ "Down", 5 }) },
	{ key = "h", mods = "CTRL|SUPER", action = act.AdjustPaneSize({ "Left", 5 }) },
	{ key = "l", mods = "CTRL|SUPER", action = act.AdjustPaneSize({ "Right", 5 }) },

	-- Tabs
	{ key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },

	-- Scroll up
	{ key = "k", mods = "CTRL|SHIFT", action = act.SendKey({ key = "UpArrow" }) },
	{ key = "j", mods = "CTRL|SHIFT", action = act.SendKey({ key = "DownArrow" }) },

	-- Workspaces
	-- Jump
	{ key = "h", mods = "CTRL|SHIFT", action = act.SwitchWorkspaceRelative(-1) },
	{ key = "l", mods = "CTRL|SHIFT", action = act.SwitchWorkspaceRelative(1) },

	-- Pick
	{
		key = "s",
		mods = "LEADER",
		action = act.ShowLauncherArgs({ flags = "WORKSPACES" }),
	},

	-- Rename
	{
		key = "r",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Enter new name for workspace",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					mux.rename_workspace(window:mux_window():get_workspace(), line)
				end
			end),
		}),
	},
}

-- and finally, return the configuration to wezterm
return config
