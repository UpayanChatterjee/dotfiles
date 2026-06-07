pragma Singleton

import Quickshell

Singleton {
    property alias showNetSpeed: store.showNetSpeed
    property alias showCpu: store.showCpu
    property alias showRam: store.showRam

    PersistentProperties {
        id: store

        reloadableId: "barExtras"
        property bool showNetSpeed: true
        property bool showCpu: true
        property bool showRam: true
    }
}
