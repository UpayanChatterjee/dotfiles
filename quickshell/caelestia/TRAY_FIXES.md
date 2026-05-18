# Tray Icon Fix: Icons Disappear After Quickshell Reload

## Problem

After reloading Quickshell (`Ctrl+Super+Alt+R`), tray icons for apps like
cloudflare-warp-gui, Whatsie, and Lutris would sometimes vanish. The apps were
still running and reachable, but the system tray was empty. The only known fix
was logging out and back in.

---

## Root Cause

The StatusNotifier protocol has two sides:

| Role | Who | Lifetime |
|---|---|---|
| **StatusNotifierWatcher** | `kded6` | Persistent — survives Quickshell restarts |
| **StatusNotifierHost** | Quickshell | Tied to the Quickshell process |
| **StatusNotifierItems** | Individual apps | Registered with the watcher |

When Quickshell restarts there is a brief window where **no host is
registered**. `kded6` detects this and emits `StatusNotifierHostUnregistered`.

Many apps (especially Electron-based ones like Whatsie and cloudflare-warp-gui)
respond to that signal by **unregistering their tray item** from `kded6`. They
treat the signal as "no shell is listening, so there is no point keeping the
item alive." When the new Quickshell process registers as a host, `kded6` emits
`StatusNotifierHostRegistered` — but these apps do not watch for that signal and
never re-register. The tray stays empty for the rest of the session.

The "sometimes" behaviour came from a race condition: if the restart completed
fast enough, `kded6` had not yet finished emitting `StatusNotifierHostUnregistered`
before the new host appeared, so no signal was emitted and items stayed
registered. If the restart was slightly slower, the signal fired and icons were
lost.

Verified with `busctl`:
```sh
# Confirms the watcher lives in kded6, not Quickshell:
busctl --user list | grep StatusNotifier

# After a broken restart, this shows 0 items even with apps running:
busctl --user get-property org.kde.StatusNotifierWatcher \
  /StatusNotifierWatcher org.kde.StatusNotifierWatcher \
  RegisteredStatusNotifierItems
```

---

## Fix — Persistent StatusNotifierHost daemon

### Part A — The daemon (`~/.local/bin/caelestia-sni-host`)

A minimal Python daemon that claims a permanent DBus name and registers itself
as a StatusNotifierHost with `kded6`. Because it is independent of Quickshell,
it never goes away during a restart. `kded6` always sees at least one host, so
`IsStatusNotifierHostRegistered` never goes `false` and
`StatusNotifierHostUnregistered` is never emitted. Apps keep their tray items
registered throughout the restart.

```
~/.local/bin/caelestia-sni-host
```

DBus name claimed: `org.kde.StatusNotifierHost-caelestia-persistent`

### Part B — systemd user service (`~/.config/systemd/user/caelestia-sni-host.service`)

Runs the daemon as part of the graphical session. Starts automatically on login
and restarts on failure with a 1-second delay.

Enable/start (already done):
```sh
systemctl --user enable --now caelestia-sni-host.service
```

Verify it is running and both hosts are visible to kded6:
```sh
systemctl --user status caelestia-sni-host
busctl --user list | grep StatusNotifierHost
# Should show both:
#   org.kde.StatusNotifierHost-<qs-pid>-<ts>   (Quickshell)
#   org.kde.StatusNotifierHost-caelestia-persistent  (the daemon)
```

---

## Recovering from the already-broken state

The daemon only prevents **future** breakage. If tray icons are already missing
(the broken state was reached before the daemon was running), the affected apps
must be restarted once — their tray items then register with `kded6` and will
survive all future Quickshell restarts.

```sh
# Example: restart Whatsie
kill $(pgrep whatsie) && app2unit -- whatsie
```

After that one restart the icons will persist across Quickshell reloads
indefinitely as long as `caelestia-sni-host.service` is running.
