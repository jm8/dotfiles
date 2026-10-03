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
		{
			key = "Space",
			mods = "CTRL|SHIFT",
			action = wezterm.action.InputSelector({
				title = "Quick Select",
				choices = {
					{ id = "hash", label = "h  Hashes" },
					{ id = "quote", label = "'  Single-quoted strings" },
					{ id = "paren", label = "(  Parens" },
				},
				alphabet = "h'(",
				action = wezterm.action_callback(function(window, pane, id, _label)
					if not id then
						return
					end
					local quick_select_patterns = {
						hash = { "(?i)(0x)?\\b[0-9a-f]{4,64}\\b" },
						quote = { "(?<=')[^'\\\\]*(?:\\\\.[^'\\\\]*)*(?=')" },
						paren = { "\\((?:[^()]|\\((?:[^()]|\\([^()]*\\))*\\))*\\)" },
					}
					window:perform_action(
						wezterm.action.QuickSelectArgs({ patterns = quick_select_patterns[id] }),
						pane
					)
				end),
			}),
		},
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
