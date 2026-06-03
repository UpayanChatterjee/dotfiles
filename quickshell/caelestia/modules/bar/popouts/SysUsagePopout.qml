import QtQuick
import QtQuick.Layouts
import Caelestia.Config
import qs.components
import qs.components.misc
import qs.services
import qs.utils

ColumnLayout {
    id: root

    spacing: Tokens.spacing.small
    width: 240

    Ref {
        service: SystemUsage
    }

    StyledText {
        Layout.topMargin: Tokens.padding.normal
        text: qsTr("System Usage")
        font.weight: 500
    }

    // CPU Section
    ColumnLayout {
        Layout.fillWidth: true
        spacing: Tokens.spacing.smaller

        RowLayout {
            spacing: Tokens.spacing.small
            MaterialIcon {
                text: "memory"
                color: Colours.palette.m3primary
            }
            StyledText {
                text: qsTr("CPU")
                font.weight: 500
            }
        }

        RowLayout {
            Layout.leftMargin: Tokens.spacing.large
            spacing: Tokens.spacing.large

            ColumnLayout {
                spacing: 0
                StyledText {
                    text: SystemUsage.cpuTemp >= 0 ? `${Math.round(SystemUsage.cpuTemp)}°C` : "—"
                    font.weight: 500
                }
                StyledText {
                    text: qsTr("Temp")
                    font.pointSize: Tokens.font.size.small
                    color: Colours.palette.m3onSurfaceVariant
                }
            }

            ColumnLayout {
                visible: SystemUsage.cpuFan >= 0
                spacing: 0
                StyledText {
                    text: `${SystemUsage.cpuFan} RPM`
                    font.weight: 500
                }
                StyledText {
                    text: qsTr("Fan Speed")
                    font.pointSize: Tokens.font.size.small
                    color: Colours.palette.m3onSurfaceVariant
                }
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        height: 1
        color: Colours.palette.m3outlineVariant
        opacity: 0.5
    }

    // GPU Section
    ColumnLayout {
        visible: SystemUsage.gpuType !== "NONE"
        Layout.fillWidth: true
        spacing: Tokens.spacing.smaller

        RowLayout {
            spacing: Tokens.spacing.small
            MaterialIcon {
                text: "desktop_windows"
                color: Colours.palette.m3secondary
            }
            StyledText {
                text: qsTr("GPU")
                font.weight: 500
            }
        }

        RowLayout {
            Layout.leftMargin: Tokens.spacing.large
            spacing: Tokens.spacing.large

            ColumnLayout {
                spacing: 0
                StyledText {
                    text: SystemUsage.gpuTemp >= 0 ? `${Math.round(SystemUsage.gpuTemp)}°C` : "—"
                    font.weight: 500
                }
                StyledText {
                    text: qsTr("Temp")
                    font.pointSize: Tokens.font.size.small
                    color: Colours.palette.m3onSurfaceVariant
                }
            }

            ColumnLayout {
                visible: SystemUsage.gpuFan >= 0
                spacing: 0
                StyledText {
                    text: `${SystemUsage.gpuFan} RPM`
                    font.weight: 500
                }
                StyledText {
                    text: qsTr("Fan Speed")
                    font.pointSize: Tokens.font.size.small
                    color: Colours.palette.m3onSurfaceVariant
                }
            }
        }
    }
}
