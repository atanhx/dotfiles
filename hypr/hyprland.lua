-- Hyprland 0.56 Lua config
-- Migrated from hyprland.conf (superseded; see git history)

local mainMod = "SUPER"
local home = os.getenv("HOME")

local terminal = "kitty"
local fileManager = "dolphin"

------------------
-- MONITOR ------
------------------

hl.monitor({
	output = "eDP-1",
	mode = "1920x1080",
	position = "0x0",
	scale = 1,
})

-------------------
-- WORKSPACES ----
-------------------

hl.workspace_rule({ workspace = "1", monitor = "eDP-1", default = true })
hl.workspace_rule({ workspace = "2", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "3", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "4", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "5", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "6", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "7", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "8", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "9", monitor = "eDP-1" })

--------------------
-- ENV ------------
--------------------

hl.env("AQ_DRM_DEVICES", "/dev/dri/card2:/dev/dri/card1")
hl.env("PYTHONDONTWRITEBYTECODE", "1")
hl.env("XDG_MENU_PREFIX", "arch-")
hl.env("PASSWORD_STORE_SET", "gnome-keyring")

hl.env("QT_QPA_PLATFORM", "xcb;wayland")
hl.env("QT_QPA_PLATFORMTHEME", "kde")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("ELECTRON_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")

---------------------
-- AUTOSTART -------
---------------------

hl.on("hyprland.start", function()
	hl.exec_cmd(
		"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland XDG_SESSION_TYPE=wayland"
	)
	hl.exec_cmd("wl-paste --type text --watch cliphist store -max-items 100000")
	hl.exec_cmd("wl-paste --type image --watch cliphist store -max-items 100000")
	hl.exec_cmd("gnome-keyring-daemon --start --components=secrets,pkcs11,ssh")
	hl.exec_cmd("dunst")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("/usr/lib/hyprpolkitagent")
	hl.exec_cmd(home .. "/dev/dotfiles/hypr/scripts/hypr")
	hl.exec_cmd(home .. "/dev/dotfiles/hypr/scripts/launch_waybar")
	hl.exec_cmd(
		'i=0; while [ "$i" -lt 50 ]; do busctl --user get-property org.kde.StatusNotifierWatcher /StatusNotifierWatcher org.kde.StatusNotifierWatcher IsStatusNotifierHostRegistered >/dev/null 2>&1 && break; sleep 0.2; i=$((i+1)); done; kdeconnect-indicator & nm-applet --indicator & blueman-applet &'
	)
	hl.exec_cmd("hyprpaper --config " .. home .. "/dev/dotfiles/hypr/hyprpaper.conf")
	hl.exec_cmd("kbuildsycoca6 --noincremental")
	hl.exec_cmd("xhost +si:localuser:root")
end)

--------------
-- INPUT ----
--------------

hl.config({
	input = {
		kb_layout = "us",
		numlock_by_default = true,
		follow_mouse = 1,
		sensitivity = 0.7,

		touchpad = {
			natural_scroll = true,
			disable_while_typing = true,
			tap_to_click = true,
			middle_button_emulation = true,
			drag_lock = false,
		},
	},
})

-----------------
-- GENERAL -----
-----------------

hl.config({
	general = {
		gaps_in = 3,
		gaps_out = 7,
		border_size = 2,
		col = {
			active_border = "rgb(992226)",
			inactive_border = "rgb(333a3d)",
		},
		layout = "dwindle",
		resize_on_border = true,
		hover_icon_on_border = true,
	},
})

---------------
-- MISC ------
---------------

hl.config({
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		mouse_move_enables_dpms = true,
		always_follow_on_dnd = true,
		layers_hog_keyboard_focus = true,
		vrr = 1,
		enable_swallow = true,
		swallow_regex = [[^(alacritty)$]],
		focus_on_activate = true,
	},
})

-------------------
-- DECORATION ----
-------------------

