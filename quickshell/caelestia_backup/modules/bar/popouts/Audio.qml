pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import Caelestia.Config
import qs.components
import qs.components.controls
import qs.services

Item {
    id: root

    required property PopoutState popouts

    property string activeTab: "outputs"

    // Driven by widest content section — all three compute implicitWidth even when hidden
    implicitWidth: Math.max(outputsTab.implicitWidth, inputsTab.implicitWidth, appsTab.implicitWidth) + Tokens.padding.normal * 2
    implicitHeight: layout.implicitHeight + Tokens.padding.normal * 2

    ButtonGroup {
        id: sinks
    }

    ButtonGroup {
        id: sources
    }

    ColumnLayout {
        id: layout

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: Tokens.padding.normal
        anchors.rightMargin: Tokens.padding.normal
        anchors.verticalCenter: parent.verticalCenter
        spacing: Tokens.spacing.normal

        // Tab bar — custom StyledRect buttons avoid ToggleButton's expand-on-select animation
        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.small

            component TabButton: StyledRect {
                id: tabBtn

                required property string tabId
                required property string tabIcon
                required property string tabLabel

                readonly property bool active: root.activeTab === tabId

                Layout.fillWidth: true
                implicitHeight: tabContent.implicitHeight + Tokens.padding.smaller * 2
                radius: active ? Tokens.rounding.small : implicitHeight / 2 * Math.min(1, Tokens.rounding.scale)
                color: active ? Colours.palette.m3secondary : Colours.palette.m3secondaryContainer

                StateLayer {
                    color: tabBtn.active ? Colours.palette.m3onSecondary : Colours.palette.m3onSecondaryContainer
                    onClicked: root.activeTab = tabBtn.tabId
                }

                RowLayout {
                    id: tabContent

                    anchors.centerIn: parent
                    spacing: Tokens.spacing.small

                    MaterialIcon {
                        text: tabBtn.tabIcon
                        font.pointSize: Tokens.font.size.normal
                        color: tabBtn.active ? Colours.palette.m3onSecondary : Colours.palette.m3onSecondaryContainer
                    }

                    StyledText {
                        text: tabBtn.tabLabel
                        color: tabBtn.active ? Colours.palette.m3onSecondary : Colours.palette.m3onSecondaryContainer
                    }
                }

                Behavior on radius {
                    Anim {
                        type: Anim.FastSpatial
                    }
                }

                Behavior on color {
                    CAnim {}
                }
            }

            TabButton {
                tabId: "outputs"
                tabIcon: "volume_up"
                tabLabel: qsTr("Outputs")
            }

            TabButton {
                tabId: "inputs"
                tabIcon: "mic"
                tabLabel: qsTr("Inputs")
            }

            TabButton {
                tabId: "apps"
                tabIcon: "apps"
                tabLabel: qsTr("Apps")
            }
        }

        // Outputs tab
        ColumnLayout {
            id: outputsTab

            Layout.fillWidth: true
            spacing: Tokens.spacing.small
            visible: root.activeTab === "outputs"

            StyledText {
                text: qsTr("Output device")
                font.weight: 500
            }

            Repeater {
                model: Audio.sinks

                StyledRadioButton {
                    required property PwNode modelData

                    ButtonGroup.group: sinks
                    checked: Audio.sink?.id === modelData.id
                    onClicked: Audio.setAudioSink(modelData)
                    text: modelData.description
                }
            }

            StyledText {
                Layout.topMargin: Tokens.spacing.smaller
                Layout.bottomMargin: -Tokens.spacing.small / 2
                text: qsTr("Volume (%1)").arg(Audio.muted ? qsTr("Muted") : `${Math.round(Audio.volume * 100)}%`)
                font.weight: 500
            }

            CustomMouseArea {
                Layout.fillWidth: true
                implicitHeight: Tokens.padding.normal * 3

                onWheel: event => {
                    if (event.angleDelta.y > 0)
                        Audio.incrementVolume();
                    else if (event.angleDelta.y < 0)
                        Audio.decrementVolume();
                }

                StyledSlider {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    implicitHeight: parent.implicitHeight
                    value: Audio.volume
                    onMoved: Audio.setVolume(value)

                    Behavior on value {
                        Anim {}
                    }
                }
            }
        }

        // Inputs tab
        ColumnLayout {
            id: inputsTab

            Layout.fillWidth: true
            spacing: Tokens.spacing.small
            visible: root.activeTab === "inputs"

            StyledText {
                text: qsTr("Input device")
                font.weight: 500
            }

            Repeater {
                model: Audio.sources

                StyledRadioButton {
                    required property PwNode modelData

                    ButtonGroup.group: sources
                    checked: Audio.source?.id === modelData.id
                    onClicked: Audio.setAudioSource(modelData)
                    text: modelData.description
                }
            }

            StyledText {
                Layout.topMargin: Tokens.spacing.smaller
                Layout.bottomMargin: -Tokens.spacing.small / 2
                text: qsTr("Mic volume (%1)").arg(Audio.sourceMuted ? qsTr("Muted") : `${Math.round(Audio.sourceVolume * 100)}%`)
                font.weight: 500
            }

            CustomMouseArea {
                Layout.fillWidth: true
                implicitHeight: Tokens.padding.normal * 3

                onWheel: event => {
                    if (event.angleDelta.y > 0)
                        Audio.setSourceVolume(Math.min(1, Audio.sourceVolume + 0.05));
                    else if (event.angleDelta.y < 0)
                        Audio.setSourceVolume(Math.max(0, Audio.sourceVolume - 0.05));
                }

                StyledSlider {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    implicitHeight: parent.implicitHeight
                    value: Audio.sourceVolume
                    onMoved: Audio.setSourceVolume(value)

                    Behavior on value {
                        Anim {}
                    }
                }
            }
        }

        // Apps tab
        ColumnLayout {
            id: appsTab

            Layout.fillWidth: true
            spacing: Tokens.spacing.normal
            visible: root.activeTab === "apps"

            Repeater {
                model: Audio.streams

                ColumnLayout {
                    id: streamDelegate

                    required property PwNode modelData
                    required property int index

                    Layout.fillWidth: true
                    spacing: Tokens.spacing.smaller

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Tokens.spacing.small

                        MaterialIcon {
                            text: Audio.getStreamMuted(streamDelegate.modelData) ? "volume_off" : "volume_up"
                            font.pointSize: Tokens.font.size.normal
                            color: Audio.getStreamMuted(streamDelegate.modelData) ? Colours.palette.m3outline : Colours.palette.m3onSurface

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Audio.setStreamMuted(streamDelegate.modelData, !Audio.getStreamMuted(streamDelegate.modelData))
                            }
                        }

                        StyledText {
                            Layout.fillWidth: true
                            elide: Text.ElideRight
                            text: Audio.getStreamName(streamDelegate.modelData)
                            font.weight: 500
                        }

                        StyledText {
                            text: `${Math.round(Audio.getStreamVolume(streamDelegate.modelData) * 100)}%`
                            color: Colours.palette.m3outline
                        }
                    }

                    CustomMouseArea {
                        Layout.fillWidth: true
                        implicitHeight: Tokens.padding.normal * 3

                        onWheel: event => {
                            const vol = Audio.getStreamVolume(streamDelegate.modelData);
                            const delta = event.angleDelta.y > 0 ? 0.05 : -0.05;
                            Audio.setStreamVolume(streamDelegate.modelData, Math.max(0, Math.min(1, vol + delta)));
                        }

                        StyledSlider {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            implicitHeight: parent.implicitHeight
                            value: Audio.getStreamVolume(streamDelegate.modelData)
                            enabled: !Audio.getStreamMuted(streamDelegate.modelData)
                            opacity: enabled ? 1 : 0.5
                            onMoved: Audio.setStreamVolume(streamDelegate.modelData, value)
                        }
                    }
                }
            }

            StyledText {
                Layout.fillWidth: true
                visible: Audio.streams.length === 0
                text: qsTr("No applications playing audio")
                color: Colours.palette.m3outline
                font.pointSize: Tokens.font.size.small
                horizontalAlignment: Text.AlignHCenter
            }
        }

        IconTextButton {
            Layout.fillWidth: true
            Layout.topMargin: Tokens.spacing.normal
            inactiveColour: Colours.palette.m3primaryContainer
            inactiveOnColour: Colours.palette.m3onPrimaryContainer
            verticalPadding: Tokens.padding.small
            text: qsTr("Open settings")
            icon: "settings"

            onClicked: root.popouts.detachRequested("audio")
        }
    }
}
