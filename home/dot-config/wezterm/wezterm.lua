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
	font_locator = "ConfigDirsOnly",
	enable_tab_bar = false,
	window_decorations = "NONE",
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
		{ key = "e", mods = "CTRL", action = wezterm.action({ EmitEvent = "open-scrollback-in-helix" }) },
	},
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
	warn_about_missing_glyphs=false,
	window_close_confirmation='NeverPrompt',
	audible_bell='Disabled',
}
