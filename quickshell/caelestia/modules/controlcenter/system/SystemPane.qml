pragma ComponentBehavior: Bound

import ".."
import "../components"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.components
import qs.components.containers
import qs.components.controls
import qs.components.effects
import qs.modules.controlcenter

Item {
    id: root

    required property Session session

    property bool usbSoundsEnabled: false
    property bool windowBlurEnabled: false

    anchors.fill: parent

    ClippingRectangle {
        id: systemClippingRect

        anchors.fill: parent
        anchors.margins: Tokens.padding.normal
        anchors.leftMargin: 0
        anchors.rightMargin: Tokens.padding.normal

        color: "transparent"
        radius: systemBorder.innerRadius

        Loader {
            anchors.fill: parent
            anchors.margins: Tokens.padding.large + Tokens.padding.normal
            anchors.leftMargin: Tokens.padding.large
            anchors.rightMargin: Tokens.padding.large

            sourceComponent: systemContentComponent
        }
    }

    InnerBorder {
        id: systemBorder

        leftThickness: 0
        rightThickness: Tokens.padding.normal
    }

    FileView {
        id: udevRuleFile

        path: "/etc/udev/rules.d/90-usb-sound.rules"
        printErrors: false
        onLoaded: root.usbSoundsEnabled = text().trim().length > 0
    }

    Process {
        id: enableProc

        command: ["pkexec", "bash", "/home/tony/user_scripts/external/usb_sound_enable.sh"]
        onRunningChanged: if (!running) udevRuleFile.reload()
    }

    Process {
        id: disableProc

        command: ["pkexec", "bash", "/home/tony/user_scripts/external/usb_sound_disable.sh"]
        onRunningChanged: if (!running) udevRuleFile.reload()
    }

    FileView {
        id: windowBlurStateFile

        path: `${Quickshell.env("HOME")}/.config/caelestia/window-blur-enabled`
        printErrors: false
        onLoaded: root.windowBlurEnabled = true
        onLoadFailed: root.windowBlurEnabled = false
    }

    Process {
        id: windowBlurProc

        command: [`${Quickshell.env("HOME")}/user_scripts/hypr/window_blur_toggle.sh`]
        onRunningChanged: if (!running) windowBlurStateFile.reload()
    }

    Component {
        id: systemContentComponent

        StyledFlickable {
            id: systemFlickable

            flickableDirection: Flickable.VerticalFlick
            contentHeight: systemLayout.height

            StyledScrollBar.vertical: StyledScrollBar {
                flickable: systemFlickable
            }

            ColumnLayout {
                id: systemLayout

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                spacing: Tokens.spacing.normal

                SectionContainer {
                    Layout.fillWidth: true
                    alignTop: true

                    StyledText {
                        text: qsTr("System")
                        font.pointSize: Tokens.font.size.normal
                    }

                    SwitchRow {
                        label: qsTr("USB sounds")
                        checked: root.usbSoundsEnabled
                        onToggled: checked => {
                            if (checked) {
                                enableProc.running = true;
                            } else {
                                disableProc.running = true;
                            }
                        }
                    }

                    SwitchRow {
                        label: qsTr("Window transparency")
                        checked: root.windowBlurEnabled
                        onToggled: _ => {
                            windowBlurProc.running = true;
                        }
                    }
                }
            }
        }
    }
}
