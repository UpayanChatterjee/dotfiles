# Caelestia Shell — Hyprland 0.55 Lua Migration

## 2026-06-09: Removed `keyword bindlni` from Hypr.qml

**File:** `services/Hypr.qml`

**What:** Removed `reloadDynamicConfs()` function and all its call sites. This function used `hyprctl keyword bindlni` to dynamically register CapsLock/NumLock keybinds at runtime.

**Why:** Hyprland 0.55 deprecated `hyprctl keyword` for keybinds. CapsLock/NumLock detection was later moved to a polling approach (see next section).

**Removed:**
- `reloadDynamicConfs()` function (was `keyword bindlni ,Caps_Lock,...` and `keyword bindlni ,Num_Lock,...`)
- `Component.onCompleted: reloadDynamicConfs()`
- `root.reloadDynamicConfs()` call from the `configreloaded` event handler

---

## 2026-06-09: CapsLock/NumLock fix for Hyprland 0.55

**Root cause:** Hyprland 0.55 cannot bind modifier-only keys (CapsLock, NumLock, Shift, Ctrl, Alt) as standalone bind targets. `hl.bind("Caps_Lock", ...)` simply never fires, regardless of dispatcher type (global, exec_cmd, or pure Lua callback).

Note: `hl.dsp.global()` works fine in 0.55 — all existing `caelestia:*` global keybinds (launcher, session, media, brightness, screenshots, volume, lock, etc.) continue to work. The CapsLock/NumLock problem is specific to binding modifier-only keys, not to the IPC mechanism.

**Fix:** Use a polling `Timer` in `services/Hypr.qml` that calls `extras.refreshDevices()` every 500ms. This detects lock state changes without needing a Hyprland keybind. The existing `onCapsLockChanged`/`onNumLockChanged` handlers then fire and show the toast.

