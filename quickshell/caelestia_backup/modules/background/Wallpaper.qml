pragma ComponentBehavior: Bound

import QtQuick
import Caelestia.Config
import qs.components
import qs.components.effects
import qs.components.filedialog
import qs.components.images
import qs.services
import qs.utils

Item {
    id: root

    property string source: Wallpapers.current
    property bool completed
    property bool isRevealing: false
    property real revealProgress: 0

    onSourceChanged: {
        if (!source) return;
        if (!completed) {
            // FileView loaded after onCompleted — set base image directly
            baseImage.path = source;
            completed = true;
            return;
        }
        overlayImage.path = source;
    }

    Component.onCompleted: {
        if (source)
            Qt.callLater(() => {
                baseImage.path = source;
                completed = true;
            });
    }

    Loader {
        asynchronous: true
        anchors.fill: parent

        active: root.completed && !root.source

        sourceComponent: StyledRect {
            color: Colours.palette.m3surfaceContainer

            Row {
                anchors.centerIn: parent
                spacing: Tokens.spacing.large

                MaterialIcon {
                    text: "sentiment_stressed"
                    color: Colours.palette.m3onSurfaceVariant
                    font.pointSize: Tokens.font.size.extraLarge * 5
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Tokens.spacing.small

                    StyledText {
                        text: qsTr("Wallpaper missing?")
                        color: Colours.palette.m3onSurfaceVariant
                        font.pointSize: Tokens.font.size.extraLarge * 2
                        font.bold: true
                    }

                    StyledRect {
                        implicitWidth: selectWallText.implicitWidth + Tokens.padding.large * 2
                        implicitHeight: selectWallText.implicitHeight + Tokens.padding.small * 2

                        radius: Tokens.rounding.full
                        color: Colours.palette.m3primary

                        FileDialog {
                            id: dialog

                            title: qsTr("Select a wallpaper")
                            filterLabel: qsTr("Image files")
                            filters: Images.validImageExtensions
                            onAccepted: path => Wallpapers.setWallpaper(path)
                        }

                        StateLayer {
                            radius: parent.radius
                            color: Colours.palette.m3onPrimary
                            onClicked: dialog.open()
                        }

                        StyledText {
                            id: selectWallText

                            anchors.centerIn: parent

                            text: qsTr("Set it now!")
                            color: Colours.palette.m3onPrimary
                            font.pointSize: Tokens.font.size.large
                        }
                    }
                }
            }
        }
    }

    // Base layer — always visible, holds the committed wallpaper
    CachingImage {
        id: baseImage
        anchors.fill: parent
    }

    // Overlay — new wallpaper revealed through an expanding circle mask
    Item {
        id: overlayContainer
        anchors.fill: parent
        visible: root.isRevealing

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: circleMask
        }

        CachingImage {
            id: overlayImage
            anchors.fill: parent

            onStatusChanged: {
                if (status === Image.Ready
                        && path === root.source
                        && root.completed
                        && path !== baseImage.path) {
                    root.isRevealing = true;
                    revealAnim.restart();
                }
            }
        }
    }

    // Mask: a white circle that grows from the screen centre outward
    Item {
        id: circleMask
        anchors.fill: parent
        layer.enabled: true
        visible: false

        Canvas {
            id: circleCanvas
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);
                if (root.revealProgress <= 0) return;
                var maxR = Math.sqrt(width * width + height * height);
                ctx.fillStyle = "white";
                ctx.beginPath();
                ctx.arc(width * 0.5, height * 0.5, maxR * root.revealProgress, 0, Math.PI * 2);
                ctx.fill();
            }
        }
    }

    Connections {
        target: root
        function onRevealProgressChanged() { circleCanvas.requestPaint(); }
    }

    NumberAnimation {
        id: revealAnim
        target: root
        property: "revealProgress"
        from: 0; to: 1
        duration: 1100
        easing.type: Easing.OutCubic

        onFinished: {
            baseImage.path = overlayImage.path;
            Qt.callLater(() => {
                root.isRevealing = false;
                root.revealProgress = 0;
            });
        }
    }
}
