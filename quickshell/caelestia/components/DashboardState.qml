pragma Singleton

import Quickshell

PersistentProperties {
    reloadableId: "dashboardState"

    property int currentTab
    property date currentDate: new Date()
}
