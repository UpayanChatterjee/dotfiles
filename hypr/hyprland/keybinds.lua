-- Keybindings
local vars = require("variables")
local home = vars.home

-- Launcher (Super key press/release)
hl.bind("SUPER + Super_L", hl.dsp.global("caelestia:launcher"), { release = true })

-- Misc keybinds
hl.bind(vars.kbSession, hl.dsp.global("caelestia:session"))
hl.bind(vars.kbLock, hl.dsp.global("caelestia:lock"))

-- Dashboard tabs
hl.bind("CTRL + SUPER + M", hl.dsp.global("caelestia:dashboardMedia"))
hl.bind("CTRL + SUPER + P", hl.dsp.global("caelestia:dashboardPerformance"))
hl.bind("CTRL + SUPER + W", hl.dsp.global("caelestia:dashboardWeather"))

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.global("caelestia:brightnessUp"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.global("caelestia:brightnessDown"), { locked = true })

-- Media
hl.bind("CTRL + SUPER + Space", hl.dsp.global("caelestia:mediaToggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.global("caelestia:mediaToggle"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.global("caelestia:mediaToggle"), { locked = true })
hl.bind("Pause", hl.dsp.global("caelestia:mediaToggle"), { locked = true })
hl.bind("CTRL + SUPER + Equal", hl.dsp.global("caelestia:mediaNext"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.global("caelestia:mediaNext"), { locked = true })
hl.bind("CTRL + SUPER + Minus", hl.dsp.global("caelestia:mediaPrev"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.global("caelestia:mediaPrev"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.global("caelestia:mediaStop"), { locked = true })
hl.bind("CTRL + SUPER + N", hl.dsp.global("caelestia:mediaNextPlayer"), { locked = true })

-- CapsLock/NumLock detection: on Hyprland 0.55.4 hl.bind("Caps_Lock"/"Num_Lock", ...)
-- registers (and survives reload) but never *fires* on toggle, so upstream's
-- caelestia:refreshDevices bind approach is a no-op here. Instead, Quickshell polls
-- keyboard state every 500ms (Timer in services/Hypr.qml). Revisit if a future
-- Hyprland makes lock-key binds actually trigger.

-- Kill/restart shell (release binds)
hl.bind("CTRL + SUPER + SHIFT + R", hl.dsp.exec_cmd("qs -c caelestia kill"), { release = true })
hl.bind(
	"CTRL + SUPER + ALT + R",
	hl.dsp.exec_cmd("qs -c caelestia kill; sleep .1; caelestia shell -d"),
	{ release = true }
)

-- Go to workspace
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(vars.kbGoToWs .. " + " .. key, hl.dsp.exec_cmd(vars.wsaction .. " workspace " .. i))
end

-- Go to workspace group
for i = 1, 10 do
	local key = i % 10
	hl.bind(vars.kbGoToWsGroup .. " + " .. key, hl.dsp.exec_cmd(vars.wsaction .. " -g workspace " .. i))
end

-- Go to workspace -1/+1
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(vars.kbPrevWs, hl.dsp.focus({ workspace = "e-1" }), { repeating = true })
hl.bind(vars.kbNextWs, hl.dsp.focus({ workspace = "e+1" }), { repeating = true })
hl.bind("SUPER + Page_Up", hl.dsp.focus({ workspace = "e-1" }), { repeating = true })
hl.bind("SUPER + Page_Down", hl.dsp.focus({ workspace = "e+1" }), { repeating = true })

-- Go to workspace group -1/+1
hl.bind("CTRL + SUPER + mouse_down", hl.dsp.focus({ workspace = "e-10" }))
hl.bind("CTRL + SUPER + mouse_up", hl.dsp.focus({ workspace = "e+10" }))

-- Toggle special workspace
hl.bind(vars.kbToggleSpecialWs, hl.dsp.workspace.toggle_special("special"))

-- Move window to workspace
for i = 1, 10 do
	local key = i % 10
	hl.bind(vars.kbMoveWinToWs .. " + " .. key, hl.dsp.exec_cmd(vars.wsaction .. " movetoworkspace " .. i))
end

-- Move window to workspace group
for i = 1, 10 do
	local key = i % 10
	hl.bind(vars.kbMoveWinToWsGroup .. " + " .. key, hl.dsp.exec_cmd(vars.wsaction .. " -g movetoworkspace " .. i))
end

-- Move window to workspace -1/+1
hl.bind("SUPER + ALT + Page_Up", hl.dsp.window.move({ workspace = "e-1" }), { repeating = true })
hl.bind("SUPER + ALT + Page_Down", hl.dsp.window.move({ workspace = "e+1" }), { repeating = true })
hl.bind("SUPER + ALT + mouse_down", hl.dsp.window.move({ workspace = "e-1" }))
hl.bind("SUPER + ALT + mouse_up", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind("CTRL + SUPER + SHIFT + right", hl.dsp.window.move({ workspace = "e+1" }), { repeating = true })
hl.bind("CTRL + SUPER + SHIFT + left", hl.dsp.window.move({ workspace = "e-1" }), { repeating = true })

-- Move window to/from special workspace
hl.bind("CTRL + SUPER + SHIFT + up", hl.dsp.window.move({ workspace = "special:special" }))
hl.bind("CTRL + SUPER + SHIFT + down", hl.dsp.window.move({ workspace = "e+0" }))
hl.bind("SUPER + ALT + S", hl.dsp.window.move({ workspace = "special:special" }))

-- Window groups (cycle through all windows, not just grouped/tabbed windows)
hl.bind(vars.kbWindowGroupCycleNext, hl.dsp.group.next(), { repeating = true })
hl.bind(vars.kbWindowGroupCyclePrev, hl.dsp.group.prev(), { repeating = true })
hl.bind("CTRL + ALT + Tab", hl.dsp.group.move_window({ forward = true }), { repeating = true })
hl.bind("CTRL + SHIFT + ALT + Tab", hl.dsp.group.move_window({ forward = false }), { repeating = true })
hl.bind(vars.kbToggleGroup, hl.dsp.group.toggle())
hl.bind(vars.kbUngroup, hl.dsp.window.move({ out_of_group = true }))
hl.bind("SUPER + SHIFT + Comma", hl.dsp.group.lock_active({ action = "toggle" }))

-- Window actions - focus
hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }))

-- Window actions - move
hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "d" }))

