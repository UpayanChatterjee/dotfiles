-- Window, workspace, and layer rules
local vars = require("variables")

-- #### Window rules ####

-- Opacity for non-fullscreen windows
hl.window_rule({
	match = { fullscreen = false },
	opacity = vars.windowOpacity .. " override",
})

-- Opaque windows (native transparency or we want them opaque)
hl.window_rule({
	match = { class = "foot|equibop|org\\.quickshell|imv|swappy" },
	opaque = true,
})

-- Center all floating windows (not xwayland because of popups)
hl.window_rule({
	match = { float = true, xwayland = false },
	center = true,
})

-- Float various apps
local floatRules = {
	"guifetch",
	"yad",
	"zenity",
	"wev",
	"org\\.gnome\\.FileRoller",
	"file-roller",
	"blueman-manager",
	"com\\.github\\.GradienceTeam\\.Gradience",
	"feh",
	"imv",
	"system-config-printer",
	"org\\.quickshell",
}
for _, cls in ipairs(floatRules) do
	hl.window_rule({ match = { class = cls }, float = true })
end

-- Float, resize and center specific apps
hl.window_rule({
	match = { class = "foot", title = "nmtui" },
	float = true,
	size = { "60%", "70%" },
	center = true,
})
hl.window_rule({
	match = { class = "org\\.gnome\\.Settings" },
	float = true,
	size = { "70%", "80%" },
	center = true,
})
hl.window_rule({
	match = { class = "org\\.pulseaudio\\.pavucontrol|yad-icon-browser" },
	float = true,
	size = { "60%", "70%" },
	center = true,
})
hl.window_rule({
	match = { class = "nwg-look" },
	float = true,
	size = { "50%", "60%" },
	center = true,
})

-- Special workspaces
hl.window_rule({ match = { class = "btop|org\\.kde\\.plasma-systemmonitor" }, workspace = "special:sysmon" })

hl.window_rule({
	match = { class = "feishin|Spotify|Supersonic|Cider|cider|com\\.github\\.th_ch\\.youtube_music" },
	workspace = "special:music",
})
hl.window_rule({
	match = { initial_title = "Spotify( Free)?" },
	workspace = "special:music",
})

hl.window_rule({
	match = { class = "discord|equibop|vesktop|whatsapp|com\\.rtosta\\.zapzap|com\\.ktechpit\\.whatsie" },
	workspace = "special:communication",
})
hl.window_rule({
	match = { class = "Todoist|io\\.github\\.alainm23\\.planify" },
	workspace = "special:todo",
})
hl.window_rule({
	match = { class = "calibre-gui|calibre|com\\.bilingify\\.readest|readest" },
	workspace = "special:books",
})
hl.window_rule({
	match = { class = "seanime-denshi|com\\.stremio\\.stremio" },
	workspace = "special:anime",
})

-- Dialogs
hl.window_rule({ match = { title = "(Select|Open)( a)? (File|Folder)(s)?" }, float = true })
hl.window_rule({ match = { title = "File (Operation|Upload)( Progress)?" }, float = true })
hl.window_rule({ match = { title = ".* Properties" }, float = true })
hl.window_rule({ match = { title = "Export Image as PNG" }, float = true })
hl.window_rule({ match = { title = "GIMP Crash Debug" }, float = true })
hl.window_rule({ match = { title = "Save As" }, float = true })
hl.window_rule({ match = { title = "Library" }, float = true })

-- Picture in picture
hl.window_rule({
	match = { title = "Picture(-| )in(-| )[Pp]icture" },
	move = { "100%-w-2%", "100%-w-3%" },
	keep_aspect_ratio = true,
	float = true,
	pin = true,
})

-- warp-gui
hl.window_rule({
	match = {
		title = "warp cloudflare",
		-- class = "python3",
	},
	float = true,
	keep_aspect_ratio = true,
	move = { 57, 432 },
})

-- bitwarden extension
-- hl.window_rule({
-- 	match = {
-- 		title = "Zen Browser",
-- 		class = "zen",
-- 	},
-- 	float = true,
-- 	keep_aspect_ratio = true,
-- 	center = true,
-- })

-- Creative software (opaque)
hl.window_rule({
	match = { class = "krita|gimp|inkscape|darktable|resolve|kdenlive|shotcut|blender|godot" },
	opaque = true,
})

-- Ueberzugpp
hl.window_rule({ match = { class = "^(ueberzugpp_.*)$" }, float = true })
hl.window_rule({ match = { class = "^(ueberzugpp_.*)$" }, no_initial_focus = true })

