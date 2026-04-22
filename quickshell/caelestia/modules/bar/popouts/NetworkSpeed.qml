//popouts/NetworkSpeed.qml
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Caelestia.Config
import qs.components
import qs.services
import qs.utils
import Caelestia.Internal
import qs.components.misc

Item {
    id: root

    // Matches audio.qml - allows interaction with the master popup manager
    required property PopoutState popouts

    implicitWidth: layout.implicitWidth + Tokens.padding.normal * 2
    implicitHeight: layout.implicitHeight + Tokens.padding.normal * 2

    Ref {
        service: NetworkUsage
    }

    ColumnLayout {
        id: layout
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        spacing: Tokens.spacing.normal

        // Title mimicking audio.qml style
        StyledText {
            text: qsTr("Network")
            font.weight: 500
        }

        // Sparkline graph
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 48
            Layout.minimumWidth: 220 // Ensure the popup has a nice minimum width

            SparklineItem {
                id: sparkline

                property real targetMax: 1024
                property real smoothMax: targetMax

                anchors.fill: parent
                line1: NetworkUsage.uploadBuffer // qmllint disable missing-type
                line1Color: Colours.palette.m3secondary
                line1FillAlpha: 0.15
                line2: NetworkUsage.downloadBuffer // qmllint disable missing-type
                line2Color: Colours.palette.m3tertiary
                line2FillAlpha: 0.2
                maxValue: smoothMax
                historyLength: NetworkUsage.historyLength

                Connections {
                    function onValuesChanged(): void {
                        sparkline.targetMax = Math.max(NetworkUsage.downloadBuffer.maximum, NetworkUsage.uploadBuffer.maximum, 1024);
                        slideAnim.restart();
                    }
                    target: NetworkUsage.downloadBuffer
                }

                NumberAnimation {
                    id: slideAnim
                    target: sparkline
                    property: "slideProgress"
                    from: 0
                    to: 1
                    duration: GlobalConfig.dashboard.resourceUpdateInterval
                }

                Behavior on smoothMax {
                    Anim {
                        type: Anim.StandardLarge
                    }
                }
            }

            // "No data" placeholder
            StyledText {
                anchors.centerIn: parent
                text: qsTr("Collecting data...")
                font.pointSize: Tokens.font.size.small
                color: Colours.palette.m3onSurfaceVariant
                visible: NetworkUsage.downloadBuffer.count < 2
                opacity: 0.6
            }
        }

        // Download row
        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.normal

            MaterialIcon {
                text: "download"
                color: Colours.palette.m3tertiary
                font.pointSize: Tokens.font.size.normal
            }

            StyledText {
                text: qsTr("Download")
                font.pointSize: Tokens.font.size.small
                color: Colours.palette.m3onSurfaceVariant
            }

            Item {
                Layout.fillWidth: true
            }

            StyledText {
                text: {
                    const fmt = NetworkUsage.formatBytes(NetworkUsage.downloadSpeed ?? 0);
                    return fmt ? `${fmt.value.toFixed(1)} ${fmt.unit}` : "0.0 B/s";
                }
                font.pointSize: Tokens.font.size.normal
                font.weight: Font.Medium
                color: Colours.palette.m3tertiary
            }
        }

        // Upload row
        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.normal

            MaterialIcon {
                text: "upload"
                color: Colours.palette.m3secondary
                font.pointSize: Tokens.font.size.normal
            }

            StyledText {
                text: qsTr("Upload")
                font.pointSize: Tokens.font.size.small
                color: Colours.palette.m3onSurfaceVariant
            }

            Item {
                Layout.fillWidth: true
            }

            StyledText {
                text: {
                    const fmt = NetworkUsage.formatBytes(NetworkUsage.uploadSpeed ?? 0);
                    return fmt ? `${fmt.value.toFixed(1)} ${fmt.unit}` : "0.0 B/s";
                }
                font.pointSize: Tokens.font.size.normal
                font.weight: Font.Medium
                color: Colours.palette.m3secondary
            }
        }

        // Session totals
        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.normal

            MaterialIcon {
                text: "history"
                color: Colours.palette.m3onSurfaceVariant
                font.pointSize: Tokens.font.size.normal
            }

            StyledText {
                text: qsTr("Total")
                font.pointSize: Tokens.font.size.small
                color: Colours.palette.m3onSurfaceVariant
            }

            Item {
                Layout.fillWidth: true
            }

            StyledText {
                text: {
                    const down = NetworkUsage.formatBytesTotal(NetworkUsage.downloadTotal ?? 0);
                    const up = NetworkUsage.formatBytesTotal(NetworkUsage.uploadTotal ?? 0);
                    return (down && up) ? `↓${down.value.toFixed(1)}${down.unit} ↑${up.value.toFixed(1)}${up.unit}` : "↓0.0B ↑0.0B";
                }
                font.pointSize: Tokens.font.size.small
                color: Colours.palette.m3onSurfaceVariant
            }
        }
    }
}
