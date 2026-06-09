-- Autostart commands (run once on Hyprland startup)
local vars = require("variables")

hl.on("hyprland.start", function()
	-- Keyring and auth
	hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
	hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

	-- Clipboard history
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("clipse -listen")

	-- Auto delete trash 30 days old
	hl.exec_cmd("trash-empty 30")

	-- Cursors
	hl.exec_cmd("hyprctl setcursor " .. vars.cursorTheme .. " " .. vars.cursorSize)
	hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme '" .. vars.cursorTheme .. "'")
	hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size " .. vars.cursorSize)

	-- Location provider and night light
	hl.exec_cmd("/usr/lib/geoclue-2.0/demos/agent")
	hl.exec_cmd("sleep 1 && gammastep")
	-- hl.exec_cmd("hyprsunset")

	-- Forward bluetooth media commands to MPRIS
	hl.exec_cmd("mpris-proxy")

	-- Resize and move windows based on matches (e.g. pip)
	hl.exec_cmd("caelestia resizer -d")

	-- Start shell
	hl.exec_cmd("caelestia shell -d")

	-- Fix dolphin MIME
	hl.exec_cmd("kbuildsycoca6 --noincremental")

	hl.exec_cmd("bat cache --build")
	hl.exec_cmd("qs -c overview")
	hl.exec_cmd("hyprpm reload")

	-- XEmbed-to-SNI bridge (for legacy tray icons like XDM)
	hl.exec_cmd("xembedsniproxy")

	-- xdm (X11 backend needed for GtkStatusIcon -> XEmbed -> xembedsniproxy -> SNI)
	hl.exec_cmd("sleep 2 && GDK_BACKEND=x11 /opt/xdman/xdm-app --background")

	-- vicinae
	hl.exec_cmd("vicinae server")
end)