-- Steam
hl.window_rule({ match = { class = "steam" }, rounding = 10 })
hl.window_rule({ match = { class = "steam", title = "Friends List" }, float = true })
-- Allow tearing for steam games
hl.window_rule({ match = { class = "steam_app_[0-9]+" }, immediate = true })
-- Always idle inhibit when playing a steam game
hl.window_rule({ match = { class = "steam_app_[0-9]+" }, idle_inhibit = "always" })

-- ATLauncher console
hl.window_rule({
	match = { class = "com-atlauncher-App", title = "ATLauncher Console" },
	float = true,
})

-- Autodesk Fusion 360
hl.window_rule({
	match = { title = "Fusion360|(Marking Menu)", class = "fusion360\\.exe" },
	no_blur = true,
})

-- Xwayland popups (win[0-9]+)
hl.window_rule({ match = { xwayland = true, title = "win[0-9]+" }, no_dim = true })
hl.window_rule({ match = { xwayland = true, title = "win[0-9]+" }, no_shadow = true })
hl.window_rule({ match = { xwayland = true, title = "win[0-9]+" }, rounding = 10 })

-- Clipse clipboard manager
hl.window_rule({
	match = { class = "^(clipse)$" },
	float = true,
	size = { 622, 652 },
	center = true,
})

-- xembedsniproxy window
hl.window_rule({
	match = { class = "^$", title = "^$" },
	no_initial_focus = true,
	focus_on_activate = false,
	suppress_event = "activate activatefocus",
	float = true,
	no_focus = true,
	no_blur = true,
	no_shadow = true,
	opacity = "0.0 override",
	-- move = { 0, 0 },
	size = { 0, 0 },
	allows_input = false,
	-- workspace = "special",
	-- render_unfocused = false,
})

-- Force KDE apps to be fully opaque (fixes transparent menus)
-- hl.window_rule({ match = { class = "^(org\\.kde.*)$" }, force_rgbx = true })
-- hl.window_rule({ match = { class = "^(org\\.qbittorrent\\.qBittorrent)$" }, force_rgbx = true })
-- hl.window_rule({ match = { class = "^peazip$" }, force_rgbx = true })

-- Vivaldi: full opacity (transparency handled by CSS backdrop-filter per-element)
hl.window_rule({ match = { class = "vivaldi-stable" }, opacity = "1.0 override" })

-- rdr2 fix
hl.window_rule({ match = { class = "^(rdr2\\.exe)$" }, fullscreen = true })

-- Float XDM main window and dialogs
hl.window_rule({ match = { class = "^(xdm-app)$" }, float = true, size = { 700, 500 }, center = true })
hl.window_rule({ match = { class = "^(Xdm-app)$" }, float = true, size = { 700, 500 }, center = true })

-- Blur readest

-- #### Workspace rules ####
hl.workspace_rule({
	workspace = "w[tv1]s[false]",
	gaps_out = vars.singleWindowGapsOut,
})
hl.workspace_rule({
	workspace = "f[1]s[false]",
	gaps_out = vars.singleWindowGapsOut,
})

-- #### Layer rules ####
-- Colour picker
hl.layer_rule({ match = { namespace = "hyprpicker" }, animation = "fade" })
-- wlogout
hl.layer_rule({ match = { namespace = "logout_dialog" }, animation = "fade" })
-- slurp
hl.layer_rule({ match = { namespace = "selection" }, animation = "fade" })
-- wayfreeze
hl.layer_rule({ match = { namespace = "wayfreeze" }, animation = "fade" })

-- Fuzzel
hl.layer_rule({ match = { namespace = "launcher" }, animation = "popin 80%" })
hl.layer_rule({ match = { namespace = "launcher" }, blur = true })

-- Shell (caelestia)
hl.layer_rule({ match = { namespace = "caelestia-(border-exclusion|area-picker)" }, no_anim = true })
hl.layer_rule({ match = { namespace = "caelestia-(drawers|background)" }, animation = "fade" })
hl.layer_rule({ match = { namespace = "caelestia-drawers" }, blur = true })
hl.layer_rule({ match = { namespace = "caelestia-drawers" }, ignore_alpha = 0.57 })

-- Overview blur
hl.layer_rule({ match = { namespace = "quickshell:overview-blur" }, blur = true })
hl.layer_rule({ match = { namespace = "quickshell:overview-blur" }, ignore_alpha = 0.2 })

-- Vicinae
hl.layer_rule({ match = { namespace = "vicinae" }, blur = true, ignore_alpha = 0, no_anim = true })

-- GTK blur?
-- hl.layer_rule({ match = { namespace = "gtk-layer-shell" }, blur = true })
-- hl.layer_rule({ match = { namespace = "gtk-layer-shell" }, ignore_alpha = true })