**Modified file:** `~/.config/hypr/hyprland/keybinds.lua`
- Removed CapsLock/NumLock binds entirely (can't work in 0.55)
- Added comment explaining the polling approach

**Modified file:** `services/Hypr.qml`
- Added `Timer { interval: 500; running: true; repeat: true; onTriggered: extras.refreshDevices() }`
- The `IpcHandler { target: "hypr", function refreshDevices() }` and `CustomShortcut { name: "refreshDevices" }` remain for manual/other use

**New file:** `~/.local/bin/caelestia-ipc`
- Fast IPC helper for Quickshell socket (built during investigation, available for future use)
- Not actually needed — polling approach was the correct fix

---

## 2026-06-09: Restored missing volume key handlers in Audio.qml

**File:** `services/Audio.qml`

**What:** Restored four `CustomShortcut` entries (`volumeUp`, `volumeDown`, `volumeMute`, `micMute`) and their helper functions (`toggleMute()`, `toggleSourceMute()`) that were missing from the current version but present in the backup. Also restored `volumeAdjustAttempted()`/`sourceVolumeAdjustAttempted()` signals used by the OSD popout.

**Added:**
- `import qs.components.misc` (required for CustomShortcut)
- `signal volumeAdjustAttempted()` and `signal sourceVolumeAdjustAttempted()`
- `toggleMute()` and `toggleSourceMute()` functions
- Signal emissions in `setVolume()` and `setSourceVolume()`
- Four `CustomShortcut` entries: `volumeUp`, `volumeDown`, `volumeMute`, `micMute`

**To apply:** Restart Quickshell (`qs -c caelestia kill && caelestia shell -d`). The Timer starts running when the service loads.

---

## 2026-06-09: Changed volume step from 10% to 5%

**File:** `~/.config/caelestia/shell.json`

**What:** Changed `services.audioIncrement` from `0.1` to `0.05`.

**Why:** The user had set `vars.volumeStep = 5` in `~/.config/hypr/hyprland/variables.lua`, but that variable only affects volume steps for Hyprland's internal dispatcher (`hl.dsp.audio.volume`), not Caelestia. Caelestia reads its volume increment from `GlobalConfig.services.audioIncrement` (which maps to `shell.json` → `services.audioIncrement`). The volume keybinds call `hl.dsp.global("caelestia:volumeUp")` → `CustomShortcut` in `Audio.qml` → `root.incrementVolume()` → `setVolume(volume + GlobalConfig.services.audioIncrement)`.

---

## 2026-06-09: Replaced `Hyprland.dispatch()` with Lua-translated `hyprctl dispatch`

**File:** `services/Hypr.qml`

**What:** Replaced `Hypr.dispatch()` — originally `Hyprland.dispatch(request)` — with a translation function that converts old-style dispatch strings to Lua expressions and calls `hyprctl dispatch`:

```qml
function dispatch(request: string): void {
    // Translates e.g. "workspace 2" → "hl.dsp.focus({ workspace = 2 })"
    //                    "togglespecialworkspace special" → 'hl.dsp.workspace.toggle_special("special")'
    //                    "movetoworkspace 5,address:0xABC" → 'hl.dsp.window.move({ workspace = 5, address = "0xABC" })'
    // etc.
    Quickshell.execDetached(["hyprctl", "dispatch", lua]);
}
```

**Why:** Two problems stacked:
1. Quickshell's `Hyprland.dispatch()` IPC is broken with Hyprland 0.55 (fails silently).
2. `hyprctl dispatch` in 0.55 evaluates its argument as Lua, so the old syntax (`hyprctl dispatch workspace 2`) generates invalid Lua: `hl.dispatch(workspace 2)` — "workspace" is treated as a variable, not a dispatcher.

The fix translates old dispatch commands to their Lua equivalents (e.g., `hl.dsp.focus({ workspace = 2 })`) and passes them to `hyprctl dispatch` as a single argument, bypassing shell quoting issues via `execDetached`'s argv interface.

**Affected call sites (all fixed by this single change):**
- `Modules/bar/Bar.qml` — scroll-to-switch workspace
- `Modules/bar/components/workspaces/Workspaces.qml` — click-to-switch workspace
- `Modules/bar/components/workspaces/SpecialWorkspaces.qml` — special workspace toggles
- `Modules/windowinfo/Buttons.qml` — move, float, pin, kill buttons
- `Modules/IdleMonitors.qml` — dpms on/off

---

## 2026-06-09: Replaced battery icon with percentage + charging bolt

**File:** `modules/bar/components/StatusIcons.qml`

**What:** Replaced the dynamic battery `MaterialIcon` with a `ColumnLayout` containing:
- A `StyledText` showing the numeric battery percentage (e.g. `85`), using `Tokens.font.body.small`
- A small filled `bolt` icon below, visible only when charging/plugged in

**Why:** User preference — a number is more precise than a battery icon, and the charging bolt provides a compact plugged-in indicator without duplicating the percentage.

---

## 2026-06-09: Added network speed to bar status icons with hover popout

**Files:**
- `modules/bar/components/StatusIcons.qml` — added network speed display (download speed value + unit, two-line layout)
- `modules/bar/popouts/NetworkSpeed.qml` (new) — popout showing download/upload rates and session totals
- `modules/bar/popouts/Content.qml` — registered `"netspeed"` popout

**What:** The status icons column now shows current download speed (e.g. "1.2" on the first line, "MB/s" on the second line in smaller text). Hovering reveals a popout with download speed (arrow_downward), upload speed (arrow_upward), and session totals (history icon).

**Data source:** `NetworkUsage` singleton service (reads `/proc/net/dev`), same as the dashboard performance `NetworkCard`.

**Note:** No settings toggle was added. The `Caelestia.Config` module is a compiled C++ plugin at `/usr/lib/qt6/qml/Caelestia/Config/` — adding a `showNetworkSpeed` property would require modifying that C++ source and recompiling. For now, the network speed is always visible when `Config.bar.status.showNetwork` is true.

---

## 2026-06-09: Redesigned network speed display in status icons

**Files:**
- `modules/bar/components/StatusIcons.qml` — pulled network speed outside the pill, redesigned layout
- `modules/bar/Bar.qml` — added netspeed popout hit-testing fallback
- `modules/bar/popouts/NetworkSpeed.qml` — swapped upload/download order to match bar

**What:** Complete redesign of the network speed display:
- **Moved outside the pill background** — network speed sits bare on the taskbar; the `StyledRect` pill only wraps the remaining status icons (lock keys, audio, mic, kb layout, network, ethernet, bluetooth, battery). When `showNetwork` is false, the pill slides up seamlessly.
- Root changed from `StyledRect` to `Item` with explicit `implicitHeight` accounting for both netspeed loader and pill
- **Upload above, download below** (swapped order in both bar and popout)
- Format: `↑3M` / `↓12K` — arrow, whole number, single-letter unit, no spaces
- Numbers use `Math.round()` — no decimals; below 1 KB/s shows `0`
- Numbers rendered in **JetBrainsMono Nerd Font** at 11px, **bold**
- Arrows keep the default font at normal size and weight; upload arrow at 70% opacity
- Rows center-aligned, content-sized — no layout shifting when values change width
- Removed `animate: true` from value texts — no fade-out/fade-in blink on update
- **Popout fix:** Bar.qml `checkPopout()` falls back to checking the `netspeed` loader directly since it's no longer a child of `iconColumn`
- Exposed `netspeed` alias on StatusIcons root for Bar.qml hit-testing

**Why:** User wanted a compact, monospace, glanceable speed indicator that's visually separated from the other status icons.

---

## 2026-06-09: OSD now shows in fullscreen and at volume/brightness limits

**Files:**
- `modules/drawers/ContentWindow.qml` — always use `WlrLayer.Overlay` when fullscreen
- `modules/osd/Wrapper.qml` — listen to `volumeAdjustAttempted`/`sourceVolumeAdjustAttempted`/`brightnessAdjustAttempted` signals
- `services/Brightness.qml` — added `brightnessAdjustAttempted` signal to Monitor component

**What:** Three fixes:

1. **OSD now appears over fullscreen apps.** The drawers window layer was gated on `Config.general.showOverFullscreen` (default `false`), keeping it on `WlrLayer.Top` where the fullscreen app rendered above it. Removed the gate — the window always moves to `WlrLayer.Overlay` in fullscreen. The `emptyRegion` mask already restricts visibility to only OSD and notification cutouts, so other drawers won't leak.

2. **OSD now shows when volume is at min (0) or max.** `Wrapper.qml` only listened to `onVolumeChanged` (a property-change signal that doesn't fire when the value is clamped to the same boundary). Added handlers for `onVolumeAdjustAttempted` and `onSourceVolumeAdjustAttempted` — signals `Audio.qml` already emitted on every adjustment attempt regardless of whether the value changed.

3. **OSD now shows when brightness is at min (0%) or max (100%).** `Brightness.qml`'s `setBrightness()` returned early when the rounded value matched current brightness, preventing `brightnessChanged` from firing. Added a `brightnessAdjustAttempted` signal emitted at the very start of `setBrightness()`, before the early return, and connected `Wrapper.qml` to it.
