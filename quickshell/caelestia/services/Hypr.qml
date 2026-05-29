pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Caelestia
import Caelestia.Config
import Caelestia.Internal
import qs.components.misc

Singleton {
    id: root

    readonly property var toplevels: Hyprland.toplevels
    readonly property var workspaces: Hyprland.workspaces
    readonly property var monitors: Hyprland.monitors

    readonly property HyprlandToplevel activeToplevel: {
        const t = Hyprland.activeToplevel;
        return t?.workspace?.name.startsWith("special:") || Hyprland.focusedWorkspace?.toplevels.values.length > 0 ? t : null;
    }
    readonly property HyprlandWorkspace focusedWorkspace: Hyprland.focusedWorkspace
    readonly property HyprlandMonitor focusedMonitor: Hyprland.focusedMonitor
    readonly property int activeWsId: focusedWorkspace?.id ?? 1

    readonly property HyprKeyboard keyboard: extras.devices.keyboards.find(kb => kb.main) ?? null
    // Local lock key state - updated via hyprctl devices process query
    // (avoids relying on IPC relay for keyboard modifier changes)
    property bool _capsLock: false
    property bool _numLock: false
    readonly property bool capsLock: _capsLock
    readonly property bool numLock: _numLock
    readonly property string defaultKbLayout: keyboard?.layout.split(",")[0] ?? "??"
    readonly property string kbLayoutFull: keyboard?.activeKeymap ?? "Unknown"
    readonly property string kbLayout: kbMap.get(kbLayoutFull) ?? "??"
    readonly property var kbMap: new Map()

    readonly property alias extras: extras
    readonly property alias options: extras.options
    readonly property alias devices: extras.devices

    property bool hadKeyboard
    property string lastSpecialWorkspace: ""

    signal configReloaded

    function dispatch(request: string): void {
        // Translate old-style dispatcher names to Lua syntax for Hyprland 0.55+
        let luaRequest = request;

        // dpms off/on/toggle
        const dpmsMatch = request.match(/^dpms\s+(.+)$/);
        if (dpmsMatch) {
            const val = dpmsMatch[1];
            if (val === "off")
                luaRequest = 'hl.dsp.dpms({ action = "disable" })';
            else if (val === "on")
                luaRequest = 'hl.dsp.dpms({ action = "enable" })';
            else
                luaRequest = 'hl.dsp.dpms({ action = "toggle" })';
        }

        // togglespecialworkspace <name>
        const toggleMatch = request.match(/^togglespecialworkspace\s+(.+)$/);
        if (toggleMatch) {
            luaRequest = `hl.dsp.workspace.toggle_special("${toggleMatch[1]}")`;
        }

        // workspace <selector> (e.g. "workspace 1", "workspace r+1", "workspace special:name")
        const wsMatch = request.match(/^workspace\s+(.+)$/);
        if (wsMatch) {
            const arg = wsMatch[1];
            if (/^\d+$/.test(arg)) {
                luaRequest = `hl.dsp.focus({ workspace = ${arg} })`;
            } else {
                luaRequest = `hl.dsp.focus({ workspace = "${arg}" })`;
            }
        }

        // movetoworkspace <ws>[,address:0x...]
        const moveWsMatch = request.match(/^movetoworkspace\s+(.+?)(?:,address:(0x[0-9a-fA-F]+))?$/);
        if (moveWsMatch) {
            const ws = moveWsMatch[1];
            const addr = moveWsMatch[2];
            if (addr && (/^\d+$/.test(ws))) {
                luaRequest = `hl.dsp.window.move({ workspace = ${ws}, window = "${addr}" })`;
            } else if (addr) {
                luaRequest = `hl.dsp.window.move({ workspace = "${ws}", window = "${addr}" })`;
            } else if (/^\d+$/.test(ws)) {
                luaRequest = `hl.dsp.window.move({ workspace = ${ws} })`;
            } else {
                luaRequest = `hl.dsp.window.move({ workspace = "${ws}" })`;
            }
        }

        // togglefloating address:0x...
        const floatMatch = request.match(/^togglefloating\s+address:(0x[0-9a-fA-F]+)$/);
        if (floatMatch) {
            luaRequest = `hl.dsp.window.float({ action = "toggle", window = "${floatMatch[1]}" })`;
        }

        // pin address:0x...
        const pinMatch = request.match(/^pin\s+address:(0x[0-9a-fA-F]+)$/);
        if (pinMatch) {
            luaRequest = `hl.dsp.window.pin({ window = "${pinMatch[1]}" })`;
        }

        // killwindow address:0x...
        const killMatch = request.match(/^killwindow\s+address:(0x[0-9a-fA-F]+)$/);
        if (killMatch) {
            luaRequest = `hl.dsp.window.kill({ window = "${killMatch[1]}" })`;
        }

        Hyprland.dispatch(luaRequest);
    }

    function cycleSpecialWorkspace(direction: string): void {
        const openSpecials = workspaces.values.filter(w => w.name.startsWith("special:") && w.lastIpcObject.windows > 0);

        if (openSpecials.length === 0)
            return;

        const activeSpecial = focusedMonitor.lastIpcObject.specialWorkspace.name ?? "";

        if (!activeSpecial) {
            if (lastSpecialWorkspace) {
                const workspace = workspaces.values.find(w => w.name === lastSpecialWorkspace);
                if (workspace && workspace.lastIpcObject.windows > 0) {
                    dispatch(`workspace ${lastSpecialWorkspace}`);
                    return;
                }
            }
            dispatch(`workspace ${openSpecials[0].name}`);
            return;
        }

        const currentIndex = openSpecials.findIndex(w => w.name === activeSpecial);
        let nextIndex = 0;

        if (currentIndex !== -1) {
            if (direction === "next")
                nextIndex = (currentIndex + 1) % openSpecials.length;
            else
                nextIndex = (currentIndex - 1 + openSpecials.length) % openSpecials.length;
        }

        dispatch(`workspace ${openSpecials[nextIndex].name}`);
    }

    function monitorNames(): list<string> {
        return monitors.values.map(e => e.name);
    }

    function monitorFor(screen: ShellScreen): HyprlandMonitor {
        return Hyprland.monitorFor(screen);
    }

    function reloadDynamicConfs(): void {
        // Caps_Lock/Num_Lock bindlines are registered in keybinds.lua persistently
    }

    function notifyCapsLock(): void {
        if (!GlobalConfig.utilities.toasts.capsLockChanged)
            return;

        if (capsLock)
            Toaster.toast(qsTr("Caps lock enabled"), qsTr("Caps lock is currently enabled"), "keyboard_capslock_badge");
        else
            Toaster.toast(qsTr("Caps lock disabled"), qsTr("Caps lock is currently disabled"), "keyboard_capslock");
    }

    function notifyNumLock(): void {
        if (!GlobalConfig.utilities.toasts.numLockChanged)
            return;

        if (numLock)
            Toaster.toast(qsTr("Num lock enabled"), qsTr("Num lock is currently enabled"), "looks_one");
        else
            Toaster.toast(qsTr("Num lock disabled"), qsTr("Num lock is currently disabled"), "timer_1");
    }

    Component.onCompleted: {
        // Seed initial lock state from existing keyboard data (avoids flash at startup)
        const initialKb = extras.devices.keyboards.find(kb => kb.main);
        if (initialKb) {
            root._capsLock = initialKb.capsLock;
            root._numLock = initialKb.numLock;
            // Explicitly notify initial state since change handlers
            // won't fire if the state matches the default property value (false)
            root.notifyCapsLock();
            root.notifyNumLock();
        }
        reloadDynamicConfs();
        queryKeyboardState();
    }

    onCapsLockChanged: {
        console.log("onCapsLockChanged: capsLock=" + capsLock);
        root.notifyCapsLock();
    }

    onNumLockChanged: {
        console.log("onNumLockChanged: numLock=" + numLock);
        root.notifyNumLock();
    }

    onKbLayoutFullChanged: {
        if (hadKeyboard && GlobalConfig.utilities.toasts.kbLayoutChanged)
            Toaster.toast(qsTr("Keyboard layout changed"), qsTr("Layout changed to: %1").arg(kbLayoutFull), "keyboard");

        hadKeyboard = !!keyboard;
    }

    Connections {
        function onRawEvent(event: HyprlandEvent): void {
            const n = event.name;
            if (n.endsWith("v2"))
                return;

            if (n === "configreloaded") {
                root.configReloaded();
                root.reloadDynamicConfs();
            } else if (["workspace", "moveworkspace", "activespecial", "focusedmon"].includes(n)) {
                Hyprland.refreshWorkspaces();
                Hyprland.refreshMonitors();
            } else if (["openwindow", "closewindow", "movewindow"].includes(n)) {
                Hyprland.refreshToplevels();
                Hyprland.refreshWorkspaces();
            } else if (n.includes("mon")) {
                Hyprland.refreshMonitors();
            } else if (n.includes("workspace")) {
                Hyprland.refreshWorkspaces();
            } else if (n.includes("window") || n.includes("group") || ["pin", "fullscreen", "changefloatingmode", "minimize"].includes(n)) {
                Hyprland.refreshToplevels();
            }
        }

        target: Hyprland
    }

    Connections {
        function onLastIpcObjectChanged(): void {
            const specialName = root.focusedMonitor.lastIpcObject.specialWorkspace.name;

            if (specialName && specialName.startsWith("special:")) {
                root.lastSpecialWorkspace = specialName;
            }
        }

        target: root.focusedMonitor
    }

    FileView {
        id: kbLayoutFile

        path: Quickshell.env("CAELESTIA_XKB_RULES_PATH") || "/usr/share/X11/xkb/rules/base.lst"
        onLoaded: {
            const layoutMatch = text().match(/! layout\n([\s\S]*?)\n\n/);
            if (layoutMatch) {
                const lines = layoutMatch[1].split("\n");
                for (const line of lines) {
                    if (!line.trim() || line.trim().startsWith("!"))
                        continue;

                    const match = line.match(/^\s*([a-z]{2,})\s+([a-zA-Z() ]+)$/);
                    if (match)
                        root.kbMap.set(match[2], match[1]);
                }
            }

            const variantMatch = text().match(/! variant\n([\s\S]*?)\n\n/);
            if (variantMatch) {
                const lines = variantMatch[1].split("\n");
                for (const line of lines) {
                    if (!line.trim() || line.trim().startsWith("!"))
                        continue;

                    const match = line.match(/^\s*([a-zA-Z0-9_-]+)\s+([a-z]{2,}): (.+)$/);
                    if (match)
                        root.kbMap.set(match[3], match[2]);
                }
            }
        }
    }

    IpcHandler {
        function refreshDevices(): void {
            extras.refreshDevices();
            root.queryKeyboardState();
        }

        function cycleSpecialWorkspace(direction: string): void {
            root.cycleSpecialWorkspace(direction);
        }

        function listSpecialWorkspaces(): string {
            return root.workspaces.values.filter(w => w.name.startsWith("special:") && w.lastIpcObject.windows > 0).map(w => w.name).join("\n");
        }

        target: "hypr"
    }

    // qmllint disable unresolved-type
    CustomShortcut {
        // qmllint enable unresolved-type
        name: "refreshDevices"
        description: "Reload devices"
        onPressed: {
            console.log("CustomShortcut onPressed fired");
            extras.refreshDevices();
            root.queryKeyboardState();
        }
        // Only fire on press, not release, to avoid racing with a still-running process
        onReleased: {}
    }

    HyprExtras {
        id: extras
    }

    // Reads keyboard state from in-process objects after refreshDevices() updates them.
    // Retries up to 4 times (200ms apart = 800ms total window) because
    // extras.refreshDevices() may complete asynchronously and the first read
    // can see stale data. Stops early as soon as state actually changes.
    Timer {
        id: kbStateTimer
        interval: 200
        repeat: true
        property int retries: 0
        onTriggered: {
            const kb = extras.devices.keyboards.find(k => k.main);
            if (kb) {
                console.log("T: capsLock=" + kb.capsLock + " numLock=" + kb.numLock);
                const changed = (root._capsLock !== kb.capsLock || root._numLock !== kb.numLock);
                root._capsLock = kb.capsLock;
                root._numLock = kb.numLock;
                if (changed || retries >= 4) {
                    stop();
                }
            } else {
                stop();
            }
            retries++;
        }
    }

    function queryKeyboardState(): void {
        console.log("QKS: timer was " + kbStateTimer.running);
        kbStateTimer.stop();
        kbStateTimer.retries = 0;
        kbStateTimer.start();
    }

    // Periodic poll as a reliable fallback.
    Timer {
        id: pollTimer
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            extras.refreshDevices();
            root.queryKeyboardState();
        }
    }
}