-- Window actions - resize
hl.bind("SUPER + Minus", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + Equal", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + SHIFT + Minus", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
hl.bind("SUPER + SHIFT + Equal", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })

-- Window actions - mouse bindings
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(vars.kbMoveWindow, hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(vars.kbResizeWindow, hl.dsp.window.resize(), { mouse = true })

-- Window actions - window state
hl.bind("CTRL + SUPER + Backslash", hl.dsp.window.center())
hl.bind("CTRL + SUPER + ALT + Backslash", function()
	hl.dispatch(hl.dsp.window.resize({ x = 55, y = 70 }))
	hl.dispatch(hl.dsp.window.center())
end)
hl.bind(vars.kbWindowPip, hl.dsp.exec_cmd("caelestia resizer pip"))
hl.bind(vars.kbPinWindow, hl.dsp.window.pin())
hl.bind(vars.kbWindowFullscreen, hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(vars.kbWindowBorderedFullscreen, hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(vars.kbToggleWindowFloating, hl.dsp.window.float({ action = "toggle" }))
hl.bind(vars.kbCloseWindow, hl.dsp.window.close())

-- Special workspace toggles
hl.bind(vars.kbSystemMonitor, hl.dsp.exec_cmd("caelestia toggle sysmon"))
hl.bind(vars.kbMusic, hl.dsp.exec_cmd("caelestia toggle music"))
hl.bind(vars.kbCommunication, hl.dsp.exec_cmd("caelestia toggle communication"))
hl.bind(vars.kbTodo, hl.dsp.exec_cmd("caelestia toggle todo"))
hl.bind(vars.kbBooks, hl.dsp.exec_cmd("caelestia toggle books"))
hl.bind(vars.kbAnime, hl.dsp.exec_cmd("caelestia toggle anime"))

-- Apps
hl.bind(vars.kbTerminal, hl.dsp.exec_cmd(home .. "/.local/bin/smart_kitty.sh"))
hl.bind(vars.kbBrowser, hl.dsp.exec_cmd("app2unit -- " .. vars.browser))
hl.bind(vars.kbEditor, hl.dsp.exec_cmd("app2unit -- " .. vars.editor))
hl.bind(vars.kbFileExplorer, hl.dsp.exec_cmd("app2unit -- " .. vars.fileExplorer))
hl.bind("SUPER + ALT + E", hl.dsp.exec_cmd("app2unit -- nemo"))
hl.bind("CTRL + ALT + Escape", hl.dsp.exec_cmd("app2unit -- qps"))
hl.bind("CTRL + ALT + V", hl.dsp.exec_cmd("app2unit -- pavucontrol"))
hl.bind("SUPER + N", hl.dsp.exec_cmd(home .. "/.local/bin/night-mode.sh"))
hl.bind("SUPER + SHIFT + T", hl.dsp.exec_cmd("quickshell -c QuickSnip -n"))

-- Utilities - screenshots
hl.bind("Print", hl.dsp.exec_cmd("caelestia screenshot"), { locked = true })
hl.bind("SUPER + SHIFT + S", hl.dsp.global("caelestia:screenshotFreeze"))
hl.bind("SUPER + SHIFT + ALT + S", hl.dsp.global("caelestia:screenshot"))
hl.bind("SUPER + ALT + R", hl.dsp.exec_cmd("caelestia record -s"))
hl.bind("CTRL + ALT + R", hl.dsp.exec_cmd("caelestia record"))
hl.bind("SUPER + SHIFT + ALT + R", hl.dsp.exec_cmd("caelestia record -r"))
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))

-- Volume
hl.bind("XF86AudioMicMute", hl.dsp.global("caelestia:micMute"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.global("caelestia:volumeMute"), { locked = true })
hl.bind("SUPER + SHIFT + M", hl.dsp.global("caelestia:volumeMute"), { locked = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.global("caelestia:volumeUp"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.global("caelestia:volumeDown"), { locked = true, repeating = true })

-- Sleep
hl.bind("SUPER + SHIFT + Z", hl.dsp.exec_cmd("systemctl suspend-then-hibernate"))

-- Clipboard and emoji
hl.bind("SUPER + V", hl.dsp.exec_cmd("kitty --class clipse -e clipse"))
hl.bind("SUPER + ALT + V", hl.dsp.exec_cmd("pkill fuzzel || caelestia clipboard -d"))
hl.bind("SUPER + Period", hl.dsp.exec_cmd("pkill fuzzel || caelestia emoji -p"))
hl.bind(
	"CTRL + SHIFT + ALT + V",
	hl.dsp.exec_cmd('sleep 0.5s && ydotool type -d 1 "$(cliphist list | head -1 | cliphist decode)"'),
	{ locked = true }
)

-- Overview (quickshell)
hl.bind("SUPER + Tab", hl.dsp.exec_cmd("qs ipc -c overview call overview toggle"))

-- Keyboard pointer
hl.bind("SUPER + R", hl.dsp.exec_cmd("wl-kbptr -o modes=floating,click -o mode_floating.source=detect"))

-- Dictionary lookup
hl.bind("SUPER + SHIFT + D", hl.dsp.exec_cmd(home .. "/.local/bin/dict.sh"))

-- Testing (debug notification)
hl.bind(
	"SUPER + ALT + F12",
	hl.dsp.exec_cmd(
		'notify-send -u low -i dialog-information-symbolic \'Test notification\' "Here\'s a really long message to test truncation and wrapping\\nYou can middle click or flick this notification to dismiss it!" -a \'Shell\' -A "Test1=I got it!" -A "Test2=Another action"'
	),
	{ locked = true }
)

hl.bind("mouse:274", function()
	local w = hl.get_active_window()

	-- Evaluate using Lua's native string matching
	if w ~= nil and w.title:match("Picture[%- ]in[%- ][Pp]icture") then
		hl.dispatch(hl.dsp.window.drag())
	end
end, { mouse = true, non_consuming = true })

hl.bind("CTRL + Space", hl.dsp.exec_cmd("vicinae toggle"))

hl.bind("F12", hl.dsp.exec_cmd("kitten quick-access-terminal"))
