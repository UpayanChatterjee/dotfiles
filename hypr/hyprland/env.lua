-- Environment variables
local vars = require("variables")

-- Themes
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("XCURSOR_THEME", vars.cursorTheme)
hl.env("XCURSOR_SIZE", tostring(vars.cursorSize))

-- Toolkit backends
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland,x11,windows")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
-- hl.env("OZONE_PLATFORM", "wayland")

-- XDG specifications
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Others
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")
hl.env("XDG_MENU_PREFIX", "arch-")

-- hypr-hints (accessibility)
-- hl.env("AT_SPI_BUS_ADDRESS", "unix:path=/run/user/1000/at-spi/bus_1")
-- hl.env("ACCESSIBILITY_ENABLED", "1")
-- hl.env("QT_ACCESSIBILITY", "1")
-- hl.env("QT_LINUX_ACCESSIBILITY_ALWAYS_ON", "1")
-- hl.env("NO_AT_BRIDGE", "0")
