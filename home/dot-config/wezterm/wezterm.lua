local wezterm = require("wezterm")
local io = require("io")
local os = require("os")

wezterm.on("open-scrollback-in-helix", function(window, pane)
	local dimensions = pane:get_dimensions()
	local text = pane:get_logical_lines_as_text(dimensions.scrollback_rows)
	local name = os.tmpname()
	local file = assert(io.open(name, "w"))
	file:write(text)
	file:close()
	local hx_pane = pane:split({
		direction = "Bottom",
		args = { "sh", "-c", 'hx "$1":9999999; status=$?; rm -f "$1"; exit $status', "--", name },
	})
	hx_pane:activate()
	local tab = window:mux_window():active_tab()
	tab:set_zoomed(true)
end)

-- Named terminals -----------------------------------------------------------
-- The name is stored as the tab title, so it is visible to
-- `wezterm cli list` (used by the `wtsend` script). Named windows get a
-- tinted background chosen from the name.
local base_scheme_name = "Catppuccin Macchiato"
local named_backgrounds = {
	"#3b2431", -- red
	"#233a2b", -- green
	"#22304d", -- blue
	"#33244d", -- purple
	"#3d3122", -- orange
	"#203a3c", -- teal
}

local function apply_name_colors(window, name)
	wezterm.GLOBAL.applied_names = wezterm.GLOBAL.applied_names or {}
	local key = tostring(window:window_id())
	if (wezterm.GLOBAL.applied_names[key] or "") == name then
		return
	end
	wezterm.GLOBAL.applied_names[key] = name

	local overrides = window:get_config_overrides() or {}
	if name == "" then
		overrides.color_schemes = nil
		overrides.color_scheme = nil
	else
		local scheme = {}
		for k, v in pairs(wezterm.color.get_builtin_schemes()[base_scheme_name]) do
			scheme[k] = v
		end
		local h = 0
		for i = 1, #name do
			h = (h * 31 + name:byte(i)) % 2147483647
		end
		scheme.background = named_backgrounds[h % #named_backgrounds + 1]
		overrides.color_schemes = { ["named-terminal"] = scheme }
		overrides.color_scheme = "named-terminal"
	end
	window:set_config_overrides(overrides)
end

-- Keep colors in sync if the name is changed elsewhere
-- (e.g. `wezterm cli set-tab-title`).
wezterm.on("update-status", function(window, _pane)
	apply_name_colors(window, window:active_tab():get_title())
end)

wezterm.on("format-window-title", function(tab, pane, _tabs, _panes, _config)
	if tab.tab_title ~= "" then
		return "[" .. tab.tab_title .. "] " .. pane.title
	end
	return pane.title
end)

local name_terminal = wezterm.action.PromptInputLine({
	description = "Name this terminal (empty to clear):",
	action = wezterm.action_callback(function(window, _pane, line)
		if line == nil then
			return
		end
		line = line:gsub("^%s+", ""):gsub("%s+$", "")
		window:active_tab():set_title(line)
		apply_name_colors(window, line)
	end),
})

return {
	color_scheme = "Catppuccin Macchiato",
	enable_wayland = false,
	front_end = "WebGpu",
	-- font_locator = "ConfigDirsOnly",
	enable_tab_bar = false,
	window_decorations = "NONE",
	font_size = 12.0,
	adjust_window_size_when_changing_font_size = false,
	quick_select_patterns = {
		'(?<=")[^"\\\\]*(?:\\\\.[^"\\\\]*)*(?=")',
		"(?<=')[^'\\\\]*(?:\\\\.[^'\\\\]*)*(?=')",
	},
	window_padding = {
		left = 3,
		right = 3,
		top = 3,
		bottom = 3,
	},
	keys = {
		{ key = "e", mods = "CTRL|SHIFT", action = wezterm.action({ EmitEvent = "open-scrollback-in-helix" }) },
		{ key = "i", mods = "CTRL|SHIFT", action = name_terminal },
		-- {
		-- 	key = "Space",
		-- 	mods = "CTRL|SHIFT",
		-- 	action = wezterm.action.InputSelector({
		-- 		title = "Quick Select",
		-- 		choices = {
		-- 			{ id = "hash", label = "h  Hashes" },
		-- 			{ id = "quote", label = "'  Single-quoted strings" },
		-- 			{ id = "paren", label = "(  Parens" },
		-- 		},
		-- 		alphabet = "h'(",
		-- 		action = wezterm.action_callback(function(window, pane, id, _label)
		-- 			if not id then
		-- 				return
		-- 			end
		-- 			local quick_select_patterns = {
		-- 				hash = { "(?i)(0x)?\\b[0-9a-f]{4,64}\\b" },
		-- 				quote = { "(?<=')[^'\\\\]*(?:\\\\.[^'\\\\]*)*(?=')" },
		-- 				paren = { "\\((?:[^()]|\\((?:[^()]|\\([^()]*\\))*\\))*\\)" },
		-- 			}
		-- 			window:perform_action(
		-- 				wezterm.action.QuickSelectArgs({ patterns = quick_select_patterns[id] }),
		-- 				pane
		-- 			)
		-- 		end),
		-- 	}),
		-- },
	},
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
	-- warn_about_missing_glyphs=false,
	window_close_confirmation='NeverPrompt',
	audible_bell='Disabled',
	font=wezterm.font_with_fallback({
		'JetBrains Mono',
		'Noto Sans Mono',
		'Symbols Nerd Font',
	})
}
