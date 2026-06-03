pragma ComponentBehavior: Bound

import QtQuick
import Caelestia.Config
import qs.components
import qs.components.misc
import qs.services
import qs.utils

StyledRect {
    id: root

    readonly property color cpuColour: Colours.palette.m3primary
    readonly property color ramColour: Colours.palette.m3tertiary

    implicitWidth: Tokens.sizes.bar.innerWidth
    implicitHeight: layout.implicitHeight + Tokens.padding.normal * 2

    color: Colours.tPalette.m3surfaceContainer
    radius: Tokens.rounding.full

    Ref {
        service: SystemUsage
    }

    Column {
        id: layout

        anchors.centerIn: parent
        spacing: Tokens.spacing.smaller

        Column {
            visible: BarExtras.showCpu
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 0

            MaterialIcon {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "memory"
                font.pointSize: Tokens.font.size.small
                color: root.cpuColour
            }
            StyledText {
                anchors.horizontalCenter: parent.horizontalCenter
                textFormat: Text.StyledText
                text: `<b>${Math.round(SystemUsage.cpuPerc * 100)}</b>%`
                font.pixelSize: 11
                color: root.cpuColour
            }
        }

        Column {
            visible: BarExtras.showRam
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 0

            MaterialIcon {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "memory_alt"
                font.pointSize: Tokens.font.size.small
                color: root.ramColour
            }
            StyledText {
                anchors.horizontalCenter: parent.horizontalCenter
                textFormat: Text.StyledText
                text: `<b>${Math.round(SystemUsage.memPerc * 100)}</b>%`
                font.pixelSize: 11
                color: root.ramColour
            }
        }
    }
}
