-- User variables and color references
-- Other configs should require() this module for shared values

local home = os.getenv("HOME")
local scheme = pcall(require, "scheme.current") and require("scheme.current") or require("scheme.default")

local vars = {}

-- ### Paths
vars.home = home
vars.configDir = home .. "/.config/hypr"
vars.hyprDir = home .. "/.config/hypr/hyprland"
vars.userConfDir = home .. "/.config/caelestia"
vars.wsaction = home .. "/.config/hypr/scripts/wsaction.fish"

-- ### Hyprland apps
vars.terminal = "kitty"
vars.browser = "zen-browser"
vars.editor = "kitty -e nvim"
vars.fileExplorer = "kitty -e yazi"

-- ### Touchpad
vars.touchpadDisableTyping = true
vars.touchpadScrollFactor = 1.5
vars.workspaceSwipeFingers = 4
vars.gestureFingers = 3
vars.gestureFingersMore = 4

-- ### Blur
vars.blurEnabled = true
vars.blurSpecialWs = false
vars.blurPopups = true
vars.blurInputMethods = true
vars.blurSize = 8
vars.blurPasses = 2
vars.blurXray = true

-- ### Shadow
vars.shadowEnabled = false
vars.shadowRange = 20
vars.shadowRenderPower = 3
vars.shadowColour = "rgba(" .. scheme.surfaceDim .. "d4)"

-- ### Gaps
vars.workspaceGaps = 10
vars.windowGapsIn = 4
vars.windowGapsOut = 10
vars.singleWindowGapsOut = 10

-- ### Window styling
vars.windowOpacity = 0.95
vars.windowRounding = 10
vars.windowBorderSize = 3
vars.activeWindowBorderColour = "rgba(" .. scheme.primary .. "e6)"
vars.inactiveWindowBorderColour = "rgba(" .. scheme.onSurfaceVariant .. "11)"

-- ### Misc
vars.volumeStep = 5
vars.cursorTheme = "macOS"
vars.cursorSize = 24

-- ### Keybind helpers
vars.kbMoveWinToWs = "SUPER + SHIFT"
vars.kbMoveWinToWsGroup = "CTRL + SUPER + ALT"
vars.kbGoToWs = "SUPER"
vars.kbGoToWsGroup = "CTRL + SUPER"

vars.kbNextWs = "CTRL + SUPER + J"
vars.kbPrevWs = "CTRL + SUPER + K"

vars.kbToggleSpecialWs = "SUPER + S"

-- Window groups
vars.kbWindowGroupCycleNext = "ALT + Tab"
vars.kbWindowGroupCyclePrev = "SHIFT + ALT + Tab"
vars.kbUngroup = "SUPER + U"
vars.kbToggleGroup = "SUPER + Comma"

-- Window actions
vars.kbMoveWindow = "SUPER + Z"
vars.kbResizeWindow = "SUPER + X"
vars.kbWindowPip = "SUPER + ALT + Backslash"
vars.kbPinWindow = "SUPER + P"
vars.kbWindowFullscreen = "SUPER + F"
vars.kbWindowBorderedFullscreen = "SUPER + ALT + F"
vars.kbToggleWindowFloating = "SUPER + ALT + Space"
vars.kbCloseWindow = "SUPER + Q"

-- Special workspace toggles
vars.kbSystemMonitor = "CTRL + SHIFT + Escape"
vars.kbMusic = "SUPER + M"
vars.kbCommunication = "SUPER + D"
vars.kbTodo = "SUPER + T"
vars.kbBooks = "SUPER + B"

-- Apps
vars.kbTerminal = "SUPER + Return"
vars.kbBrowser = "SUPER + W"
vars.kbEditor = "SUPER + C"
vars.kbFileExplorer = "SUPER + E"

-- Misc
vars.kbSession = "CTRL + ALT + Delete"
vars.kbClearNotifs = "CTRL + ALT + C"
vars.kbShowPanels = "SUPER + A"
vars.kbLock = "CTRL + ALT + L"
vars.kbRestoreLock = "SUPER + ALT + L"

return vars