hl.config({
	decoration = {
		rounding = 5,
		active_opacity = 1,
		inactive_opacity = 1,
		shadow = {
			enabled = false,
		},
		blur = {
			enabled = false,
			new_optimizations = true,
			popups = false,
			special = false,
		},
	},
})

-------------------
-- ANIMATIONS ----
-------------------

hl.config({
	animations = {
		enabled = false,
	},
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

--------------
-- DWINDLE --
--------------

hl.config({
	dwindle = {
		default_split_ratio = 1,
		preserve_split = true,
		smart_resizing = true,
		permanent_direction_override = true,
		split_width_multiplier = 1.2,
		split_bias = 0,
		force_split = 2,
	},
})

-------------
-- BINDS ----
-------------

hl.config({
	binds = {
		workspace_back_and_forth = true,
	},
})

------------------
-- XWAYLAND -----
------------------

hl.config({
	xwayland = {
		use_nearest_neighbor = true,
	},
})

---------------
-- CURSOR -----
---------------

hl.config({
	cursor = {
		use_cpu_buffer = true,
		sync_gsettings_theme = true,
		no_hardware_cursors = 2,
	},
})

---------------
-- GESTURES ---
---------------

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 4, direction = "up", action = "fullscreen" })

------------------
-- WINDOW RULES -
------------------

hl.window_rule({
	name = "resize-and-float",
	match = { class = "qalculate-qt" },
	float = true,
	size = { 500, 700 },
})

hl.window_rule({
	name = "rofi-border",
	match = { class = "[Rr]ofi" },
	border_size = 0,
})

hl.window_rule({
	name = "mpv-video0",
	match = { title = "video0 - mpv" },
	float = true,
	size = { 256, 192 },
	move = { 1640, 858 },
})

hl.window_rule({
	name = "xwaylandvideobridge",
	match = { class = "xwaylandvideobridge" },
	no_blur = true,
	max_size = { 1, 1 },
	no_initial_focus = true,
	no_anim = true,
	opacity = "0.0 override",
})

hl.window_rule({
	name = "move-discord-to-6",
	match = { class = "[Dd]iscord|[Ww]ebCord|[Vv]esktop" },
	workspace = "7 silent",
})

hl.window_rule({
	name = "quite-kde-popup",
	match = { class = [[^(org\.kde\.kdeconnect.*)$]] },
	no_focus = true,
	no_initial_focus = true,
	stay_focused = true,
	opacity = "0 override",
})

------------------
-- KEYBINDS -----
------------------

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("qalculate-qt"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(home .. "/dev/dotfiles/hypr/scripts/launcher.sh"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(home .. "/dev/dotfiles/hypr/scripts/powermenu.sh"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(home .. "/dev/dotfiles/hypr/scripts/clipboard.sh"))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd(home .. "/dev/dotfiles/hypr/scripts/shell_history.sh"))
hl.bind(mainMod .. " + W", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.exec_cmd("hyprpicker -a -n"))
hl.bind(mainMod .. " + TAB", hl.dsp.focus({ last = true }))
hl.bind(mainMod .. " + Q", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(home .. "/dev/dotfiles/hypr/scripts/capture.sh"))
hl.bind(mainMod .. " + F2", hl.dsp.exec_cmd("grimshot savecopy screen"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("grimshot savecopy area"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("hyprvoice toggle"))
hl.bind(
	mainMod .. " + SHIFT + D",
	hl.dsp.exec_cmd(
		'mkdir -p ~/Pictures/ && FILE=~/Pictures/screenshot-$(date +%Y-%m-%d_%H-%M-%S).png && grimshot save screen "$FILE" && sleep 0.2 && wl-copy < "$FILE" && kdeconnect-cli -d $(kdeconnect-cli --list-available --id-only | head -n1) --share "$FILE"'
	)
)

hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + T", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5 --allow-boost"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5 --allow-boost"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pamixer --default-source -t"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer -t"), { locked = true, repeating = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

for i = 1, 9 do
	hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }))
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }))

hl.bind(mainMod .. " + g", hl.dsp.group.toggle())
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.workspace.toggle_special(""))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("hyprlock"))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
