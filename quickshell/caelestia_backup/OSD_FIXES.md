# OSD Fixes: Fullscreen & Max Value

## Problems

1. **Fullscreen**: The volume/brightness OSD would not appear when a fullscreen application was active.
2. **Max brightness**: The OSD would not appear when pressing brightness keys at max/min because `setBrightness()` returned early without changing the property.
3. **Max volume**: The OSD would not appear when pressing volume keys at max/min. Root cause: volume keys were bound directly to `wpctl` in Hyprland (`exec`), bypassing Quickshell entirely. PipeWire emits no change event when the value is already clamped, so no QML signal ever fired.

---

## Fix 1 — OSD visible over fullscreen apps

**File**: `modules/drawers/ContentWindow.qml`

The drawer window's Wayland layer is controlled by `WlrLayershell.layer`. It was only set to `WlrLayer.Overlay` (above fullscreen apps) when `Config.general.showOverFullscreen` was enabled. Added an additional condition so that the layer switches to `Overlay` whenever the OSD itself is actively shown (`visibilities.osd`), regardless of the global setting.

```qml
// Before
WlrLayershell.layer: fsTransitionProg > 0 && contentItem.Config.general.showOverFullscreen ? WlrLayer.Overlay : WlrLayer.Top

// After
WlrLayershell.layer: (fsTransitionProg > 0 && contentItem.Config.general.showOverFullscreen) || (root.hasFullscreen && visibilities.osd) ? WlrLayer.Overlay : WlrLayer.Top
```

---

## Fix 2 — OSD shows at max/min brightness

**File**: `services/Brightness.qml`

`Monitor.setBrightness()` has an early return when the rounded brightness value hasn't changed (i.e. already at max or min). Added a `signal adjustAttempted()` that fires before that early return, so the OSD can react even when the value is clamped.

```qml
// Added to Monitor component
signal adjustAttempted()
```

```js
// In setBrightness(), emit before the early-return guard
function setBrightness(value: real): void {
    value = Math.max(0, Math.min(1, value));
    const rounded = Math.round(value * 100);
    adjustAttempted();          // <-- added
    if (Math.round(brightness * 100) === rounded)
        return;
    // ...
}
```

---

## Fix 3 — OSD shows at max/min volume

**Files**: `services/Audio.qml`, `~/.config/hypr/hyprland/keybinds.conf`

### Root cause
Volume keys were bound in Hyprland as `exec, wpctl set-volume ...`, running `wpctl` as an external process. Quickshell never saw the key press. When volume was already at max, `wpctl` made no change, PipeWire emitted no event, and the QML `onVolumeChanged` signal never fired.

### Part A — Route volume keys through Quickshell (`keybinds.conf`)
Added `CustomShortcut` entries to `Audio.qml` (matching the pattern brightness already uses) and changed the Hyprland volume bindings from `exec wpctl` to `global, caelestia:`:

```diff
- bindl = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
- bindl = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
- bindl = Super+Shift, M, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
- bindle = , XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ $volumeStep%+
- bindle = , XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ $volumeStep%-
+ bindl = , XF86AudioMicMute, global, caelestia:micMute
+ bindl = , XF86AudioMute, global, caelestia:volumeMute
+ bindl = Super+Shift, M, global, caelestia:volumeMute
+ bindle = , XF86AudioRaiseVolume, global, caelestia:volumeUp
+ bindle = , XF86AudioLowerVolume, global, caelestia:volumeDown
```

Note: `setVolume()` already calls `sink.audio.muted = false` before setting volume, so the unmute-on-raise behaviour is preserved. Step size matches the original `$volumeStep = 10` since `GlobalConfig.services.audioIncrement = 0.1`.

### Part B — Emit signals and add shortcuts (`services/Audio.qml`)
Added `volumeAdjustAttempted` / `sourceVolumeAdjustAttempted` signals (emitted in `increment`/`decrement` functions), `toggleMute()` / `toggleSourceMute()` helpers, and the four `CustomShortcut` entries.

**Important**: `Audio.qml` also needed `import qs.components.misc` added to its imports — that is where `CustomShortcut` is provided. `Brightness.qml` already had this import; `Audio.qml` did not, which caused a load failure on first restart (`CustomShortcut is not a type`). Without this import, Caelestia refuses to start entirely.

```qml
signal volumeAdjustAttempted()
signal sourceVolumeAdjustAttempted()

function toggleMute(): void {
    if (sink?.ready && sink?.audio)
        sink.audio.muted = !sink.audio.muted;
}
function toggleSourceMute(): void {
    if (source?.ready && source?.audio)
        source.audio.muted = !source.audio.muted;
}

function incrementVolume(amount: real): void {
    volumeAdjustAttempted();    // <-- added
    setVolume(volume + (amount || GlobalConfig.services.audioIncrement));
}
function decrementVolume(amount: real): void {
    volumeAdjustAttempted();    // <-- added
    setVolume(volume - (amount || GlobalConfig.services.audioIncrement));
}
// (same pattern for incrementSourceVolume / decrementSourceVolume)

// qmllint disable unresolved-type
CustomShortcut {
    name: "volumeUp"
    description: "Increase volume"
    onPressed: root.incrementVolume()
}
CustomShortcut {
    name: "volumeDown"
    description: "Decrease volume"
    onPressed: root.decrementVolume()
}
CustomShortcut {
    name: "volumeMute"
    description: "Toggle mute"
    onPressed: root.toggleMute()
}
CustomShortcut {
    name: "micMute"
    description: "Toggle microphone mute"
    onPressed: root.toggleSourceMute()
}
```

---

## Fix 4 — Wire new signals into the OSD

**File**: `modules/osd/Wrapper.qml`

Connected the three new signals to `root.show()` so the OSD appears. The existing `onVolumeChanged` / `onBrightnessChanged` handlers still update the displayed value when it actually changes; the new handlers purely trigger visibility.

```qml
Connections {
    // existing handlers unchanged ...

    function onVolumeAdjustAttempted(): void {
        root.show();
    }
    function onSourceVolumeAdjustAttempted(): void {
        root.show();
    }

    target: Audio
}

Connections {
    // existing onBrightnessChanged unchanged ...

    function onAdjustAttempted(): void {
        root.show();
    }

    target: root.monitor
}
```
