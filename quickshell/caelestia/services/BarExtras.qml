pragma Singleton

import Quickshell

Singleton {
    property alias showNetSpeed: store.showNetSpeed

    PersistentProperties {
        id: store

        reloadableId: "barExtras"
        property bool showNetSpeed: true
    }
}
